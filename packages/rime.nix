{
  trivialBuild,
  fetchFromGitHub,
  librime,
  dash,
}:
let emacsRimeSoDir = "$out/share/emacs/site-lisp/librime-emacs.so";
in
trivialBuild rec {
  pname = "emacs-rime";
  src = fetchFromGitHub {
    owner = "DogLooksGood";
    repo = "emacs-rime";
    rev = "0a50c918d2de56aa401a68ba37394446c6fc9ed6";
    hash = "sha256-AM2JtDNBISjVUFSkzLa14DRfunuKoCG9mrPZDL4sQZU=";
  };
  # elisp dependencies
  propagatedUserEnvPkgs = [
    dash
  ];
  buildInputs = propagatedUserEnvPkgs ++ [ librime ];
  postFixup = "gcc lib.c -o ${emacsRimeSoDir} -fPIC -O2 -Wall -shared -lrime";
}