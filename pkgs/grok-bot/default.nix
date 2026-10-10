{
  lib,
  stdenv,
  fetchurl,
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
  pname = "grok-bot";
  version = "0.68.1";
  commit = "33103062f95061ccf9c81c5b365d37ab152c3b66";

  # xAI's Grok Bot is built and hosted by Cursor. Its apt repo
  # (https://downloads.cursor.com/aptrepo, suite grok-bot) lags behind the
  # website, so track the x.ai/bot "Linux .deb x64" link instead; it redirects
  # to the current version and commit:
  #   curl -sI https://api2.cursor.sh/updates/download/stable/linux-x64/grok-bot-fb0a830618be0c54 | grep -i location
  src = fetchurl {
    url = "https://downloads.cursor.com/grokbot/stable/${commit}/linux/x64/grok-bot_${version}_amd64.deb";
    hash = "sha256-sr6BBtKz6uB9mD1fHKd7ZXrM3mZtxEDbKkCUIez/M1k=";
  };

  nativeBuildInputs = [
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

    # upstream installs to "/opt/Grok Bot"; drop the space on the way in
    mkdir -p $out/bin $out/lib $out/share
    cp -r "opt/Grok Bot" $out/lib/grok-bot
    cp -r usr/share/applications usr/share/icons $out/share/

    # like chatgpt and claude-desktop, the grokbot:// login callback is spawned
    # via this desktop file by a browser process that may have no usable PATH
    substituteInPlace $out/share/applications/grok-bot.desktop \
      --replace-fail "Exec=grok-bot" "Exec=$out/bin/grok-bot"

    runHook postInstall
  '';

  # Same trap as in ../claude-desktop: wrapGAppsHook3 propagates makeBinaryWrapper,
  # which shadows `makeWrapper` and embeds the ${NIXOS_OZONE_WL:+...} expression
  # below as literal argv entries instead of letting a shell expand it at launch.
  postFixup = ''
    makeShellWrapper $out/lib/grok-bot/grok-bot $out/bin/grok-bot \
      "''${gappsWrapperArgs[@]}" \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}"
  '';

  meta = {
    description = "Grok Bot desktop agent by xAI";
    homepage = "https://x.ai/bot";
    license = lib.licenses.unfree;
    sourceProvenance = [lib.sourceTypes.binaryNativeCode];
    platforms = ["x86_64-linux"];
    mainProgram = "grok-bot";
  };
}
