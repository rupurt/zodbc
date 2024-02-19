pub const SetEnvAttrError = error{
    Error,
};

pub const DriverConnectError = error{
    Error,
    InvalidHandle,
    NoDataFound,
};

pub const PrepareError = error{
    Error,
    InvalidHandle,
};

pub const NumResultColsError = error{
    Error,
    InvalidHandle,
    StillExecuting,
};

pub const DescribeColError = error{
    Error,
    InvalidHandle,
    // StillExecuting,
};

pub const ExecuteError = error{
    Error,
    InvalidHandle,
    NeedData,
    NoDataFound,
};

pub const FetchScrollError = error{
    Error,
    InvalidHandle,
    // NeedData,
    // NoDataFound,
};
