{ pkgs, ... }:

let
  myAliases = {
    cat = "bat";
  };

in {
  programs.bash = {
    enable = true;
    enableCompletion = true;
    shellAliases = myAliases;
  };

  home.packages = with pkgs; [
    bat
  ];
}