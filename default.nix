{ config, pkgs, ... }:

{
  imports = [ ./modules ];
  nixpkgs = { config = { allowUnfree = true; }; };

  time.timeZone = "Israel";

  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.supportedFilesystems = [ "ntfs" ];
  boot.tmpOnTmpfs = true; # Duh.

  networking.networkmanager.enable = true;

  users.users.ckie = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
    openssh.authorizedKeys.keys = [ (builtins.readFile ./ext/id_rsa.pub) ];
    initialPassword = "cookie";
  };

  # Nasty obscure EBUSY errors will come without this
  security.pam.loginLimits = [{
    domain = "*";
    type = "soft";
    item = "nofile"; # max FD count
    value = "unlimited";
  }];

  # Some bare basics
  environment.systemPackages = with pkgs; [
    wget
    vim
    tree
    neofetch
    git
    killall
    htop
    file
    inetutils
    binutils-unwrapped
    pciutils
    usbutils
    dig
    asciinema
    ripgrep
  ];

  cookie = {
    # Daemons
    services.ssh.enable = true;
    # Etc
    git.enable = true;
    binaryCaches.enable = true;
    nix-path.enable = true;
    cookie-overlay.enable = true;
    ipban.enable = true;
  };

  home-manager.users.ckie = { pkgs, ... }: {
    cookie = {
      bash.enable = true;
      nixpkgs-config.enable = true;
    };
  };
}
