{ lib, ... }:
with builtins;
with lib;
rec {
  # [ { name = "x"; value = "a"; } { name = "y"; value = "b"; } ]
  attrsToList = attrs:
    mapAttrsToList (name: value: { inherit name value; }) attrs;

  # mapFilterAttrs ::
  #   (name -> value -> bool)
  #   (name -> value -> { name = any; value = any; })
  #   attrs
  # mapFilterAttrs (n: v: n == "foo_x")
  #   (n: v: lib.nameValuePair ("foo_" + n) ("bar_" + v)) { x = "a"; y = "b";}
  # { foo_x = "bar_a"; }
  mapFilterAttrs = pred: f: attrs: filterAttrs pred (mapAttrs' f attrs);

  genAttrs' = values: f: listToAttrs (map f values);

  # anyAttrs :: (name -> value -> bool) attrs
  anyAttrs = pred: attrs:
    any (attr: pred attr.name attr.value) (attrsToList attrs);

  # countAttrs :: (name -> value -> bool) attrs
  countAttrs = pred: attrs:
    count (attr: pred attr.name attr.value) (attrsToList attrs);
}