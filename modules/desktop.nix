{ config, lib, pkgs, ... }:

let cfg = config.cookie.desktop;
in with lib; {
  options.cookie.desktop = {
    enable = mkEnableOption "Enables the Cookie's desktop";
    # These are used by home/i3.nix, home/polybar.nix
    primaryMonitor = mkOption {
      type = types.str;
      example = "eDP-1";
      description = "primary output";
    };
    secondaryMonitor = mkOption {
      type = types.nullOr types.str;
      example = "eDP-1";
      description = "secondary output";
      default = null;
    };
    laptop = mkEnableOption "Enables laptop-specific customizations";
  };

  config = mkIf cfg.enable {
    # Supposedly this build is better for desktop users
    boot.kernelPackages = pkgs.linuxPackages_zen;

    home-manager.users.ron = { pkgs, ... }: {
      cookie = {
        polybar = {
          enable = true;
          laptop = cfg.laptop;
        };
        gtk.enable = true;
        dunst.enable = true;
        emacs.enable = true;
        keyboard.enable = true;
        redshift.enable = true;
        st.enable = true;
        nautilus.enable = true;
        i3.enable = true;
        xcursor.enable = true;
        school-schedule.enable = true;
        mpd.enable = true;
      };
      services.rsibreak.enable = true;
    };
    cookie = {
      xserver.enable = true;
      sound = {
        enable = true;
        pulse = {
          enable = mkDefault true;
          lowLatency = mkDefault false;
        };
      };
      sleep.enable = true;
      slock.enable = true;
      fonts.enable = true;
      gnome.enable = true;
      qt5.enable = true;
      chat-apps.enable = true;
    };
  };
}
