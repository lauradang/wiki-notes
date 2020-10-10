# Helm Charts

## Artifactory

### [Adding and Upgrading Charts](https://www.jfrog.com/confluence/display/JFROG/Helm+Chart+Repositories)

```bash
helm repo add <REPO_KEY> http://<ARTIFACTORY_HOST>:<ARTIFACTORY_PORT>/artifactory/<REPO_KEY> --username <USERNAME> --password <PASSWORD>
helm upgrade <RELEASE_NAME> <repo_name>/<chart_name> # Release name can be anything you want
```

**Important Note:** Does not add actual files to your machine/container. Just gives you virtual access to the repo.

