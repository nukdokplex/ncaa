{ lib, ... }: {
  umport = import ./umport.nix { inherit lib; };
  hyprland-utils = import ./hyprland-utils.nix { inherit lib; };
}
