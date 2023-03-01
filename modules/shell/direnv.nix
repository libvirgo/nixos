{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.shell.direnv;
in {
  options.modules.shell.direnv = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = [ pkgs.direnv ];
    home-manager.users.${config.user.name} = {
      programs = {
       direnv = {
         enable = true;
         enableZshIntegration = true;
         nix-direnv = {
           enable = true;
         };
       };
      };
    };
  };
}
