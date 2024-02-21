{
  description = "NixOS flake";

  # ---- SYSTEM SETTINGS ---- #
  systemSettings = {
    system = "x86_64-linux";
    profile = "vm";
    hostname = "hostname";
    timezone = "Europe/Moscow";
    locale = "en_US.UTF-8";
  };

  # ----- USER SETTINGS ----- #
  userSettings = rec {
    username = "username";
  };

  # configure pkgs
  pkgs-unstable = import nixpkgs-unstable {
    system = systemSettings.system;
    config = {allowUnfree = true; allowUnfreePredicate = (_: true);};
  };

  # configure lib
  lib = nixpkgs.lib;

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-23.11"; # stable branch
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable"; # unstable branch
  };

  outputs = { self, nixpkgs, ... }@inputs: {
    # Please replace nixos with your hostname
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      
      modules = [
        # Import the previous configuration.nix we used,
        # so the old configuration file still takes effect
        ./configuration.nix
      ];
    };
  };
}