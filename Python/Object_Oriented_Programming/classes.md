## Class-Level State vs Instance-Level State in Python Classes

### Key Concepts

- **Class-level state:**  
  - Shared across all instances of the class (or accessed directly via the class).  
  - Typically used for fixed configuration or constants.  
  - Works naturally with `@classmethod`s because no need to instantiate objects.  
  - Example use case: database table name, API endpoint URL, or shared resource identifier.

- **Instance-level state:**  
  - Unique to each instance/object.  
  - Used when each object requires its own data or context.  
  - Requires `__init__` method and instance methods.  
  - Example use case: user-specific data, session info, or request parameters.

---

### When to Use Classmethods vs `__init__`

| Scenario                                  | Use `@classmethod`                     | Use `__init__` + Instance Methods           |
|-------------------------------------------|---------------------------------------|----------------------------------------------|
| Fixed, shared configuration per class     | ✅ Yes (e.g., shared DB table name)    | ❌ No need to create instances                |
| Varying configuration or context per call | ❌ Leads to repetitive argument passing| ✅ Cleaner to encapsulate context in instance|
| Stateless utility or service methods       | ✅ Ideal for utilities and helpers     | Sometimes unnecessary                          |
| Stateful workflows or processors            | ❌ Difficult to manage state            | ✅ Best suited for tracking internal state    |

---

### Code Examples

#### Example: Class-level state with classmethods

```python
class DataAccessObject:
    table_name = None  # Class-level fixed configuration

    @classmethod
    def get_table(cls):
        return Database.connect_table(cls.table_name)

    @classmethod
    def find_by_id(cls, record_id):
        table = cls.get_table()
        return table.find_one({"id": record_id})

class UserDAO(DataAccessObject):
    table_name = "users"
```
- table_name is shared and fixed for each DAO subclass.
- No need to instantiate UserDAO to call find_by_id.
- Suitable for stateless, shared configuration.

#### Example: Instance-level state

```python
class ReportGenerator:
    def __init__(self, user, filters, data_source):
        self.user = user
        self.filters = filters
        self.data_source = data_source

    def generate(self):
        # Use instance variables to customize report generation
        filtered_data = self.data_source.query(self.filters)
        return self._format_report(filtered_data)

    def _format_report(self, data):
        # Instance method accessing self context
        return f"Report for {self.user.name}: {data}"
```
- Each ReportGenerator instance carries its own state (user, filters, etc.).
- Cleaner than passing these arguments repeatedly to static methods.
- Better for workflows needing persistent context.


