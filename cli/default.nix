{rustPlatform}:
rustPlatform.buildRustPackage {
  name = "tnt";
  version = "0.0.1";
  src = ./.;
  cargoLock.lockFile = ./Cargo.lock;
}
