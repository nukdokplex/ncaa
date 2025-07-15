{
  description = "A collection of crap, hacks, and copy-paste to make my hosts boot";

  inputs = {
    # pinned inputs
    nixpkgs.url = "github:NixOS/nixpkgs?ref=nixos-unstable";

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    # systems
    systems.url = "github:nix-systems/default-linux";

    # alphabetically ordered
    agenix-rekey.inputs.flake-parts.follows = "flake-parts";
    agenix-rekey.inputs.nixpkgs.follows = "nixpkgs";
    agenix-rekey.url = "github:oddlama/agenix-rekey";
    agenix.inputs.darwin.follows = "";
    agenix.inputs.home-manager.follows = "home-manager";
    agenix.inputs.nixpkgs.follows = "nixpkgs";
    agenix.url = "github:ryantm/agenix";
    disko.inputs.nixpkgs.follows = "nixpkgs";
    disko.url = "github:nix-community/disko";
    ez-configs.inputs.flake-parts.follows = "flake-parts";
    ez-configs.inputs.nixpkgs.follows = "nixpkgs";
    ez-configs.url = "github:ehllie/ez-configs";
    flake-utils.url = "github:numtide/flake-utils";
    git-hooks-nix.inputs.nixpkgs.follows = "nixpkgs";
    git-hooks-nix.url = "github:cachix/git-hooks.nix";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    hy3.inputs.hyprland.follows = "hyprland";
    hy3.url = "github:outfoxxed/hy3?ref=hl0.49.0";
    hyprland-plugins.inputs.hyprland.follows = "hyprland";
    hyprland-plugins.inputs.nixpkgs.follows = "nixpkgs";
    hyprland-plugins.url = "github:hyprwm/hyprland-plugins?ref=v0.49.0";
    hyprland.inputs.nixpkgs.follows = "nixpkgs";
    hyprland.inputs.pre-commit-hooks.follows = "";
    hyprland.inputs.systems.follows = "systems";
    hyprland.url = "github:hyprwm/Hyprland?ref=v0.49.0";
    lanzaboote.inputs.nixpkgs.follows = "nixpkgs";
    lanzaboote.inputs.pre-commit-hooks-nix.follows = "";
    lanzaboote.url = "github:nix-community/lanzaboote";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
    nix-index-database.url = "github:nix-community/nix-index-database";
    nixcord.inputs.nixpkgs.follows = "nixpkgs";
    nixcord.url = "github:KaylorBen/nixcord";
    nixos-nftables-firewall.inputs.nixpkgs.follows = "nixpkgs";
    nixos-nftables-firewall.url = "github:thelegy/nixos-nftables-firewall";
    nixvim.inputs.flake-parts.follows = "flake-parts";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";
    nixvim.inputs.nuschtosSearch.follows = "";
    nixvim.url = "github:nix-community/nixvim";
    nur.inputs.flake-parts.follows = "flake-parts";
    nur.inputs.nixpkgs.follows = "nixpkgs";
    nur.url = "github:nix-community/nur";
    picokeys-nix.url = "github:ViZiD/picokeys-nix?ref=dev";
    pkgs-by-name-for-flake-parts.url = "github:drupol/pkgs-by-name-for-flake-parts";
    simple-nixos-mailserver.inputs.nixpkgs.follows = "nixpkgs";
    simple-nixos-mailserver.url = "gitlab:simple-nixos-mailserver/nixos-mailserver/master";
    spicetify.inputs.nixpkgs.follows = "nixpkgs";
    spicetify.url = "github:Gerg-L/spicetify-nix";
    stylix.inputs.flake-compat.follows = "";
    stylix.inputs.home-manager.follows = "home-manager";
    stylix.inputs.nixpkgs.follows = "nixpkgs";
    stylix.url = "github:nix-community/stylix";
    tssp.inputs.nixpkgs.follows = "nixpkgs";
    tssp.url = "github:nukdokplex/tssp-nix?ref=dev";
  };

  # notice that this nixConfig is being imported by nixosModules.common.base
  nixConfig = {
    extra-substituters = [
      "https://nukdokplex.cachix.org"
      "https://nix-community.cachix.org"
      "https://hyprland.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nukdokplex.cachix.org-1:ikhOYrqfHkiYDCfnYKucldBri13hBtfC+8bTBTT7hW0="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
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
          pkgs-by-name-for-flake-parts.flakeModule
          ./lib
          ./overlays.nix
          ./ez-configs.nix
          ./picokeys.nix
          ./devshells.nix
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
              };
              overlays = with config.flake.overlays; [
                lib-custom
                overrides
                imports
                # do not use pkgs overlay, you will encounter infinite recursion
              ];
            };
          in
          {
            _module.args.pkgs = import inputs.nixpkgs nixpkgsArgs;
            formatter = pkgs.nixfmt-rfc-style;
            pkgsDirectory = ./packages;
          };
      }
    );
}
