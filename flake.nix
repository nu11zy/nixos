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

  inputs = {
    # NixOS official package source, using the nixos-23.11 branch here
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
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