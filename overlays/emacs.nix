self: super:
with super.lib;
with super.pkgs;
{
  myemacs = ((emacsPackagesFor ((super.emacsGit.override{
    nativeComp = false;
    withGTK3 = true;
  }).overrideAttrs (old: {
    name = "emacs-30";
    version = "30.0.50";
    src = fetchFromGitHub {
      owner = "libvirgo";
      repo = "emacs-src";
      rev = "196832769d9ff8dca2aeb7bce5d827c82ceafa55";
      sha256 = "sha256-DP3PYprDRLog2rzmfeu5cLlEfVO2qjU7H6+nR0amvB0=";
    };
    dontWrapGApps = true;
  }))).emacsWithPackages (epkgs: [
    epkgs.vterm
#    (callPackage ../packages/rime.nix {
#      inherit (pkgs) fetchFromGitHub librime;
#      inherit (epkgs) trivialBuild dash;
#    })
  ]));
}
