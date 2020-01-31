# Migrations

```bash
$ ssh vagrant@192.168.20.10
$ cd fairtax..
$ php artisan make:migration fippa_trackings_documents_add_checksum
…
$ php artisan migrate
```
### Rollbacks
```bash
$ php artisan migrate:rollback
```