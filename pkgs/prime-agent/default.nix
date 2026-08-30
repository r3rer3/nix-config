{
  lib,
  stdenv,
  buildNpmPackage,
  fetchurl,
  autoPatchelfHook,
}:
buildNpmPackage rec {
  pname = "prime-agent";
  version = "0.8.1";

  src = fetchurl {
    url = "https://github.com/PrimeIntellect-ai/prime-agent/releases/download/v${version}/prime-agent-${version}.tgz";
    hash = "sha256-RsJNsXgt0xrcNdXGy8x1Vk+rps7TvyzPA9g27ncTRHU=";
  };

  # The release tarball ships no lockfile; this one was generated against it
  # with `npm install --package-lock-only --ignore-scripts`. Regenerate it and
  # npmDepsHash on every version bump.
  postPatch = ''
    cp ${./package-lock.json} package-lock.json
  '';

  npmDepsHash = "sha256-R9Iiz93xhqzSF/cofV4vpzxsBzmalsvx09QlDW2lBew=";

  # dist/ is prebuilt; postinstall only bootstraps the Python kernel runtime,
  # which prime-agent re-runs on demand at first launch (into ~/.prime-agent)
  dontNpmBuild = true;
  npmFlags = ["--ignore-scripts"];

  # zeromq/koffi ship prebuilt addon.node binaries that need patching on NixOS
  nativeBuildInputs = lib.optionals stdenv.isLinux [autoPatchelfHook];
  buildInputs = lib.optionals stdenv.isLinux [stdenv.cc.cc.lib];

  # prebuilds for other OSes/libcs are dead weight and unresolvable for
  # autoPatchelf; the loaders pick the build for the running platform anyway
  postInstall = lib.optionalString stdenv.isLinux ''
    mods=$out/lib/node_modules/prime-agent/node_modules
    rm -rf $mods/koffi/build/koffi/{openbsd,freebsd,musl,win32,darwin}_* \
      $mods/zeromq/build/{darwin,win32} \
      $mods/zeromq/build/linux/*/node/musl-*
  '';

  meta = {
    description = "Self-improving RLM agent for coding workflows and long-running autonomous tasks";
    homepage = "https://github.com/PrimeIntellect-ai/prime-agent";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    mainProgram = "prime-agent";
  };
}
