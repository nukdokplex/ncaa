{ inputs, ... }:
{
  nixpkgs.overlays = with inputs.self.outputs.overlays; [
    packages
    overrides
    imports
  ];
}
