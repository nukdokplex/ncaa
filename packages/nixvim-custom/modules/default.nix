{
  inputs,
  ...
}:
{
  imports = (
    inputs.self.lib'.umport {
      path = ./.;
      recursive = true;
      exclude = [ ./default.nix ];
    }
  );
}
