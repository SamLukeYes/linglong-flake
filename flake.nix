{
  description = "Deploy Linglong anywhere";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }: 
  let
    system = "x86_64-linux";
  in {
    packages.${system} = import ./. { pkgs = nixpkgs.legacyPackages.${system}; };
  };
}
