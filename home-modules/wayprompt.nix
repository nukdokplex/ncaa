{ lib, config, ... }:
{
  programs.wayprompt = {
    enable = true;
    settings.general.corner-radius = 0;
  };

  # ssh integration
  home.sessionVariables = {
    SSH_ASKPASS = lib.getExe' config.programs.wayprompt.package "wayprompt-ssh-askpass";
  };

  # gpg integration
  services.gpg-agent = {
    pinentry = {
      inherit (config.programs.wayprompt) package;
      program = "pinentry-wayprompt";
    };
  };
}
