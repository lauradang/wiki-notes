### Migrating Models

#### Go to admin.py, add code 
```python
from django.contrib import admin
from mptt.admin import MPTTModelAdmin
from .models import Company

@admin.register(Company)
class CompanyAdmin(MPTTModelAdmin):
  pass

@admin.register(HotSearch)
class HotSearchAdmin(admin.ModelAdmin):
    pass
```
#### Activate grantmatch-app virtual server
```bash
$ workon grantmatch-app
```
#### Make migrations and migrating
```bash
$ python manage.py makemigrations
$ python manage.py migrate
```

#### Rollback migration
```bash
$ python manage.py migrate your_app (timesheet eg) 0002
```
- Delete individual migration files (both of them)
- Update model 
- New make migration

#### When ```make migrations``` work but not ```migrate```
```bash
$ python3 manage.py migrate jobs 0003 --fake
$ python3 manage.py migrate jobs 
```