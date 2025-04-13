{ pkgs, lib, config, inputs, ... }: {
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
    vim
    w3m
    wget
    fzf
    usbutils
    rage
    nushell
    bash
  ];
}
