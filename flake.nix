{
  description = "@shymega's Nix Flake for their Hyprland configs";

  inputs = {
    # Core repos
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-26.05";

    # Home Environment deps
    home-manager = {
      url = "github:nix-community/home-manager?ref=release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Hyprland dependencies.
    hyprnix = {
      url = "github:hyprwm/hyprnix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.systems.follows = "systems";
    };
    hyprland.follows = "hyprnix/hyprland";
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins?ref=v0.55.0";
      inputs.hyprland.follows = "hyprland"; # Prevents version mismatch.
    };
    split-monitor-workspaces = {
      url = "github:Duckonaut/split-monitor-workspaces?rev=3aeb50c7fba3141590529b3f1a19dd80d1e77925";
      inputs.hyprland.follows = "hyprland";
    };
    snappy-switcher = {
      url = "github:OpalAayan/snappy-switcher";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixfigs-wallpapers = {
      url = "github:shymega/nixfigs-wallpapers";
      flake = false;
    };

    # Hyprland theme (W2K)
    hypr-dotw2k = {
      url = "github:shymega/hypr-dotw2k";
      inputs.hyprnix.follows = "hyprnix";
    
      inputs.home-manager.follows = "home-manager";
      inputs.hyprland-plugins.follows = "hyprland-plugins";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.snappy-switcher.follows = "snappy-switcher";
    };

    # Flake utils
    systems.url = "github:nix-systems/triplet";
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
