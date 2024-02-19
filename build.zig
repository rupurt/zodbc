const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // ----------------------------
    // Module
    // ----------------------------
    const odbc_mod = b.addModule("odbc", .{
        .root_source_file = .{ .path = "src/odbc/root.zig" },
    });
    const zodbc_mod = b.addModule("zodbc", .{
        .root_source_file = .{ .path = "src/root.zig" },
        .imports = &.{
            .{ .name = "odbc", .module = odbc_mod },
        },
    });

    // ----------------------------
    // Library
    // ----------------------------
    const lib = b.addSharedLibrary(.{
        .name = "zodbc",
        .root_source_file = .{ .path = "src/root.zig" },
        .version = .{ .major = 0, .minor = 0, .patch = 0 },
        .target = target,
        .optimize = optimize,
    });
    lib.root_module.addImport("odbc", odbc_mod);
    lib.linkage = .dynamic;
    lib.linkLibC();
    lib.linkSystemLibrary("odbc");
    lib.linkSystemLibrary("arrow");
    b.installArtifact(lib);

    // ----------------------------
    // Executable
    // ----------------------------
    const exe = b.addExecutable(.{
        .name = "zodbc",
        .root_source_file = .{ .path = "src/main.zig" },
        .target = target,
        .optimize = optimize,
    });
    exe.linkLibrary(lib);
    b.installArtifact(exe);

    // ----------------------------
    // Run
    // ----------------------------
    const run_cmd = b.addRunArtifact(exe);
    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }
    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);

    // ----------------------------
    // Tests
    // ----------------------------
    const lib_unit_tests = b.addTest(.{
        .name = "[LIB UNIT]",
        .test_runner = "test_runner.zig",
        .root_source_file = .{ .path = "src/root.zig" },
        .target = target,
        .optimize = optimize,
    });
    lib_unit_tests.linkLibC();
    lib_unit_tests.linkSystemLibrary("odbc");
    const run_lib_unit_tests = b.addRunArtifact(lib_unit_tests);

    const exe_unit_tests = b.addTest(.{
        .name = "[EXE UNIT]",
        .test_runner = "test_runner.zig",
        .root_source_file = .{ .path = "src/main.zig" },
        .target = target,
        .optimize = optimize,
    });
    const run_exe_unit_tests = b.addRunArtifact(exe_unit_tests);

    const test_unit_step = b.step("test:unit", "Run unit tests");
    test_unit_step.dependOn(&run_lib_unit_tests.step);
    test_unit_step.dependOn(&run_exe_unit_tests.step);

    // Db2 integration tests
    const db2_integration_tests = b.addTest(.{
        .name = "[DB2 INTEGRATION]",
        .test_runner = "test_runner.zig",
        .root_source_file = .{ .path = "test/db2/test_integration.zig" },
        .target = target,
        .optimize = optimize,
    });
    db2_integration_tests.root_module.addImport("odbc", odbc_mod);
    db2_integration_tests.root_module.addImport("zodbc", zodbc_mod);
    db2_integration_tests.linkLibC();
    db2_integration_tests.linkSystemLibrary("odbc");
    const run_db2_integration_tests = b.addRunArtifact(db2_integration_tests);
    const test_integration_db2_step = b.step("test:integration:db2", "Run Db2 integration tests");
    test_integration_db2_step.dependOn(&run_db2_integration_tests.step);

    // MariaDB integration tests
    const mariadb_integration_tests = b.addTest(.{
        .name = "[MARIADB INTEGRATION]",
        .test_runner = "test_runner.zig",
        .root_source_file = .{ .path = "test/mariadb/test_integration.zig" },
        .target = target,
        .optimize = optimize,
    });
    mariadb_integration_tests.root_module.addImport("odbc", odbc_mod);
    mariadb_integration_tests.root_module.addImport("zodbc", zodbc_mod);
    mariadb_integration_tests.linkLibC();
    mariadb_integration_tests.linkSystemLibrary("odbc");
    const run_mariadb_integration_tests = b.addRunArtifact(mariadb_integration_tests);
    const test_integration_mariadb_step = b.step("test:integration:mariadb", "Run MariaDB integration tests");
    test_integration_mariadb_step.dependOn(&run_mariadb_integration_tests.step);

    // Postgres integration tests
    const postgres_integration_tests = b.addTest(.{
        .name = "[POSTGRES INTEGRATION]",
        .test_runner = "test_runner.zig",
        .root_source_file = .{ .path = "test/postgres/test_integration.zig" },
        .target = target,
        .optimize = optimize,
    });
    postgres_integration_tests.root_module.addImport("odbc", odbc_mod);
    postgres_integration_tests.root_module.addImport("zodbc", zodbc_mod);
    postgres_integration_tests.linkLibC();
    postgres_integration_tests.linkSystemLibrary("odbc");
    const run_postgres_integration_tests = b.addRunArtifact(postgres_integration_tests);
    const test_integration_postgres_step = b.step("test:integration:postgres", "Run Postgres integration tests");
    test_integration_postgres_step.dependOn(&run_postgres_integration_tests.step);

    const test_integration_step = b.step("test:integration", "Run integration tests");
    test_integration_step.dependOn(test_integration_db2_step);
    test_integration_step.dependOn(test_integration_mariadb_step);
    test_integration_step.dependOn(test_integration_postgres_step);

    const test_step = b.step("test", "Run tests");
    test_step.dependOn(test_unit_step);
    test_step.dependOn(test_integration_step);
}
