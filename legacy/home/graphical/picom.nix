{ pkgs, ... }:

{
  services.picom = {
    enable = true;
    backend = "xrender";
    fade = true;
    fadeDelta = 5;
    inactiveOpacity = "1.0";
    opacityRule = [
      "90:class_g *?= 'Rofi'"
      "90:class_g *?= 'Dunst'"
      "id = 0x1800001" # this id is for slock "https://wiki.archlinux.org/index.php/Picom#slock"
    ];
    shadow = true;
    shadowExclude = [
      "90:class_g *?= 'Dunst'"
      "_GTK_FRAME_EXTENTS@:c"
    ];
    shadowOffsets = [ (-7) (-7) ];
    vSync = true;
  };
}