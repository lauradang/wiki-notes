# Volumes

## Persistent Volume (PV) and Persistent Volume Claim (PVC)

**References:**

https://www.youtube.com/watch?v=OulmwTYTauI&ab_channel=SeanWingert

![](pvc2.png)

### Persistent Volume Claim (PVC)

- Claims a certain amount of volume for the designated pods
  -  More than one pod can map back to one PVC - so multiple pods can share one storage space if needed
- Does not need to specify where the storage is coming from (Cloud, SSD, etc.), only concerned with how much storage is needed for the pods
  - Since these are supposed to be written up by the developers, the developers don't need to know where the storage is coming from, they just need storage
- PVC **binds** with either a Persistent Volume or a Storage Class

### Persistent Volume (PV)

- Specifies where the volumes are coming from (Cloud, SSD, etc.)
- Acts as an abstraction to physical storage
- Ops people are meant to handle this

**Note:** Cannot bind 2 PVCs to the same PV, but can bind 2 PVs to the same PVC

![](pvc1.png)

### Example

https://gitlab.com/nanuchi/youtube-tutorial-series/-/blob/master/configmap-and-secret-volumes/mosquitto-config-components.yaml (View comments in the following example to understand better)

**random note: commenting out doesn't seem to work that often so be careful in case you see your volume is not mounting for some reason and there are no errors being thrown**

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: mosquitto-config-file
data:
  mosquitto.conf: |
    log_dest stdout
    log_type all
    log_timestamp true
    listener 9001
    
---
apiVersion: v1
kind: Secret
metadata:
  name: mosquitto-secret-file
type: Opaque
data:
  secret.file: |
    c29tZXN1cGVyc2VjcmV0IGZpbGUgY29udGVudHMgbm9ib2R5IHNob3VsZCBzZWU=
    
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: mosquitto
  labels:
    app: mosquitto
spec:
  replicas: 1
  selector:
    matchLabels:
      app: mosquitto
  template:
    metadata:
      labels:
        app: mosquitto
    spec:
      containers: 
        - name: mosquitto
          image: eclipse-mosquitto:1.6.2
          ports:
            - containerPort: 1883
          volumeMounts: # Here, we list all volumes we want to mount from POD TO CONTAINER
            - name: mosquitto-conf # Notice this obviously must exist in the POD (look below)
              mountPath: /mosquitto/config # Path in the filesystem inside the container 
            - name: mosquitto-secret
              mountPath: /mosquitto/secret  
              readOnly: true
      volumes: # Here, we list all volumes we want to mount in the POD
        - name: mosquitto-conf
          configMap:
            name: mosquitto-config-file # Name of the ConfigMap resource (look above)
        - name: mosquitto-secret 
          secret:
            secretName: mosquitto-secret-file # Name of the Secret resource (look above)

---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: mosquitto
  labels:
    app: mosquitto
spec:
  replicas: 1
  selector:
    matchLabels:
      app: mosquitto
  template:
    metadata:
      labels:
        app: mosquitto
    spec:
      containers:
        - name: mosquitto
          image: eclipse-mosquitto:1.6.2
          ports:
            - containerPort: 1883
```

