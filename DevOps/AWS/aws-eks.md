# AWS EKS
## Authenticate
Remember to configure your AWS credentials before starting
```bash
$ aws configure
# Enter credentials here (creator of instance has this information)
```
## Write permission to cluster
```bash
$ eksctl utils write-kubeconfig --cluster at --region us-east-2
```

