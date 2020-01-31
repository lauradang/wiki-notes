# Manipulating Models

## Get model

```python
MyModel = apps.get_moel('app_name', 'MyModel')
```

## Get field values

```python
for model_obj in MyModel.objects.all():
  model_obj.field_name # get value of field name of obj
  Model.objects.get(pk=...)

  model_obj_save() # make sure you save after manipulating anything
```

