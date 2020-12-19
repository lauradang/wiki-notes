# Helm/Kubernetes Chart Example

## Commands to Run

This should be done after files are set up

1. Install Helm chart (look in helm-commands.md)
2. List the pods to check if they are healthy, if not, check logs (look in kubernetes-commands.md)

## Tree Structure

```
.
└── Chart.yml
└── values.yml
├── volumes
│   └── volume.txt
├── templates
│   └──_helpers.tpl
│   ├── ingress
│   	└── ingress.yaml
│   ├── example-service
│   	└── example-service-config.yaml
│   	└── example-service-deployment.yaml
│   	└── example-service-service.yaml
│   ├── mariadb
│   	└── mariadb-deployment.yaml
│   	└── mariadb-pvc.yaml
│   	└── mariadb-service.yaml
│   ├── secrets
│   	└── mariadb-secrets.yaml
```

## Files

**Chart.yaml**

```yaml
apiVersion: v1
appVersion: "0.1"
description: Helm Chart for application (example-service)
name: application
version: "0.1"
```

**values.yaml**

```yaml
timestamp: ""

example-service:
  name: &example-service_name example-service
  replicaCount: 1
  image:
    repository: <repository_url_from_docker_hub>
    name: <image_name>
    tag: 0.1.0
  livenessProbe:
    failureThreshold: 3
    httpGet:
      path: /api/endpoint
      port: 8080
      scheme: HTTP
    initialDelaySeconds: 10
    periodSeconds: 10
    timeoutSeconds: 5
  readinessProbe:
    failureThreshold: 5
    httpGet:
      path: /api/endpoint
      port: 8080
      scheme: HTTP
    initialDelaySeconds: 10
    periodSeconds: 10
    timeoutSeconds: 5
  containerPort: &example-service_containerPort 8039
  imagePullPolicy: Always
  serviceType: NodePort
  servicePort: 8039
  serviceProtocol: TCP
  nodePort: 31251 
  SpringDataSourceUsername: username
  SpringDataSourcePassword: password
  TZ: America/Los_Angeles
  restartPolicy: OnFailure
  hostName: &example-service_hostname example-service.com

mariadb:
  name: mariadb
  image:
    repository: <repository_url_from_docker_hub>
    name: <image_name>
    tag: 0.1.0
  livenessProbe:
    failureThreshold: 10
    initialDelaySeconds: 10
    periodSeconds: 10
  readinessProbe:
    failureThreshold: 10
    initialDelaySeconds: 10
    periodSeconds: 10
  imagePullPolicy: IfNotPresent
  containerPort: 3306
  servicePort: 3306
  nodePort: 31306
  dbPort: 3306
  databaseName: databasse
  databaseTableName: database_table
  userid: username
  password: password

mariadbpvc:
  enabled: true
  storageClass: gp2

ingress:
  enabled: true
  hosts:
    - name: *example-service_hostname
      paths:
        - path: /*
          serviceName: ssl-redirect
          servicePort: use-annotation
        - path: /*
          serviceName: *example-service_name
          servicePort: *example-service_containerPort

  annotations:
    kubernetes.io/ingress.class: alb
    alb.ingress.kubernetes.io/scheme: internet-facing
    alb.ingress.kubernetes.io/certificate-arn: <certificate-arn>
    alb.ingress.kubernetes.io/listen-ports: '[{"HTTP": 80}, {"HTTPS":443}]'
    alb.ingress.kubernetes.io/actions.ssl-redirect: '{"Type": "redirect", "RedirectConfig": { "Protocol": "HTTPS", "Port": "443", "StatusCode": "HTTP_301"}}'
    alb.ingress.kubernetes.io/backend-protocol: HTTPS
    external-dns.alpha.kubernetes.io/hostname: *example-service_hostname
```

**_helpers.tpl**

