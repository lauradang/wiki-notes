# SQLAlchemy

## Multithreading

Typically, SQLAlchemy does not support multithreading. This can be an issue if your API/web client uses multiple workers. However, we can support multithreading as follows:

```python
## This is a global util file

import os
from contextlib import contextmanager
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from api.config import db_username, db_password, db_private_ip, db_database_name

DB_CREDENTIALS = f"{db_username}:{db_password}@{db_private_ip}:3306/{db_database_name}"

def create_engine_and_session():
  	# Ensure pymysql is installed
    db_uri = f"mysql+pymysql://{DB_CREDENTIALS}"

    if os.environ.get("IS_UNIT_TEST"):
        db_uri = "sqlite:///:unit_test:"

    new_engine = create_engine(db_uri, echo=False)
    new_session = sessionmaker(autocommit=False,
                               autoflush=False,
                               bind=new_engine)

    return new_engine, new_session

current_engine, Session = create_engine_and_session()

@contextmanager
def session_scope():
    session = Session()
    try:
        yield session
        session.commit()
    except:
        session.rollback()
    finally:
        session.close()
```

```python
## Example file that manipulates the database in a multithreaded environment
## Keep in mind you should keep all sessions separate. Do not pass sessions from function to function.
from api.util import session_scope # importing function from file above

def example_function():
    with session_scope() as session:
        learner_name = session.query(
            DatabaseModel.field
        ).first[0]
```

