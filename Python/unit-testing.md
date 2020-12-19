# Python Unit Testing

## Mocking function

```python
# file: module/module1.py
def get_name():
  return 1

# file: test.py
import mock # EXTERNAL DEPENDENCY DO PIP INSTALL
from module.module1 import get_name

def test_get_name(self):
    with mock.patch("module.module1.get_name") as mock_get_name:
        mock_get_name.return_value = 2
        assert get_name() == 2 # Should pass!
```

## Mocking method

```python
# file: module/module1.py
class ExampleClass:
  def get_name(self):
    return 1

# file: test.py
import mock # EXTERNAL DEPENDENCY DO PIP INSTALL
from module.module1.ExampleClass import get_name

def test_get_name(self):
    with mock.patch("module.module1.ExampleClass.get_name") as mock_get_name:
        mock_get_name.return_value = 2
        assert get_name() == 2 # Should pass!
```

## Testing functions that do not return anything

```python
# file: module/module1.py
import logging

def get_name(self):
  logging.info("Name was successfully requested")

# file: test.py
import mock
from module.module1 import get_name

def test_get_name(self):
    with mock.patch("logging") as mock_logging:
      	# Can do this:
        mock_logging.info.assert_called_once()
        # OR this:
				mock_logging.info.assert_called_with("Name was successfully requested")
        
        # Both should pass!
```

## Mocking requests

This is specifically for the external dependency `requests`.

```python
import mock

with mock.patch("requests.get") as mock_get_request:
    mock_get_request.return_value.json.return_value = some_dict
```

**Using `response` library**:

```python
import requests
import responses

@responses.activate
def test_get_response_json_success(self) -> None:
    test_url = "https://somewebsite.com"
    test_json = {"test": "data"}

    responses.add(responses.GET, test_url, json=test_json, status=200)
    response = requests.get(test_url)
    result = get_response_json(response, "some_msg") # some function that gets the json from a request

    assert result == test_json
```

## Mocking class objects

When we want a class object with mock fields, we can use `MagicMock`

```python
# file: module/module1.py
import subprocess
process = subprocess.run(...) # This returns an object with these fields: stdout, stderr, returncode

# file: test.py
import mock
from unittest.mock import MagicMock
from module.module1 import process

def test_subprocess(self) -> None:
    with mock.patch("subprocess.run") as mock_subprocess:
        mock_subprocess.return_value = MagicMock(
            returncode=127, 
          	stderr=b"Some error", 
          	stdout=b"something"
        )
        assert process.returncode == 127
        assert process.stderr == b"Some error"
        assert process.stdout = b"something"
```

## Mocking exception raised

```python
# file: module/module1.py
client = ...
logger = ...

def send_email():
  try:
    client.send_email()
  except SomeError as e:
    logger.error(e)
 
# file: test.py
import mock
from contextmanager import ExitStack
from module.module1 import send_email

def test_send_email_fail_error(self):
    self.mock_client = mock.patch("module.module1.client")
    self.mock_logger = mock.patch("module.module1.logger")
    
    with ExitStack() as context_stack:
        mock_client = context_stack.enter_context(self.mock_client)
        mock_logger = context_stack.enter_context(self.mock_logger)

        mock_client.send_email.side_effect = SomeError() #notice it's calling a function here
        send_email()
        mock_logger.error.assert_called_once()
```

## Mocking global variables

```python
import mock # EXTERNAL DEPENDENCY DO PIP INSTALL

# file: module/module1.py
name = 1

def get_name():
  return name

# file: test.py
from module.module1 import get_name

def test_get_name(self):
    with mock.patch("module.module1.name") as mock_name:
        mock_name.return_value = 2
        assert get_name() == 2 # Should pass!
```

## Mock Endpoints (Flask-specific)

