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
  libusb1,
  libxkbcommon,
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
  pname = "chatgpt";
  version = "26.901.31953";

  # OpenAI only ships amd64/arm64 .deb packages; bump the version together
  # with the hash from the apt index:
  # https://persistent.oaistatic.com/codex-app-prod/linux/deb/dists/stable/main/binary-amd64/Packages
  src = fetchurl {
    url = "https://persistent.oaistatic.com/codex-app-prod/linux/deb/pool/main/c/chatgpt/chatgpt_${version}_amd64.deb";
    hash = "sha256-K7RSK+h33mwX5fTAcbBuxkiCsd0JqPC9IErwI6t1bZw=";
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
    libusb1
    libxkbcommon
    nspr
    nss
    pango
    stdenv.cc.cc.lib
    systemd
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

  autoPatchelfIgnoreMissingDeps = [
    # bundled node_modules ship a musl prebuild next to the glibc one
    "libc.musl-x86_64.so.1"
    # Electron's optional Qt shims; without them dialogs fall back to GTK
    "libQt5Core.so.5"
    "libQt5Gui.so.5"
    "libQt5Widgets.so.5"
    "libQt6Core.so.6"
    "libQt6Gui.so.6"
    "libQt6Widgets.so.6"
  ];

  dontConfigure = true;
  dontBuild = true;
  dontWrapGApps = true;

  unpackPhase = ''
    runHook preUnpack
    dpkg-deb --fsys-tarfile $src | tar -x --no-same-permissions --no-same-owner
    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/lib $out/share
    cp -r usr/lib/chatgpt $out/lib/chatgpt
    cp -r usr/share/applications usr/share/pixmaps $out/share/

    # like claude-desktop, the codex:// login callback is spawned via this
    # desktop file by a browser process that may have no usable PATH
    substituteInPlace $out/share/applications/chatgpt.desktop \
      --replace-fail "Exec=chatgpt" "Exec=$out/bin/chatgpt"

    runHook postInstall
  '';

  postFixup = ''
    makeWrapper $out/lib/chatgpt/ChatGPT $out/bin/chatgpt \
      "''${gappsWrapperArgs[@]}" \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}"
  '';

  meta = {
    description = "ChatGPT desktop app by OpenAI (Linux preview)";
    homepage = "https://learn.chatgpt.com/docs/linux/linux-app";
    license = lib.licenses.unfree;
    platforms = ["x86_64-linux"];
    mainProgram = "chatgpt";
  };
}
