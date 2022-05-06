# URL Routing

We have this scenario: Application receives request via `/app`, but we want the service to route to `/<application-service-name>/app`. How do we do this without changing the application in Kubernetes?

We can use a NGINX load balancer as a proxy.

1. Create an NGINX K8s service (image: `nginxinc/nginx-unprivileged:1.16-alpine`) - separate from K8s service of the application

2. Mount the following config map to the container `/etc/nginx/conf.d/default.conf`:

```nginx
server {
  listen       80;
  server_name  localhost;
  resolver kube-dns.kube-system.svc.cluster.local valid=10s;

  location /app { # /app means to route public URL to /app
    # e.g. rewrite /<application-service-name>/app to just the 2nd part which is /app
    # User will access the 2nd argument (/app), and /app
    # will reroute to /<application-service-name>/app
    rewrite /(.*)/(.*) /$2  break; # $2 refers to the 2nd (.*)
    # $1 is <application-service-name> first (.*) in rewrite
    proxy_pass         http://$1.<NAMESPACE>.svc.cluster.local:80;
    proxy_redirect     off;
    proxy_set_header   Host $host;
  }
}
```