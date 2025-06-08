{
  inputs = {
    nixpkgs.url = "github:cachix/devenv-nixpkgs/rolling";
    systems.url = "github:nix-systems/default";
    devenv.url = "github:cachix/devenv";
    devenv.inputs.nixpkgs.follows = "nixpkgs";
    fenix.url = "github:nix-community/fenix";
    fenix.inputs = {
      nixpkgs.follows = "nixpkgs";
    };
  };

  nixConfig = {
    extra-trusted-public-keys = "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=";
    extra-substituters = "https://devenv.cachix.org";
  };

  outputs =
    {
      self,
      nixpkgs,
      devenv,
      systems,
      ...
    }@inputs:
    let
      forEachSystem = nixpkgs.lib.genAttrs (import systems);
    in
    {
      packages = forEachSystem (system: {
        devenv-up = self.devShells.${system}.default.config.procfileScript;
        devenv-test = self.devShells.${system}.default.config.test;
      });

      devShells = forEachSystem (
        system:
        let
          overlays = [ ];
          pkgs = import nixpkgs {
            inherit system overlays;
          };
        in
        #pkgs = nixpkgs.legacyPackages.${system};
        {
          default = devenv.lib.mkShell {
            inherit inputs pkgs;
            modules = [
              {
                # https://devenv.sh/reference/options/
                packages = with pkgs; [
                  clang
                  llvmPackages_17.clang-unwrapped
                  llvmPackages_17.bintools-unwrapped
                ];
                languages = {
                  rust = {
                    enable = true;
                    channel = "nightly";
                    targets = [ "x86_64-unknown-linux-gnu" ];
                  };

                  javascript = {
                    enable = true;
                    bun.enable = true;
                  };

                  python = {
                    enable = true;
                    uv.enable = true;
                  };
                };

                enterShell = ''
                  unset SOURCE_DATE_EPOCH
                '';
              }
            ];
          };
        }
      );
    };
}
