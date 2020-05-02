# Python Flask Unit Testing

## Mock Endpoints

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
    temp_database_uri = "sqlite:///:unit_test:"
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
            if_exists="append"
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























