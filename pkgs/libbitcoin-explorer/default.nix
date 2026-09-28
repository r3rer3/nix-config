{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  boost186,
  secp256k1,
  zeromq,
}: let
  # 3.8.0 (2023) is the last release: master is the 4.x rewrite, which its own
  # README calls "not usable in its current state". nixpkgs dropped this whole
  # 3.x stack in c983d7bc802f for pinning Boost 1.75, so it is rebuilt here
  # against the newest Boost it still compiles with.
  version = "3.8.0";

  # asio's io_service, io_service::work and resolver::query, which the 3.x
  # networking code is built on, were removed in Boost 1.87
  boost = boost186;

  mkLibbitcoin = {
    pname,
    # libbitcoin/libbitcoin-{client,protocol} have been deleted from GitHub;
    # the copies kept by upstream's lead maintainer carry the same v3.8.0 tags
    # (identical hashes to the ones nixpkgs pinned)
    owner ? "libbitcoin",
    hash,
    configureFlags ? [],
    meta ? {},
    ...
  } @ args:
    stdenv.mkDerivation (removeAttrs args ["owner" "hash"]
      // {
        inherit version;

        src = fetchFromGitHub {
          inherit owner hash;
          repo = pname;
          rev = "v${version}";
        };

        nativeBuildInputs = [autoreconfHook pkg-config];

        enableParallelBuilding = true;

        configureFlags =
          [
            "--with-tests=no"
            "--with-boost=${boost.dev}"
            "--with-boost-libdir=${boost.out}/lib"
          ]
          ++ configureFlags;

        meta =
          {
            homepage = "https://libbitcoin.info/";
            # AGPL with a lesser clause
            license = lib.licenses.agpl3Plus;
            platforms = lib.platforms.linux ++ lib.platforms.darwin;
          }
          // meta;
      });

  libbitcoin-system = mkLibbitcoin {
    pname = "libbitcoin-system";
    hash = "sha256-7fxj2hnuGRUS4QSQ1w0s3looe9pMvE2U50/yhNyBMf0=";

    # Boost.Log / Boost.Interprocess API changes since 1.75, and deprecated
    # secp256k1 aliases that have since been removed (details in the patch)
    patches = [./libbitcoin-system-compat.patch];

    propagatedBuildInputs = [secp256k1];

    meta.description = "C++ library for building bitcoin applications";
  };

  libbitcoin-protocol = mkLibbitcoin {
    pname = "libbitcoin-protocol";
    owner = "evoskuil";
    hash = "sha256-xf0qQQnZ8h6ent1sgkVTo55+9drZM8Zbx0deYZnLBho=";
    propagatedBuildInputs = [libbitcoin-system zeromq];
    meta.description = "Bitcoin blockchain query protocol";
  };

  libbitcoin-client = mkLibbitcoin {
    pname = "libbitcoin-client";
    owner = "evoskuil";
    hash = "sha256-5qbxixaozHFsOcBxnuGEfNJyGL8UaYCOPwPakfc0bAg=";
    propagatedBuildInputs = [libbitcoin-protocol];
    meta.description = "Bitcoin client query library";
  };

  libbitcoin-network = mkLibbitcoin {
    pname = "libbitcoin-network";
    hash = "sha256-zDT92bvA779mzTodpKugCoxapB6vY2jCMSGZEkJLTXQ=";
    # an overload made ambiguous by newer Boost.System (details in the patch)
    patches = [./libbitcoin-network-compat.patch];
    propagatedBuildInputs = [libbitcoin-system];
    meta.description = "Bitcoin P2P network library";
  };
in
  mkLibbitcoin {
    pname = "libbitcoin-explorer";
    hash = "sha256-NUAtjrfRbZg5ewQo4PZ1HEoG8GRrsPcNb78UYMHqdyo=";

    buildInputs = [libbitcoin-client libbitcoin-network];

    configureFlags = [
      "--with-bash-completiondir=${placeholder "out"}/share/bash-completion/completions"
    ];

    passthru = {
      inherit
        libbitcoin-system
        libbitcoin-protocol
        libbitcoin-client
        libbitcoin-network
        ;
    };

    meta = {
      description = "Bitcoin command line tool";
      homepage = "https://github.com/libbitcoin/libbitcoin-explorer";
      mainProgram = "bx";
    };
  }
