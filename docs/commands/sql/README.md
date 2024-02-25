# Commands / SQL

```shell
> zodbc sql -h
USAGE:
  zodbc sql [OPTIONS]

OPTIONS:
  -c, --command <VALUE>   SQL statement that will be executed
  -d, --dsn <VALUE>       Data source name connection string
  -w, --workers <VALUE>   Number of connections to use within separate kernel threads
  -t, --timing            Log execution time metrics
  -v, --verbose <VALUE>   Log memory and call trace information
  -h, --help              Prints help information
```

```shell
> zodbc sql \
    --command='SELECT * FROM SYSIBM.SYSTABLES' \
    --dsn="Driver=${DB2_DRIVER};Hostname=localhost;Database=testdb;Port=50000;Uid=db2inst1;Pwd=password;" \
    --workers=4 \
    --timing \
    --verbose=1
```
