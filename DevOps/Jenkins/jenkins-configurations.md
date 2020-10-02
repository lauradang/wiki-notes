# Jenkins Configurations

Something very different in DevOps from typical software developer work is that there are a lot of configurations (non-code) you must ensure are set up properly.

## Specify Git Branch Code

For a pipeline, you can actually specify the branch you want to build. Go to the bottom of the pipeline configurations where you can set up the SCM as Git and specify the branches to build.

## Global Pipeline Libraries

We usually have libraries built by us with global utility functions. To load in the entire repo for a pipeline, go to Manage Jenkins > Configure Global Settings and scroll to "Global Pipeline Libraries". Here we can load in different libaries we've built via SCM such as Git. We can even specify the branch of the library we want to use similarly to pipeline build code. To load the library we have configured, you put this at the top of the Jenkinsfile you want to build:

```groovy
@Library('name_of_library') _
```

## [Webhooks]([https://mohamicorp.atlassian.net/wiki/spaces/DOC/pages/381419546/Configuring+Webhook+To+Jenkins+for+Bitbucket+Bitbucket+Branch+Source+Plugin?preview=%2F381419546%2F381419552%2FScreen%20Shot%202017-10-23%20at%204.06.16%20PM.png](https://mohamicorp.atlassian.net/wiki/spaces/DOC/pages/381419546/Configuring+Webhook+To+Jenkins+for+Bitbucket+Bitbucket+Branch+Source+Plugin?preview=%2F381419546%2F381419552%2FScreen Shot 2017-10-23 at 4.06.16 PM.png))

Don't forget to configure them on both your SCM and the pipeline.

**Important note:** Jenkins has a 5 second default quiet period. If your webhook tries to send more than one trigger in this time, one or more of those triggers will not go through on the Jenkins pipeline. To fix this, go to the pipeline congurations and set the Quiet period to 0.

## Manifests

A manifest has a bunch of information for the Jenkinsfile. Manifests are usually stored in a repo (usually the repo we are testing) separate from the Jenkinsfile repo. So in the Jenkinsfile, to read the manifest, we usually clone the manifest's repo, then read it. 

Since there can be many manifests for one pipeline, we usually parametrize the name of the manifest file as a "Choice Parameter" called "Component" in the pipeline configurations.  The choices would be the names of the different manifest files.

## Credentials

Having credentials/tokens in source code is pretty bad. To access them in pipelines, go to Manage Jenkins > Manage Credentials and create a new credential with the ID, username, and password. Then we use it in the code like so without showing the actual values of the credentials:

```groovy
// You need the Credential and Credential Binding plugins
withCredentials([
  usernamePassword( // function that gives the username and password individually 
    credentials: "<global_credential_ID>", 
    usernameVariable: "USER", // stores username into USER variable
    passwordVariable: "PWD" // stores password into PWD variable
  ) 
]) {
  // So here, we can use USER and PWD
  sh "some script ${USER} ${PWD}" 
}

// Alternatively we can do this too:
withCredentials([
  usernameColonPassword( // function that gives the username and password in this form -> <username>:<password>
    credentials: "<global_credential_ID>", 
    variable: "CREDS"
  ) 
]) {
  // useful for curl which takes the username and password in the colon form
  sh "curl -u ${CREDS} -X GET 'some_url >> some_json.json'"
}
```



