{
  config,
  lib,
  pkgs,
  ...
}:
{
  users = {
    groups = {
      torrent.gid = 901;
      music.gid = 902;
    };

    users.torrent = {
      name = "torrent";
      group = "torrent";
      uid = 901;
      createHome = false;
      home = "/var/empty/";
      hashedPasswordFile = config.age.secrets.torrent-user-password-hashed.path;
    };

    users.music = {
      name = "music";
      group = "music";
      uid = 902;
      createHome = false;
      home = "/var/empty/";
      hashedPasswordFile = config.age.secrets.music-user-password-hashed.path;
    };

    users.nukdokplex.extraGroups = [
      "torrent"
      "music"
    ];
  };

  system.activationScripts.samba_user_create = ''
    password=$(cat "${config.age.secrets.nukdokplex-smb-user-password.path}")
    echo -e "$password\n$password\n" | ${lib.getExe' pkgs.samba "smbpasswd"} -a -s nukdokplex
    password=$(cat "${config.age.secrets.music-user-password.path}")
    echo -e "$password\n$password\n" | ${lib.getExe' pkgs.samba "smbpasswd"} -a -s music
    password=$(cat "${config.age.secrets.torrent-user-password.path}")
    echo -e "$password\n$password\n" | ${lib.getExe' pkgs.samba "smbpasswd"} -a -s torrent
  '';

  age.secrets = {
    nukdokplex-smb-user-password.generator.script = "strong-password";
    torrent-user-password.generator.script = "strong-password";
    torrent-user-password-hashed.generator = {
      dependencies.password = config.age.secrets.torrent-user-password;
      script = "sha512-hashed-password";
    };
    music-user-password.generator.script = "strong-password";
    music-user-password-hashed.generator = {
      dependencies.password = config.age.secrets.music-user-password;
      script = "sha512-hashed-password";
    };
  };
}
