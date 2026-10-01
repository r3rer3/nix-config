{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "libtexprintf";
  version = "1.31";

  src = fetchFromGitHub {
    owner = "bartp5";
    repo = "libtexprintf";
    tag = "v${finalAttrs.version}";
    hash = "sha256-OXDcohfSfik0H1MpoznN267OVTYkW75N+TIF6lRRvZ0=";
  };

  nativeBuildInputs = [autoreconfHook];

  enableParallelBuilding = true;

  # the test scripts are #!/bin/bash and run the freshly built utftex
  postPatch = ''
    patchShebangs *.sh src/*.sh
  '';

  doCheck = true;
  # every test script works on the same ref/tmp/out scratch files in test/,
  # so running them concurrently makes them clobber each other
  enableParallelChecking = false;

  meta = {
    description = "Formatted output with tex-like syntax support (provides utftex, a LaTeX to unicode renderer)";
    homepage = "https://github.com/bartp5/libtexprintf";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.unix;
    mainProgram = "utftex";
  };
})
