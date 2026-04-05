{
  config,
  pkgs,
  pkgs-unstable,
  mcphub-nvim,
  ...
}: {
  programs.neovim = {
    enable = true;
    defaultEditor = true;

    package = pkgs-unstable.neovim-unwrapped;

    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    withNodeJs = true;
    withPython3 = true;
    withRuby = false;

    extraLuaConfig = ''
      require('aniseed.env').init()
    '';

    plugins = with pkgs.vimPlugins; [
      # fennel integration
      aniseed

      # lua utils
      plenary-nvim

      # start page
      alpha-nvim

      # web icons
      nvim-web-devicons

      # colorschemes
      catppuccin-nvim

      # useful mappings
      vim-surround

      # tree sitter and tree sitter plugins
      pkgs-unstable.vimPlugins.nvim-treesitter.withAllGrammars
      pkgs-unstable.vimPlugins.nvim-treesitter-textobjects
      pkgs-unstable.vimPlugins.nvim-ts-context-commentstring
      pkgs-unstable.vimPlugins.nvim-ts-autotag
      pkgs-unstable.vimPlugins.rainbow-delimiters-nvim

      # lsp
      (pkgs.vimUtils.buildVimPlugin {
        name = "nvim-lspconfig";
        src = pkgs.fetchFromGitHub {
          owner = "neovim";
          repo = "nvim-lspconfig";
          rev = "841c6d4139aedb8a3f2baf30cef5327371385b93";
          hash = "sha256-1wmf28UMTt0ZTD8w66OieP+YYkht3n4bOkoNa4dD6/0=";
        };
      })
      pkgs-unstable.vimPlugins.lspsaga-nvim
      goto-preview
      (pkgs.vimUtils.buildVimPlugin {
        name = "fidget-nvim";
        src = pkgs.fetchFromGitHub {
          owner = "j-hui";
          repo = "fidget.nvim";
          rev = "main";
          hash = "sha256-Zap4UVicIvCaPqCMgdlnEAGbMzq1xM4uGpVqZL1iju0=";
        };
      })
      (pkgs.vimUtils.buildVimPlugin {
        name = "lspkind";
        src = pkgs.fetchFromGitHub {
          owner = "onsails";
          repo = "lspkind.nvim";
          rev = "c7274c48137396526b59d86232eabcdc7fed8a32";
          hash = "sha256-aIopYLm/x1CgCKpcsu9pxpqL0SXXhHDPTM8DKUwGeRw=";
        };
      })
      (pkgs-unstable.vimUtils.buildVimPlugin {
        name = "outline.nvim";
        doCheck = false;
        src = pkgs.fetchFromGitHub {
          owner = "hedyhli";
          repo = "outline.nvim";
          rev = "main";
          hash = "sha256-+jN6VV7McqszRLHPx7sYme2mq3BzaOr5IOHbF+uZPrc=";
        };
      })
      (pkgs.vimUtils.buildVimPlugin {
        name = "vista";
        src = pkgs.fetchFromGitHub {
          owner = "liuchengxu";
          repo = "vista.vim";
          rev = "master";
          hash = "sha256-7k94AyzOx4Iqwu1Vns4i69/NR1uWlwouOB0UL9VsdL0=";
        };
      })

      # linting
      (pkgs.vimUtils.buildVimPlugin {
        name = "none-ls";
        src = pkgs.fetchFromGitHub {
          owner = "nvimtools";
          repo = "none-ls.nvim";
          rev = "main";
          hash = "sha256-PmDYh9VqfpxNzIepTiNzXKrighUN9e6Ug5pCD3XCGd4=";
        };
        doCheck = false;
      })

      # highlight uses of word under the cursor
      pkgs-unstable.vimPlugins.vim-illuminate

      # file tree
      pkgs-unstable.vimPlugins.nvim-tree-lua

      # telescope
      telescope-nvim
      telescope-fzf-native-nvim
      telescope-ui-select-nvim
      telescope-ultisnips-nvim

      # comments
      comment-nvim
      (pkgs.vimUtils.buildVimPlugin {
        name = "todo-comments-nvim";
        src = pkgs.fetchFromGitHub {
          owner = "folke";
          repo = "todo-comments.nvim";
          rev = "411503d3bedeff88484de572f2509c248e499b38";
          hash = "sha256-VE7n/yoYPEkp4WQ89ftscspnijPrEMroPg5qVYyVcbM=";
        };
        doCheck = false;
      })

      # session manager
      pkgs-unstable.vimPlugins.auto-session

      # status line
      lualine-nvim
      nvim-navic

      # git
      vim-fugitive
      git-blame-nvim
      (pkgs.vimUtils.buildVimPlugin {
        name = "git-conflict";
        src = pkgs.fetchFromGitHub {
          owner = "akinsho";
          repo = "git-conflict.nvim";
          rev = "main";
          hash = "sha256-CmSgmpg5K3ySXYrDjg8yTAojeLWJdSHP8uNVFyrkNhc=";
        };
      })

      # range highlighter
      range-highlight-nvim

      # better parenthesis for Lisp-like languages
      (pkgs.vimUtils.buildVimPlugin {
        name = "nvim-parinfer";
        src = pkgs.fetchFromGitHub {
          owner = "gpanders";
          repo = "nvim-parinfer";
          rev = "master";
          hash = "sha256-hzm+VF669NpILT6P540PriXDuOCjPq3D7YKxLv5EsQU=";
        };
      })

      # visual information of where cursor is when jumping around
      (pkgs.vimUtils.buildVimPlugin {
        name = "flare.nvim";
        src = pkgs.fetchFromGitHub {
          owner = "stonelasley";
          repo = "flare.nvim";
          rev = "08eddc77b02415fe7480d84cfbc4f8a7bd1b3d82";
          hash = "sha256-GSNjPAfrbpWo3W1gLJBv04o3CGKfika/OHkHyRoQtcE=";
        };
      })

      # improve the default vim.ui interfaces
      (pkgs.vimUtils.buildVimPlugin {
        name = "dressing.nvim";
        src = pkgs.fetchFromGitHub {
          owner = "stevearc";
          repo = "dressing.nvim";
          rev = "3a45525bb182730fe462325c99395529308f431e";
          hash = "sha256-N4hB5wDgoqXrXxSfzDCrqmdDtdVvq+PtOS7FBPH7qXE=";
        };
      })

      # UI Component Library for Neovim.
      (pkgs.vimUtils.buildVimPlugin {
        name = "nui.nvim";
        src = pkgs.fetchFromGitHub {
          owner = "MunifTanjim";
          repo = "nui.nvim";
          rev = "53e907ffe5eedebdca1cd503b00aa8692068ca46";
          hash = "sha256-6U7E/i5FuNXQy+sF4C5DVxuTPqNKD5wxUgFohpOjm9Q=";
        };
      })

      # embed images into any markup language
      (pkgs.vimUtils.buildVimPlugin {
        name = "img-clip.nvim";
        src = pkgs.fetchFromGitHub {
          owner = "HakonHarnes";
          repo = "img-clip.nvim";
          rev = "5ff183655ad98b5fc50c55c66540375bbd62438c";
          hash = "sha256-Q4v4E8Iay6rXvtUsM5ULo1cnBYduzTw42kIgJlodq5U=";
        };
      })

      # improve viewing Markdown files in Neovim
      (pkgs.vimUtils.buildVimPlugin {
        name = "render-markdown.nvim";
        src = pkgs.fetchFromGitHub {
          owner = "MeanderingProgrammer";
          repo = "render-markdown.nvim";
          rev = "e3c18ddd27a853f85a6f513a864cf4f2982b9f26";
          hash = "sha256-7O8V8XDYn4ITF9VfvV1OSkto+piIm/DpwtEe+vJcE2g=";
        };
      })

      # AI
      pkgs-unstable.vimPlugins.copilot-vim
      mcphub-nvim."${pkgs.system}".default

      # indentation info
      pkgs-unstable.vimPlugins.indent-blankline-nvim

      # pretty list for showing diagnostics, references, telescope results, quickfix and location lists
      pkgs-unstable.vimPlugins.trouble-nvim

      # colorizer / color highlighter
      (pkgs.vimUtils.buildVimPlugin {
        name = "colorizer";
        src = pkgs.fetchFromGitHub {
          owner = "norcalli";
          repo = "nvim-colorizer.lua";
          rev = "master";
          hash = "sha256-gjO89Sx335PqVgceM9DBfcVozNjovC8KML1OZCRNMGw=";
        };
      })

      # peek lines
      numb-nvim

      # vim training
      train-nvim

      # autopairs
      pkgs-unstable.vimPlugins.nvim-autopairs

      # remote plugin framework
      nvim-yarp

      # fzy lua native
      (pkgs.vimUtils.buildVimPlugin {
        name = "fzy-lua-native";

        src = pkgs.fetchFromGitHub {
          owner = "r3rer3";
          repo = "fzy-lua-native";
          rev = "d292979fd892bf86b149e5ee962ef7325c365204";
          hash = "sha256-zGehQsVhgWdN+YnWx4o4dCVMUSTBN5qiI93hyRgDrrU=";
        };

        doCheck = false;
      })

      # repl
      (pkgs.vimUtils.buildVimPlugin {
        name = "iron.nvim";

        src = pkgs.fetchFromGitHub {
          owner = "Vigemus";
          repo = "iron.nvim";
          rev = "master";
          hash = "sha256-I2o1H9iRgGHmLA0v2U508hKWFCFrvZxXGWUOLtke7Do=";
        };
      })

      # different wild menu
      wilder-nvim

      # even better %
      pkgs-unstable.vimPlugins.vim-matchup

      # collection of modules
      (pkgs.vimUtils.buildVimPlugin {
        name = "mini.nvim";
        src = pkgs.fetchFromGitHub {
          owner = "echasnovski";
          repo = "mini.nvim";
          rev = "v0.17.0";
          hash = "sha256-xmNZrQDptaNcECHSGtjownFyR1qxsP7lge8OAIFe8BU=";
        };
      })

      # which-key
      pkgs-unstable.vimPlugins.which-key-nvim

      # marks and bookmarks
      marks-nvim

      # terminal
      pkgs-unstable.vimPlugins.asyncrun-vim
      (pkgs.vimUtils.buildVimPlugin {
        name = "toggleterm";
        src = pkgs.fetchFromGitHub {
          owner = "akinsho";
          repo = "toggleterm.nvim";
          rev = "main";
          hash = "sha256-fytbX+L12TK45YKFU9K+iFJcDrwboKabihc2LtX29J4=";
        };
      })

      # snippets
      luasnip

      # completion
      pkgs-unstable.vimPlugins.nvim-cmp
      pkgs-unstable.vimPlugins.cmp-buffer
      pkgs-unstable.vimPlugins.cmp-rg
      pkgs-unstable.vimPlugins.cmp-path
      pkgs-unstable.vimPlugins.cmp-under-comparator
      pkgs-unstable.vimPlugins.cmp_luasnip
      (pkgs.vimUtils.buildVimPlugin {
        name = "cmp-nvim-lsp";
        src = pkgs.fetchFromGitHub {
          owner = "hrsh7th";
          repo = "cmp-nvim-lsp";
          rev = "cbc7b02bb99fae35cb42f514762b89b5126651ef";
          hash = "sha256-CYZdfAsJYQyW413fRvNbsS5uayuc6fKDvDLZ2Y7j3ZQ=";
        };
      })
      pkgs-unstable.vimPlugins.cmp-nvim-lsp-signature-help

      # clang
      (pkgs.vimUtils.buildVimPlugin {
        name = "clangd-extensions";
        src = pkgs.fetchFromGitHub {
          owner = "p00f";
          repo = "clangd_extensions.nvim";
          rev = "main";
          hash = "sha256-JWo5yY/ei21np71Qmhs7vxST5fy9VnhlFOKClCOdnhg=";
        };
      })

      # futhark
      pkgs.vimPlugins.futhark-vim

      # rust
      pkgs-unstable.vimPlugins.rustaceanvim

      # golang
      pkgs-unstable.vimPlugins.go-nvim

      # haskell
      pkgs-unstable.vimPlugins.haskell-tools-nvim

      # coq
      (pkgs.vimUtils.buildVimPlugin {
        name = "coqtail";
        src = pkgs.fetchFromGitHub {
          owner = "whonore";
          repo = "Coqtail";
          rev = "d470fff7591bf826ca10090a14ccf2e1dc8199db";
          hash = "sha256-gXTXaCGIXyZfRfz9c29FG1kWD6E1sFXfB4Ar7wXr4H4=";
        };
      })

      # agda
      (pkgs.vimUtils.buildVimPlugin {
        name = "cornelis";
        src = pkgs.fetchFromGitHub {
          owner = "agda";
          repo = "cornelis";
          rev = "master";
          hash = "sha256-Z/2hBW/bRb8wtJqBUT8tqgoXg4XqGNvp8L6xw+zHDaU=";
        };
      })

      # lean4
      pkgs-unstable.vimPlugins.lean-nvim

      # brainfuck
      (pkgs.vimUtils.buildVimPlugin {
        name = "brainfuck";
        src = pkgs.fetchFromGitHub {
          owner = "q60";
          repo = "vim-brainfuck";
          rev = "master";
          hash = "sha256-X0N4iqc/m03wrgV4Lyn2ICBw8u1Vm8CilUxXkwHknFY=";
        };
      })

      # obsidian
      pkgs-unstable.vimPlugins.obsidian-nvim

      # images
      pkgs-unstable.vimPlugins.snacks-nvim
    ];
  };

  xdg.configFile."nvim/fnl" = {
    source = ./fnl;
    onChange = ''
      rm -rf ${config.xdg.configHome}/nvim/lua
      ${pkgs.neovim}/bin/nvim --headless -c "lua require(\"aniseed.env\").init()" -c "q"
    '';
  };
}
