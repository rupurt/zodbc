const std  = @import("std");
const builtin = @import("builtin");
const native_endian = builtin.target.cpu.arch.endian();

pub fn readInt(T: type, buf: []u8) T {
    const slice: []const u8 = buf[0..@intCast(@sizeOf(T))];
    return std.mem.readInt(T, @ptrCast(slice), native_endian);
}
