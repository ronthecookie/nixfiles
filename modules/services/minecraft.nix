{ lib, config, pkgs, ... }:

let
  cfg = config.cookie.services.minecraft;
  paper = pkgs.minecraft-server.overrideAttrs (oldAttrs: {
    src = pkgs.fetchurl {
      url =
        "https://papermc.io/api/v2/projects/paper/versions/1.16.5/builds/753/downloads/paper-1.16.5-753.jar";
      sha256 = "19pcz9cdwnnb4g645pkjfcskxmr8wcrkzyvq6a30af7yd4gjw102";
    };
  });
  console = pkgs.writeShellScriptBin "mc" ''
    ${pkgs.mcrcon}/bin/mcrcon localhost -p minecraft "$@"
  '';
in with lib; {
  options.cookie.services.minecraft = {
    enable = mkEnableOption "Enables the Minecraft server service";
  };

  config = mkIf cfg.enable {
    services.minecraft-server = {
      enable = true;
      eula = true;
      openFirewall = true;
      package = paper;
    };

    users = {
      groups.minecraft = { };
      users = {
        ckie.extraGroups =
          [ "minecraft" ]; # I need to have read-write for /var/lib/minecraft
        minecraft.group = "minecraft";
      };
    };
    # We need a separate unit so we can use root privileges for this
    systemd.services.minecraft-server-perms = {
      description = "Setup permissions for /var/lib/minecraft";
      script = ''
        ${pkgs.coreutils}/bin/chmod -R 2777 /var/lib/minecraft
        ${pkgs.coreutils}/bin/chown -R minecraft:minecraft /var/lib/minecraft
      '';
      after = [ "minecraft-server.service" ];
    };

    environment.systemPackages = [ console ];
  };
}
