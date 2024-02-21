{ lib, pkgs, systemSettings, userSettings, ... }:

{
  imports = [
    ../../hardware-configuration.nix
  ];

  # ensure nix flakes are enabled
  nix.package = pkgs.nixFlakes;
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  # allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  # Networking
  networking.hostName = systemSettings.hostname;
  networking.networkmanager.enable = true;

  # Timezone and locale
  time.timeZone = systemSettings.timezone;
  i18n.defaultLocale = systemSettings.locale;
  i18n.extraLocaleSettings = {
    LC_ADDRESS = systemSettings.regionFormat;
    LC_IDENTIFICATION = systemSettings.regionFormat;
    LC_MEASUREMENT = systemSettings.regionFormat;
    LC_MONETARY = systemSettings.regionFormat;
    LC_NAME = systemSettings.regionFormat;
    LC_NUMERIC = systemSettings.regionFormat;
    LC_PAPER = systemSettings.regionFormat;
    LC_TELEPHONE = systemSettings.regionFormat;
    LC_TIME = systemSettings.regionFormat;
  };

  # User account
  users.users.${userSettings.username} = {
    isNormalUser = true;
    description = userSettings.username;
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
    uid = 1000;
  };

  # System packages
  environment.systemPackages = with pkgs; [
    git
  ];

  # Default shell (bash)
  environment.shells = with pkgs; [ bash ];
  users.defaultUserShell = pkgs.bash;

  # Version
  system.stateVersion = "22.11";
}