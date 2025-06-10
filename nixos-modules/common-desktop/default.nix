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
      path = ./modules;
      recursive = false;
    };
}
