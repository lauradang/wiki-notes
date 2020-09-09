# Kubernetes Introduction

Let's say you want to run a single instance of the application, so we use: `docker run nodejs`. What if the number of users increase to the point that the single instance cannot handle the load? We would increase the number of instances by running the command `docker run nodejs` many times.

In other words, when the number of users increase, we would have to manage and monitor the load and number of containers ourselves which can be difficult and tedious. In addition, we'd have to monitor the health of each container that is active and ensure that if one fails, we can bring it back or have a safe fallback. We also have to monitor the health of the actual host. If the host fails, all the containers would also fail.

## Container Orchestration

This is a solution for the above problem.

**What is it?** Multiple docker hosts where each one hosts some number of containers. If one host fails, we still have another host with a bunch of containers. We can spin up a container orchestration with the following command:

```bash
docker service create --replicas=100 nodejs
```

Docker Swarm, Kubernetes, and Mesos provide this solution.

Docker Swarm is easy to setup, but lacks some features for heavy production servers. 