# Mapping/Publishing

## Ports

How can someone access your application?

```bash
docker run webapp
>> * Running on http://0.0.0.0:5000/
```

You can access it through port 5000 (the docker container is listening/exposed from this port), but what IP do we use?

1. The IP of the docker **container** (every docker container gets a default IP address)
   - **IMPORTANT NOTE**: This is internal and is only accessible within the docker host. So opening a browser within the docker browser would yield the application.
   - e.g. `http://172.17.0.2:5000/`
2. The IP of the docker **host**
   - You must map port inside docker container to free port on docker host (e.g. map port 80 from localhost to port 5000)
   - e.g. `http://192.168.1.5:80/`
   - Command to map the port: `docker run -p 80:5000 <name>`
     - All traffic to port 80 gets routed to port 5000 inside the docker container
     - This way, we can run multiple instances of the application and map the instances to different ports at the same time



## Volumes

When you remove a container, all the data goes with it. How do we persist the data? We have to map the data stored in the container to a local location:

```bash
docker run -v <local/file/path>:/var/lib/mysql mysql
```



 

