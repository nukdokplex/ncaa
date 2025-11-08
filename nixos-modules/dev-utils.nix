{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # nix
    nixfmt-rfc-style # formatter
    alejandra # formatter
    statix # linter
    deadnix # dead code remover
    nix-prefetch
    nix-prefetch-github
    nix-prefetch-docker
    nix-prefetch-scripts
    cachix # nix cache server

    # web
    prettierd # formatter
    prettier # formatter
    eslint_d # linter
    eslint # linter

    # bash
    shellcheck # shell script analysis tool
    shellharden # corrective bash syntax highlighter
    shfmt # shell parser and formatter

    # python
    python3Packages.isort # python imports sorting
    python3Packages.black # formatter
    python3Packages.flake8 # linter

    # rust
    rustfmt # formatter
    clippy # linter

    # docker
    dockerfmt # formatter
    hadolint # linter

    # json
    jsonfmt # formatter
    jq # general-purpose json processor
    jid # interactive json exploration

    # markdown
    pandoc # swiss army knife for document conversion
    mdformat # formatter
  ];
}
