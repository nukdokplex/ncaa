{
  inputs,
  lib',
  ...
}:
{
  imports =
    [
      ../common-base
    ]
    ++ lib'.umport {
      path = ./.;
      exclude = [ ./default.nix ];
      recursive = false;
    };
}
