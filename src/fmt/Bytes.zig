const std = @import("std");

const Self = @This();
const bytes_per_group = 1024;
const bytes_per_kib = bytes_per_group;
const bytes_per_mib = bytes_per_kib * bytes_per_group;
const bytes_per_gib = bytes_per_mib * bytes_per_group;
const bytes_per_tib = bytes_per_gib * bytes_per_group;

pub fn allocPrint(allocator: std.mem.Allocator, bytes: usize) ![]const u8 {
    const f_bytes = asFloatFromInt(bytes);
    if (bytes < bytes_per_kib) {
        return std.fmt.allocPrint(allocator, "{d} Bi", .{bytes});
    } else if (bytes < bytes_per_mib) {
        return std.fmt.allocPrint(allocator, "{d:0.2} Ki", .{f_bytes / asFloatFromInt(bytes_per_kib)});
    } else if (bytes < bytes_per_gib) {
        return std.fmt.allocPrint(allocator, "{d:0.2} Mi", .{f_bytes / asFloatFromInt(bytes_per_mib)});
    } else if (bytes <= bytes_per_tib) {
        return std.fmt.allocPrint(allocator, "{d:0.2} Gi", .{f_bytes / asFloatFromInt(bytes_per_gib)});
    } else {
        return std.fmt.allocPrint(allocator, "{d:0.2} Ti", .{f_bytes / asFloatFromInt(bytes_per_tib)});
    }
}

fn asFloatFromInt(value: usize) f64 {
    return @as(f64, @floatFromInt(value));
}
