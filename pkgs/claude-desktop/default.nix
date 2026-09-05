{
  lib,
  stdenv,
  fetchurl,
  dpkg,
  autoPatchelfHook,
  makeWrapper,
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
  version = "1.46388.2";

  # Anthropic only ships amd64/arm64 .deb packages; bump the version together
  # with the hash from the apt index:
  # https://downloads.claude.ai/claude-desktop/apt/stable/dists/stable/main/binary-amd64/Packages
  src = fetchurl {
    url = "https://downloads.claude.ai/claude-desktop/apt/stable/pool/main/c/claude-desktop/claude-desktop_${version}_amd64.deb";
    hash = "sha256-mL9U6F5JFgaMQoFFmw8EMdj/aANHc/PumDEdcgZWarE=";
  };

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
    makeWrapper
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

  postFixup = ''
    makeWrapper $out/lib/claude-desktop/claude-desktop $out/bin/claude-desktop \
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
