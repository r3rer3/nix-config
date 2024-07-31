{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # You can import other home-manager modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/home-manager):
    # outputs.homeManagerModules.example

    # Or modules exported from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModules.default

    # You can also split up your configuration and import pieces of it here:
    ./alacritty
    ./git
    ./newsboat.nix
    ./nvim
    ./shell
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages

      inputs.neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];

    # Configure your nixpkgs instance
    config = {
      allowUnfree = true;
    };
  };

  home = {
    username = "r3rer3";
    homeDirectory = "/home/r3rer3";
  };

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # password manager
    _1password
    _1password-gui

    # communication
    whatsapp-for-linux
    weechat
    discord
    telegram-desktop
    signal-desktop
    zoom-us
    rainbowstream
    redlib

    # reverse engineering and security
    ghidra
    charles
    iaito
    radare2
    ida-free
    imhex
    qFlipper
    wireshark
    termshark
    mitmproxy
    mkcert
    nmap
    nss
    cutter
    yara

    # virtual machines
    qemu
    quickemu
    quickgui
    virt-viewer

    # AI
    gpt4all
    lmstudio
    promptfoo
    aichat
    local-ai
    gorilla-cli
    llm
    gptscript
    gptcommit
    private-gpt
    tgpt
    shell-gpt
    jan

    # organization
    obsidian

    # music
    spotify

    # audio
    ardour
    audacity

    # image and video
    gimp
    shotcut
    vlc
    handbrake
    inkscape
    conjure
    imagemagick
    termshot

    # fonts
    inter
    monaspace
    nerdfonts
    noto-fonts-emoji
    roboto

    # copy and paste utils for terminal
    wl-clipboard

    # android
    android-tools
    android-studio

    # decentralization
    bisq-desktop
    tor-browser
    onionshare
    trezor-suite
    electrum
    sparrow
    wasabiwallet
    kubo

    # 3D
    (blender.override {
      cudaSupport = true;
    })
    prusa-slicer
    cura
    freecad
    unityhub

    # utilities
    nix-search-cli
    lm_sensors
    psensor
    glow
    jql
    youki
    eva
    lshw-gui
    dmidecode
    util-linux
    exfat
    figma-linux
    httpie
    xh
    asciinema
    postman
    bloomrpc
    protonmail-bridge
    protonmail-bridge-gui
    pomodoro-gtk
    ulauncher
    neofetch
    pgcli
    iredis
    litecli
    mycli
    igrep
    valgrind
    ngrok
    supabase-cli
    netcat
    asciidoctor
    ast-grep
    bear
    doctl
    hut
    eza
    sad
    sd
    hyperfine
    flyctl
    fzy
    gnuplot
    graphviz
    grpcurl
    kubernetes-helm
    hexyl
    kubernetes
    minikube
    localstack
    ninja
    meson
    just
    nasm
    ncdu
    dua
    dust
    nethack
    tree
    pstree
    rlwrap
    dogdns
    tokei
    scc
    ccache
    sccache
    shellcheck
    tcptraceroute
    vhs
    wabt
    websocat
    warp
    wasmtime
    aflplusplus
    tidy-viewer

    # kde packages
    kdePackages.kalgebra
    kdePackages.ktorrent
    kdePackages.kgpg
    kdePackages.kcalc
    kdePackages.kdenlive

    # programming languages
    luajit
    luajitPackages.fennel

    # VPNs
    mullvad-vpn

    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';

    # ".emacs.d/init.el".source = config.lib.file.mkOutOfStoreSymlink ./init.el;
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/r3rer3/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
  };

  programs.awscli = {
    enable = true;
  };

  programs.librewolf = {
    enable = true;
    settings = {
      "privacy.clearOnShutdown.history" = false;
      "privacy.clearOnShutdown.downloads" = false;
      "webgl.disabled" = false;
    };
  };

  programs.chromium.enable = true;

  programs.ssh = {
    enable = true;

    addKeysToAgent = "no";

    extraConfig = ''
      IdentitiesOnly yes
      PreferredAuthentications publickey
    '';

    matchBlocks = {
      "r3rer3-sourcehut" = {
        host = "*sr.ht";
        identityFile = ["~/.ssh/r3rer3-sourcehut"];
      };
      "r3rer3-github" = {
        host = "github.com";
        identityFile = ["~/.ssh/r3rer3-github"];
      };
    };
  };

  programs.obs-studio.enable = true;

  programs.tmux = {
    enable = true;

    disableConfirmationPrompt = true;
    mouse = false;
    prefix = "C-a";
    keyMode = "vi";
    terminal = "alacritty";

    shell = "${pkgs.fish}/bin/fish";

    extraConfig = ''
      set-option -ga terminal-overrides ",alacritty:Tc"
      bind-key x kill-pane
      set-option -g renumber-windows on

      bind k select-pane -U
      bind j select-pane -D
      bind h select-pane -L
      bind l select-pane -R
    '';

    plugins = with pkgs; [
      tmuxPlugins.sensible
      {
        plugin = tmuxPlugins.resurrect;
        extraConfig = "set -g @resurrect-strategy-nvim 'session'";
      }
      {
        plugin = tmuxPlugins.continuum;
        extraConfig = ''
          set -g @continuum-restore 'on'
          set -g @continuum-save-interval '5' # minutes
        '';
      }
      tmuxPlugins.catppuccin
    ];
  };

  programs.direnv = {
    enable = true;

    nix-direnv.enable = true;
  };

  programs.gpg = {
    enable = true;
    publicKeys = [];
  };

  programs.aerc = {
    enable = true;

    extraConfig = {
      general = {
        pgp-provider = "gpg";
      };
    };
  };

  programs.rtorrent = {
    enable = true;
  };

  programs.zoxide = {
    enable = true;
  };

  programs.fd = {
    enable = true;

    hidden = true;
  };

  programs.fzf = {
    enable = true;
  };

  programs.man = {
    enable = true;
  };

  programs.lsd = {
    enable = true;
  };

  programs.broot = {
    enable = true;
  };

  programs.tealdeer = {
    enable = true;
  };

  programs.navi = {
    enable = true;
  };

  programs.ripgrep = {
    enable = true;
  };

  programs.bottom = {
    enable = true;
  };

  programs.bat = {
    enable = true;
  };

  programs.jq = {
    enable = true;
  };

  services.flameshot = {
    enable = true;
  };

  services.gpg-agent = {
    enable = true;

    pinentryPackage = pkgs.pinentry-curses;
    defaultCacheTtl = 43200;
  };

  # Let home-manager install and manage itself
  programs.home-manager.enable = true;

  fonts = {
    fontconfig = {
      enable = true;
      defaultFonts = {
        emoji = ["Noto Color Emoji"];
        monospace = ["Iosevka"];
        sansSerif = ["Inter"];
        serif = ["Roboto Slab"
      };
    };
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05";
}
