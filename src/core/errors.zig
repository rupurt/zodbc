pub const AllocError = @import("Handle.zig").AllocError;
pub const DriverConnectError = @import("Connection.zig").DriverConnectError;

const Statement = @import("Statement.zig");
pub const SetEnvAttrError = Statement.SetEnvAttrError;
pub const ColumnsError = Statement.ColumnsError;
pub const PrepareError = Statement.PrepareError;
pub const NumResultColsError = Statement.NumResultColsError;
pub const DescribeColError = Statement.DescribeColError;
pub const BindColError = Statement.BindColError;
pub const ExecuteError = Statement.ExecuteError;
pub const FetchScrollError = Statement.FetchScrollError;
