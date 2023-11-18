{
  inputs = {
    systems.url = "github:nix-systems/default";
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.url = "nixpkgs";
    };
  };

  outputs = {
    self,
    systems,
    nixpkgs,
    treefmt-nix,
    ...
  } @ inputs: let
    eachSystem = f:
      nixpkgs.lib.genAttrs (import systems) (
        system:
          f nixpkgs.legacyPackages.${system}
      );

    treefmtEval = eachSystem (pkgs: treefmt-nix.lib.evalModule pkgs ./treefmt.nix);
  in {
    packages = eachSystem (pkgs: {
      cli = pkgs.callPackage ./cli {};
      alacritty-with-kittykeys = pkgs.callPackage ./alacritty-with-kittykeys {};
    });

    # Create a devShell for each package.
    devShells = eachSystem (pkgs:
      nixpkgs.lib.attrsets.mapAttrs (packageName: package:
        pkgs.mkShell {
          inputsFrom = [package];
        })
      self.packages.${pkgs.system});

    formatter = eachSystem (pkgs: treefmtEval.${pkgs.system}.config.build.wrapper);

    checks = eachSystem (pkgs: {
      formatting = treefmtEval.${pkgs.system}.config.build.check self;
    });
  };
}
