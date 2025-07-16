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
      ./agenix-rekey-generators.nix
      ./k3b-custom.nix
      ./lutris.nix
      ./nixpkgs-overlays.nix
      ./optical-disk-essentials.nix
      ./usb-essentials.nix
      ./via.nix
    ]);
}
