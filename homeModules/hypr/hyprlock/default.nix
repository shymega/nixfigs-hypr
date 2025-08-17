{
  pkgs,
  lib,
  inputs,
  ...
}: {
  imports = [inputs.hyprland.homeManagerModules.default];
  programs.hyprlock = {
    enable = true;
  };
}
