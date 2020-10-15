# Kubernetes Networking

## Accessing containers
While you're inside a container, you cannot access it by curling its container IP like Docker Compose. Since you are inside the container, you should be using the hostname `localhost`. To see which port to use, enter this command while inside the container: `ss -ln`.

## Ports in Kubernetes
https://medium.com/@deepeshtripathi/all-about-kubernetes-port-types-nodeport-targetport-port-containerport-e9f447330b19

![](https://i.stack.imgur.com/mZlH9.png)
### `containerPort`
**Pod object**: Informational purposes only (no effect on actual deployment)
**Service object**:
Port on which app can be reached out inside the container. 

`Service` object exposes internal pod endpoints as service to outer world

### `port` in `Service` object
`Service` will be exposed INTERNALLY to cluster aplications on this port

### `nodePort`
`Service` will be exposed EXTERNALLY to cluster on this port

If you want to access the pod from the external world: `host-ip:nodePort`

**What happens when we hit `host-ip:nodePort`?**
1. Sends traffic received on `nodePort` and forwards that to `port` which is also defined in the `Service` object.
2. Traffic now gets redirected from `port` to `targetPort` which is also defined in the `Service` object. `targetPort` used to define port on which container has exposed application.

**Note**: `targetPort` and `containerPort` must be identical most of the time - port that is open in container would be the same port you want to send traffic from service via `targetPort`

## Liveness/Readiness Probe
Performed by the kubelet, so you are within the node - nodeIPs are irrelevant here (check image in Kubernetes networking for clear picture)