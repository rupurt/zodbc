const std = @import("std");
const zig_cli = @import("zig-cli");

var config = struct {
    host: []const u8 = "localhost",
    port: u16 = undefined,
    command: []const u8 = undefined,
}{};

pub var cmd = zig_cli.Command{
    .name = "special-columns",
    .target = zig_cli.CommandTarget{
        .action = zig_cli.CommandAction{
            .exec = run,
        },
    },
};

fn run() !void {
    std.log.debug("server is listening on {s}:{}", .{ config.host, config.port });
}
