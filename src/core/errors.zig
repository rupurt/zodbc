pub const AllocError = @import("Handle.zig").AllocError;
pub const SetEnvAttrError = @import("Environment.zig").SetEnvAttrError;

const Connection = @import("Connection.zig");
pub const DriverConnectError = Connection.DriverConnectError;
pub const GetConnectAttrError = Connection.GetConnectAttrError;
pub const SetConnectAttrError = Connection.SetConnectAttrError;

const Statement = @import("Statement.zig");
pub const GetStmtAttrError = Statement.GetStmtAttrError;
pub const SetStmtAttrError = Statement.SetStmtAttrError;
pub const ColumnsError = Statement.ColumnsError;
pub const PrepareError = Statement.PrepareError;
pub const NumResultColsError = Statement.NumResultColsError;
pub const DescribeColError = Statement.DescribeColError;
pub const BindColError = Statement.BindColError;
pub const ExecuteError = Statement.ExecuteError;
pub const ExecDirectError = Statement.ExecDirectError;
pub const RowCountError = Statement.RowCountError;
pub const MoreResultsError = Statement.MoreResultsError;
pub const SetPosError = Statement.SetPosError;
pub const FetchError = Statement.FetchError;
pub const FetchScrollError = Statement.FetchScrollError;
