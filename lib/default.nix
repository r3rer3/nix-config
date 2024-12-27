# functions tern, right, mkIfElse from https://git.zynh.me/Zynh0722/nixos/src/branch/main/lib/default.nix
final: prev:
let
  inherit (prev) isFunction mkMerge mkIf;
in
rec {
  tern = pred: x: y: if pred then x else y;

  right = f: g:
    tern (isFunction g)
    (right (x: f (g (x))))
    (f (g));

  mkIfElse = pred: yes: no: mkMerge [
    (mkIf pred yes)
    (mkIf (!pred) no)
  ];
}