```yaml
{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "application.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "application.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "application.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "application.labels" }}
app: {{ include "application.fullname" . }}
chart: {{ .Chart.Name }}-{{ .Chart.Version | replace "+" "_" }}
release: {{ .Release.Name }}
heritage: {{ .Release.Service }}
{{- end -}}

{{- define "imagePullSecret" -}}
{{- printf "{\"auths\": {\"%s\": {\"auth\": \"%s\"} } }" .registry (printf "%s:%s" .username .password | b64enc ) | b64enc -}}
{{- end -}}

{{- define "checkDbReadyInitContainer" -}}
{{- $db := .Values.mariadb -}}
{{- $image := printf "%s/%s:%s" $db.image.repository $db.image.name $db.image.tag -}}
{{- $dbConnectionString := printf "-h%s-%s-%s -P%v -u%s -p%s" .Release.Name .Chart.Name $db.name $db.containerPort $db.userid $db.password }}
- name: check-db-ready
  image: {{ $image }}
  command: ['sh', '-c',
            'until mysqladmin status {{$dbConnectionString}};
             do echo waiting for database; sleep 2; done;']
{{- end -}}
```

**application-deployment.yaml**

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name:  {{ include "application.fullname" . }}-{{ .Values.example-service.name }}
  labels: {{- include "application.labels" . | indent 4 }}
spec:
  replicas: {{ .Values.example-service.replicaCount }}
  selector:
    matchLabels:
      app.kubernetes.io/name: {{ include "application.fullname" . }}-{{ .Values.example-service.name }}
      app.kubernetes.io/instance: {{ .Release.Name }}
  template:
    metadata:
      annotations:
        timestamp: "{{ .Values.timestamp }}"
      labels:
        app.kubernetes.io/name: {{ include "application.fullname" . }}-{{ .Values.example-service.name }}
        app.kubernetes.io/instance: {{ .Release.Name }}
    spec:
      imagePullSecrets:
      - name: regcred
      initContainers: {{ include "checkDbReadyInitContainer" . | indent 6 }}
      containers:
      - name: main
        image: "{{ .Values.example-service.image.repository }}/{{ .Values.example-service.image.name }}:{{ .Values.example-service.image.tag }}"
        imagePullPolicy: {{ .Values.example-service.imagePullPolicy }}
        ports:
        - name: http
          containerPort: {{ .Values.example-service.containerPort }}
          protocol: {{ .Values.example-service.serviceProtocol }}
        env:   
        - name: SPRING_DATASOURCE_URL
          value: jdbc:mariadb://{{ include "application.fullname" . }}-{{ .Values.mariadb.name }}:{{ .Values.mariadb.dbPort }}/{{ .Values.mariadb.databaseName}}
        - name: SPRING_DATASOURCE_USERNAME
          value: {{ .Values.example-service.SpringDataSourceUsername | quote }}
        - name: SPRING_DATASOURCE_PASSWORD
          value: {{ .Values.example-service.SpringDataSourcePassword | quote }}
        - name: TZ
          value: {{ .Values.example-service.TZ | quote }}
        volumeMounts:
        - name: config-volume
          mountPath: /keys
        livenessProbe:
          failureThreshold: {{ .Values.example-service.livenessProbe.failureThreshold }}
          httpGet:
            path: {{ .Values.example-service.livenessProbe.httpGet.path }}
            port: {{ .Values.example-service.livenessProbe.httpGet.port }}
            scheme: {{ .Values.example-service.livenessProbe.httpGet.scheme }}
          initialDelaySeconds: {{ .Values.example-service.livenessProbe.initialDelaySeconds }}
          periodSeconds: {{ .Values.example-service.livenessProbe.periodSeconds }}
          timeoutSeconds: {{ .Values.example-service.livenessProbe.timeoutSeconds }}
        readinessProbe:
          failureThreshold: {{ .Values.example-service.readinessProbe.failureThreshold }}
          httpGet:
            path: {{ .Values.example-service.readinessProbe.httpGet.path }}
            port: {{ .Values.example-service.readinessProbe.httpGet.port }}
            scheme: {{ .Values.example-service.readinessProbe.httpGet.scheme }}
          initialDelaySeconds: {{ .Values.example-service.readinessProbe.initialDelaySeconds }}
          periodSeconds: {{ .Values.example-service.readinessProbe.periodSeconds }}
          timeoutSeconds: {{ .Values.example-service.readinessProbe.timeoutSeconds }}
      volumes:
      - name: config-volume
        configMap:
          name: {{ include "application.fullname" . }}-{{ .Values.example-service.name }}-configmap
