{ lib', ... }:
{
  imports = lib'.umport {
    path = ./.;
    recursive = false;
    exclude = [ ./default.nix ];
  };
}
