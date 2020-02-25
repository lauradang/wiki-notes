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