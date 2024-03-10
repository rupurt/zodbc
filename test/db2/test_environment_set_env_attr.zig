const std = @import("std");
const testing = std.testing;
const expectEqual = testing.expectEqual;
const expectError = testing.expectError;
const allocator = testing.allocator;

const zodbc = @import("zodbc");
const err = zodbc.errors;
const attrs = zodbc.odbc.attributes;

const AttributeValue = attrs.EnvironmentAttributeValue;

test "setEnvAttr/2 can modify settings that will be shared among connections" {
    const env = try zodbc.testing.environment();
    defer env.deinit();

    var odbc_buf: [256]u8 = undefined;

    try env.setEnvAttr(.{ .OdbcVersion = .V2 });
    @memset(odbc_buf[0..], 0);
    const odbc_version_value = try env.getEnvAttr(allocator, .OdbcVersion, odbc_buf[0..]);
    defer odbc_version_value.deinit(allocator);
    try expectEqual(
        AttributeValue.OdbcVersion.V2,
        odbc_version_value.OdbcVersion,
    );

    try env.setEnvAttr(.{ .ConnectionPooling = .OnePerDriver });
    @memset(odbc_buf[0..], 0);
    const connection_pooling_value = try env.getEnvAttr(allocator, .ConnectionPooling, odbc_buf[0..]);
    defer connection_pooling_value.deinit(allocator);
    try expectEqual(
        AttributeValue.ConnectionPooling.OnePerDriver,
        connection_pooling_value.ConnectionPooling,
    );

    try env.setEnvAttr(.{ .CpMatch = .RelaxedMatch });
    @memset(odbc_buf[0..], 0);
    const cp_match_value = try env.getEnvAttr(allocator, .CpMatch, odbc_buf[0..]);
    defer cp_match_value.deinit(allocator);
    try expectEqual(
        AttributeValue.CpMatch.RelaxedMatch,
        cp_match_value.CpMatch,
    );
}

test "setEnvAttr/2 returns an error for unixODBC attributes" {
    const env = try zodbc.testing.environment();
    defer env.deinit();

    try expectError(
        err.SetEnvAttrError.Error,
        env.setEnvAttr(.{ .UnixodbcSyspath = "/new/path" }),
    );

    try expectError(
        err.SetEnvAttrError.Error,
        env.setEnvAttr(.{ .UnixodbcVersion = "1234" }),
    );

    try expectError(
        err.SetEnvAttrError.Error,
        env.setEnvAttr(.{ .UnixodbcEnvattr = "FOO=BAR" }),
    );
}

// By default Db2 is set to return null terminated strings. The IBM documentation claims
// that you can disable null terminated strings but `SQLSetEnvAttr` through unixODBC
// returns an error with the message:
//
// `[unixODBC][Driver Manager]Optional feature not implemented`
//
// - https://www.ibm.com/docs/en/db2-for-zos/11?topic=functions-sqlsetenvattr-set-environment-attributes
test "setEnvAttr/2 returns an error when null terminated output is false" {
    const env = try zodbc.testing.environment();
    defer env.deinit();

    var odbc_buf: [256]u8 = undefined;

    try env.setEnvAttr(.{ .OutputNts = .True });
    @memset(odbc_buf[0..], 0);
    const output_nts_value = try env.getEnvAttr(allocator, .OutputNts, odbc_buf[0..]);
    defer output_nts_value.deinit(allocator);
    try expectEqual(
        AttributeValue.OutputNts.True,
        output_nts_value.OutputNts,
    );

    try expectError(
        err.SetEnvAttrError.Error,
        env.setEnvAttr(.{ .OutputNts = .False }),
    );
}
