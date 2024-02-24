const std = @import("std");

const odbc = @import("odbc");
const ColDescription = odbc.types.ColDescription;

const Self = @This();

column_descriptions: []ColDescription = undefined,
