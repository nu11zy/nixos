{ pkgs, userSettings, ... }:

{
  home.username = userSettings.username;
  home.homeDirectory = "/home/"+userSettings.username;

  programs.home-manager.enable = true;

  imports = [
    # ../../user/shell/sh.nix
  ];

  home.stateVersion = "22.11";

  home.packages = with pkgs; [
    neofetch
  ];
}