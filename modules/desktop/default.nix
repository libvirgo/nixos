{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop;
in {
  config = mkIf config.services.xserver.enable {
    assertions = [
      {
        assertion = (countAttrs (n: v: n == "enable" && value) cfg) < 2;
        message = "Can't have more than one desktop environment enabled at a time";
      }
      {
        assertion =
          let srv = config.services;
          in srv.xserver.enable ||
             srv.sway.enable ||
             !(anyAttrs
               (n: v: isAttrs v &&
                      anyAttrs (n: v: isAttrs v && v.enable))
               cfg);
        message = "Can't enable a desktop app without a desktop environment";
      }
    ];

    # Configure keymap in X11
    services.xserver = {
      layout = "us";
      xkbVariant = "";
    };
    services.xserver.excludePackages = [ pkgs.xterm ];
    user.packages = with pkgs; [
    ];
    environment.systemPackages = with pkgs; [
      kitty
      microsoft-edge
    ];
    fonts = {
      fontDir.enable = true;
      enableGhostscriptFonts = true;
      fonts = with pkgs; [
        noto-fonts
        (nerdfonts.override { fonts = [ "JetBrainsMono" "Iosevka" ]; })
      ];
      fontconfig = {
        defaultFonts = {
          emoji = [ "Noto Color Emoji" ];
	      monospace = [ "Noto Sans Mono" ];
	      sansSerif = [ "Noto Sans" ];
	      serif = [ "Noto Serif" ];
        };
      };
    };
  };
}