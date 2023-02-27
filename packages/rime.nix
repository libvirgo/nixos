#{
#  trivialBuild,
#  fetchFromGitHub,
#  librime,
#  dash,
#}:
#let emacsRimeSoDir = "$out/share/emacs/site-lisp/librime-emacs.so";
#in
#trivialBuild rec {
#  pname = "emacs-rime";
#  src = fetchFromGitHub {
#    owner = "DogLooksGood";
#    repo = "emacs-rime";
#    rev = "6438abacace7d94f05fabc45b82d619677fc5fca";
#    hash = "sha256-wNMLRU13jL+YfxJbuAYYZKGTeYKZqp0ORYmd76hI2zs=";
#  };
#  # elisp dependencies
#  propagatedUserEnvPkgs = [
#    dash
#  ];
#  buildInputs = propagatedUserEnvPkgs ++ [ librime ];
#  postFixup = "gcc lib.c -o ${emacsRimeSoDir} -fPIC -O2 -Wall -shared -lrime";
#}