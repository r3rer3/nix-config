# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example'
pkgs: {
  # example = pkgs.callPackage ./example { };
  btcdeb = pkgs.callPackage ./btcdeb {};
  chatgpt = pkgs.callPackage ./chatgpt {};
  claude-desktop = pkgs.callPackage ./claude-desktop {};
  codex = pkgs.callPackage ./codex {};
  grok-bot = pkgs.callPackage ./grok-bot {};
  libbitcoin-explorer = pkgs.callPackage ./libbitcoin-explorer {};
  prime-agent = pkgs.callPackage ./prime-agent {};
  fhs-env = (
    let
      base = pkgs.appimageTools.defaultFhsEnvArgs;
    in
      pkgs.buildFHSEnv (base
        // {
          name = "fhs-env";
          targetPkgs = pkgs: (
            (base.targetPkgs pkgs)
            ++ (with pkgs; [
              pkg-config
              ncurses
            ])
          );
          profile = "export FHS=1";
          runScript = "bash";
          extraOutputsToInstall = ["dev"];
        })
  );
}
