{
  description = "A collection of crap, hacks, and copy-paste to make my hosts boot";

  inputs = {
    # pinned inputs
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    # systems
    systems.url = "github:nix-systems/default-linux";
    # this system is made to be a simple manipulator of flake-input-patcher's system since there is no any
    patcher-system.url = "github:nix-systems/x86_64-linux";
    # alphabetically ordered
    agenix-rekey.inputs.flake-parts.follows = "flake-parts";
    agenix-rekey.inputs.nixpkgs.follows = "nixpkgs";
    agenix-rekey.url = "github:oddlama/agenix-rekey";
    agenix.inputs.darwin.follows = "";
    agenix.inputs.home-manager.follows = "home-manager";
    agenix.inputs.nixpkgs.follows = "nixpkgs";
    agenix.url = "github:ryantm/agenix";
    bunny-yazi.flake = false;
    bunny-yazi.url = "github:stelcodes/bunny.yazi";
    custom-shell-yazi.flake = false;
    custom-shell-yazi.url = "github:AnirudhG07/custom-shell.yazi";
    disko.inputs.nixpkgs.follows = "nixpkgs";
    disko.url = "github:nix-community/disko";
    ez-configs.inputs.flake-parts.follows = "flake-parts";
    ez-configs.inputs.nixpkgs.follows = "nixpkgs";
    ez-configs.url = "github:ehllie/ez-configs";
    flake-input-patcher.url = "github:jfly/flake-input-patcher";
    flake-input-patcher.inputs.nixpkgs.follows = "nixpkgs";
    flake-input-patcher.inputs.systems.follows = "patcher-system";
    flake-utils.url = "github:numtide/flake-utils";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    hyprland-plugins.inputs.hyprland.follows = "hyprland";
    hyprland-plugins.inputs.nixpkgs.follows = "nixpkgs";
    hyprland-plugins.url = "github:hyprwm/hyprland-plugins";
    hyprland.inputs.nixpkgs.follows = "nixpkgs";
    hyprland.inputs.pre-commit-hooks.follows = "";
    hyprland.inputs.systems.follows = "systems";
    hyprland.url = "github:hyprwm/Hyprland";
    lanzaboote.inputs.nixpkgs.follows = "nixpkgs";
    lanzaboote.inputs.pre-commit-hooks-nix.follows = "";
    lanzaboote.url = "github:nix-community/lanzaboote";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
    nix-index-database.url = "github:nix-community/nix-index-database";
    nixvim.inputs.flake-parts.follows = "flake-parts";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";
    nixvim.inputs.nuschtosSearch.follows = "";
    nixvim.url = "github:nix-community/nixvim";
    nur.inputs.flake-parts.follows = "flake-parts";
    nur.inputs.nixpkgs.follows = "nixpkgs";
    nur.url = "github:nix-community/nur";
    picokeys-nix.url = "github:nukdokplex/picokeys-nix";
    pkgs-by-name-for-flake-parts.url = "github:drupol/pkgs-by-name-for-flake-parts";
    simple-nixos-mailserver.inputs.nixpkgs.follows = "nixpkgs";
    simple-nixos-mailserver.url = "gitlab:simple-nixos-mailserver/nixos-mailserver/master";
    spicetify.inputs.nixpkgs.follows = "nixpkgs";
    spicetify.url = "github:Gerg-L/spicetify-nix";
    stylix.inputs.flake-compat.follows = "";
    stylix.inputs.home-manager.follows = "home-manager";
    stylix.inputs.nixpkgs.follows = "nixpkgs";
    stylix.url = "github:nix-community/stylix";
    tssp.inputs.flake-parts.follows = "flake-parts";
    tssp.inputs.nixpkgs.follows = "nixpkgs";
    tssp.url = "github:nukdokplex/tssp-nix";
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
    unpatchedInputs@{ flake-input-patcher, patcher-system, ... }:
    let
      patcher = flake-input-patcher.lib.${builtins.elemAt (import patcher-system) 0};
      inputs = patcher.patch unpatchedInputs {
        nixpkgs.patches = [
          (patcher.fetchpatch {
            name = "epson_201310w: init at 1.0.1";
            url = "https://github.com/NixOS/nixpkgs/pull/411842.patch";
            hash = "sha256-S5ykGoC0Gs/yaqn7LKuYtivV23CjBZ3wFsykT/nmBIA=";
          })
        ];
      };
    in
    inputs.flake-parts.lib.mkFlake { inherit inputs; } (
      { lib, config, ... }:
      {
        flake.lib = import ./lib { inherit lib; };
        _module.args.flakeRoot = ./.;
        _module.args.lib-custom = config.lib;

        imports = [
          inputs.ez-configs.flakeModule
          inputs.agenix-rekey.flakeModule
          inputs.pkgs-by-name-for-flake-parts.flakeModule
          ./overlays.nix
          ./ez-configs.nix
          ./picokeys.nix
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
              overlays = [
                config.flake.overlays.imported
                config.flake.overlays.lib-custom
                # do not use pkgs overlay, you will encounter infinite recursion
              ];
            };
          in
          {
            _module.args.pkgs = import inputs.nixpkgs nixpkgsArgs;

            formatter = pkgs.nixfmt-rfc-style;
            pkgsDirectory = ./packages;

            devShells.agenix-rekey = pkgs.mkShell {
              nativeBuildInputs = [
                pkgs.agenix-rekey.package
                pkgs.rage
                pkgs.age-plugin-yubikey
                pkgs.age-plugin-fido2-hmac
              ];
            };
          };
      }
    );
}
