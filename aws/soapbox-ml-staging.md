# Soapbox ML-Staging

SSH into AWS server

```bash
~$ ssh ml-staging
```

Checkout own branch inside staging server

```bash
forge@ml-staging:~$ git clone —branch <branch-name> github@github.com:Soapbox/ml-api.git <name-of-clone-folder>
```

Copy CSV files

```bash
forge@ml-staging:~$ cp ~/data/next_steps.csv data/
```

Do your own preprocessing in your own branch

PII = Personally Identifiable Information / Scrubbing

* use the past coop's jupyter notebook

