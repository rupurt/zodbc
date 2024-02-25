# zodbc

A blazing fast ODBC Zig client

```shell
> zodbc -h
zodbc

USAGE:
  zodbc [OPTIONS]

COMMANDS:
  sql
  tables
  table-privileges
  columns
  column-privileges
  special-columns
  primary-keys
  foreign-keys
  statistics
  data-sources
  functions
  procedures
  procedure-columns
  benchmark

OPTIONS:
  -h, --help   Prints help information
```

## Goals

- [ ] Fastest ODBC C ABI client library for bulk load/unload
- [x] Kernel thread worker pool concurrency per ODBC connection
- [x] High level Zig bindings
- [x] ODBC row & column bindings
- [x] ODBC Zig bindings
- [ ] ODBC to Arrow record batch reader/writer
- [ ] ODBC zero copy C ABI 
- [ ] High level C ABI
- [ ] Database benchmarks
- [ ] Python bindings
- [ ] Elixir bindings
- [ ] Java bindings
- [ ] .NET bindings

## Getting Started

- [Usage](#usage)
- [Commands](./docs/commands)
    - [sql](./docs/commands/sql)
    - [tables](./docs/commands/tables)
    - [table-privileges](./docs/commands/table_privileges)
    - [columns](./docs/commands/columns)
    - [column-privileges](./docs/commands/column_privileges)
    - [special-columns](./docs/commands/special_columns)
    - [primary-keys](./docs/commands/primary_keys)
    - [foreign-keys](./docs/commands/foreign_keys)
    - [statistics](./docs/commands/statistics)
    - [data-sources](./docs/commands/data_sources)
    - [functions](./docs/commands/functions)
    - [procedures](./docs/commands/procedures)
    - [procedure-columns](./docs/commands/procedure-columns)
    - [benchmark](./docs/commands/benchmark)
- [Library](./docs/LIBRARY.md)
- [Nix](./docs/NIX.md)
- [Development](./docs/DEVELOPMENT.md)

## Usage

1. Add `zodbc` as a dependency in your `build.zig.zon`
```zig
.{
    .name = "<name_of_your_package>",
    .version = "<version_of_your_package>",
    .dependencies = .{
        .zodbc = .{
            .url = "https://github.com/rupurt/zodbc/archive/<git_tag_or_commit_hash>.tar.gz",
            .hash = "<package_hash>",
        },
    },
}
```

Set `<package_hash>` to `12200000000000000000000000000000000000000000000000000000000000000000`, and Zig will provide the correct found value in an error message.

2. Add `zodbc` as a dependency module in your `build.zig`
```zig
// ...
const zodbc_dep = b.dependency("zodbc", .{ .target = target, .optimize = optimize });
exe.root_module.addImport("zodbc", zodbc_dep.module("zodbc"));
```

## Development

```shell
> nix develop -c $SHELL
```

```shell
> make
```

```shell
> make test
```

```shell
> make run
```

```shell
> make clean
```

```shell
> make build
```

```shell
> make exec
```

```shell
> make compose.up
> make compose.down
```

# License

`zodbc` is released under the [MIT license](./LICENSE)
