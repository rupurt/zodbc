const std = @import("std");
const zig_cli = @import("zig-cli");

pub var cmd = zig_cli.Command{
    .name = "load",
    .target = zig_cli.CommandTarget{
        .action = zig_cli.CommandAction{
            .exec = run,
        },
    },
};

fn run() !void {
    std.log.err("not implemented yet", .{});
}
