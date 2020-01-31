# Database Queries

### Deleting rows with foreign key constraints

1. Figure out all the relationships of the table of the row you are trying to delete (go to model_name.php and check for belongsToMany, HasMany, etc.)
2. Create a delete helper function in model_name.php and use ```detach()``` and ```delete()``` as necessary
```php
public function delete()
{
    $this->grants()->detach();
    $this->fippaImports()->detach();
    $this->documents()->delete();

    parent::delete();
}
```
3. Call this function in the controller
```php
public function destroy(FippaTracking $fippaTracking)
{
    $fippaTracking->delete();

    return redirect()
        ->route('fippa_trackers')
        ->withSuccess('Fippa Tracker successfully deleted.');
}
```