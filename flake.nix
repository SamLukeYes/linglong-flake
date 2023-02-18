{
  description = "Deploy Linglong anywhere";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }: 
  let
    system = "x86_64-linux";
  in {
    packages.${system} = flake-utils.lib.flattenTree (
      import ./. { pkgs = nixpkgs.legacyPackages.${system}; }
    );
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

          systemd = {
            packages = [ linglong ];
            tmpfiles.rules = [
              "C /var/lib/linglong 0775 deepin-linglong deepin-linglong - ${linglong-root}"
              "Z /var/lib/linglong 0775 deepin-linglong deepin-linglong - -"
              "d /var/log/linglong 0757 root root - -"
            ];
          };

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
