{ lib, ... }:
let
  umport = (import ./modules/umport.nix) lib;
  files = umport {
    path = ./.;
    recursive = false;
    exclude = [ ./default.nix ];
  };

  callLib = lib: file: (import file) { inherit lib; };
in
{
  # this is nixpkgs lib + custom lib
  # aware of ton evaluation warnings you will encounter
  flake.lib = lib.extend (
    final: prev: builtins.foldl' (acc: elem: acc // (callLib final elem)) { } files
  );

  # only custom lib
  flake.lib' = lib.fix (
    final: builtins.foldl' (acc: elem: acc // (callLib (lib // final) elem)) { } files
  );
}
