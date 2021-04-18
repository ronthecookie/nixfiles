# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.initrd.availableKernelModules =
    [ "nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/37a7ad2a-22f9-4b1b-a924-2576e99ad635";
    fsType = "ext4";
  };

  boot.initrd.luks.devices."rootfs".device =
    "/dev/disk/by-uuid/6c1f2ed3-cec7-4ffd-bed2-58292996ad6f";

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/9556-DD8F";
    fsType = "vfat";
  };

 fileSystems."/mnt/games" = {
   device = "/dev/md127";
   fsType = "ext4";
 };

  fileSystems."/mnt/backup" = {
    device = "/dev/disk/by-uuid/08f2ac6c-3564-4110-a436-fed882a9f4e8";
    fsType = "ext4";
  };

  swapDevices = [ ];

}
