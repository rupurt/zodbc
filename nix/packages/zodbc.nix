{
  pkgs,
  specialArgs ? {},
}: let
  defaultArgs = {
    pname = "zodbc";
    version = "0.0.0";
  };
  args = defaultArgs // specialArgs;
in
  pkgs.stdenv.mkDerivation {
    pname = args.pname;
    version = args.version;
    src = ../..;

    nativeBuildInputs = [];

    buildInputs =
      [
        pkgs.gnumake
        pkgs.pkg-config
        pkgs.zigpkgs.master
        pkgs.unixODBC
        pkgs.arrow-cpp
      ]
      ++ pkgs.lib.optionals (pkgs.stdenv.isLinux) [
      ]
      ++ pkgs.lib.optionals (pkgs.stdenv.isDarwin) [
      ];

    # Ideally darwin would unpack the source dmg with something like undmg or hdiutil. Unfortunately
    # the Db2 image is signed which is not supported currently in undmg and hdiutil would require
    # the derivation to be impure.
    installPhase = ''
      mkdir -p $out
      make build
      cp -r zig-out/* $out
    '';
  }
