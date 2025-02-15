{ pkgs, lib, config, inputs, ... }: {
  config = lib.mkIf config.common.base.enable {
    environment.systemPackages = with pkgs; [
      # please sort list of packages alphabetically!
      atop
      bind
      btop
      cachix
      cmatrix
      fastfetch
      ffmpeg
      htop
      inotify-tools
      jq
      libwebp
      nix-index
      nix-search-cli
      nixpkgs-fmt
      psmisc
      qmk
      sl
      tmux
      vim
      w3m 
      wget
      inputs.home-manager.packages.${pkgs.system}.home-manager
      inputs.agenix.packages.${pkgs.system}.agenix
    ];
  };
}
