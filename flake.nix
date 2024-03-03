{
  description = "A blazing fast ODBC Zig client";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    zig-overlay = {
      url = "github:mitchellh/zig-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    odbc-drivers = {
      url = "github:rupurt/odbc-drivers-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    flake-utils,
    nixpkgs,
    zig-overlay,
    odbc-drivers,
    ...
  }: let
    systems = ["x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin"];
    outputs = flake-utils.lib.eachSystem systems (system: let
      pkgs = import nixpkgs {
        # NOTE:
        # IBM currently only provides an x86_64 driver for Mac. An aarch64 native driver
        # is scheduled for 2024 so this can be removed when it's released
        # - https://ibm-data-and-ai.ideas.ibm.com/ideas/DB2CON-I-92
        system =
          if system == "aarch64-darwin"
          then "x86_64-darwin"
          else system;
        overlays = [
          zig-overlay.overlays.default
          odbc-drivers.overlay
          # WebUI fails to build on Linux with unexported symbol
          # - emcc: error: undefined exported symbol: "__ZNSt3__212basic_stringIcNS_11char_traitsIcEENS_9allocatorIcEEE9__grow_byEmmmmmm" [-Wundefined] [-Werror]
          # (final: prev: {
          #   tree-sitter = prev.tree-sitter.override {webUISupport = true;};
          # })
        ];
      };
      db2Driver =
        if pkgs.stdenv.isLinux
        then "${pkgs.odbc-driver-pkgs.db2-odbc-driver}/lib/libdb2o.so"
        else "${pkgs.odbc-driver-pkgs.db2-odbc-driver}/lib/libdb2o.dylib";
      postgresDriver =
        if pkgs.stdenv.isLinux
        then "${pkgs.odbc-driver-pkgs.postgres-odbc-driver}/lib/psqlodbca.so"
        else "${pkgs.odbc-driver-pkgs.postgres-odbc-driver}/lib/psqlodbca.dylib";
    in {
      # packages exported by the flake
      packages = {};

      # nix run
      apps = {};

      # nix fmt
      formatter = pkgs.alejandra;

      # nix develop -c $SHELL
      devShells.default = pkgs.mkShell {
        name = "default dev shell";

        buildInputs = [
          pkgs.pkg-config
          pkgs.zigpkgs.master
          pkgs.unixODBC
          pkgs.arrow-cpp
        ];

        packages =
          [
            pkgs.odbc-driver-pkgs.db2-odbc-driver
            pkgs.odbc-driver-pkgs.postgres-odbc-driver
            pkgs.tracy
            pkgs.tree-sitter
          ]
          ++ pkgs.lib.optionals (pkgs.stdenv.isLinux) [
            pkgs.strace
            pkgs.valgrind
          ];

        DB2_DRIVER = db2Driver;
        POSTGRES_DRIVER = postgresDriver;
      };
    });
  in
    outputs;
}
