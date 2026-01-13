{
  description = "A collection of crap, hacks, and copy-paste to make my hosts boot";

  inputs = {
    agenix-rekey.inputs.flake-parts.follows = "flake-parts";
    agenix-rekey.inputs.nixpkgs.follows = "nixpkgs";
    agenix-rekey.url = "github:oddlama/agenix-rekey";
    agenix.inputs.darwin.follows = "";
    agenix.inputs.home-manager.follows = "home-manager";
    agenix.inputs.nixpkgs.follows = "nixpkgs";
    agenix.url = "github:ryantm/agenix";
    deploy-rs.inputs.flake-compat.follows = "";
    deploy-rs.inputs.nixpkgs.follows = "nixpkgs";
    deploy-rs.url = "github:serokell/deploy-rs";
    disko.inputs.nixpkgs.follows = "nixpkgs";
    disko.url = "github:nix-community/disko";
    ez-configs.inputs.flake-parts.follows = "flake-parts";
    ez-configs.inputs.nixpkgs.follows = "nixpkgs";
    ez-configs.url = "github:ehllie/ez-configs";
    flake-parts.inputs.nixpkgs-lib.follows = "nixpkgs";
    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-utils.url = "github:numtide/flake-utils";
    freesmlauncher.url = "github:FreesmTeam/FreesmLauncher";
    freesmlauncher.inputs.nixpkgs.follows = "nixpkgs";
    git-hooks-nix.inputs.nixpkgs.follows = "nixpkgs";
    git-hooks-nix.url = "github:cachix/git-hooks.nix";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager?ref=release-25.11";
    hyprdynamicmonitors.inputs.nixpkgs.follows = "nixpkgs";
    hyprdynamicmonitors.url = "github:fiffeek/hyprdynamicmonitors?ref=v1.4.0";
    hyprland-plugins.inputs.hyprland.follows = "hyprland";
    hyprland-plugins.inputs.nixpkgs.follows = "nixpkgs";
    hyprland-plugins.url = "github:hyprwm/hyprland-plugins?ref=v0.52.0";
    hyprland.inputs.nixpkgs.follows = "nixpkgs";
    hyprland.inputs.pre-commit-hooks.follows = "";
    hyprland.inputs.systems.follows = "systems";
    hyprland.url = "github:hyprwm/Hyprland?ref=v0.52.2";
    lanzaboote.inputs.nixpkgs.follows = "nixpkgs";
    lanzaboote.inputs.pre-commit.follows = "";
    lanzaboote.url = "github:nix-community/lanzaboote";
    nix-bwrapper.inputs.nuschtosSearch.follows = "";
    nix-bwrapper.inputs.treefmt-nix.follows = "";
    nix-bwrapper.url = "github:Naxdy/nix-bwrapper";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
    nix-index-database.url = "github:nix-community/nix-index-database";
    nixcord.inputs.nixpkgs.follows = "nixpkgs";
    nixcord.url = "github:KaylorBen/nixcord";
    nixos-anywhere.inputs.disko.follows = "";
    nixos-anywhere.inputs.nix-vm-test.follows = "";
    nixos-anywhere.inputs.nixos-images.follows = "";
    nixos-anywhere.inputs.nixos-stable.follows = "";
    nixos-anywhere.inputs.nixpkgs.follows = "nixpkgs";
    nixos-anywhere.inputs.treefmt-nix.follows = "";
    nixos-anywhere.url = "github:nix-community/nixos-anywhere?ref=1.13.0";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    nixos-nftables-firewall.inputs.nixpkgs.follows = "nixpkgs";
    nixos-nftables-firewall.url = "github:thelegy/nixos-nftables-firewall";
    nixpkgs.url = "github:NixOS/nixpkgs?ref=nixos-25.11";
    nixvim.inputs.flake-parts.follows = "flake-parts";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";
    nixvim.inputs.nuschtosSearch.follows = "";
    nixvim.url = "github:nix-community/nixvim?ref=nixos-25.11";
    nur.inputs.flake-parts.follows = "flake-parts";
    nur.url = "github:nix-community/nur";
    picokeys-nix.url = "github:ViZiD/picokeys-nix?ref=36ec5635d5b2ddb88f68d6e251b56cc4b81a38b0";
    simple-nixos-mailserver.inputs.nixpkgs.follows = "nixpkgs";
    simple-nixos-mailserver.url = "gitlab:simple-nixos-mailserver/nixos-mailserver?ref=nixos-25.11";
    stylix.inputs.nixpkgs.follows = "nixpkgs";
    stylix.url = "github:nix-community/stylix?ref=release-25.11";
    systems.url = "github:nix-systems/default-linux";
    tssp.inputs.nixpkgs.follows = "nixpkgs";
    tssp.url = "github:nukdokplex/tssp-nix";
  };

  # notice that this nixConfig is being imported by nixosModules.common.base
  nixConfig = {
    experimental-features = [
      "nix-command"
      "flakes"
      "pipe-operators"
    ];
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } (
      { config, ... }:
      {
        _module.args.flakeRoot = ./.;
        _module.args.lib-custom = config.flake.lib';

        imports = with inputs; [
          ez-configs.flakeModule
          agenix-rekey.flakeModule
          ./lib
          ./packages.nix
          ./overlays.nix
          ./ez-configs.nix
          ./devshells.nix
          ./deploy.nix
        ];

        systems = import inputs.systems;

        perSystem =
          {
            system,
            pkgs,
            ...
          }:
          let
            nixpkgsArgs = {
              inherit system;
              config = {
                allowUnfree = true;
                allowBroken = true;
              };
              overlays = with config.flake.overlays; [
                lib-custom
                overrides
                imports
                inputs.nix-bwrapper.overlays.default
                # do not use pkgs overlay, you will encounter infinite recursion
              ];
            };
          in
          {
            _module.args.pkgs = import inputs.nixpkgs nixpkgsArgs;

            agenix-rekey = {
              homeConfigurations = { };
              collectHomeManagerConfigurations = false;
            };

            formatter = pkgs.nixfmt-rfc-style;
          };
      }
    );
}
