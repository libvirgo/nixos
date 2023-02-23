{ config, inputs, ... }:
let
  pkgs-unstable = import inputs.nixpkgs-unstable {
    system = pkgs.system;
    config.allowUnfree = true;
  };
  pkgs = import inputs.nixpkgs {
    overlays = [
      (import (builtins.fetchTarball { url = https://github.com/nix-community/emacs-overlay/archive/master.tar.gz; }))
      (import ../../overlays/emacs.nix)
    ];
  };
in
{
  home.username = "sakura";
  home.homeDirectory = "/home/sakura";
  programs.home-manager.enable = true;
  home.stateVersion = "22.11";
  xdg.configFile = {
    "kitty/kitty.conf".source = ./config/kitty/kitty.conf;
    "tmux/tmux.conf".source= ./config/tmux/tmux.conf;
  };
  home.file = {
    ".face".source = ./config/face.png;
  };
  home.packages = with pkgs-unstable; [
      jetbrains.idea-ultimate
      obsidian
      fd
      ripgrep
      watchexec
      pkgs.myemacs
      minikube
      kubectl
  ];
  dconf.settings = {
    "org/gnome/shell/extensions/trayIconsReloaded" = {
      icon-margin-horizontal = 2;
      icon-padding-horizontal = 2;
      icon-size = 20;
      icons-limit = 5;
      position-weight = 999;
      tray-margin-left = 2;
      tray-position = "center";
    };
    "org/gnome/shell/extensions/nightthemeswitcher/commands" = {
      enabled = true;
      sunrise = "notify-send 'Hello sunshine!'";
      sunset = "notify-send 'Hello moonshine!'";
    };
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
        oss = "nixos-rebuild switch --flake .#ragdoll --impure --use-remote-sudo && source ~/.zshrc";
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
	{
          name = "zsh-nix-shell";
          file = "nix-shell.plugin.zsh";
          src = pkgs.fetchFromGitHub {
            owner = "chisui";
            repo = "zsh-nix-shell";
            rev = "v0.5.0";
            sha256 = "0za4aiwwrlawnia4f29msk822rj9bgcygw6a8a6iikiwzjjz0g91";
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
