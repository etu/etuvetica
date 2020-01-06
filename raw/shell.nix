with (import <nixpkgs> {});

mkShell {
  buildInputs = [
    netpbm
    potrace
    fontforge-gtk
    gimp
    perl
  ];
}
