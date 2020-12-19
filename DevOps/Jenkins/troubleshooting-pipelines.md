# Troubleshooting Pipelines

## Bitbucket Webhook Triggers Missed

 Jenkins has a 5 second default quiet period. If your webhook tries to send more than one trigger in this time, one or more of those triggers will not go through on the Jenkins pipeline. To fix this, go to the pipeline congurations and set the Quiet period to 0.

## Aborted pipelines

This often happens Sonarqube Analysis and Quality gate. We can increase the sleep timer to minimize the likelihood of this happening.

```groovy
stages{
    stage("Analysis"){
        steps{
            withSonarQubeEnv('SonarqubeCorp') {
            runSonar()
            sleep(60) // <---- INCREASE THIS TIME
        }
      }
    }
stage("Quality Gate") {
    when {
        expression { RUN_TESTS }
    }
    steps {
        timeout(time: 10, unit: 'MINUTES') {
        waitForQualityGate abortPipeline: true
    }
  }
```

