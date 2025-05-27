{
  description = "A collection of crap, hacks, and copy-paste to make my hosts boot";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    systems = {
      url = "github:nix-systems/default-linux";
    };
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    flake-utils = {
      url = "github:numtide/flake-utils";
    };
    ez-configs = {
      url = "github:ehllie/ez-configs";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
    };
    agenix = {
      url = "github:ryantm/agenix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        darwin.follows = "";
        home-manager.follows = "home-manager";
      };
    };
    agenix-rekey = {
      url = "github:oddlama/agenix-rekey";
      inputs = {
        # TODO: check inputs
        flake-parts.follows = "flake-parts";
        nixpkgs.follows = "nixpkgs";
      };
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        pre-commit-hooks-nix.follows = "";
      };
    };
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
        nuschtosSearch.follows = "";
      };
    };
    nur = {
      url = "github:nix-community/nur";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
      };
    };
    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        pre-commit-hooks.follows = "";
        systems.follows = "systems";
      };
    };
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs = {
        hyprland.follows = "hyprland";
        nixpkgs.follows = "nixpkgs";
      };
    };
    picokeys-nix = {
      # url = "github:ViZiD/picokeys-nix";
      url = "github:nukdokplex/picokeys-nix";
      # i don't want to picokeys imports global nixpkgs
      # inputs.nixpkgs.follows = "nixpkgs";
    };
    simple-nixos-mailserver = {
      url = "gitlab:simple-nixos-mailserver/nixos-mailserver/master";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };
    spicetify = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:nix-community/stylix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
        flake-compat.follows = "";
        # git-hooks.follows = "";
      };
    };
    tssp = {
      url = "github:nukdokplex/tssp-nix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
      };
    };

    # yazi plugins
    bunny-yazi = {
      url = "github:stelcodes/bunny.yazi";
      flake = false;
    };
    custom-shell-yazi = {
      url = "github:AnirudhG07/custom-shell.yazi";
      flake = false;
    };
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
    inputs@{ flake-parts, systems, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } (
      { lib, ... }:
      {
        _module.args.flakeRoot = ./.;
        imports = [
          inputs.ez-configs.flakeModule
          inputs.agenix-rekey.flakeModule
          ./ez-configs.nix
          ./packages
          ./picokeys.nix
        ];

        flake.lib = import ./lib { inherit lib; };

        systems = import systems;

        perSystem =
          {
            config,
            pkgs,
            system,
            ...
          }:
          {
            formatter = pkgs.nixfmt-rfc-style;

            devShells.agenix-rekey = pkgs.mkShell {
              nativeBuildInputs = [
                config.agenix-rekey.package
                pkgs.rage
                pkgs.age-plugin-yubikey
                pkgs.age-plugin-fido2-hmac
              ];
            };
          };
      }
    );
}
