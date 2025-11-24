{ inputs, ... }:
{
  nixpkgs.overlays = [
    inputs.self.outputs.overlays.packages
    inputs.self.outputs.overlays.overrides
    inputs.self.outputs.overlays.imports
    inputs.nix-bwrapper.overlays.default
  ];
}
