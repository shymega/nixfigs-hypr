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
      url = "github:hyprwm/Hyprland?ref=v0.53.1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins?ref=v0.52.0";
      inputs.hyprland.follows = "hyprland";
    };
    split-monitor-workspaces = {
      url = "github:Duckonaut/split-monitor-workspaces?rev=8f0c875a5ba9864b1267e74e6f03533d18c2bca0";
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
              inherit inputs self;
            };
            home = {
              modulesDirectory = ./homeModules;
            };
          };
        };
      };
}
