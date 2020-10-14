# Environment

## Downloading Python
Download Python from the website and ensure when you install, the "set to Path" is checked.

## Downloading Pip
You must download Python first. Then run these commands:
```bash
$ curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
$ python get-pip.py
```
Now set the pip path correctly using the method below.

**Note**: This did not work in VSCode for some reason, do it in the Windows command prompt.

## Set environment variable
Go to Control Panel and manually append to the variable. 

- **Remember to restart the terminal when appending to a variable**
- VSCode somehow does not work the same as the terminal, stick to the terminal when dealing with this in Windows

## See PATH variable
```bash
echo %PATH%
```

## Virtual Environment
```bash
$ pip install virtualenv
$ virtualenv env
$ \pathto\env\Scripts\activate
```

