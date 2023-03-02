{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.gnome;
in {
  options.modules.desktop.gnome = {
    enable = mkBoolOpt false;
  };
  config = mkIf cfg.enable {
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
    environment.systemPackages = with pkgs; [
      libnotify
    ] ++ (with gnomeExtensions; [
      clipboard-indicator
      tray-icons-reloaded
      night-theme-switcher
    ]);
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
      # no need to redefine it in your config for now)
      #media-session.enable = true;
    };
  };
}