{
  lib,
  stdenv,
  buildNpmPackage,
  fetchurl,
  autoPatchelfHook,
}:
buildNpmPackage rec {
  pname = "prime-agent";
  version = "0.9.1";

  src = fetchurl {
    url = "https://github.com/PrimeIntellect-ai/prime-agent/releases/download/v${version}/prime-agent-${version}.tgz";
    hash = "sha256-VzvODNAE/GIFLpqSQImUG385Jmq3HmapTIWh+dNYNbo=";
  };

  # The release tarball ships no lockfile; this one was generated against it
  # with `npm install --package-lock-only --ignore-scripts`. Regenerate it and
  # npmDepsHash on every version bump.
  postPatch = ''
    cp ${./package-lock.json} package-lock.json
  '';

  npmDepsHash = "sha256-VMikXrDY1uQS9wL9UJGNN5xpVPkaCoakNdbGTSlbNYk=";

  # dist/ is prebuilt; postinstall only bootstraps the Python kernel runtime,
  # which prime-agent re-runs on demand at first launch (into ~/.prime-agent)
  dontNpmBuild = true;
  npmFlags = ["--ignore-scripts"];

  # koffi ships prebuilt addon.node binaries that need patching on NixOS
  nativeBuildInputs = lib.optionals stdenv.isLinux [autoPatchelfHook];
  buildInputs = lib.optionals stdenv.isLinux [stdenv.cc.cc.lib];

  # prebuilds for other OSes/libcs are dead weight and unresolvable for
  # autoPatchelf; the loaders pick the build for the running platform anyway
  postInstall = lib.optionalString stdenv.isLinux ''
    rm -rf $out/lib/node_modules/prime-agent/node_modules/koffi/build/koffi/{openbsd,freebsd,musl,win32,darwin}_*
  '';

  meta = {
    description = "Self-improving RLM agent for coding workflows and long-running autonomous tasks";
    homepage = "https://github.com/PrimeIntellect-ai/prime-agent";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    mainProgram = "prime-agent";
  };
}