```

**application-config.yaml**

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ include "application.fullname" . }}-{{ .Values.example-service.name }}-configmap
  labels:
    {{- include "application.labels" . | indent 4 }}
    app.kubernetes.io/name: {{ template "application.fullname" . }}-{{ .Values.example-service.name }}
    app.kubernetes.io/instance: {{ .Release.Name }}
binaryData:
  <volume_file_name>: |-
    {{ .Files.Get "path/to/volume/<volume_file_name>" | b64enc }}
```

**application-service.yaml**

```yaml
apiVersion: v1
kind: Service
metadata:
  name: {{ include "application.fullname" . }}-{{ .Values.example-service.name }}
  labels:
    {{- include "application.labels" . | indent 4 }}
    app.kubernetes.io/name: {{ template "application.fullname" . }}-{{ .Values.example-service.name }}
    app.kubernetes.io/instance: {{ .Release.Name }}
spec:
  type: {{ .Values.example-service.serviceType }}
  ports:
  - port: {{ .Values.example-service.servicePort }}
    targetPort: {{ .Values.example-service.containerPort }}
    protocol: {{ .Values.example-service.serviceProtocol }}
    {{ if .Values.example-service.nodePort }}
    nodePort: {{ .Values.example-service.nodePort }}
    {{ end }}
  selector:
    app.kubernetes.io/name: {{ include "application.fullname" . }}-{{ .Values.example-service.name }}
    app.kubernetes.io/instance: {{ .Release.Name }}
```

**mariadb-deployment.yaml**

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ include "application.fullname" . }}-{{ .Values.mariadb.name }}
  labels: {{- include "application.labels" . | indent 4 }}
spec:
  strategy:
    type: Recreate
  selector:
    matchLabels:
      app.kubernetes.io/name: {{ include "application.fullname" . }}-{{ .Values.mariadb.name }}
      app.kubernetes.io/instance: {{ .Release.Name }}
  template:
    metadata:
      labels:
        app.kubernetes.io/name: {{ include "application.fullname" . }}-{{ .Values.mariadb.name }}
        app.kubernetes.io/instance: {{ .Release.Name }}
    spec:
      imagePullSecrets:
      - name: regcred
      containers:
      - name: {{ include "application.fullname" . }}-{{ .Values.mariadb.name }}
        image: "{{ .Values.mariadb.image.repository }}/{{ .Values.mariadb.image.name }}:{{ .Values.mariadb.image.tag }}"
        ports:
        - containerPort: {{ .Values.mariadb.dbPort }}
        env:
        - name: MYSQL_ROOT_PASSWORD
          valueFrom:
            secretKeyRef:
              name: {{ include "application.fullname" . }}-mariadb-secret
              key: password
        - name: MYSQL_DATABASE
          value: {{ .Values.mariadb.databaseName }}
{{- if .Values.mariadbpvc.enabled }}
        volumeMounts:
        - name: mariadb-storage
          mountPath: /var/lib/mysql
          subPath: mariadb
        livenessProbe:
          exec:
            command:
            - mysql
            - --user={{ .Values.mariadb.userid }}
            - --password={{ .Values.mariadb.password }}
            - -e 
            - 'use {{ .Values.mariadb.databaseName }}; select * from {{ .Values.mariadb.databaseTableName }};'
          initialDelaySeconds: {{ .Values.mariadb.livenessProbe.initialDelaySeconds }}
          periodSeconds: {{ .Values.mariadb.livenessProbe.periodSeconds }}
          failureThreshold: {{ .Values.mariadb.livenessProbe.failureThreshold }}
        readinessProbe:
          exec:
            command:
            - mysql
            - --user={{ .Values.mariadb.userid }}
            - --password={{ .Values.mariadb.password }}
            - -e 
            - 'use {{ .Values.mariadb.databaseName }}; select * from {{ .Values.mariadb.databaseTableName }};'
          initialDelaySeconds: {{ .Values.mariadb.readinessProbe.initialDelaySeconds }}
          periodSeconds: {{ .Values.mariadb.readinessProbe.periodSeconds }}
          failureThreshold: {{ .Values.mariadb.readinessProbe.failureThreshold }}
      volumes:
      - name: mariadb-storage
        persistentVolumeClaim:
          claimName: {{ include "application.fullname" . }}-auth-db-pvc
{{ end }}
```

**mariadb-pvc.yaml**

```yaml
{{- if .Values.mariadbpvc.enabled -}}
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: {{ include "application.fullname" . }}-auth-db-pvc
  labels: {{- include "application.labels" . | indent 4 }}
