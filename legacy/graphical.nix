{ config, pkgs, ... }:

{
  imports =
    [ ./graphical/slock.nix ./graphical/fonts.nix ./graphical/scrolling.nix ];

  home-manager.users.ron = { pkgs, ... }: {
    imports = [
      ./home/graphical/xsession.nix
      ./home/graphical/xcursor.nix
      ./home/graphical/layout.nix
      ./home/graphical/redshift.nix
      ./home/graphical/nautilus.nix
      # ./home/graphical/picom.nix
      ./home/kitty.nix
      ./home/doom.nix
    ];
  };
  services.xserver = {
    enable = true;
    libinput.enable = true;
    desktopManager.xterm.enable =
      true; # this somehow makes home-manager's stuff run
  };

  # gnome apps are weird
  programs.dconf.enable = true;
  environment.systemPackages = with pkgs; [
    gnome3.adwaita-icon-theme
    gnomeExtensions.appindicator
  ];
  services.udev.packages = with pkgs; [ gnome3.gnome-settings-daemon ];
}
