{ lib, config, pkgs, ... }:

let
  cfg = config.cookie.services.minecraft;
  paper = pkgs.minecraft-server.overrideAttrs (oldAttrs: {
    src = pkgs.fetchurl {
      url = let
        build = 100;
        mc = "1.17.1";
      in "https://papermc.io/api/v2/projects/paper/versions/${mc}/builds/${
        toString build
      }/downloads/paper-${mc}-${toString build}.jar";
      sha256 = "sha256-pucvSPELrff+2moxJgrqI2ks9mw9gd0KOAMq65N2DvM=";
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
      jvmOpts =
        "-Xms3G -Xmx3G -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 -Dusing.aikars.flags=https://mcflags.emc.gs -Daikars.new.flags=true";
    };

    # We need a separate unit so we can use root privileges for this
    systemd.services.minecraft-server-perms = {
      description = "Setup permissions for /var/lib/minecraft";
      script = "true";
      postStart = ''
        ${pkgs.coreutils}/bin/mkdir /home/ckie/minecraft
        ${pkgs.bindfs}/bin/bindfs --create-for-user=minecraft --create-with-perms=0700 -u ckie -g users -p 0600,u+X /var/lib/minecraft /home/ckie/minecraft
      '';
      wantedBy = [ "minecraft-server.service" ];
    };

    environment.systemPackages = [ console ];
  };
}
