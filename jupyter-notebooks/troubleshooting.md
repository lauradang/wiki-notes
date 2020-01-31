# Troubleshooting

[jupyter command not found on mac ox · Issue \#89 · jupyter/help · GitHub](https://github.com/jupyter/help/issues/89)

```bash
sudo rm -rf /Library/Frameworks/Python.framework
rm /usr/local/bin/python3*
brew uninstall python3
brew install python3
which python3
python3 -m pip install --upgrade pip
python3 -m pip install jupyter
which jupyter
jupyter notebook
```

