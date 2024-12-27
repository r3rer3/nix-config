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

    config = {
      allowUnfree = true;
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

      pkgs = makePkgs system;

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

            pkgs-unstable = makePkgs {
              inherit system;
              nix-pkgs = inputs.nixpkgs-unstable;
            };

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

            pkgs-unstable = makePkgs {
              inherit system;
              nix-pkgs = inputs.nixpkgs-unstable;
            };

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
