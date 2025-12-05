{
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    # please sort list of packages alphabetically!
    atop
    bash
    bat # woke cat
    bind
    btop
    cmatrix
    fastfetch
    fzf
    htop
    inotify-tools
    jq
    libwebp
    net-tools
    nix-index
    nix-search-cli
    nixpkgs-fmt
    nurl
    openssl
    psmisc
    rage
    sl
    usbutils
    vim
    w3m
    wget
  ];
}
