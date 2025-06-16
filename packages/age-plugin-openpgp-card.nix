{
  lib,
  fetchFromGitHub,

  rustPlatform,

  pcsclite,
  pkg-config,
  ...
}:
rustPlatform.buildRustPackage (final: {
  pname = "age-plugin-openpgp-card";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "wiktor-k";
    repo = final.pname;
    rev = "v${final.version}";
    hash = "sha256-uJmYtc+GxJZtCjLQla/h9vpTzPcsL+zbM2uvAQsfwIY=";
  };

  cargoHash = "sha256-YZGrEO6SOS0Kir+1d8shf54420cYjvcfKYS+T2NlEug=";

  buildInputs = [ pcsclite ];
  nativeBuildInputs = [ pkg-config ];

  meta = {
    description = "Age plugin for using ed25519 on OpenPGP Card devices (Yubikeys, Nitrokeys).";
    homepage = "https://github.com/wiktor-k/age-plugin-openpgp-card";
    license = with lib.licenses; [
      asl20
      mit
    ];
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    mainProgram = "age-plugin-openpgp-card";
    maintainers = with lib.maintainers; [ nukdokplex ];
  };
})
