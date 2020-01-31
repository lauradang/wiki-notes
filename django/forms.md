# Forms

## request.POST with files

In addition to adding request.POST, you have to add request.FILES

```python
form = self.form(request.POST, request.FILES, instance=user)
```

## Instance

When fixing a form that is updating an existing object, you have to pass instance=object into the form

```python
form = self.form(instance=user)
```

