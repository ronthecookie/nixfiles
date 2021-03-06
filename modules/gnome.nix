{ lib, config, pkgs, ... }:

let cfg = config.cookie.gnome;
in with lib; {
  options.cookie.gnome = {
    enable = mkEnableOption "Enables a bunch of GNOME apps";
  };
  config = mkIf cfg.enable {
    programs.dconf.enable = true;
    environment.systemPackages = with pkgs; [
      gnome3.adwaita-icon-theme
      gnomeExtensions.appindicator
      # apps
    ];
    home-manager.users.ckie = { pkgs, ... }: {
      home.packages = with pkgs; [
        gnome3.file-roller
        gnome3.gnome-system-monitor
        gnome3.gnome-calculator
        gnome3.totem
        gnome3.eog
      ];
    };
    services.udev.packages = with pkgs; [ gnome3.gnome-settings-daemon ];
  };
}
