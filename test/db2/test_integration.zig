comptime {
    _ = @import("test_environment_get_env_attr.zig");
    _ = @import("test_environment_set_env_attr.zig");
    _ = @import("test_connection_get_connect_attr.zig");
    _ = @import("test_connection_set_connect_attr.zig");
    _ = @import("test_connection_get_info.zig");
    _ = @import("test_statement_data_sources.zig");
    _ = @import("test_statement_describe_col.zig");
    _ = @import("test_statement_row_count.zig");
    _ = @import("test_statement_get_stmt_attr.zig");
    _ = @import("test_statement_set_stmt_attr.zig");
    _ = @import("test_statement_more_results.zig");
    _ = @import("test_statement_fetch.zig");
    _ = @import("test_statement_fetch_scroll.zig");
    _ = @import("test_statement_tables.zig");
    _ = @import("test_statement_table_privileges.zig");
    _ = @import("test_statement_columns.zig");
    _ = @import("test_statement_special_columns.zig");
    _ = @import("test_statement_column_privleges.zig");
    _ = @import("test_statement_primary_keys.zig");
    _ = @import("test_statement_foreign_keys.zig");
    _ = @import("test_statement_param_binding.zig");
    _ = @import("test_statement_transaction.zig");
    _ = @import("test_statement_get_functions.zig");
    _ = @import("test_statement_procedures.zig");
    _ = @import("test_statement_procedure_columns.zig");
    _ = @import("test_worker_pool_prepare_execute_and_read_batches.zig");
}