spec:
  storageClassName: {{ .Values.mariadbpvc.storageClass }}
  accessModes:
  - ReadWriteOnce
  resources:
    requests:
      storage: 5Gi
{{- end -}}
```

**mariadb-service.yaml**

```yaml
apiVersion: v1
kind: Service
metadata:
  name: {{ include "application.fullname" . }}-{{ .Values.mariadb.name }}
  labels:
    {{- include "application.labels" . | indent 4 }}
    app.kubernetes.io/name: {{ template "application.fullname" . }}-{{ .Values.mariadb.name }}
    app.kubernetes.io/instance: {{ .Release.Name }}
spec:
  type: NodePort
  ports:
  - port: {{ .Values.mariadb.servicePort }}
    targetPort: {{ .Values.mariadb.containerPort }}
    protocol: TCP
    {{ if .Values.mariadb.nodePort }}
    nodePort: {{ .Values.mariadb.nodePort }}
    {{ end }}
  selector:
    app.kubernetes.io/name: {{ include "application.fullname" . }}-{{ .Values.mariadb.name }}
    app.kubernetes.io/instance: {{ .Release.Name }}
```

**mariadb-secrets.yaml**

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: {{ include "application.fullname" . }}-mariadb-secret
  labels: {{- include "application.labels" . | indent 4 }}
data:
  username: {{ .Values.mariadb.userid | b64enc | quote }}
  password: {{ .Values.mariadb.password | b64enc | quote }}
```

**ingress.yaml**

```yaml
{{- if .Values.ingress.enabled -}}
{{ $releaseName := .Release.Name }}
{{ $chartName := .Chart.Name }}
apiVersion: networking.k8s.io/v1beta1
kind: Ingress
metadata:
  name: {{ template "application.fullname" . }}
  labels: {{- include "application.labels" . | indent 4 }}
{{- if .Values.ingress.labels }}
{{ .Values.ingress.labels | toYaml | trimSuffix "\n"| indent 4 -}}
{{- end}}
{{- if .Values.ingress.annotations}}
  annotations:
    {{- range $key, $value := .Values.ingress.annotations }}
    {{ $key }}: {{ $value | quote }}
    {{- end }}
{{- end }}
spec:
  rules:
    {{- range .Values.ingress.hosts }}
    - host: {{ .name }}
      http:
        paths:
          {{- range .paths }}
          - backend:
              serviceName: {{ if ne .serviceName "ssl-redirect" }}{{ $releaseName }}-{{ $chartName }}-{{ end }}{{ .serviceName }}
              servicePort: {{ .servicePort }}
            {{- if .path }}
            path: {{ .path }}
            {{- end -}}
          {{- end -}}
    {{- end -}}
  {{- if .Values.ingress.tls }}
  tls:
{{ toYaml .Values.ingress.tls | indent 4 }}
  {{- end -}}
{{- end -}}
```

