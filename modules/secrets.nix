{ pkgs, config, lib, ... }:

# Copyright (c) 2020 Christine Dodrill <me@christine.website>

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
with lib;

let
  cfg = config.cookie.secrets;

  secret = types.submodule {
    options = {
      source = mkOption {
        type = types.path;
        description = "local secret path";
      };

      dest = mkOption {
        type = types.str;
        description = "where to write the decrypted secret to";
      };

      owner = mkOption {
        default = "root";
        type = types.str;
        description = "who should own the secret";
      };

      group = mkOption {
        default = "root";
        type = types.str;
        description = "what group should own the secret";
      };

      permissions = mkOption {
        example = "0400";
        type = types.str;
        description = "Permissions expressed as octal.";
      };
    };
  };

  metadata = lib.importTOML ../ext/metadata.toml;

  mkSecretOnDisk = name:
    { source, ... }:
    pkgs.stdenv.mkDerivation {
      name = "${name}-secret";
      phases = "installPhase";
      buildInputs = [ pkgs.rage ];
      installPhase =
        let key = metadata.hosts."${config.networking.hostName}".ssh_pubkey;
        in ''
          rage -a -r '${key}' -o "$out" '${source}'
        '';
    };

  mkService = name:
    { source, dest, owner, group, permissions, ... }: {
      description = "decrypt secret for ${name}";
      wantedBy = [ "multi-user.target" ];

      serviceConfig.Type = "oneshot";

      script = with pkgs; ''
        rm -rf ${dest}
        "${rage}"/bin/rage -d -i /etc/ssh/ssh_host_ed25519_key -o '${dest}' '${
          mkSecretOnDisk name { inherit source; }
        }'

        chown '${owner}':'${group}' '${dest}'
        chmod '${permissions}' '${dest}'
      '';
    };
in {
  options.cookie.secrets = mkOption {
    type = types.attrsOf secret;
    description = "secret configuration";
    default = { };
  };

  # options.cookie.lib.secrets = {
  #   secretType =
  #     mkOption { description = "the type used for secret declarations"; };
  # };

  # config.cookie.lib.secrets = { secretType = secret; };

  config.systemd.services = let
    units = mapAttrs' (name: info: {
      name = "${name}-key";
      value = (mkService name info);
    }) cfg;
  in units;
}
