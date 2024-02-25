const std = @import("std");
const zig_cli = @import("zig-cli");
const app = @import("app.zig");

pub fn run(allocator: std.mem.Allocator) !void {
    return zig_cli.run(app.app, allocator);
}
