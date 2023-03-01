{ pkgs, config, lib, ... }:
let configDir = config.dotfiles.configDir;
in
{
  imports = [
#    ../home.nix
    ./hardware-configuration.nix
  ];
  networking.networkmanager.enable = true;

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
  };
  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  modules = {
    desktop = {
      gnome.enable = true;
    };
    hardware = {
      audio.enable = true;
    };
    i18n = {
      chinese.enable = true;
    };
    shell = {
      zsh.enable = true;
      git.enable = true;
      direnv.enable = true;
    };
  };
  environment.systemPackages = with pkgs; [
    nodejs
    python3
  ];
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
  services.flatpak.enable = true;
  home.file = {
    ".face".source = "${configDir}/face.png";
  };
  users.users.${config.user.name} = {
    extraGroups = [ "networkmanager" "kvm" "docker" "vboxusers" ];
  };
  user.packages = with pkgs.unstable; [
      jetbrains.idea-ultimate
      obsidian
      watchexec
      minikube
      kubectl
      gradle
  ];
}