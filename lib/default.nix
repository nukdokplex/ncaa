{ lib, ... }:
let
  umport = (import ./modules/umport.nix) lib;
  files = umport {
    path = ./.;
    recursive = false;
    exclude = [ ./default.nix ];
  };

  modifications = lib.fix (final: builtins.map (file: import file { inherit final lib; }) files);

in
{
  flake.lib = builtins.foldl' (acc: elem: lib.recursiveUpdate acc elem) lib modifications;
}
