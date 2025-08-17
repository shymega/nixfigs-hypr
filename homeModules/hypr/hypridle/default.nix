{
  pkgs ? inputs.nixpkgs.legacyPackages.x86_64-linux,
  inputs,
  ...
}: {
  imports = [inputs.hyprland.homeManagerModules.default];
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "pidof hyprland || ${pkgs.hyprlock}/bin/hyprlock --immediate";
        on_lock_cmd = "hyprctl dispatch dpms off";
        on_unlock_cmd = "hyprctl dispatch dpms on";
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = "hyprctl dispatch dpms on";
      };
      listener = [
        {
          timeout = 300;
          on-timeout = "loginctl lock-session";
        }
      ];
    };
  };
}
