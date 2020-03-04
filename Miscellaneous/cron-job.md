# Cron Jobs

### List Cron Jobs

```bash
$ crontab -l
```

### New Cron Job

```bash
$ crontab -e
>> Opens file to edit
# Timing syntax
50 19 * * * python3 text.py > test.txt
```

**Timing Syntax**:

1. minute
2. hour
3. day of month
4. month
5. day of week

Asterisks(*) indicate it will run every *time*. 

### Remove Cron Job

```bash
$ crontab -r
```

