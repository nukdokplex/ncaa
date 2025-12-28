{
  lib,
  config,
  inputs,
  ...
}:
let
  falhofnir = inputs.self.outputs.nixosConfigurations.falhofnir.config;
in
{
  options.services.sing-box.falhofnir-hysteria2-extraConfig = lib.mkOption {
    type = lib.types.attrs;
    default = { };
  };

  config = {
    services.sing-box = {
      settings.outbounds = lib.singleton (
        {
          tag = "falhofnir-hysteria2";
          type = "hysteria2";
          server = "falhofnir.nukdokplex.ru";
          server_port = 1199;
          obfs = {
            type = "salamander";
            password._secret = config.age.secrets.falhofnir-hysteria2-obfs-password.path;
          };
          password._secret = config.age.secrets.falhofnir-hysteria2-user-password.path;
          tls = {
            enabled = true;
            server_name = "jugger.fannybaws.ru";
          };
          brutal_debug = true;
        }
        // config.services.sing-box.falhofnir-hysteria2-extraConfig
      );
    };

    age.secrets = {
      falhofnir-hysteria2-user-password = {
        generator.script = "strong-password";
        owner = "sing-box";
        group = "sing-box";
      };
      falhofnir-hysteria2-obfs-password = {
        inherit (falhofnir.age.secrets.hysteria2-obfs-password) rekeyFile;
        owner = "sing-box";
        group = "sing-box";
      };
    };
  };
}
