{username}: {
  pkgs,
  pkgs-unstable,
  pkgs-mozilla,
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

  home = {
    inherit username;
    homeDirectory = "${
      if pkgs.stdenv.isDarwin
      then "/Users"
      else "/home"
    }/${username}";
  };

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs;
    [
      # nix editor tooling
      nil
      alejandra
      nixd

      # communication
      weechat
      discord
      telegram-desktop
      signal-desktop
      zoom-us
      rainbowstream
      redlib
      element-desktop

      # organization
      obsidian

      # music
      spotify

      # fonts
      fontconfig
      freetype
      inter
      monaspace
      nerdfonts
      noto-fonts-emoji
      roboto
      newcomputermodern

      # programming languages
      luajit
      luajitPackages.fennel

      # utilities
      duf
      dig
      dasel
      nix-search-cli
      glow
      jql
      eva
      httpie
      xh
      asciinema
      postman
      neofetch
      pgcli
      iredis
      litecli
      mycli
      igrep
      ngrok
      pkgs-unstable.supabase-cli
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
      wasmtime
      tidy-viewer

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
    ]
    ++ (
      if pkgs.stdenv.isLinux
      then [
        # nighly firefox
        pkgs-mozilla.${stdenv.hostPlatform.system}.firefox-nightly-bin

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

        # AI tools
        promptfoo
        private-gpt
        gptcommit
        aichat

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

        # copy and paste utils for terminal
        wl-clipboard

        # android
        android-tools
        android-studio

        # decentralization
        bisq2
        tor-browser
        onionshare
        trezor-suite
        electrum
        sparrow
        wasabiwallet
        kubo

        # 3D and electronics
        (blender.override {
          cudaSupport = true;
        })
        prusa-slicer
        pkgs-unstable.cura-appimage
        freecad-wayland
        unityhub
        kicad
        ngspice

        # utilities
        exfat
        figma-linux
        util-linux
        lm_sensors
        resources
        youki
        lshw-gui
        dmidecode
        protonmail-bridge
        protonmail-bridge-gui
        pomodoro-gtk
        ulauncher
        valgrind
        kubernetes
        warp
        aflplusplus

        # kde packages
        kdePackages.kalgebra
        kdePackages.ktorrent
        kdePackages.kgpg
        kdePackages.kcalc
        kdePackages.kdenlive
      ]
      else []
    );

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
  home.sessionVariables =
    if pkgs.stdenv.isLinux
    then {
      FREETYPE_PROPERTIES = "truetype:interpreter-version=40 cff:no-stem-darkening=0 autofitter:no-stem-darkening=0";
    }
    else {};

  programs.direnv = {
    enable = true;

    nix-direnv.enable = true;
  };

  programs.awscli = {
    enable = true;
  };

  programs.librewolf = {
    enable = pkgs.stdenv.isLinux;
    settings = {
      "privacy.clearOnShutdown.history" = false;
      "privacy.clearOnShutdown.downloads" = false;
      "webgl.disabled" = false;
    };
  };

  programs.chromium.enable = pkgs.stdenv.isLinux;

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

      set -gu default-command
      set -g default-shell "${pkgs.fish}/bin/fish"
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

  programs.aerc = {
    enable = true;

    extraConfig = {
      general = {
        pgp-provider = "gpg";
      };
      viewer = {
        pager = "less -R";
      };
      filters = {
        "application/pgp" = "gpg --decrypt";
        "text/plain" = "colorize";
      };
    };
  };

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

  programs.gpg = {
    enable = true;
    publicKeys = [];
  };

  services.gpg-agent = {
    enable = true;

    pinentryPackage = pkgs.pinentry-curses;
    defaultCacheTtl = 43200;
  };

  services.ollama = {
    enable = true;

    acceleration = "cuda";
    environmentVariables = {
      OLLAMA_MODELS = "/home/r3rer3/Projects/AdditionalProjects/ollama-models";
    };
  };

  programs.obs-studio.enable = pkgs.stdenv.isLinux;

  programs.rtorrent = {
    enable = pkgs.stdenv.isLinux;
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

  # Let home-manager install and manage itself
  programs.home-manager.enable = true;

  fonts = {
    fontconfig = {
      enable = true;
      defaultFonts = {
        emoji = ["Noto Color Emoji"];
        monospace = ["Iosevka"];
        sansSerif = ["Inter"];
        serif = ["Roboto Slab"];
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