```python
import unittest
import json
from flask import Flask, jsonify
from api.exceptions.error import Error
from api.endpoints.example_endpoint import blueprint

class ExampleTestCase(unittest.TestCase):
    def __init__(self, *args, **kwargs):
        super(ExampleTestCase, self).__init__(*args, **kwargs)
        
        self.app = Flask(__name__)
        self.tester = self.app.test_client()
        # If the Flask App you are testing is a blueprint
        self.app.register_blueprint(blueprint) 
        
    # Error handler - Enables assertRaise in unit testing
    @self.app.errorhandler(Error)
    def handle_invalid_usage(error):
        response = jsonify(error.to_dict())
        response.status_code = error.status_code
        return response
      
    def example_test(self):
        request_data = {"sample": "hello how are you?"}
        response = self.tester.post(
            endpoint,
            data=json.dumps(request_data),
            content_type="application/json"
        )
        response_data = response.get_data(as_text=True)
        response_data = json.loads(response_data) if response_data else response_data

        self.assertEqual(response.status_code, 200)
        self.assertIsNotNone(response_data["categories"])
        self.assertEqual(response_data["sample"], request_data["sample"])
```

## Mock Databases using SQLAlchemy

```python
# File that defines tables
from sqlalchemy import Column, Integer, String, Boolean, ForeignKey, Float
from sqlalchemy.ext.declarative import declarative_base

Base = declarative_base()

class ExampleTable(Base):
    """
    The model schema for the classification_models table.
    """
    __tablename__ = "test_table"

    id = Column(Integer, primary_key=True)
    field1 = Column(String(250), nullable=False)

    def __repr__(self):
        return "<{}(id='{}', field1='{}')>".format(
            ExampleTable.__class__.__name__,
            self.id,
            self.field1
        )
```



```python
from sqlalchemy import create_engine
from sqlalchemy.orm import scoped_session, sessionmaker
from api.database_models.models import (
    Base,
    ExampleTable,
)

# setUp is a function from unittest.TestCase. It is part of a class that inherits from the unittest.TestCase class
def setUp(self):
    temp_database_uri = "sqlite:///:memory:"
    engine = create_engine(temp_database_uri, echo=False)
    self.session = scoped_session(
        sessionmaker(
            autocommit=False,
            autoflush=False,
            bind=engine
        )
    )
    Base.metadata.drop_all(bind=engine)

    with self.app.app_context():
        Base.query = self.session.query_property()
        Base.metadata.create_all(bind=engine)
       
        # Seeding a CSV if needed
        df = pd.read_csv("seed.csv", index_col=0)
        df.to_sql(
            ExampleTable().__tablename__,
            con=engine,
            if_exists="append",
          	index=False # if you do not want the index column
        )

# Similarly to setUp, we also have tearDown
def tearDown(self):
    self.session.remove()
    self.session.close()

#### Now, you can add unit tests and use self.session to query for the database
```

## Mock AWS S3 Services

```python
## Here is the global util file for usage in your entire Flask app
def create_s3_client():
    if os.environ.get("IS_UNIT_TEST"):
        return boto3.client("s3")

    return boto3.client(
        "s3",
        aws_access_key_id=aws_public_key,
        aws_secret_access_key=aws_secret_key,
        region_name=aws_region
    )
```

```python
from moto import mock_s3
from api.util import create_s3_client

class ExampleS3TestCase(unittest.TestCase):
    @mock_s3
    def __init__(self, *args, **kwargs):
        super(ExampleS3TestCase, self).__init__(*args, **kwargs)
        self.s3_client = create_s3_client()
        
    def setUp(self):
        super(ExampleS3TestCase, self).setUp()
        
        # Creating a fake file to upload to the S3 bucket
        _ = open("test.pkl", "w").close()

    def tearDown(self):
        super(ExampleS3TestCase, self).tearDown()
        
        # Remove the fake file that was created in setUp()
        os.remove("test.pkl")

    @mock_s3
    def setup_s3(self):
        self.s3_client.create_bucket(Bucket=aws_bucket_name)
        self.s3_client.put_object(Bucket=aws_bucket_name,
                                  Body="",
                                  Key=S3_CLASS_DIR)
        self.s3_client.upload_file(self.model_name_path,
                                   aws_bucket_name,
                                   self.test_model_s3_path)
        
    @mock_s3
    def test_download_models_from_bucket(self):
        self.setup_s3()
        # The function that we are testing that uses the real s3 client
        download_models_from_bucket() 
        self.assertIn(self.test_model_name, os.listdir(CONTAINER_MODEL_DIR))
```























