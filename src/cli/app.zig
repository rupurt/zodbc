const std = @import("std");
const zig_cli = @import("zig-cli");
const sql = @import("cmd/sql.zig");
const tables = @import("cmd/tables.zig");
const table_privileges = @import("cmd/table_privileges.zig");
const columns = @import("cmd/columns.zig");
const special_columns = @import("cmd/special_columns.zig");
const column_privileges = @import("cmd/column_privileges.zig");
const primary_keys = @import("cmd/primary_keys.zig");
const foreign_keys = @import("cmd/foreign_keys.zig");
const statistics = @import("cmd/statistics.zig");
const data_sources = @import("cmd/data_sources.zig");
const functions = @import("cmd/functions.zig");
const procedures = @import("cmd/procedures.zig");
const procedure_columns = @import("cmd/procedure_columns.zig");
const info = @import("cmd/info.zig");
const attrs = @import("cmd/attrs.zig");
const benchmark = @import("cmd/benchmark.zig");

pub var app = &zig_cli.App{
    .command = zig_cli.Command{
        .name = "zodbc",
        .target = zig_cli.CommandTarget{
            .subcommands = &.{
                &sql.cmd,
                &tables.cmd,
                &table_privileges.cmd,
                &columns.cmd,
                &column_privileges.cmd,
                &special_columns.cmd,
                &primary_keys.cmd,
                &foreign_keys.cmd,
                &statistics.cmd,
                &data_sources.cmd,
                &functions.cmd,
                &procedures.cmd,
                &procedure_columns.cmd,
                &info.cmd,
                &attrs.cmd,
                &benchmark.cmd,
            },
        },
    },
};
