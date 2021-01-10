{ config, pkgs, ... }:

{
  imports = [
    ./graphical/slock.nix
    ./graphical/layout.nix
    ./graphical/fonts.nix
    ./graphical/scrolling.nix
  ];

  services.xserver.enable = true;
  sound.enable = true;
  hardware.pulseaudio.enable = true;
  services.xserver.libinput.enable = true;
  services.xserver.windowManager.i3 = {
    enable = true;
    package = pkgs.i3-gaps;
    extraPackages = with pkgs; [
      i3blocks
      acpi # util for i3blocks battery info
      brightnessctl
      rofi
      dunst
      gnome3.gnome-screenshot
      gnome3.gnome-calculator
      picom
      redshift
      kdeconnect
      libnotify # notify-send
      xclip
      networkmanagerapplet
      sysstat
      feh
      xorg.xkill # if shit gets stuck
      # apps
      pavucontrol
      gnome3.nautilus
    ];
  };

  # services.xserver.displayManager.lightdm.enable = true;
  services.xserver.displayManager.defaultSession = "none+i3";

  home-manager.users.ron = (import ./home/i3.nix);
}
