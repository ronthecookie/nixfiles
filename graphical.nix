{ config, pkgs, ... }:

{
  imports =
    [ ./slock.nix ];

  sound.enable = true;
  hardware.pulseaudio.enable = true;

  services.xserver.enable = true;
  services.xserver.windowManager.i3 = {
    enable = true;
    package = pkgs.i3-gaps;
    extraPackages = with pkgs; [
      i3blocks
      brightnessctl
      rofi
      dunst
      gnome3.gnome-screenshot
      picom
      redshift
      kdeconnect
      libnotify # notify-send
      xclip
      networkmanagerapplet
      sysstat
      feh
      # apps
      pavucontrol
      kitty
      gnome3.nautilus
    ];
  };

  services.xserver.layout = "us,il";
  services.xserver.xkbOptions = "grp:win_space_toggle";
  services.xserver.libinput.enable = true;
  services.xserver.libinput.naturalScrolling = true;
  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.displayManager.sessionCommands =
    "sh -c '${pkgs.xorg.xmodmap}/bin/xmodmap /home/ron/dots/xorg/.local/share/layouts/caps*'";
  services.xserver.config = ''
    Section "InputClass"
      Identifier     "Enable NatrualScrolling for TrackPoint"
      Driver "libinput"
      MatchIsPointer "on"
      Option "NaturalScrolling" "true"
    EndSection
  '';
  # services.xserver.displayManager.lightdm.greeters.gtk.iconTheme = {
  #   package = pkgs.paper-icon-theme;
  #   name = "Paper";
  # };


  fonts = {
    enableDefaultFonts = true;
    fonts = with pkgs; [
      cantarell-fonts
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      liberation_ttf
      nerdfonts
      hack-font
      ubuntu_font_family
    ];
    fontconfig.defaultFonts.monospace = [ "Hack" ];
  };

}
