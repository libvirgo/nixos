# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];
  nixpkgs.config.allowUnfree = true;
  modules = {
    desktop.gnome.enable = true;
  };

  networking.hostName = "ragdoll"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Asia/Shanghai";

  # Configure network proxy if necessary
  networking.proxy.default = "http://127.0.0.1:7890";
  networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain,10.96.0.0/12,192.168.59.0/24,192.168.49.0/24,192.168.39.0/24";
  networking.extraHosts = ''
    127.0.0.1 etcd
    127.0.0.1 redis
    127.0.0.1 jaeger
  '';
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.inputMethod = {
    enabled = "ibus";
    ibus.engines = with pkgs.ibus-engines; [ rime ];
  };
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };
  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;
  services.flatpak.enable = true;
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.defaultUserShell = pkgs.zsh;
  environment.shells = with pkgs; [ zsh ];
  users.users.sakura = {
    isNormalUser = true;
    description = "sakura";
    extraGroups = [ "networkmanager" "wheel" "kvm" "docker" "vboxusers" ];
    packages = with pkgs; [
    ];
    initialPassword = "nixos";
  };
  fonts = {
    fontDir.enable = true;
    fonts = with pkgs; [
      sarasa-gothic
      noto-fonts
      noto-fonts-cjk-serif
      noto-fonts-cjk-sans
      (nerdfonts.override { fonts = [ "JetBrainsMono" "Iosevka" ]; })
    ];
    fontconfig = {
      defaultFonts = {
        emoji = [ "Noto Color Emoji" ];
	    monospace = [ "Noto Sans Mono CJK SC" "Sarasa Mono SC" ];
	    sansSerif = [ "Noto Sans CJK SC" ];
	    serif = [ "Noto Sans CJK SC" ];
      };
    };
  };
  virtualisation = {
    docker = {
      enable = true;
      storageDriver = "btrfs";
      logDriver = "json-file";
    };
    virtualbox.host = {
      enable = true;
      enableExtensionPack = true;
    };
#    anbox.enable = true;
  };
  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
}

