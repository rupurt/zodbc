const std = @import("std");

const core = @import("core");
const Rowset = core.Rowset;

const Self = @This();

pub fn items(self: Self) RowsetIterator {
    _ = self;
    return .{};
}

pub const RowsetIterator = struct {
    pub fn next(self: Self) Rowset {
        _ = self;
        return .{
            .column_descriptions = .{},
        };
    }
};
