{
  ezModules,
  lib,
  inputs,
  flakeRoot,
  ...
}:
{
  # import all modules in this module so this ("default") module become super-module that inherits all nixos modules in this flake
  imports =
    (with inputs; [
      stylix.nixosModules.stylix
      nur.modules.nixos.default
      agenix.nixosModules.default
      agenix-rekey.nixosModules.default
      hyprland.nixosModules.default
      disko.nixosModules.disko
      tssp.nixosModules.default
    ])
    ++ (with ezModules; [
      k3b-custom
      lutris
      optical-disk-essentials
      steam
      usb-essentials
      via
    ]);
}
