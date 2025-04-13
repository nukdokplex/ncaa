{
  programs.carapace = {
    enable = true;
    enableNushellIntegration = true;
  };

  programs.nushell = {
    enable = true;
    shellAliases = {
      nrs = "sudo nixos-rebuild switch --flake path:/home/nukdokplex/ncaa#(hostname) --accept-flake-config";
      nrb = "sudo nixos-rebuild boot --flake path:/home/nukdokplex/ncaa#(hostname) --accept-flake-config";
      nrt = "sudo nixos-rebuild test --flake path:/home/nukdokplex/ncaa#(hostname) --accept-flake-config";
      nrbuild = "nixos-rebuild build --flake path:/home/nukdokplex/ncaa#(hostname) --accept-flake-config";
    };
  };
}
