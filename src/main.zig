const std = @import("std");
const cli = @import("cli");

var gpa = std.heap.GeneralPurposeAllocator(.{}){};
const allocator = gpa.allocator();

pub fn main() !void {
    return cli.run(allocator);
}
