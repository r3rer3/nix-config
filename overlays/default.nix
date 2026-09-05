# This file defines overlays
{inputs, ...}: {
  # This one brings our custom packages from the 'pkgs' directory
  additions = final: _prev: import ../pkgs final.pkgs;

  # This one contains whatever you want to overlay
  # You can change versions, add patches, set compilation flags, anything really.
  # https://nixos.wiki/wiki/Overlays
  modifications = final: prev: {
    # example = prev.example.overrideAttrs (oldAttrs: rec {
    # ...
    # });

    # nixpkgs lags behind codex's release cadence; pin the CLI to the current
    # upstream release on top of nixpkgs' recipe. That recipe also pins the
    # prebuilt librusty_v8 the `v8` crate links against, so before bumping
    # check that codex-rs/Cargo.lock still wants the same `v8` version.
    # The override retires itself once nixpkgs catches up.
    codex =
      if prev.lib.versionOlder prev.codex.version "0.153.3"
      then
        prev.codex.overrideAttrs (finalAttrs: _: {
          version = "0.153.3";

          src = final.fetchFromGitHub {
            owner = "openai";
            repo = "codex";
            tag = "rust-v${finalAttrs.version}";
            hash = "sha256-JujjJx9GHcTgirqEFr9tc4Ghzx65YNOqpNCc7rtthfI=";
          };

          # buildRustPackage derives cargoDeps from the recipe's own cargoHash,
          # not from overridden attrs, so the vendored deps are replaced by hand
          cargoDeps = final.rustPlatform.fetchCargoVendor {
            inherit (finalAttrs) pname version src sourceRoot;
            hash = "sha256-GG6kOXmCdq+bZLU2ul0DIVL8lDuweayvZvXn6+bcUZw=";
          };
        })
      else prev.codex;
  };

  # When applied, the unstable nixpkgs set (declared in the flake inputs) will
  # be accessible through 'pkgs.unstable'
  unstable-packages = final: _prev: {
    unstable = import inputs.nixpkgs-unstable {
      system = final.system;
      config.allowUnfree = true;
    };
  };
}
