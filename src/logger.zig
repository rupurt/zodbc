pub fn Logger(comptime T: type) type {
    _ = T;
    return struct {
        pub fn err(message: []const u8) void {
            _ = message;
        }

        pub fn info(message: []const u8) void {
            _ = message;
        }

        pub fn warn(message: []const u8) void {
            _ = message;
        }
    };
}
