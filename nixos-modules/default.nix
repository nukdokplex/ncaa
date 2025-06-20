{
  ezModules,
  inputs,
  ...
}:
{
  # import all modules in this module so this ("default") module become super-module that inherits all nixos modules in this flake
  imports =
    (with inputs; [
      agenix-rekey.nixosModules.default
      agenix.nixosModules.default
      disko.nixosModules.disko
      hyprland.nixosModules.default
      nur.modules.nixos.default
      stylix.nixosModules.stylix
      tssp.nixosModules.default
    ])
    ++ (with ezModules; [
      k3b-custom
      lutris
      nixpkgs-overlays
      optical-disk-essentials
      steam
      usb-essentials
      via
    ]);
}
