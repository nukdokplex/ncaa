{ inputs, ... }:
{
  nixpkgs.overlays = with inputs.self.outputs.overlays; [
    pkgs
    overrides
  ];
}
