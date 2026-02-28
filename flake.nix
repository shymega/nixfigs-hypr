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
      url = "github:hyprwm/hyprnix";
    };
    split-monitor-workspaces = {
      url = "github:Duckonaut/split-monitor-workspaces?rev=1680bf943b86e373db4b770d3280cf09ee08f208";
      inputs.hyprland.follows = "hyprland"; # <- make sure this line is present for the plugin to work as intended
    };
    hy3 = {
      url = "github:outfoxxed/hy3?ref=hl0.53.0.1";
      inputs.hyprland.follows = "hyprland";
    };
    Hyprspace = {
      url = "github:KZDKM/Hyprspace";
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
