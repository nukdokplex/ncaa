{ ezModules, inputs, ... }:
{
  imports = [
    inputs.disko.nixosModules.disko
  ]
  ++ (with ezModules; [
    agenix
    archive-utils
    console
    dns
    firewall
    fs-utils
    home-manager
    miscellaneous-utils
    nix
    nixpkgs-overlays
    openssh
    usb-utils
  ]);
}
