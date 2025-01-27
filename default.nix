{
  lib,
  buildNpmPackage,
}:
buildNpmPackage {
  pname = "nodemon";
  version = "1.0.0";
  src = lib.cleanSource ./.;
  npmDepsHash = "sha256-h8TpS1O+6uW76f8hiKBmRqKk9BuI/Da2MAvKSm8mIf4=";
  dontNpmBuild = true;
}
