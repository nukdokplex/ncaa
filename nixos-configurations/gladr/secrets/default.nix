{ lib, ... }: let
  substractPath = path: component: lib.removePrefix ((builtins.toString component)+"/") (builtins.toString path);
  generateSecretsDir = settings@{ secretsDir, dirPrefix, path, ... }: builtins.listToAttrs (
    builtins.map
      (file: lib.nameValuePair (dirPrefix + "/" + file) ({
        file = ./${dirPrefix}/${file};
        path = "${path}/${file}";
      } // (lib.filterAttrs (name: _: ! builtins.elem name [ "secretsDir" "dirPrefix" "path" ]) settings) ))
      (
        builtins.map
          (fullPath: substractPath fullPath secretsDir)
          (lib.filesystem.listFilesRecursive secretsDir)
      )
  );
in {
  age.secrets = {

  } // generateSecretsDir {
    secretsDir = ./secureboot;
    dirPrefix = "secureboot";
    path = "/var/lib/sbctl";
    owner = "root";
    group = "root";
    mode = "600";
  };
}
