const std = @import("std");

const odbc = @import("odbc");
const ColDescription = odbc.types.ColDescription;

const Self = @This();

allocator: std.mem.Allocator,
column_descriptions: []ColDescription = undefined,
column_buffers: []u8 = undefined,

pub fn init(
    allocator: std.mem.Allocator,
    column_descriptions: []ColDescription,
    fetch_array_size: usize,
) !Self {
    _ = fetch_array_size;
    const column_buffers = try allocator.alloc(u8, column_descriptions.len);
    return .{
        .allocator = allocator,
        .column_descriptions = column_descriptions,
        .column_buffers = column_buffers,
    };
}

pub fn deinit(self: Self) void {
    self.allocator.free(self.column_buffers);
}
