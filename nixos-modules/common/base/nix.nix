{ lib, config, inputs, ... }: let
  base = "/etc/nixpkgs/channels";
  nixpkgsPath = "${base}/nixpkgs";
in {
  config = lib.mkIf config.common.base.enable {
    systemd.tmpfiles.rules = [
      "L+ ${nixpkgsPath} - - - - ${inputs.nixpkgs}"
    ];
    nix = {
      enable = true;
      nixPath = [
        "nixpkgs=${nixpkgsPath}"
      ];
      registry.nixpkgs.flake = inputs.nixpkgs;
      settings = {
        show-trace = true;
        sandbox = true;
        allowed-users = [ "@wheel" ];
        experimental-features = [ "nix-command" "flakes" ];
        min-free = "1G";
        max-free = "5G";
      };
      optimise = {
        automatic = true;
        dates = [
          "5:00"
        ];
        persistent = true;
        randomizedDelaySec = "60min";
      };
      gc = {
        automatic = true;
        dates = "weekly";
        persistent = true;
        randomizedDelaySec = "180min";
        options = ''
          --delete-older-than 14d
        '';
      };
    };
  };
}
