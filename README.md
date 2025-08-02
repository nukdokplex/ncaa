# NukDokPlex's Nix-Code-as-Anything (NCaA)

A collection of crap to make my hosts boot and some other prekoldesses.

[![nixpkgs branch shield](https://img.shields.io/badge/dynamic/json?url=https%3A%2F%2Fgithub.com%2Fnukdokplex%2Fncaa%2Fraw%2Frefs%2Fheads%2Fmaster%2Fflake.lock&query=%24.nodes.nixpkgs.original.ref&style=flat-square&logo=nixos&logoColor=%235277C3&label=nixpkgs%20branch&labelColor=white&color=%235277C3)](https://github.com/nukdokplex/ncaa/blob/master/flake.lock)
[![nixpkgs commit shield](https://img.shields.io/badge/dynamic/json?url=https%3A%2F%2Fgithub.com%2Fnukdokplex%2Fncaa%2Fraw%2Frefs%2Fheads%2Fmaster%2Fflake.lock&query=%24.nodes.nixpkgs.locked.rev&style=flat-square&logo=nixos&logoColor=%235277C3&label=nixpkgs%20commit&labelColor=white&color=%235277C3)](https://github.com/nukdokplex/ncaa/blob/master/flake.lock)
[![formatting shield](https://img.shields.io/badge/formatting-nixfmt-5277c3?style=flat-square&logo=nixos&logoColor=5277c3&labelColor=white)](https://github.com/NixOS/nixfmt)
[![commit activity shield](https://img.shields.io/github/commit-activity/m/nukdokplex/ncaa?style=flat-square&logo=git&logoColor=%23F05032&label=commit%20activity&labelColor=white&color=%23F05032)](https://github.com/nukdokplex/ncaa/commits)
[![nix-check workflow](https://img.shields.io/github/actions/workflow/status/nukdokplex/ncaa/nix-check.yml?branch=master&style=flat-square&logo=githubactions&logoColor=%232088FF&label=nix-check&labelColor=white&color=%20%232088FF)](https://github.com/nukdokplex/ncaa/actions/workflows/nix-check.yml?query=branch%3Amaster)
[![build-nixos-hosts](https://img.shields.io/github/actions/workflow/status/nukdokplex/ncaa/build-nixos-hosts.yml?branch=master&style=flat-square&logo=githubactions&logoColor=%232088FF&label=build-nixos-hosts&labelColor=white&color=%20%232088FF)](https://github.com/nukdokplex/ncaa/actions/workflows/build-nixos-hosts.yml?query=branch%3Amaster)
[![license](https://img.shields.io/github/license/nukdokplex/ncaa?style=flat-square&logo=spdx&logoColor=%234398CC&label=license&labelColor=white&color=%234398CC)](https://github.com/nukdokplex/ncaa/raw/refs/heads/master/LICENSE)

## Key features

- this is a nix flake;
- [hercules-ci/flake-parts](https://github.com/hercules-ci/flake-parts) powered;
- outputs NixOS/Home Manager configurations/modules structured KISSfully with a little help of [ehllie/ez-configs](https://github.com/ehllie/ez-configs);
- [ryantm/agenix](https://github.com/ryantm/agenix) + [oddlama/agenix-rekey](https://github.com/oddlama/agenix-rekey) powered secret store;
- provides some uselessful NixOS and Home Manager modules, feel free to explore corresponding nixos-modules and home-modules directories;
- provides some lib functions;
- no furry and anime girls, I don't like them;
- GNU GPL v3 licensed;

## Hosts

What are those cool hostnames mean? Well I name my hosts after the old Norse horses. There is no any reason why I give some host that specific horse name, I just like it and that's all. Sleipnir is exception because this horse belongs to Odin and it is mighty and tricky as my home desktop.

| Hostname  | Board                                     | CPU                       | GPU                                     | RAM                               | OS    | Purpose                                                                                                   |
| --------- | ----------------------------------------- | ------------------------- | --------------------------------------- | --------------------------------- | ----- | --------------------------------------------------------------------------------------------------------- |
| sleipnir  | MSI B550 TOMAHAWK (MS-7C91)               | AMD Ryzen 5 5600 (12)     | AMD Radeon RX 6700 XT                   | 32GiB                             | NixOS | Desktop                                                                                                   |
| gladr     | Acer Swift SF314-41                       | AMD Ryzen 5 3500U (8)     | AMD Radeon Vega 8 Graphics (Integrated) | 20-2=18GiB (2GiB allocated to VRAM) | NixOS | Laptop                                                                                                    |
| falhofnir | KVM (RHEL 7.6.0 PC (i440FX + PIIX, 1996)) | Intel Xeon E5-2680 v4 (1) | Cirrus Logic GD 5446 (Virtual)          | 1GiB                              | NixOS | Proxy server (AmneziaWG, sing-box)                                                                        |
| gler      | KVM (RHEL 7.6.0 PC (i440FX + PIIX, 1996)) | Intel Xeon E5-2670 v2 (2) | Cirrus Logic GD 5446 (Virtual)          | 2GiB                              | NixOS | Mailserver (using [simple-nixos-mailserver](https://gitlab.com/simple-nixos-mailserver/nixos-mailserver)) |
