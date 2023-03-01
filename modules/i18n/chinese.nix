{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.i18n.chinese;
in {
  options.modules.i18n.chinese = {
    enable = mkBoolOpt false;
  };
  config = mkIf cfg.enable (mkMerge [
  {
    fonts = {
      fonts = with pkgs; [
        sarasa-gothic
        noto-fonts-cjk-serif
        noto-fonts-cjk-sans
      ];
      fontconfig = {
        defaultFonts = {
	      monospace = [ "Noto Sans Mono CJK SC" "Sarasa Mono SC" ];
	      sansSerif = [ "Noto Sans CJK SC" ];
	      serif = [ "Noto Sans CJK SC" ];
        };
      };
    };
    i18n.inputMethod = {
      enabled = "ibus";
      ibus.engines = with pkgs.ibus-engines; [ rime ];
    };
  }
  (mkIf config.modules.desktop.gnome.enable {
    services.xserver.desktopManager.gnome = {
      extraGSettingsOverrides = ''
        [org.gnome.desktop.input-sources]
        sources=[('xkb', 'us'), ('ibus', 'rime')]
      '';
    };
  })
  ]);
}