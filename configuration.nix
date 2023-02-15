# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, nixpkgs-unstable, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];
  nixpkgs.config.allowUnfree = true;
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
  networking.hostName = "ragdoll"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Asia/Shanghai";

  # Configure network proxy if necessary
  networking.proxy.default = "http://127.0.0.1:7890";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
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
  # Enable the X11 windowing system.
  services.xserver.enable = true;


  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome = {
    enable = true;
    extraGSettingsOverrides = ''
      [org.gnome.system.location]
      enabled=true
      [org.gnome.desktop.interface]
      text-scaling-factor=1.25
      cursor-blink=false
      cursor-size=32
      [org.gnome.desktop.wm.preferences]
      button-layout='appmenu:minimize,close'
      [org.gnome.desktop.input-sources]
      sources=[('xkb', 'us'), ('ibus', 'rime')]

      # Extensions settings
      [org.gnome.shell]
      enabled-extensions=['clipboard-indicator@tudmotu.com', 'trayIconsReloaded@selfmade.pl', 'nightthemeswitcher@romainvigier.fr']
    '';
  };
  services.xserver.excludePackages = [ pkgs.xterm ];
  services.xserver.desktopManager.xterm.enable = false;
  environment.gnome.excludePackages = (with pkgs; [
    gnome-tour
    gnome-console
    gnome-connections
  ]) ++ (with pkgs.gnome; [
    cheese
    epiphany
  ]);
  

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
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
    ] ++ (with nixpkgs-unstable; [
      jetbrains.goland
      jetbrains.datagrip
    ]);
  };
  environment.systemPackages = with pkgs; [
    git
    kitty
    nodejs
    tmux
    microsoft-edge
    python3
    libnotify
  ] ++ (with gnomeExtensions; [
    clipboard-indicator
    tray-icons-reloaded
    night-theme-switcher
  ]);
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
    };
    virtualbox.host = {
      enable = true;
      enableExtensionPack = true;
    };
#    anbox.enable = true;
  };
  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  system.copySystemConfiguration = true;
  system.stateVersion = "22.11"; # Did you read the comment?
}

