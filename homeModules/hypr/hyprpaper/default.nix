{
  pkgs,
  lib,
  inputs,
  ...
}: {
  imports = [inputs.hyprland.homeManagerModules.default];
  services.hyprpaper.enable = true;
}
