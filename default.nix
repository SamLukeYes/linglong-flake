{ pkgs ? import <nixpkgs> { } }:

with pkgs;
let 
  packages = ps: with ps; {
    linglong = callPackage ./linglong { };
    linglong-box = callPackage ./linglong/box.nix { };
    linglong-dbus-proxy = callPackage ./linglong/dbus.nix { };
    linglong-root = callPackage ./linglong/root.nix { };
  };
in
  lib.makeScope libsForQt5.newScope packages