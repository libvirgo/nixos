{ config, pkgs, ... }:

{
  home.username = "sakura";
  home.homeDirectory = "/home/sakura";
  programs.home-manager.enable = true;
  home.stateVersion = "22.11";
  xdg.configFile = {
    "kitty/kitty.conf".source = ./config/kitty/kitty.conf;
    "tmux/tmux.conf".source= ./config/tmux/tmux.conf;
  };
  programs = {
    git = {
      enable = true;
      userEmail = "sakurapetgirl@live.com";
      userName = "libvirgo";
      extraConfig = {
        credential = {
          helper = "store";
        };
      };
    };
    bat.enable = true;
    exa = {
      enable = true;
      enableAliases = true;
    };
    direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv = {
        enable = true;
      };
    };
    fzf = {
      enable = true;
      enableZshIntegration = true;
    };
    zoxide = {
      enable = true;
      enableZshIntegration = true;
      options = [ "--cmd cd" ];
    };
    zsh = {
      enable = true;
      enableAutosuggestions = true;
      enableSyntaxHighlighting = true;
      shellAliases = {
        cat = "bat -p";
        unpack = "tar -xvf";
        pack = "tar -zcvf archive.tar.gz";
        glog = "git log --oneline --decorate --graph";
        gst = "git status";
        oss = "sudo nixos-rebuild switch --impure --flake $HOME/Documents/code/flake/nixos#$HOST && source ~/.zshrc";
      };
      plugins = [
        {
          name = "powerlevel10k-config";
          src = ./config/zsh;
          file = "p10k-config.zsh";
        }
        {
          name = "fzf-tab";
          src = pkgs.fetchFromGitHub {
              owner = "Aloxaf";
              repo = "fzf-tab";
              rev = "69024c27738138d6767ea7246841fdfc6ce0d0eb";
              sha256 = "sha256-yN1qmuwWNkWHF9ujxZq2MiroeASh+KQiCLyK5ellnB8=";
          };
        }
      ];
      zplug = {
        enable = true;
        plugins = [
          {
            name = "ogham/exa";
            tags = [ use:completions/zsh ];
          }
          {
            name = "djui/alias-tips";
          }
          {
            name = "romkatv/powerlevel10k";
            tags = [ as:theme depth:1 ];
          }
        ];
      };
    };
  };
}
