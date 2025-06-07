{ lib, final, ... }:
{
  modules.umport = (import ./umport.nix) lib;

  inherit (final.modules) umport;
}
