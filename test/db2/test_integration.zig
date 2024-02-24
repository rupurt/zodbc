comptime {
    _ = @import("test_statement_data_sources.zig");
    _ = @import("test_statement_tables.zig");
    _ = @import("test_statement_table_privileges.zig");
    _ = @import("test_statement_columns.zig");
    _ = @import("test_statement_special_columns.zig");
    _ = @import("test_statement_column_privleges.zig");
    _ = @import("test_statement_primary_keys.zig");
    _ = @import("test_statement_foreign_keys.zig");
    _ = @import("test_statement_param_binding.zig");
    _ = @import("test_statement_describe_col.zig");
    _ = @import("test_statement_transaction.zig");
    _ = @import("test_statement_get_functions.zig");
    _ = @import("test_statement_procedures.zig");
    _ = @import("test_statement_procedure_columns.zig");
    _ = @import("test_statement_execute_direct_and_fetch.zig");
    _ = @import("test_statement_prepare_execute_bind_col_and_fetch.zig");
    _ = @import("test_connection_pool_prepare_execute_and_read_batches.zig");
}
