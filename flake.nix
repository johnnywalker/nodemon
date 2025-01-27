{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";

    git-hooks.url = "github:cachix/git-hooks.nix";
    git-hooks.inputs.nixpkgs.follows = "nixpkgs";

    treefmt-nix.url = "github:numtide/treefmt-nix";
    treefmt-nix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    self,
    nixpkgs,
    git-hooks,
    treefmt-nix,
  }: let
    supportedSystems = ["x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin"];

    # small tool to iterate over each system
    eachSystem = f:
      nixpkgs.lib.genAttrs supportedSystems (
        system: let
          pkgs = import nixpkgs {
            inherit system;
            # for packer
            config.allowUnfree = true;
          };
        in
          f pkgs
      );

    # Eval the treefmt modules from ./treefmt.nix
    treefmtEval = eachSystem ({pkgs, ...}: treefmt-nix.lib.evalModule pkgs ./treefmt.nix);
  in {
    checks = eachSystem (pkgs: {
      git-hooks = import ./git-hooks.nix {
        inherit pkgs;
        git-hooks = git-hooks.lib.${pkgs.system};
        treefmt-wrapper = treefmtEval.${pkgs.system}.config.build.wrapper;
      };

      # check formatting
      formatting = treefmtEval.${pkgs.system}.config.build.check self;
    });

    # for `nix fmt`
    formatter = eachSystem (pkgs: treefmtEval.${pkgs.system}.config.build.wrapper);

    packages = eachSystem (pkgs: {
      yarn = pkgs.writeScriptBin "yarn" ''
        #!${pkgs.runtimeShell}
        echo "Please use npm instead of yarn"
        exit 1
      '';
    });

    devShells = eachSystem (pkgs: {
      default = pkgs.mkShell {
        buildInputs =
          self.checks.${pkgs.system}.git-hooks.enabledPackages
          ++ (with pkgs; [
            alejandra
            nodejs
          ])
          ++ (with self.packages.${pkgs.system}; [yarn]);
        shellHook = ''
          ${self.checks.${pkgs.system}.git-hooks.shellHook}
        '';
      };
    });
  };
}
