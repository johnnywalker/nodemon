{
  pkgs,
  git-hooks,
  treefmt-wrapper,
}:
git-hooks.run {
  src = ./.;
  hooks = {
    convco.enable = true;
    shellcheck.enable = false;
    treefmt.enable = true;
    treefmt.package = treefmt-wrapper;
    trailing-whitespace = {
      enable = true;
      name = "Trim Trailing Whitespace";
      description = "This hook trims trailing whitespace.";
      entry = "${pkgs.python3Packages.pre-commit-hooks}/bin/trailing-whitespace-fixer";
      types = ["text"];
    };
    end-of-line-fixer = {
      enable = true;
      name = "Fix End of Files";
      description = "Ensures that a file is either empty, or ends with one newline.";
      entry = "${pkgs.python3Packages.pre-commit-hooks}/bin/end-of-file-fixer";
      types = ["text"];
    };
  };
}
