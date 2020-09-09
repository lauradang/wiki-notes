# Kubernetes Architecture

## Nodes/Minions

A virtual or physical machine where the Kubernetes tools are installed. A node is a working machine where the containers will be launched by Kubernetes.

## Cluster

A set of nodes grouped together. If one node within the cluster fails, there are other nodes in the cluster that can go up to ensure the application is still accessible.

## Master

A node where the control plane in Kubernetes is installed. The master watches over the nodes in the cluster and is responsible for the orchestration of the nodes.

## Components

When installing Kubernetes, here's what you are installing:

1. API server
   - front-end for users
   - interfaces and CLI talk to API server to manage the Kubernetes clusters
2. etcd
   - Stores all data used to manage the clusters
   - e.g. We have a bunch of nodes with a master in the cluster. This ensures there are no conflict between the masters of each cluster.
3. kubelet
   - Agent that runs on each node in the cluster
   - Ensures that the containers are running on the nodes as expected
4. Container Runtime
   - The software that runs the containers (in most cases, Docker)
5. Controller
   - brain behind the orchestration
   - responsible for noticing when nodes go down, and making decisions when to bring up new containers
6. Scheduler
   - responsible for distributing containers across multiple nodes
   - searches for newly created containers and assigns them to nodes 

