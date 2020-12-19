# API
### What is an API?
- set of data (often in JSON)
- access different endpoints of API to get certain data (we usually don't want all the data)

## Request Handler

When building an application that queries from an API a lot, we need to expect errors in handling requests to the API. We can build a handler class to handle all the exceptions without filling our code with try-excepts.

**General rule of thumb**: When we find we have many repetitive try-excepts, build a handler class.

```python
"""Class with methods that handle requests to API"""
import json
import time
from typing import Union

import requests

from handlers.handler import Handler
from logger import logger

base_url = "http://some-api.com"

# Handler class is a parent class that handles parsing the credentials
class RequestHandler(Handler):
    """Class that handles requests"""

    def __init__(self, *args, **kwargs) -> None:
        super(RequestHandler, self).__init__(*args, **kwargs)
        
        api_credentials = self.get_credentials() # this method comes from the parent Handler class
        self.default_params = {"some_param": "some_value"}

    def get_request(self, url_path: str, params=None) -> Union[None, requests.Response]:
        """Sends GET request to API"""
        if params:
            self.default_params.update(params)

        request_url = base_url + url_path

        try:
            response = requests.get(
                request_url,
                headers={"Content-Type": "application/json"},
                params=self.default_params,
                auth=(credentials["user"], credentials["password"]),
            )
        except requests.exceptions.RequestException as err:
            logger.error("Unable to fetch %s\n%s", err, request_url)
            return None

        if hasattr(response, "status_code"):
            status_code = response.status_code
        else:
            logger.error("Response has no status_code attribute")
            return None

        if status_code == 429:
            time.sleep(60)
            response = self.get_request(url_path, params=params, api=api)

        if status_code != 200:
            logger.error(
                "Unable to fetch - return code %s\n%s", status_code, request_url
            )
            return None

        return response

    def get_response_json(
        self, response: requests.Response, requested_info: str
    ) -> Union[None, dict]:
        """Gets JSON from response"""
        if not response:
            return None

        try:
            response_json = response.json()
        except json.decoder.JSONDecodeError:
            logger.error("Could not decode JSON for %s", requested_info)
            response_json = None

        return response_json
```

Example on how to use request class:

```python
response = request_handler.get_request("some_path")
response_json = request_handler.get_response_json(response, "some_log")
```

