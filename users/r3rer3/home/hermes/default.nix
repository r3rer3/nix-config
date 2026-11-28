{
  inputs,
  config,
  lib,
  pkgs,
  ...
}: let
  # On macOS pnpm leaves an empty v11/links in the store it fetches, so the
  # archive misses upstream's (Linux-computed) nix/pnpm-deps-hash and every
  # frontend fails to build: NousResearch/hermes-agent#150713. This is the fix
  # from the still-open PR #150967; drop it once that is merged and locked.
  # hermes-agent.nix builds the pnpm store through `callPackage ./lib.nix`, so
  # the fetcher is only reachable by wrapping callPackage.
  darwinPackage = inputs.hermes-agent.packages.${pkgs.stdenv.hostPlatform.system}.default.override (prev: let
    inherit (prev.callPackage ({fetchPnpmDeps}: {inherit fetchPnpmDeps;}) {}) fetchPnpmDeps;
  in {
    callPackage = fn: args:
      prev.callPackage fn (args
        // lib.optionalAttrs (builtins.isPath fn && baseNameOf fn == "lib.nix") {
          fetchPnpmDeps = fetchArgs:
            fetchPnpmDeps (fetchArgs
              // {
                # rmdir keeps the directory if it is ever non-empty
                preFixup = ''
                  rmdir "$storePath/v11/links" 2>/dev/null || true
                '';
              });
        });
  });
in {
  imports = [inputs.hermes-agent.homeManagerModules.default];

  services.hermes-agent = {
    enable = true;

    package = lib.mkIf pkgs.stdenv.isDarwin darwinPackage;

    # Managed mode: `hermes setup` and `hermes config set` are blocked, so all
    # configuration lives here and is rendered to ~/.hermes/config.yaml.
    settings = {
      # OpenRouter model id; set settings.model.base_url to use a provider directly.
      model.default = "meta/muse-spark-1.3";
    };

    # Secrets stay out of the Nix store. Create the file before enabling:
    #   install -m 0600 /dev/null ~/.secrets/hermes.env
    #   echo "OPENROUTER_API_KEY=sk-or-..." >> ~/.secrets/hermes.env
    environmentFiles = ["${config.home.homeDirectory}/.secrets/hermes.env"];

    # Messaging gateway (Telegram, Discord, Slack, ...) as a user service.
    # Only useful once environmentFiles provides the platform tokens.
    # On Linux also set `users.users.r3rer3.linger = true;` at the host level,
    # or the service stops at logout.
    # gateway.enable = true;
  };

  # hermes CLI on PATH + HERMES_HOME exported for the session
  programs.hermes-agent.enable = true;
}
