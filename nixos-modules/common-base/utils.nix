{
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    # please sort list of packages alphabetically!
    atop
    bind
    btop
    bat # woke cat
    cmatrix
    fastfetch
    htop
    inotify-tools
    jq
    libwebp
    nix-index
    nix-search-cli
    nixpkgs-fmt
    nurl
    psmisc
    sl
    vim
    w3m
    wget
    fzf
    usbutils
    rage
    bash
  ];
}
