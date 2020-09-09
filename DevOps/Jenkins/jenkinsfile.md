# Jenkinsfile

A scripted pipeline that goes into your repository (like Dockerfile).

## Pipeline Syntax

### Declarative

```groovy
CODE_CHANGES = getGitChanges() // You can also define your own variables to use
// getGitChanges() would be a Groovy script that checks if the code changed

pipeline { // "pipeline" must be top-level
    agent any // Where to run the build (agent is a Jenkins agent which can be a node, executor on the node, etc.)
    					// agent example: agent to run linux, agent to run windows
    					// "any" means any next available agent
    // NOTE: You must always have pipeline and agent 
    
    stages { // where the actual work happens
        stage('Build') {
            steps {
                echo 'Building..'
            }
        }
        stage('Test') {
          	when { // When you only want to run the test on a certain branch
              	expression {
                  		// boolean expressions go here
                			// Jenkins has an environment variable called BRANCH_NAME that represents the current branch
                			BRANCH_NAME == 'dev' || BRANCH_NAME == 'master' && CODE_CHANGES == true
                } // if this block is true, the stage will proceed, if this block is false, rest of stage skipped
            }
            steps {
                echo 'Testing..'
            }
        }
        stage('Deploy') {
            steps {
                echo 'Deploying....'
            }
        }
    }
  
  // POST ACTIONS
  post {
    always { // execute something after the stages have been executed no matter the outcome of these stages
      // ex. send an email to developers about info
    }
    success { // execute something ONLY if the build succeeded
      
    }
    failure { // execute something ONLY if the build failed
      
    }
  }
}
```

### Scripted

- Uses groovy engine

```javascript
node {
  // groovy script
}

// equivalent to pipeline { agenda any }
```

## Environment Variables

### Variables available in Jenkins

You can see them at `localhost:8080/env-vars.html`

**How to define them**:

```groovy
pipeline { 
    agent any
    environment { // Define environment variables that you can use in all stages
      // METHOD 1
      NEW_VERSION = '1.3.0'
      
      // METHOD 2 (using jenkins credentials) You need the Credential and Credential Binding plugins
      // credentials() is a function that binds jenkins variable to environment variable
      SERVER_CREDENTIALS = credentials('') // takes in ID/reference of global credentials (need to make one)
    }

    stages { 
        stage('Build') {
            steps {
                echo 'Building..'
                echo "Building new version ${NEW VERSION}"
                echo 'Building new version ${NEW VERSION}' // notice this is different from line above
            } 
        }
        stage('Test') {
            steps {
                echo 'Testing..'
            }
        }
        stage('Deploy') {
            steps {
                echo 'Deploying....'
              	sh "${SERVER_CREDENTIALS}"
            }
        }
    }
  }
}
```

What if you only need to use credentials in one stage? We can use **wrapper syntax**.

```groovy
// You need the Credential and Credential Binding plugins
pipeline { 
    agent any
    stages { 
        stage('Build') {
            steps {
                echo 'Building..'
            }
        }
        stage('Test') {
            steps {
                echo 'Testing..'
            }
        }
        stage('Deploy') {
            steps {
                echo 'Deploying....'
              	// Define wrapper function withCredentials()
              	// Takes in an object (in Groovy, [] is an object)
                withCredentials([
                  usernamePassword( // function that gives the username and password individually 
                    credentials: <id_of_global_cred>, 
                    usernameVariable: USER, // stores username into USER
                    passwordVariable: PWD // stores password into PWD
                  ) 
                ]) {
										// So here, we can use USER and PWD
                  sh "some script ${USER} ${PWD}"
                }
            }
        }
    }
  }
}
```

## Accessing Build Tools

In projects, you have multiple builds such as Maven Build or Gradle build. So you would need a line like `sh "maven build"` in the stages. How do we access this?

**Note**: Jenkins only supports 3 builds tools: *gradle, maven, and jdk*. `yarn` and `npm` cannot be done this way,

```groovy
pipeline {
		agent any
    tools {
    maven 'Maven' // Check localhost:8080/configureTools/ if 'Maven' is installed
}
```

## Parameterize your Build

You may want external configurations for your Jenkinsfile. For example, you want to select which version of the application you want to deploy. You can do this with parameters.

```groovy
pipeline {
  agent any
  parameters {
    // type_of_parameter(name: name_of_parameter, ...)
    string(name: 'VERSION', defaultValue: '', description: 'version to deploy on prod')
    choice(name: 'VERSION', choices: ['1.1.0', '1.2.0', '1.3.0'], description: '')
    booleanParam(name: 'executeTests', defaultValue: true, description: '')
  }

  stages { 
    stage('Build') {
        steps {
            echo 'Building..'
        }
    }
    stage('Test') {
        when {
          expression {
						params.executeTests // equivalent to params.executeTests == true
          }
        } // if params.executeTests is true, testing will be executed
        steps {
            echo 'Testing..'
        }
    }
    stage('Deploy') {
        steps {
            echo 'Deploying....'
          	echo "Deploying version ${params.VERSION}"
        }
    }
}
```

To choose the paraeters, they will show up in Build (Build in Jenkins becomes Build with Parameters).

## External Groovy Scripts

```groovy
// Here's a random .groovy file (let's call is script.groovy)
def buildApp() {
		echo 'building the application...'
}

def testApp() {
  	echo 'testing the application...'
}

def deployApp() {
  	echo 'deploying the application...'
    echo "deploying version ${params.VERSION}" // ALL ENV VARIABLES IN JENKINS ARE ACCESSIBLE IN GROOVY SCRIPTS
}

return this // need this to import these functions into jenkinsfile
```

```groovy
// Jenkinsfile
def gv // define a variable to load the groovy script
  
pipeline {
  agent any
  
  stages { 
    stage('Init') { // define an init stage to import the groovy script
        steps {
            script { // In this block, you can write normal groovy syntax
								gv = load "script.groovy"
            }
        }
    }
    stage('Build') {
        steps {
            script { 
								gv.buildApp()
            }
        }
    }
    stage('Test') {
        steps {
            script { 
								gv.testApp()
            }
        }
    }
    stage('Deploy') {
        steps {
            script { 
								gv.deployApp()
            }
        }
    }
}
```

