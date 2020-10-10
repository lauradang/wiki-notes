# Virtual Environment
### Make virtual environment
```bash
$ pip install virtualenv
$ virtualenv mypython
```

### Start virtual environment
```bash
$ source mypython/bin/activate
```

### Deactivate virtual environment
```bash
$ deactivate
```

### Start virtual environment in Python3
```bash
$ virtualenv -p python3 <envname>
```

### Environment variables inside virtual environment
```bash
$ vi .env
>> Type your environment variables in this file (VAR=VALUE)

$ pip install python-dotenv
```

### Switch python version in virtualenv

**Use case:** Some dependencies are not supported by Python3.8 yet.

```bash
$ virtualenv --python=/usr/bin/python<version> <path/to/new/virtualenv/>

# To find path for python (it's not always /usr/bin/...):
$ which python<version_number>
```

