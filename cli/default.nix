{
  writeScriptBin,
  python3,
  stdenv,
}:
stdenv.mkDerivation {
  name = "tnt";
  version = "0.0.1";
  src = ""; # ???
  buildInputs = [python3];
  installPhase = ''
    mkdir $out/bin
    echo "echo hello world" > $out/bin/tnt
    chmod +x $out/bin/tnt
  '';
}
