{ lib, config, pkgs, ... }:

let cfg = config.cookie.services.matrix;

in with lib; {
  options.cookie.services.matrix = {
    enable = mkEnableOption "Enables the Matrix service using Synapse";
    host = mkOption {
      type = types.str;
      default = "localhost";
      description = "The user-facing host";
      example = "ckie.dev";
    };
    serviceHost = mkOption {
      type = types.str;
      default = "matrix.localhost";
      description = "The reverse-proxied host";
      example = "matrix.ckie.dev";
    };
  };

  config = mkIf cfg.enable {
    services.nginx.virtualHosts = {
      ${cfg.host} = {

        locations."= /.well-known/matrix/server".extraConfig = let
          # use 443 instead of the default 8448 port to unite
          # the client-server and server-server port for simplicity
          server = { "m.server" = "${cfg.serviceHost}:443"; };
        in ''
          add_header Content-Type application/json;
          return 200 '${builtins.toJSON server}';
        '';
      };
      ${cfg.serviceHost} = {
        locations."/".extraConfig = ''
          return 302 $scheme://${cfg.host}$request_uri;
        '';

        # forward all Matrix API calls to synapse
        locations."/_matrix" = {
          proxyPass = "http://[::1]:8008"; # without a trailing /
        };
      };
    };
    services.matrix-synapse = {
      enable = true;
      server_name = cfg.host;
      public_baseurl = "https://${cfg.serviceHost}/";
      database_type = "sqlite3";
      listeners = [{
        port = 8008;
        bind_address = "::1";
        type = "http";
        tls = false;
        x_forwarded = true;
        resources = [{
          names = [ "client" "federation" ];
          compress = false;
        }];
      }];
    };
  };
}
