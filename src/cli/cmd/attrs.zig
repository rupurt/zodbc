const std = @import("std");
const zig_cli = @import("zig-cli");

const env = @import("attrs/env.zig");

pub var cmd = zig_cli.Command{
    .name = "attrs",
    .target = zig_cli.CommandTarget{
        .subcommands = &.{
            &env.cmd,
        },
    },
};
