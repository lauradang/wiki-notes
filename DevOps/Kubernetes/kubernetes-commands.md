# Kubernetes Commands

## Spinning up the instances

```bash
kubectl run --replicas=1000 web-server # deploys an application on the cluster 1000 times
```

## Scaling the instances

```bash
kubectl run --replicas=1000 web-server
kubectl scale --replaces=2000 web-server # scales up the current webserver to 2000 instances
```

## Updating the instances

```bash
# Updates all instances to the given image
kubectl rolling-update web-server --image=web-server:2
```

## Rollback

```bash
# If something goes wrong in the updates, we can always roll back all the instances
kubectl rolling-update web-server --rollback
```

## View Information on the Cluster

```bash
kubectl cluster-info
```

## See nodes in cluster

```bash
kubectl get nodes
```

