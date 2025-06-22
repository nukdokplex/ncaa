{
  inputs,
  ezModules,
  lib',
  ...
}:
{
  imports =
    [
      ezModules.common-base
    ]
    ++ lib'.umport {
      path = ./.;
      exclude = [ ./default.nix ];
      recursive = false;
    };
}
