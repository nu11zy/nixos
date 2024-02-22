{
  description = "NixOS flake";

  outputs = { self, nixpkgs, nixpkgs-stable, home-manager, ... }@inputs:
  let
    # ---- SYSTEM SETTINGS ---- #
    systemSettings = {
      system = "x86_64-linux";
      profile = "vm";
      hostname = "hostname";
      timezone = "Europe/Moscow";
      locale = "en_US.UTF-8";
      regionFormat = "ru_RU.UTF-8";
    };

    # ----- USER SETTINGS ----- #
    userSettings = rec {
      username = "username";
    };

    # configure pkgs
    pkgs = import nixpkgs {
      system = systemSettings.system;
      config = { allowUnfree = true; allowUnfreePredicate = (_: true); };
    };

    pkgs-stable = import nixpkgs-stable {
      system = systemSettings.system;
      config = { allowUnfree = true; allowUnfreePredicate = (_: true); };
    };

    # configure lib
    lib = nixpkgs.lib;

  in {
    homeConfigurations = {
      user = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        # path to home.nix for selected profile
        modules = [ (./. + "/profile"+("/"+systemSettings.profile)+"/home.nix") ];
        extraSpecialArgs = {
          inherit pkgs-stable;
          inherit systemSettings;
          inherit userSettings;
        };
      };
    };

    nixosConfigurations = {
      system = lib.nixosSystem {
        system = systemSettings.system;
        # path to configuration.nix for selected profile
        modules = [ (./. + "/profile"+("/"+systemSettings.profile)+"/configuration.nix") ];
        specialArgs = {
          inherit pkgs-stable;
          inherit systemSettings;
          inherit userSettings;
        };
      };
    };
  };

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable"; # unstable branch
    nixpkgs-stable.url = "nixpkgs/nixos-23.11"; # stable branch

    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };
}