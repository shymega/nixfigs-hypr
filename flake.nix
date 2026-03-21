{
  description = "@shymega's Nix Flake for their Hyprland configs";

  inputs = {
    # Core repos
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-25.11";

    # Home Environment deps
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Hyprland dependencies.
    hyprland = {
      url = "github:hyprwm/Hyprland?rev=b940b0d2c197841b0f648598ee782dbaf9e0a89b";
    };
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins?ref=v0.53.0";
      inputs.hyprland.follows = "hyprland"; # Prevents version mismatch.
    };
    split-monitor-workspaces = {
      url = "github:Duckonaut/split-monitor-workspaces?rev=7f15447980ba2e6e3c57ca268ab556eb70ef562e";
      inputs.hyprland.follows = "hyprland";
    };
    snappy-switcher.url = "github:OpalAayan/snappy-switcher";
    hy3 = {
      url = "github:outfoxxed/hy3?ref=hl0.54.2";
      inputs.hyprland.follows = "hyprland";
    };

    # Hyprland theme (W2K)
    hypr-dotw2k = {
      url = "github:shymega/hypr-dotw2k";
    };

    # Flake utils
    systems.url = "github:nix-systems/default";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    ez-configs = {
      url = "github:ehllie/ez-configs";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
    };
  };

  outputs = inputs: let
    inherit (inputs) self;
  in
    with inputs;
      flake-parts.lib.mkFlake {inherit inputs;} {
        imports = [
          ez-configs.flakeModule
        ];
        systems = import systems;

        perSystem = {
          config,
          pkgs,
          lib,
          self,
          ...
        }: {
          ezConfigs = {
            earlyModuleArgs = {
              inherit inputs;
            };
            home = {
              modulesDirectory = ./homeModules;
            };
          };
        };
      };
}
