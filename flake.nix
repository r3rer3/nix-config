{
  description = "My Nix config :D";

  nixConfig = {
    substituters = [
      "https://cache.nixos.org"
    ];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";

    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    # also see the 'unstable-packages' overlay at 'overlays/default.nix'.

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: let
    builders = import ./builders.nix inputs;

    # supported systems for your flake packages, shell, etc.
    linuxSystem = "x86_64-linux";
    darwinSystem = "aarch64-darwin";

    # this is a function that generates an attribute by calling a function you
    # pass to it, with each system as an argument
    forAllSystems = nixpkgs.lib.genAttrs [linuxSystem darwinSystem];

    lib = nixpkgs.lib.extend (import ./lib);

    getUsers = hostname:
      lib.right
      (lib.filter (n:
        builtins.elem hostname
        (
          import ./users/${n} {username = n;}
        )
        .hosts))
      builtins.attrNames
      (lib.filterAttrs (_: v: v == "directory"))
      builtins.readDir
      ./users;
  in {
    # Formatter for your nix files, available through 'nix fmt'
    # Other options beside 'alejandra' include 'nixpkgs-fmt'
    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);

    # Your custom packages
    # Accessible through 'nix build', 'nix shell', etc
    packages = forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});

    # Your custom packages and modifications, exported as overlays
    overlays = import ./overlays {inherit inputs;};

    # Reusable nixos modules you might want to export
    # These are usually stuff you would upstream into nixpkgs
    nixosModules = import ./modules/nixos;

    # Reusable home-manager modules you might want to export
    # These are usually stuff you would upstream into home-manager
    homeManagerModules = import ./modules/home-manager;

    nixosConfigurations = builders.compileNixosSystems [
      rec {
        hostname = "r3rer3-linux";
        system = linuxSystem;
        users = getUsers hostname;
      }
    ];

    darwinConfigurations = builders.compileDarwinSystems [
      rec {
        hostname = "r3rer3s-MacBook-Pro";
        system = darwinSystem;
        users = getUsers hostname;
      }
    ];

    devShells = forAllSystems (system: let
      pkgs = import nixpkgs {inherit system;};
    in {
      default = pkgs.mkShell {
        packages = with pkgs; [
          # nix lsp and formatter
          alejandra

          # fennel lsp and formatter
          fennel-ls
          fnlfmt
        ];
      };
    });
  };
}
