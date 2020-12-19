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

## Enums

```python
from sqlalchemy import Enum
from sqlalchemy.ext.declarative import declarative_base

Base = declarative_base()


class BaseEnum(enum.Enum):
    """Defines utility methods for accessing enum fields"""

    @classmethod
    def list_enums(cls) -> list:
        """Lists the enums"""
        return cls.__members__ # When you call AuthorTeams.list_enums(), it will output [TEAM_!, TEAM_2, TEAM_3]
      
class Teams(BaseEnum):
    """Enums for teams"""

    TEAM_1 = 1
    TEAM_2 = 2
    TEAM_3 = 3


class SomeTable(Base):
    __tablename__ = "some_table"

    id = Column(Integer, primary_key=True)
    team = Column(Enum(Teams))
```

## Base Class

When each SQLAlchemy model/table class has common methods, we can put them in the `Base` class that all the tables inherit from.

Here are some methods I found to be useful:

```python
from sqlalchemy.ext.declarative import declarative_base

class Base:
    """Parent class for all SQLA models"""

    def generate_key_value(self) -> Iterator[Dict[str, any]]:
        """Generate attribute name/val pairs, filtering out SQLA attributes."""
        exclude = ("_sa_adapter", "_sa_instance_state")
        for key, value in vars(self).items():
            if not key.startswith("_") and not any(
                hasattr(value, attr) for attr in exclude
            ):
                yield key, value

    def __repr__(self) -> str:
        """Prints the queries all nice"""
        params = ", ".join(
            f"\n\t{key}={value}" for key, value in self.generate_key_value()
        )
        return f"{self.__class__.__name__}({params}\n)"

    def get_unique_constraint_columns(self) -> List[str]:
        """Gets columns that have unique constraints""" 
        # This is given the unique constraints are defined in the __table_args__
        if hasattr(self, "__table_args__"):
            table_args = self.__table_args__
        else:
            return []

        if table_args:
            return [column.name for column in table_args[0].columns]

    def get_columns(self) -> Dict[str, any]:
        """Gets columns values of entry excluding SQLAlchemy default columns"""
        return {
            column: value
            for column, value in vars(self).items()
            if column != "_sa_instance_state"
        }

Base = declarative_base(cls=Base)

class SomeTable(Base):
    __tablename__ = "some_table"

    id = Column(Integer, primary_key=True)
    something_unique = Column(String(255), nullable=False)

    __table_args__ = (UniqueConstraint("something_unique"),) # also works with multiple columns
```

## Foreign Keys

```python
class ParentTable(Base):
    __tablename__ = "parent_table"

    id = Column(Integer, primary_key=True)
    child = Column(ForeignKey("ChildTable.id"), index=True)
    child_table = relationship("ChildTable")

    
class ChildTable(Base):
    __tablename__ = "child_table"

    id = Column(Integer, primary_key=True)
```

## Datetime/Timestamp Column

```python
from datetime import datetime
from sqlalchemy.dialects.mysql import DATETIME


class SomeTable(Base):
    __tablename__ = "some_table"

    id = Column(Integer, primary_key=True)
    timestamp = Column(DATETIME(fsp=6), default=datetime.utcnow) # PASS IN THE FUNCTION (DONT PASS IT IN WITH ())
```

## Useful SQLAlchemy Utility Functions

```python
"""SQLAlchemy functions that are commonly used among the bitbucket classes"""
from typing import Union

from sqlalchemy.ext.declarative.api import DeclarativeMeta
from sqlalchemy.orm.session import Session

from logger import logger

# <some_model_class_object> = e.g. SomeTable(..., ...)
def get_unique_constraint_filters(entry: <some_model_class_object>) -> (DeclarativeMeta, dict):
    """Gets the table and filters needed in order to query for an entry"""
    table = entry.__class__
    return table, {
        getattr(table, unique_col): getattr(entry, unique_col)
        for unique_col in entry.get_unique_constraint_columns()
    }


def get_entry_id(entry: <some_model_class_object>, session: Session) -> Union[None, int]:
    """Gets ID of a given entry in MySQL"""
    table, filters = get_unique_constraint_filters(entry)
    query = session.query(table)

    for column, value in filters.items():
        query = query.filter(column == value)

    if query.scalar():
        return query.first().id
    else:
        logger.debug("ID was not found in table %s", table)
        return None


def upsert_entry_to_mysql(entry: entry: <some_model_class_object>, session: Session) -> None:
    """Upserts entry to MySQL"""
    table, filters = get_unique_constraint_filters(entry)
    entry_query = session.query(table)

    for column, value in filters.items():
        entry_query = entry_query.filter(column == value)

    if entry_query.scalar():
        entry_values = entry.get_columns()
        query_id = session.query(table).filter(table.id == entry_query.first().id)

        for column, value in entry_values.items():
            query_id.update({column: value})
    else:
        session.add(entry)

    session.commit()
```

