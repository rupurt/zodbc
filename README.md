# zodbc

A blazing fast ODBC Zig client

# Goals

- [ ] Fastest ODBC C ABI client library for bulk load/unload
- [ ] Concurrent ODBC statement & connection rowset fetching
- [x] ODBC row & column bindings
- [ ] ODBC zero copy direct C ABI 
- [ ] ODBC to Arrow record batch reader/writer
- [x] ODBC to Zig struct
- [x] ODBC low level bindings to Zig
- [ ] High level C ABI
- [x] High level Zig bindings
- [ ] Automated benchmark and regression suite

# Development

```shell
> nix develop -c $SHELL
```

```shell
> make
```

```shell
> make test
> make test/unit
> make test/integration
> make test/integration.db2
> make test/integration.mariadb
> make test/integration.postgres
> make test.nosummary
> make test.nosummary/unit
> make test.nosummary/integration
> make test.nosummary/integration.db2
> make test.nosummary/integration.mariadb
> make test.nosummary/integration.postgres
> make test.summary
```

```shell
> make build
> make build.fast
> make build.small
> make build.safe
```

```shell
> make clean
```

```shell
> make run
```

```shell
> make compose.up
> make compose.down
```

# License

`zodbc` is released under the [MIT license](./LICENSE)
