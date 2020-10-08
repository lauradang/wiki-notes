# AWS EKS
## Authenticate
Remember to configure your AWS credentials before starting
```bash
$ aws configure
# Enter credentials here (creator of instance has this information)
```
## Create a cluster
```bash
$ eksctl utils write-kubeconfig --cluster at --region us-east-2
```  