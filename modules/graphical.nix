{ config, pkgs, ... }:

{
  imports =
    [ ./graphical/slock.nix ./graphical/fonts.nix ./graphical/scrolling.nix ];

  home-manager.users.ron = { pkgs, ... }: {
    imports = [
      ./home/graphical/xsession.nix
      ./home/graphical/xcursor.nix
      ./home/graphical/layout.nix
    ];
  };
  sound.enable = true;
  hardware.pulseaudio.enable = true;
  services.xserver = {
    enable = true;
    libinput.enable = true;
    desktopManager.xterm.enable =
      true; # this somehow makes home-manager's stuff run
  };

}
