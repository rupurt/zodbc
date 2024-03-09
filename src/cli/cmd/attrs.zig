const std = @import("std");
const zig_cli = @import("zig-cli");

const env = @import("attrs/env.zig");
const con = @import("attrs/con.zig");
const stmt = @import("attrs/stmt.zig");

pub var cmd = zig_cli.Command{
    .name = "attrs",
    .target = zig_cli.CommandTarget{
        .subcommands = &.{
            &env.cmd,
            &con.cmd,
            &stmt.cmd,
        },
    },
};
