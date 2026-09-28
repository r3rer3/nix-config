{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  openssl,
  # private key tools (WIF conversion, key generation, ...); off upstream by
  # default so nobody gets talked into pasting a real key into a debugger
  enableDangerous ? false,
}:
stdenv.mkDerivation {
  pname = "btcdeb";
  # upstream has no release since 0.3.20 (2020); the in-tree version string
  # (configure.ac) has been 5.0.24 since that tag was cut in 2023
  version = "5.0.24-unstable-2026-07-26";

  src = fetchFromGitHub {
    owner = "bitcoin-core";
    repo = "btcdeb";
    rev = "16bda4579960068a6f530cfac43ccf375499b5b4";
    hash = "sha256-WvHrfsLwZpfLgOk0aEuCU6zEY67zOoWJTxBGTaRa47g=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [openssl];

  configureFlags = lib.optionals enableDangerous ["--enable-dangerous"];

  enableParallelBuilding = true;

  # upstream's test runner is a plain bin_PROGRAM that reads its fixtures from
  # doc/txs relative to the cwd, so run it from the source tree and don't ship it
  doCheck = true;
  checkPhase = ''
    runHook preCheck
    ./test-btcdeb
    runHook postCheck
  '';

  postInstall = ''
    rm $out/bin/test-btcdeb
  '';

  meta = {
    description = "Bitcoin Script debugger";
    homepage = "https://github.com/bitcoin-core/btcdeb";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    mainProgram = "btcdeb";
  };
}
