{
  alacritty,
  fetchFromGitHub,
  rustPlatform,
  scdoc,
}:
alacritty.override {
  # Overriding the arguments to buildRustPackage appears to only be possible by
  # overriding the rustPlatform input.
  # https://discourse.nixos.org/t/is-it-possible-to-override-cargosha256-in-buildrustpackage/4393/3
  rustPlatform =
    rustPlatform
    // {
      buildRustPackage = args:
        rustPlatform.buildRustPackage (args
          // {
            src = fetchFromGitHub {
              owner = "kchibisov";
              repo = "alacritty";
              rev = "kitty-keyboard";
              hash = "sha256-FVnA/9vivnFhWbFLbOW35bJ+Me2pCVAuN+Xd9CkRIho=";
            };
            cargoHash = "sha256-MlWhdhA218L539O+Kkd5kV+UDsJXAz137/O0sUbQTJI=";
            preInstall = ''
              # Alacritty changed up its manpages in
              # https://github.com/alacritty/alacritty/commit/e3746e49a117ebf8d1f43715554c5a1cf8d4a116.
              # This preserves the old behavior so we don't have to override `postInstall`
              ${scdoc}/bin/scdoc < extra/man/alacritty.1.scd > extra/alacritty.man
              ${scdoc}/bin/scdoc < extra/man/alacritty-msg.1.scd > extra/alacritty-msg.man

              # Alacritty removed this file in https://github.com/alacritty/alacritty/commit/bd4906722a1a026b01f06c94c33b13ff63a7e044.
              # This preserves the old behavior so we don't have to override `postInstall`
              # (Note: there are now new man pages that should also get processed)
              touch alacritty.yml
            '';
          });
    };
}
