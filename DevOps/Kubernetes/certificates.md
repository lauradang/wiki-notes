# Certificates

https://howhttps.works/certificate-authorities/

Once you deploy an application and you get a "Your connection is not secure" with no padlock on the website. That means the certificate from the server is not trusted by the browser (certificate was not issused by a CA authority).

If the application is deployed on Kubernetes, you need to track down where the certificate is located (which pod and the location inside the pod). You can usually find the path / `secretName` / `credentialName` in the `Ingress` resource or even istio `Gateway` resource. Then find the corresponding pods and go to that path to find the certificate

The certificate is most likely self-signed by letsencrypt or another third-party issuer (resource type: `ClusterIssuer`). Find out  how it is being generated (look for resource `Certificate`). 

To get a CA authorized certificate, you must go through your cloud provider. For Azure, you have to [create a Key Vault and create a signed certificate](https://docs.microsoft.com/en-us/azure/key-vault/certificates/certificate-scenarios). For IBM Cloud, if you are using a load balancer, there is a [single command](https://cloud.ibm.com/docs/containers?topic=containers-loadbalancer_hostname) to run to obtain a DNS and certificate for that load balancer!

If you are using Azure, export the signed certificate you just created in `.pfx` format. Using OpenSSL, you can split this `.pfx` file into `.crt` and `.key` files shown [here](https://www.markbrilman.nl/2011/08/howto-convert-a-pfx-to-a-seperate-key-crt-file/). 

## Istio Gateway

https://istio.io/latest/docs/tasks/traffic-management/ingress/secure-ingress/

If you are using istio `Gateway` resource, then the file should be something like this:

```yaml
  apiVersion: networking.istio.io/v1alpha3
  kind: Gateway
  metadata:
  name: kubeflow-gateway
  namespace: kubeflow
  spec:
  selector:
      istio: ingressgateway
  servers:
  - hosts:
      - '*'
      port:
          name: http
          number: 80
          protocol: HTTP
      # Upgrade HTTP to HTTPS
      tls:
          httpsRedirect: true
  - hosts:
      - '*'
      port:
          name: https
          number: 443
          protocol: HTTPS
      tls:
          mode: SIMPLE
          privateKey: /etc/istio/ingressgateway-certs/tls.key # WHERE THE .key FILE PATH SHOULD BE EXPORTED INTO
          serverCertificate: /etc/istio/ingressgateway-certs/tls.crt # WHERE THE .CRT FILE PATH SHOULD BE EXPORTED INTO
```

You can also do it through secrets

```bash
kubectl create -n istio-system secret tls istio-ingressway-tls \
	--key=istio-ingressway-tls.key \
  --cert=istio-ingressway-tls.crt
```

```yaml
  apiVersion: networking.istio.io/v1alpha3
  kind: Gateway
  metadata:
  name: kubeflow-gateway
  namespace: kubeflow
  spec:
  selector:
      istio: ingressgateway
  servers:
  - hosts:
      - '*'
      port:
          name: http
          number: 80
          protocol: HTTP
      # Upgrade HTTP to HTTPS
      tls:
          httpsRedirect: true
  - hosts:
      - '*'
      port:
          name: https
          number: 443
          protocol: HTTPS
      tls:
        mode: SIMPLE
        credentialName: istio-ingressway-tls # must be the same as secret
```

## Kubernetes Ingress

```bash
kubectl create secret tls ingress-tls \
    --key ingress-tls.key \
    --cert ingress-tls.crt
```

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: tls-example-ingress
spec:
  tls:
  - hosts:
      - https-example.foo.com
    secretName: ingress-tls
  rules:
  - host: https-example.foo.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: service1
            port:
              number: 80
```

> 



