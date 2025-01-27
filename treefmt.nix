{...}: {
  # Used to find the project root
  projectRootFile = "flake.nix";
  programs = {
    # *.nix
    alejandra.enable = true;

    # *.{json,md,yaml}
    prettier = {
      enable = true;
      settings = {
        printWidth = 100;
        singleQuote = true;
        semi = false;
        overrides = [
          {
            files = "*.md";
            options = {
              tabWidth = 4;
            };
          }
        ];
      };
    };
  };
}
