{
  lib,
  stdenv,
  fetchurl,
  asar,
  dpkg,
  autoPatchelfHook,
  makeShellWrapper,
  wrapGAppsHook3,
  alsa-lib,
  at-spi2-atk,
  at-spi2-core,
  atk,
  cairo,
  cups,
  dbus,
  expat,
  gdk-pixbuf,
  glib,
  gtk3,
  libdrm,
  libgbm,
  libGL,
  libnotify,
  libsecret,
  libxkbcommon,
  libcap_ng,
  libseccomp,
  nspr,
  nss,
  pango,
  pipewire,
  systemd,
  vulkan-loader,
  libx11,
  libxcb,
  libxcomposite,
  libxdamage,
  libxext,
  libxfixes,
  libxrandr,
}:
stdenv.mkDerivation rec {
  pname = "claude-desktop";
  version = "5.1231.2";

  # Anthropic only ships amd64/arm64 .deb packages; bump the version together
  # with the hash from the apt index:
  # https://downloads.claude.ai/claude-desktop/apt/stable/dists/stable/main/binary-amd64/Packages
  src = fetchurl {
    url = "https://downloads.claude.ai/claude-desktop/apt/stable/pool/main/c/claude-desktop/claude-desktop_${version}_amd64.deb";
    hash = "sha256-600Wya/wppY2bYhyj3T6VRNr58/ePB/jWvQGK0WVW28=";
  };

  nativeBuildInputs = [
    asar
    dpkg
    autoPatchelfHook
    makeShellWrapper
    wrapGAppsHook3
  ];

  buildInputs = [
    alsa-lib
    at-spi2-atk
    at-spi2-core
    atk
    cairo
    cups
    dbus
    expat
    gdk-pixbuf
    glib
    gtk3
    libdrm
    libgbm
    libxkbcommon
    libcap_ng
    libseccomp
    nspr
    nss
    pango
    # linked (DT_NEEDED) by the bundled claude-native-binding.node
    pipewire
    stdenv.cc.cc.lib
    libx11
    libxcb
    libxcomposite
    libxdamage
    libxext
    libxfixes
    libxrandr
  ];

  # dlopen'd at runtime, not in DT_NEEDED
  runtimeDependencies = [
    libGL
    libnotify
    libsecret
    systemd
    vulkan-loader
  ];

  dontConfigure = true;
  dontBuild = true;
  dontWrapGApps = true;

  unpackPhase = ''
    runHook preUnpack
    # plain `dpkg-deb -x` fails on the setuid chrome-sandbox in the nix sandbox
    dpkg-deb --fsys-tarfile $src | tar -x --no-same-permissions --no-same-owner
    runHook postUnpack
  '';

  # At startup the app narrows its own PATH to root-owned system directories
  # (/usr/bin, /bin, ..., /run/current-system/sw/bin), so nothing it spawns can
  # be shadowed from a user-writable directory. Every child inherits that PATH,
  # including the xdg-open behind shell.openExternal. Under Plasma xdg-open
  # hands the URL to KIO, which resolves the default browser's bare
  # `Exec=librewolf` in that PATH, but home-manager installs into ~/.nix-profile,
  # so the login page never opened ("Could not find the program 'librewolf'").
  # Append NixOS's per-user and default profiles to that list, after the system
  # directories so those still win. The list is duplicated in two bundles.
  # Only the *.node files and github-mcp-server live in app.asar.unpacked. The
  # diff makes sure the repack leaves exactly those out of the archive, and
  # upstream's copy is kept since asar drops github-mcp-server's exec bit.
  postPatch = ''
    resources=usr/lib/claude-desktop/resources
    asar extract $resources/app.asar app
    bundles=$(grep -rlF '"/run/current-system/profile/bin"]' app/.vite/build) ||
      { echo "claude-desktop: PATH allowlist not found, see postPatch"; exit 1; }
    substituteInPlace $bundles --replace-fail \
      '"/run/current-system/profile/bin"]' \
      '"/run/current-system/profile/bin",...((h,u)=>[h&&h+"/.nix-profile/bin",h&&h+"/.local/state/nix/profile/bin",u&&"/etc/profiles/per-user/"+u+"/bin","/nix/var/nix/profiles/default/bin"])(process.env.HOME,process.env.USER).filter(p=>p&&p.startsWith("/"))]'
    asar pack app app.asar --unpack '{*.node,github-mcp-server}'
    diff -r $resources/app.asar.unpacked app.asar.unpacked
    mv app.asar $resources/app.asar
    rm -rf app app.asar.unpacked
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/lib $out/share
    cp -r usr/lib/claude-desktop $out/lib/claude-desktop
    cp -r usr/share/applications usr/share/icons $out/share/

    # The claude:// login callback is spawned via this desktop file by the
    # browser, whose process may have no usable PATH (LibreWolf under Plasma
    # runs without one), so the bare `Exec=claude-desktop` never resolves.
    substituteInPlace $out/share/applications/*.desktop \
      --replace-fail "Exec=claude-desktop" "Exec=$out/bin/claude-desktop"

    runHook postInstall
  '';

  # wrapGAppsHook3 propagates makeBinaryWrapper, whose setup hook redefines the
  # `makeWrapper` shell function after make-wrapper.sh has defined it. The binary
  # wrapper embeds --add-flags verbatim, so the ${NIXOS_OZONE_WL:+...} expression
  # below reached Electron as two literal argv entries instead of being expanded
  # by a shell at launch. The app takes the first argv entry that does not start
  # with "-" as the deep link to open, so that literal text shadowed the claude://
  # login callback handed over by the browser and login never completed. Call the
  # shell wrapper by its unambiguous name so the expression is expanded at runtime.
  postFixup = ''
    makeShellWrapper $out/lib/claude-desktop/claude-desktop $out/bin/claude-desktop \
      "''${gappsWrapperArgs[@]}" \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}"
  '';

  meta = {
    description = "Claude desktop app: Chat, Cowork and Claude Code (Linux beta)";
    homepage = "https://code.claude.com/docs/en/desktop-linux";
    license = lib.licenses.unfree;
    platforms = ["x86_64-linux"];
    mainProgram = "claude-desktop";
  };
}
