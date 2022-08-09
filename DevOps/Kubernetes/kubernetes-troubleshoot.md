# Troubleshooting Kubernetes

## FailedScheduling

### Check node

```bash
$ kubectl describe pod ...

> Events:
  Type     Reason            Age                   From               Message
  ----     ------            ----                  ----               -------
  Warning  FailedScheduling  3m16s                 default-scheduler  0/70 nodes are available: 2 node(s) had taint {dedicated: ml}, that the pod didn't tolerate, 2 node(s) had taint {dedicated: production-worker}, that the pod didn't tolerate, 2 node(s) had taint {node.kubernetes.io/unreachable: }, that the pod didn't tolerate, 2 node(s) were unschedulable, 3 node(s) had taint {dedicated: kubemaster}, that the pod didn't tolerate, 4 node(s) had taint {dedicated: production}, that the pod didn't tolerate, 4 node(s) had taint {dedicated: simtest}, that the pod didn't tolerate, 51 node(s) didn't match Pod's node affinity.
```
```bash
$ kubectl get node ...

> some.node            Ready,SchedulingDisabled      <none>                 625d     v1.18.17
```
**Fix**:
```bash
kubectl uncordon some.node
```

### Check deployment

Does the deployment exist for the pods? Do replicas exist for the deployment (e.g. is it something other than `0/0`)?