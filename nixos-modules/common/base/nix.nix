{ lib, config, ... }: {
  config = lib.mkIf config.common.base.enable {
    nixpkgs.config.allowUnfree = true;
    nix = {
      enable = true;
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
