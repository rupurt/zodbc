const std = @import("std");
const testing = std.testing;
const expectEqual = testing.expectEqual;
const expectError = testing.expectError;
const allocator = testing.allocator;

const zodbc = @import("zodbc");
const err = zodbc.errors;
const attrs = zodbc.odbc.attributes;

const AttributeValue = attrs.EnvironmentAttributeValue;

test ".setEnvAttr/1 can modify settings that will be shared among connections" {
    const env = try zodbc.testing.environment();
    defer env.deinit();

    try env.setEnvAttr(.{ .OdbcVersion = .V2 });
    const odbc_version_attr = try env.getEnvAttr(.OdbcVersion);
    try expectEqual(
        AttributeValue.OdbcVersion.V2,
        odbc_version_attr.OdbcVersion,
    );

    try env.setEnvAttr(.{ .ConnectionPooling = .OnePerDriver });
    const connection_pooling_attr = try env.getEnvAttr(.ConnectionPooling);
    try expectEqual(
        AttributeValue.ConnectionPooling.OnePerDriver,
        connection_pooling_attr.ConnectionPooling,
    );

    try env.setEnvAttr(.{ .CpMatch = .StrictMatch });
    const cp_match_attr = try env.getEnvAttr(.CpMatch);
    try expectEqual(
        AttributeValue.CpMatch.StrictMatch,
        cp_match_attr.CpMatch,
    );
}

// By default Db2 is set to return null terminated strings. The IBM documentation claims
// that you can disable null terminated strings but `SQLSetEnvAttr` through unixODBC
// returns an error with the message:
//
// `[unixODBC][Driver Manager]Optional feature not implemented`
//
// - https://www.ibm.com/docs/en/db2-for-zos/11?topic=functions-sqlsetenvattr-set-environment-attributes
test ".setEnvAttr/1 returns an error when null terminated output is false" {
    const env = try zodbc.testing.environment();
    defer env.deinit();

    var output_nts_attr: AttributeValue = undefined;
    output_nts_attr = try env.getEnvAttr(.OutputNts);
    try expectEqual(AttributeValue.OutputNts.True, output_nts_attr.OutputNts);

    try env.setEnvAttr(.{ .OutputNts = .True });
    output_nts_attr = try env.getEnvAttr(.OutputNts);
    try expectEqual(AttributeValue.OutputNts.True, output_nts_attr.OutputNts);

    try expectError(
        err.SetEnvAttrError.Error,
        env.setEnvAttr(.{ .OutputNts = .False }),
    );
}
