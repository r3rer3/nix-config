{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  versionCheckHook,
}: let
  # 0.10.0 replaced the TypeScript npm package with a Rust build. The npm
  # tarball is now only a migration shim that downloads that build into
  # ~/.local at first launch, so package upstream's per-platform release
  # payload instead. Bump `version` and every hash together; SHA256SUMS on the
  # release lists them (convert with `nix-hash --to-sri --type sha256 <hex>`):
  # https://github.com/PrimeIntellect-ai/prime-agent/releases
  targets = {
    x86_64-linux = {
      platform = "linux-x64";
      hash = "sha256-wWvSr153tT9JuRSkR0LEz2pnxe1QAAQUMLeNvUw7y+w=";
    };
    aarch64-linux = {
      platform = "linux-arm64";
      hash = "sha256-88qzUwpNfKQ9vvgyG/E/Jg0boF2LXd4FcWWiC9T2dcQ=";
    };
    x86_64-darwin = {
      platform = "darwin-x64";
      hash = "sha256-r0hmtbqC80GblkKQ4/Aj3bm5mVionhbuhWliuQHsD8Y=";
    };
    aarch64-darwin = {
      platform = "darwin-arm64";
      hash = "sha256-5Bi99i/LAAJ3e/OsQ7zBNlErJnY/KrXFAHkvJuNylOU=";
    };
  };

  target =
    targets.${stdenv.hostPlatform.system}
    or (throw "prime-agent: no release payload for ${stdenv.hostPlatform.system}");
in
  stdenv.mkDerivation (finalAttrs: {
    pname = "prime-agent";
    version = "0.10.0";

    src = fetchurl {
      url = "https://github.com/PrimeIntellect-ai/prime-agent/releases/download/v${finalAttrs.version}/prime-agent-${finalAttrs.version}-${target.platform}.tar.gz";
      inherit (target) hash;
    };

    # the tarball has no top-level directory
    sourceRoot = ".";

    # glibc-linked on Linux, needing only libgcc_s beyond libc
    nativeBuildInputs = lib.optionals stdenv.isLinux [autoPatchelfHook];
    buildInputs = lib.optionals stdenv.isLinux [stdenv.cc.cc.lib];

    dontConfigure = true;
    dontBuild = true;
    # symbols are kept for upstream's crash decoder (the release's *.debug.gz)
    dontStrip = true;

    # The binary resolves prime-agent-runtime/, skills/, the bundled model and
    # MCP catalogs etc. next to its own (symlink-resolved) path, so keep the
    # payload together and mirror the installer's ~/.local layout. The Python
    # kernel is still bootstrapped on first launch into the user's data dir,
    # using uv from PATH (or offering to install it, as before).
    installPhase = ''
      runHook preInstall

      mkdir -p $out/bin $out/share
      cp -r . $out/share/prime-agent
      ln -s ../share/prime-agent/prime-agent $out/bin/prime-agent

      runHook postInstall
    '';

    doInstallCheck = true;
    nativeInstallCheckInputs = [versionCheckHook];

    meta = {
      description = "Self-improving RLM agent for coding workflows and long-running autonomous tasks";
      homepage = "https://github.com/PrimeIntellect-ai/prime-agent";
      changelog = "https://github.com/PrimeIntellect-ai/prime-agent/releases/tag/v${finalAttrs.version}";
      license = lib.licenses.mit;
      sourceProvenance = [lib.sourceTypes.binaryNativeCode];
      platforms = builtins.attrNames targets;
      mainProgram = "prime-agent";
    };
  })
