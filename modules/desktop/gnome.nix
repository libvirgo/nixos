{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.gnome;
    configDir = config.dotfiles.configDir;
in {
  options.modules.desktop.gnome = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    services.xserver.enable = true;
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
    home-manager.users.${config.user.name}.dconf.settings = {
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
    environment.gnome.excludePackages = (with pkgs; [
      gnome-tour
      gnome-console
      gnome-connections
    ]) ++ (with pkgs.gnome; [
      cheese
      epiphany
    ]);
    environment.systemPackages = with pkgs; [
      libnotify
    ] ++ (with gnomeExtensions; [
      clipboard-indicator
      tray-icons-reloaded
      night-theme-switcher
    ]);
  };
}
