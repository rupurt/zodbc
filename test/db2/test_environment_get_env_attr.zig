const std = @import("std");
const testing = std.testing;
const expectEqual = testing.expectEqual;
const allocator = testing.allocator;

const zodbc = @import("zodbc");
const attrs = zodbc.odbc.attributes;

const AttributeValue = attrs.EnvironmentAttributeValue;

test ".getEnvAttr/1 retrieves the current setting for an environment attribute" {
    const env = try zodbc.testing.environment();
    defer env.deinit();

    const odbc_version_attr = try env.getEnvAttr(.OdbcVersion);
    try expectEqual(AttributeValue.OdbcVersion.V3_80, odbc_version_attr.OdbcVersion);

    const output_nts_attr = try env.getEnvAttr(.OutputNts);
    try expectEqual(AttributeValue.OutputNts.True, output_nts_attr.OutputNts);

    const connection_pooling_attr = try env.getEnvAttr(.ConnectionPooling);
    try expectEqual(AttributeValue.ConnectionPooling.Off, connection_pooling_attr.ConnectionPooling);

    const cp_match_attr = try env.getEnvAttr(.CpMatch);
    try expectEqual(AttributeValue.CpMatch.StrictMatch, cp_match_attr.CpMatch);
}
