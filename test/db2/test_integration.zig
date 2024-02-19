comptime {     
    _ = @import("test_data_sources.zig");
    _ = @import("test_tables.zig");
    _ = @import("test_table_privileges.zig");
    _ = @import("test_columns.zig");
    _ = @import("test_special_columns.zig");
    _ = @import("test_column_privleges.zig");
    _ = @import("test_column_binding.zig");
    _ = @import("test_primary_keys.zig");
    _ = @import("test_foreign_keys.zig");
    _ = @import("test_param_binding.zig");
    _ = @import("test_describe_col.zig");
    _ = @import("test_transaction.zig");
    _ = @import("test_get_functions.zig");
    _ = @import("test_procedures.zig");
    _ = @import("test_procedure_columns.zig");
    _ = @import("test_execute_direct_statement.zig");
    _ = @import("test_execute_prepared_statement.zig");
    _ = @import("test_connection_pool_execute_statement.zig");
 }
