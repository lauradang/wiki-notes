## Tor

#### Set Up
```bash
$ brew install tor
```
Be in folder with .torr
```bash
$ touch .torrc
$ open .torrc
$ tor --hash-password "$PASSWORD"
```
Copy and paste output into .torrc
```
SOCKSPort 9050
HashedControlPassword #:RANDOMCAPS
CookieAuthentication 1
```
#### Code
```bash
$ tor
```
```python
from torrequest import TorRequest
import requests

session = requests.session()
session.proxies = {}
session.proxies['http'] = 'socks5h://localhost:9050'
session.proxies['https'] = 'socks5h://localhost:9050'

source_start = session.get(url)
```