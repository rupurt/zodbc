const std = @import("std");
const zig_cli = @import("zig-cli");

const environment = @import("attributes/environment.zig");
const connection = @import("attributes/connection.zig");
const statement = @import("attributes/statement.zig");

pub var cmd = zig_cli.Command{
    .name = "attributes",
    .options = &.{},
    .target = zig_cli.CommandTarget{
        .subcommands = &.{
            &environment.cmd,
            &connection.cmd,
            &statement.cmd,
        },
    },
};
