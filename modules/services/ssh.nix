{ lib, config, pkgs, ... }:

let cfg = config.cookie.services.ssh;

in with lib; {
  options.cookie.services.ssh = {
    enable = mkEnableOption "Enables the OpenSSH daemon and Mosh";
  };

  config = mkIf cfg.enable {
    services.openssh = {
      enable = true;
      forwardX11 = true;
      permitRootLogin = "no";
      passwordAuthentication = false;
    };
    services.fail2ban = mkIf config.networking.firewall.enable {
      enable = true;
      maxretry = 1;
    };

    environment.systemPackages = with pkgs; [ mosh ];
    # Mosh ports
    networking.firewall.allowedUDPPortRanges = [{
      from = 60000;
      to = 61000;
    }];
  };
}
