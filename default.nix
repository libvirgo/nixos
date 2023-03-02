{ inputs, config, lib, pkgs, ... }:

with lib;
with lib.my;
{
  imports =
    # I use home-manager to deploy files to $HOME; little else
    [
      inputs.home-manager.nixosModules.home-manager {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        environment = {
          sessionVariables = {
            XDG_CACHE_HOME  = "$HOME/.cache";
            XDG_CONFIG_HOME = "$HOME/.config";
            XDG_DATA_HOME   = "$HOME/.local/share";
            XDG_BIN_HOME    = "$HOME/.local/bin";
          };
         };
        home-manager.extraSpecialArgs = { inherit inputs; };
      }
      (lib.mkAliasOptionModule ["hm"] ["home-manager" "users" "sakura"])
    ]
    # All my personal modules
    ++ (mapModulesRec' (toString ./modules) import);
  hm = import ./users/sakura/home.nix;
  # Use the systemd-boot EFI boot loader.
  boot = {
    supportedFilesystems = [ "ntfs" ];
    kernelPackages = pkgs.linuxPackages_6_1;
    plymouth.enable = true;
    consoleLogLevel = 0;
    initrd.verbose = false;
    kernelParams = [
      "quiet"
      "splash"
      "loglevel=3"
    ];
    loader = {
      timeout = 0;
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };
  nix = {
    package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };
  environment.systemPackages = with pkgs; [
    git
    kitty
    nodejs
    tmux
    microsoft-edge
    python3
  ];
  programs = {
    mtr.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    zsh.enable = true;
    neovim = {
      enable = true;
      withPython3 = true;
      viAlias = true;
      vimAlias = true;
    };
  };
  system.copySystemConfiguration = true;
  system.stateVersion = "22.11"; # Did you read the comment?
}