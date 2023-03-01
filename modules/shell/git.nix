{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.shell.git;
    configDir = config.dotfiles.configDir;
in {
  options.modules.shell.git = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      git
    ];
    home-manager.users.${config.user.name}.programs = {
      git = {
        enable = true;
        userEmail = "sakurapetgirl@live.com";
        userName = "libvirgo";
        extraConfig = {
          credential = {
            helper = "store";
          };
	      url."https://".insteadOf = "git://";
        };
      };
    };
#    modules.shell.zsh.rcFiles = [ "${configDir}/git/aliases.zsh" ];
  };
}
