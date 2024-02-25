const std = @import("std");

const odbc = @import("odbc");
const ColDescription = odbc.types.ColDescription;

const Self = @This();

column_descriptions: []ColDescription = undefined,

pub fn init(column_descriptions: []ColDescription) Self {
    return .{
        .column_descriptions = column_descriptions,
    };
}

pub fn deinit(self: Self) void {
    _ = self;
}
