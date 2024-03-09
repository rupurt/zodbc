const std = @import("std");
const testing = std.testing;
const expectEqual = testing.expectEqual;
const expectEqualStrings = testing.expectEqualStrings;
const expectError = testing.expectError;
const allocator = testing.allocator;

const zodbc = @import("zodbc");
const err = zodbc.errors;
const attrs = zodbc.odbc.attributes;

const AttributeValue = attrs.EnvironmentAttributeValue;

test "getEnvAttr/3 can retrieve the current item values" {
    const env = try zodbc.testing.environment();
    defer env.deinit();

    var odbc_buf: [256]u8 = undefined;

    @memset(odbc_buf[0..], 0);
    const odbc_version_value = try env.getEnvAttr(allocator, .OdbcVersion, odbc_buf[0..]);
    defer odbc_version_value.deinit(allocator);
    try expectEqual(
        AttributeValue.OdbcVersion.V3,
        odbc_version_value.OdbcVersion,
    );

    @memset(odbc_buf[0..], 0);
    const output_nts_value = try env.getEnvAttr(allocator, .OutputNts, odbc_buf[0..]);
    defer output_nts_value.deinit(allocator);
    try expectEqual(
        AttributeValue.OutputNts.True,
        output_nts_value.OutputNts,
    );

    @memset(odbc_buf[0..], 0);
    const connection_pooling_value = try env.getEnvAttr(allocator, .ConnectionPooling, odbc_buf[0..]);
    defer connection_pooling_value.deinit(allocator);
    try expectEqual(
        AttributeValue.ConnectionPooling.Off,
        connection_pooling_value.ConnectionPooling,
    );

    @memset(odbc_buf[0..], 0);
    const cp_match_value = try env.getEnvAttr(allocator, .CpMatch, odbc_buf[0..]);
    defer cp_match_value.deinit(allocator);
    try expectEqual(
        AttributeValue.CpMatch.StrictMatch,
        cp_match_value.CpMatch,
    );

    @memset(odbc_buf[0..], 0);
    const unixodbc_syspath_value = try env.getEnvAttr(allocator, .UnixodbcSyspath, odbc_buf[0..]);
    defer unixodbc_syspath_value.deinit(allocator);
    try expectEqualStrings(
        "/etc",
        unixodbc_syspath_value.UnixodbcSyspath,
    );

    @memset(odbc_buf[0..], 0);
    const unixodbc_version_value = try env.getEnvAttr(allocator, .UnixodbcVersion, odbc_buf[0..]);
    defer unixodbc_version_value.deinit(allocator);
    try expectEqualStrings(
        "2.3.12",
        unixodbc_version_value.UnixodbcVersion,
    );
}

test "getEnvAttr/3 returns an error for unsupported items" {
    const env = try zodbc.testing.environment();
    defer env.deinit();

    var odbc_buf: [256]u8 = undefined;

    @memset(odbc_buf[0..], 0);
    try expectError(
        err.GetEnvAttrError.Error,
        env.getEnvAttr(allocator, .UnixodbcEnvattr, odbc_buf[0..]),
    );
}
