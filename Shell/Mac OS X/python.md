# Python

## Downloading Python

https://opensource.com/article/19/5/python-3-default-mac

```bash
$ brew install pyenv
$ pyenv install <version_number> # e.g. 3.7.3
$ pyenv global 3.7.3
# and verify it worked
$ pyenv version
>> 3.7.3 (set by /Users/lauradang/.pyenv/version)

$ echo -e 'if command -v pyenv 1>/dev/null 2>&1; then\n  eval "$(pyenv init -)"\nfi' >> ~/.bash_profile

# Restart Terminal
$ exec $0
$ which python
/Users/lauradang/.pyenv/shims/python
```

