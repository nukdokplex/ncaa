{ pkgs, lib, ... }: {
  programs.git = {
    enable = true;
    signing.format = "openpgp";
  };
  programs.gpg.enable = true;
  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    enableZshIntegration = true;
  };
  programs.zsh = {
    enable = true;
    shellAliases = {
      nrs = "sudo nixos-rebuild switch --flake path:$HOME/ncaa#$(hostnamectl --json=short | '${lib.getExe pkgs.jq}' --raw-output .Hostname) --accept-flake-config";
      nrb = "sudo nixos-rebuild boot --flake path:$HOME/ncaa#$(hostnamectl --json=short | '${lib.getExe pkgs.jq}' --raw-output .Hostname) --accept-flake-config";
      nrt = "sudo nixos-rebuild test --flake path:$HOME/ncaa#$(hostnamectl --json=short | '${lib.getExe pkgs.jq}' --raw-output .Hostname) --accept-flake-config";
      nrbuild = "sudo nixos-rebuild build --flake path:$HOME/ncaa#$(hostnamectl --json=short | '${lib.getExe pkgs.jq}' --raw-output .Hostname) --accept-flake-config";
    };
    initExtra = lib.mkAfter ''
      source ${pkgs.nix-index}/etc/profile.d/command-not-found.sh
    '';
    oh-my-zsh = {
      enable = true;
      theme = "agnoster";
    };
  };

  stylix.iconTheme = {
    enable = true;
    package = pkgs.papirus-icon-theme.override { color = "adwaita"; };
    light = "Papirus";
    dark = "Papirus-Dark";
  };

  # this config causes adding unwanted nixpkgs overlay
  stylix.targets.gnome-text-editor.enable = false;
}
