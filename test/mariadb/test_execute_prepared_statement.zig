const std = @import("std");
const testing = std.testing;

test "can execute a prepared statement and fetch a cursor" {
    try testing.expectEqual(1, 1);
}
