{
  pkgs,
  lib,
  osConfig ? {},
  inputs,
  ...
}: let
  cfg = config.nixfigs.gui.hyprland.hyprlock;
  enabled = cfg.enabled && lib.checkRole "workstation" osConfig;
in {
  imports = [inputs.hyprland.homeManagerModules.default];
  programs.hyprlock = {
    enable = true;
    package = pkgs.unstable.hyprlock;
  };
}
