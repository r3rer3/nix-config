{
  lib,
  stdenv,
  stdenvNoCC,
  fetchurl,
  zstd,
  installShellFiles,
  versionCheckHook,
  patchelf,
  ncurses,
}: let
  # Upstream publishes one "complete package" per target. Bump `version` and
  # every hash together; the hashes are the plain sha256 of each tarball:
  #   nix store prefetch-file --json <url> | jq -r .hash
  # https://github.com/openai/codex/releases
  targets = {
    x86_64-linux = {
      triple = "x86_64-unknown-linux-musl";
      hash = "sha256-9D+bmwubY2jdyXt31Ddpba/MrKc2ANRt9bipszyKUCo=";
    };
    aarch64-darwin = {
      triple = "aarch64-apple-darwin";
      hash = "sha256-HE8gnuV9FS/xBZ4KTP9ADck1kP815PFfFLn3Xy7kxK8=";
    };
  };

  target =
    targets.${stdenvNoCC.hostPlatform.system}
    or (throw "codex: no complete package for ${stdenvNoCC.hostPlatform.system}");

  isLinux = stdenvNoCC.hostPlatform.isLinux;
in
  stdenvNoCC.mkDerivation (finalAttrs: {
    pname = "codex";
    version = "0.157.1";

    # Why not nixpkgs' codex: since 0.157.0 the interactive CLI auto-starts a
    # shared app-server daemon, which it installs by copying the "complete
    # package" it was launched from (bin/, codex-package.json, codex-path/rg,
    # codex-resources/bwrap) into ~/.codex/packages/app-server-daemon. The
    # nixpkgs build only installs the binaries, so every `codex` launch died
    # with "this CLI has no complete local package". Shipping upstream's own
    # package keeps that layout intact. Once installed, the daemon follows
    # upstream's release channel on its own, independent of this pin.
    src = fetchurl {
      url = "https://github.com/openai/codex/releases/download/rust-v${finalAttrs.version}/codex-package-${target.triple}.tar.zst";
      inherit (target) hash;
    };

    # the tarball has no top-level directory
    sourceRoot = ".";

    nativeBuildInputs =
      [
        zstd
        installShellFiles
      ]
      ++ lib.optionals isLinux [patchelf];

    dontConfigure = true;
    dontBuild = true;

    # Keep the shipped bytes: `codex` compares a blake3 of bin/codex with the
    # running executable before installing the daemon, and verifies a
    # compile-time sha256 of codex-resources/bwrap before exec'ing it. Those
    # are static musl binaries anyway (Mach-O on Darwin).
    dontStrip = true;
    dontPatchELF = true;
    dontPatchShebangs = true;

    installPhase = ''
      runHook preInstall

      mkdir -p $out
      cp -r bin codex-package.json codex-path codex-resources $out/

      runHook postInstall
    '';

    postInstall = ''
      # `codex completion` still resolves CODEX_HOME; keep it inside the sandbox
      export HOME=$(mktemp -d)
      installShellCompletion --cmd codex \
        --bash <($out/bin/codex completion bash) \
        --fish <($out/bin/codex completion fish) \
        --zsh <($out/bin/codex completion zsh)
    '';

    # The bundled zsh backs the zsh-fork exec runtime (only used when the login
    # shell is zsh). It is the one glibc-linked executable, so give it a loader
    # and libtinfo it can find. The voice host and its gstreamer libs are left
    # as shipped; voice mode is untested on NixOS.
    postFixup = lib.optionalString isLinux ''
      patchelf \
        --set-interpreter "${stdenv.cc.bintools.dynamicLinker}" \
        --set-rpath "${lib.makeLibraryPath [ncurses stdenv.cc.libc]}" \
        $out/codex-resources/zsh/bin/zsh
      $out/codex-resources/zsh/bin/zsh --version
    '';

    doInstallCheck = true;
    nativeInstallCheckInputs = [versionCheckHook];

    meta = {
      description = "Lightweight coding agent that runs in your terminal";
      homepage = "https://github.com/openai/codex";
      changelog = "https://github.com/openai/codex/releases/tag/rust-v${finalAttrs.version}";
      license = lib.licenses.asl20;
      sourceProvenance = [lib.sourceTypes.binaryNativeCode];
      mainProgram = "codex";
      platforms = builtins.attrNames targets;
    };
  })
