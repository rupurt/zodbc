# Commands / Attrs

- [env](#env)
- [con](#con)
- [stmt](#stmt)

```console
> zodbc attrs -h
USAGE:
  zodbc attrs [OPTIONS]

COMMANDS:
  env
  con
  stmt

OPTIONS:
  -h, --help              Prints help information
```

## env

```console
> zodbc attrs env
SQL_ATTR_ODBC_VERSION=attributes.EnvironmentAttributeValue.OdbcVersion.V3
SQL_ATTR_OUTPUT_NTS=attributes.EnvironmentAttributeValue.OutputNts.True
SQL_ATTR_CONNECTION_POOLING=attributes.EnvironmentAttributeValue.ConnectionPooling.Off
SQL_ATTR_CP_MATCH=attributes.EnvironmentAttributeValue.ConnectionPooling.Off
SQL_ATTR_UNIXODBC_SYSPATH=/etc
SQL_ATTR_UNIXODBC_VERSION=2.3.12
```

## con

```console
> zodbc attrs con --dsn="Driver=${DB2_DRIVER};Hostname=localhost;Database=testdb;Port=50000;Uid=db2inst1;Pwd=password;"
SQL_ATTR_ACCESS_MODE=attributes.ConnectionAttributeValue.AccessMode.ReadWrite
SQL_ATTR_AUTO_COMMIT=attributes.ConnectionAttributeValue.Autocommit.On
SQL_ATTR_CONNECTION_TIMEOUT=0
SQL_ATTR_LOGIN_TIMEOUT=0
SQL_ATTR_ODBC_CURSORS=attributes.ConnectionAttributeValue.OdbcCursors.UseDriver
SQL_ATTR_TRACE=attributes.ConnectionAttributeValue.Trace.Off
SQL_ATTR_TXN_ISOLATION=attributes.ConnectionAttributeValue.TxnIsolation.ReadCommitted
SQL_ATTR_ASYNC_ENABLE=attributes.ConnectionAttributeValue.AsyncEnable.Off
```

## stmt

```console
> zodbc attrs stmt --dsn="Driver=${DB2_DRIVER};Hostname=localhost;Database=testdb;Port=50000;Uid=db2inst1;Pwd=password;"
...
```
