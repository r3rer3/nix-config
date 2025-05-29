{
  self,
  nixpkgs,
  ...
} @ inputs: let
  inherit (lib.attrsets) nameValuePair;
  inherit (inputs) nix-darwin;

  lib = nixpkgs.lib.extend (import ./lib);

  makePkgs = {
    system,
    nix-pkgs ? nixpkgs,
  }: (import nix-pkgs {
    inherit system;

    overlays = let
      outputs = self.outputs;
    in [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages

      # You can also add overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];

    config = {
      allowUnfree = true;
      allowBroken = true;
    };
  });
in rec {
  toPartialNixosConfig = {
    hostname,
    system,
    users ? [],
  }:
    nameValuePair
    hostname
    (lib.nixosSystem rec {
      inherit system;

      pkgs = makePkgs {inherit system;};

      specialArgs = {
        inherit inputs users;
        hostPlatform = system;
      };

      modules = [
        ./hosts/${hostname}/configuration.nix
        inputs.home-manager.nixosModules.home-manager
        {
          home-manager.users =
            lib.genAttrs
            users
            (user:
              (
                import ./users/${user} {username = user;}
              )
              .home);

          home-manager.extraSpecialArgs = {
            inherit inputs;
            outputs = self.outputs;

            inherit pkgs;

            pkgs-unstable = makePkgs {
              inherit system;
              nix-pkgs = inputs.nixpkgs-unstable;
            };

            pkgs-mozilla = inputs.nixpkgs-mozilla.packages;

            mcphub-nvim = inputs.mcphub-nvim.packages;
            mcphub = inputs.mcphub.packages;

            lib = pkgs.lib.extend (_: _: inputs.home-manager.lib);
          };
        }
      ];
    });

  toPartialDarwinConfig = {
    hostname,
    system ? "aarch64-darwin",
    users ? [],
  }:
    nameValuePair
    hostname
    (nix-darwin.lib.darwinSystem rec {
      inherit system;

      pkgs = makePkgs {inherit system;};

      specialArgs = {
        inherit self inputs users;
        hostPlatform = system;
      };

      modules = [
        ./hosts/${hostname}/configuration.nix
        inputs.home-manager.darwinModules.home-manager
        {
          home-manager.users =
            lib.genAttrs
            users
            (user:
              (
                import ./users/${user} {username = user;}
              )
              .home);

          home-manager.extraSpecialArgs = {
            inherit inputs;
            outputs = self.outputs;

            pkgs = makePkgs {inherit system;};
            pkgs-unstable = makePkgs {
              inherit system;
              nix-pkgs = inputs.nixpkgs-unstable;
            };

            mcphub-nvim = inputs.mcphub-nvim.packages;
            mcphub = inputs.mcphub.packages;

            lib = pkgs.lib.extend (_: _: inputs.home-manager.lib);
          };
        }
      ];
    });

  compileSystems = toPartialConfiguration:
    lib.right builtins.listToAttrs (map toPartialConfiguration);

  compileDarwinSystems = compileSystems toPartialDarwinConfig;
  compileNixosSystems = compileSystems toPartialNixosConfig;
}
