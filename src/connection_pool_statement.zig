pub const ConnectionPoolStatement = struct {
    pub fn init() !*ConnectionPoolStatement {}

    pub fn deinit(self: *ConnectionPoolStatement) !void {
        _ = self;
    }

    pub fn prepare(self: *ConnectionPoolStatement) !void {
        _ = self;
    }

    pub fn execute(self: *ConnectionPoolStatement) !void {
        _ = self;
    }

    pub fn executeDirect(self: *ConnectionPoolStatement) !void {
        _ = self;
    }
};
