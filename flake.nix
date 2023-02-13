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
    defaultPackage.${system} = self.packages.${system}.linglong;
    
    nixosModules = { config, lib, ... }:
      with lib;
      with self.packages.${system};
      let cfg = config.services.linglong; in
      {
        options = {
          services.linglong = {
            enable = mkEnableOption "linglong";
          };
        };

        config = mkIf cfg.enable {
          environment = {
            profiles = [ "${linglong}/etc/profile.d" ];
            systemPackages = [ linglong ];
          };

          services.dbus.packages = [ linglong ];
          systemd.packages = [ linglong ];

          users = {
            groups.deepin-linglong = {};
            users.deepin-linglong = {
              group = "deepin-linglong";
              isSystemUser = true;
            };
          };
        };
      };
  };
}
