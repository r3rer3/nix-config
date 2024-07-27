{
  lib,
  config,
  pkgs,
  ...
}: {
  programs.neovim = {
    enable = true;
    defaultEditor = true;

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
      nvim-treesitter.withAllGrammars
      nvim-treesitter-textobjects
      nvim-ts-context-commentstring
      nvim-ts-autotag
      rainbow-delimiters-nvim

      # lsp
      nvim-lspconfig
      lspsaga-nvim
      goto-preview
      (pkgs.vimUtils.buildVimPlugin {
        name = "fidget-nvim";
        src = pkgs.fetchFromGitHub {
          owner = "j-hui";
          repo = "fidget.nvim";
          rev = "main";
          hash = "sha256-fjxdRN08BMU7jTWdhdzh8kW18ZURS9SJCwnTxuz6aFE=";
        };
      })
      (pkgs.vimUtils.buildVimPlugin {
        name = "lspkind";
        src = pkgs.fetchFromGitHub {
          owner = "onsails";
          repo = "lspkind.nvim";
          rev = "master";
          hash = "sha256-1KK6JhQUtA5mxwRSKU5e3pTQzZwaoAjzycBLx5X/xlA=";
        };
      })
      (pkgs.vimUtils.buildVimPlugin {
        name = "outline.nvim";
        src = pkgs.fetchFromGitHub {
          owner = "hedyhli";
          repo = "outline.nvim";
          rev = "main";
          hash = "sha256-U8FmA7dJIV9T6Uose7Q9xATfB73H6PPQAGLw3FEsk9Y=";
        };
      })
      (pkgs.vimUtils.buildVimPlugin {
        name = "vista";
        src = pkgs.fetchFromGitHub {
          owner = "liuchengxu";
          repo = "vista.vim";
          rev = "master";
          hash = "sha256-04HEuCBeWYghX70RqgthahGweFl7gkFBKeoGYiUa6j4=";
        };
      })

      # linting
      (pkgs.vimUtils.buildVimPlugin {
        name = "none-ls";
        src = pkgs.fetchFromGitHub {
          owner = "nvimtools";
          repo = "none-ls.nvim";
          rev = "main";
          hash = "sha256-ZA9MSpgRotndP9craRoLeId/kyi5Wi5aqxBrSvfLtME=";
        };
      })

      # highlight uses of word under the cursor
      vim-illuminate

      # file tree
      nvim-tree-lua

      # telescope
      telescope-nvim
      telescope-fzf-native-nvim
      telescope-ui-select-nvim
      telescope-ultisnips-nvim

      # comments
      comment-nvim
      todo-comments-nvim

      # session manager
      auto-session

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
          hash = "sha256-SablEni7+VYXUs5lkgpZBqzIBWDE2p3f+R4vXrzF+oE=";
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
          hash = "sha256-diwLtmch8LzaX7FIwBNy78n3iY7VnqMC1n0ep8k5kWE=";
        };
      })

      # visual information of where cursor is when jumping around
      (pkgs.vimUtils.buildVimPlugin {
        name = "beacon";
        src = pkgs.fetchFromGitHub {
          owner = "DanilaMihailov";
          repo = "beacon.nvim";
          rev = "a786c9a89b2c739c69f9500a2f70f2586c06ec27";
          hash = "sha256-qD0dwccNjhJ7xyM+yG8bSFUyPn7hHZyC0RBy3MW1hz0=";
        };
      })

      # copilot
      copilot-vim

      # preview markdown
      glow-nvim

      # indentation info
      (pkgs.vimUtils.buildVimPlugin {
        name = "indent-blankline";
        src = pkgs.fetchFromGitHub {
          owner = "lukas-reineke";
          repo = "indent-blankline.nvim";
          rev = "master";
          hash = "sha256-PSsXBB2KOFPJJ1O8fpTvsVe2A0/wU6Ae9dN/UemraZM=";
        };
      })

      # pretty list for showing diagnostics, references, telescope results, quickfix and location lists
      (pkgs.vimUtils.buildVimPlugin {
        name = "trouble";
        src = pkgs.fetchFromGitHub {
          owner = "folke";
          repo = "trouble.nvim";
          rev = "main";
          hash = "sha256-db/riM3Kq+QgGUqRxJHA4HYXJE31276hrUrDj4UhC2g=";
        };
      })

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
      (pkgs.vimUtils.buildVimPlugin {
        name = "autopairs";
        src = pkgs.fetchFromGitHub {
          owner = "windwp";
          repo = "nvim-autopairs";
          rev = "master";
          hash = "sha256-2+r2SkCtLqKn6CxbEjvUEpsPL5G9KNOf7Q9lGMsolZs=";
        };
      })

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
      })

      # different wild menu
      wilder-nvim

      # even better %
      (pkgs.vimUtils.buildVimPlugin {
        name = "vim-matchup";
        src = pkgs.fetchFromGitHub {
          owner = "andymass";
          repo = "vim-matchup";
          rev = "master";
          hash = "sha256-0w2IjpEM/+yvY6fRJfVkuCRYdcEVpLsVduDB+T13hG8=";
        };
      })

      # collection of modules
      (pkgs.vimUtils.buildVimPlugin {
        name = "mini.nvim";
        src = pkgs.fetchFromGitHub {
          owner = "echasnovski";
          repo = "mini.nvim";
          rev = "v0.13.0";
          hash = "sha256-dB+v1kJYyCEzC5N5s6Sbf05ZEU2MJnFrkV3w5b2ZuYY=";
        };
      })

      # which-key
      (pkgs.vimUtils.buildVimPlugin {
        name = "which-key";
        src = pkgs.fetchFromGitHub {
          owner = "folke";
          repo = "which-key.nvim";
          rev = "main";
          hash = "sha256-nv9s4/ax2BoL9IQdk42uN7mxIVFYiTK+1FVvWDKRnGM=";
        };
      })

      # marks and bookmarks
      marks-nvim

      # terminal
      (pkgs.vimUtils.buildVimPlugin {
        name = "asyncrun";
        src = pkgs.fetchFromGitHub {
          owner = "skywind3000";
          repo = "asyncrun.vim";
          rev = "master";
          hash = "sha256-mViw92okQyL7GqBx/M7j1B0JCmhOjoez4wVgjI35teQ=";
        };
      })
      (pkgs.vimUtils.buildVimPlugin {
        name = "toggleterm";
        src = pkgs.fetchFromGitHub {
          owner = "akinsho";
          repo = "toggleterm.nvim";
          rev = "main";
          hash = "sha256-G+sU7e9EyASEYzdIfBRI2BF5R2upFfOFClU6ERlfp3A=";
        };
      })

      # snippets
      luasnip

      # completion
      (pkgs.vimUtils.buildVimPlugin {
        name = "nvim-cmp";
        src = pkgs.fetchFromGitHub {
          owner = "hrsh7th";
          repo = "nvim-cmp";
          rev = "main";
          hash = "sha256-jc4fQBaAuL4XhHljVU3sdaEyQCnHbI+gwNOTnGHk0qM=";
        };
      })
      cmp-buffer
      cmp-rg
      cmp-path
      cmp-under-comparator
      cmp_luasnip
      (pkgs.vimUtils.buildVimPlugin {
        name = "cmp-nvim-lsp";
        src = pkgs.fetchFromGitHub {
          owner = "hrsh7th";
          repo = "cmp-nvim-lsp";
          rev = "main";
          hash = "sha256-CT1+Z4XJBVsl/RqvJeGmyitD6x7So0ylXvvef5jh7I8=";
        };
      })
      (pkgs.vimUtils.buildVimPlugin {
        name = "cmp-nvim-lsp-signature-help";
        src = pkgs.fetchFromGitHub {
          owner = "hrsh7th";
          repo = "cmp-nvim-lsp-signature-help";
          rev = "main";
          hash = "sha256-tLMhkmdehH3IDlIdqJq6GHpudY0G05Asjir6p4aONyI=";
        };
      })

      # clang
      (pkgs.vimUtils.buildVimPlugin {
        name = "clangd-extensions";
        src = pkgs.fetchFromGitHub {
          owner = "p00f";
          repo = "clangd_extensions.nvim";
          rev = "main";
          hash = "sha256-D7wibK3aRDcrB/Fhw8b2QUnmXxjzgpQZI6ar4vlSgvg=";
        };
      })

      # rust
      (pkgs.vimUtils.buildVimPlugin {
        name = "rustaceanvim";
        src = pkgs.fetchFromGitHub {
          owner = "mrcjkb";
          repo = "rustaceanvim";
          rev = "master";
          hash = "sha256-KlkWIOJYFH+Z9YQPSqh0lkuwejH+PuYXcUAJa0hKmFo=";
        };
      })

      # golang
      (pkgs.vimUtils.buildVimPlugin {
        name = "go-nvim";
        src = pkgs.fetchFromGitHub {
          owner = "ray-x";
          repo = "go.nvim";
          rev = "master";
          hash = "sha256-OXsdo+kvNZGCoSuz0b9ORofYhnzNpjL1Fug7IKc5hlo=";
        };
      })

      # haskell
      (pkgs.vimUtils.buildVimPlugin {
        name = "haskell-tools-nvim";
        src = pkgs.fetchFromGitHub {
          owner = "mrcjkb";
          repo = "haskell-tools.nvim";
          rev = "master";
          hash = "sha256-Jgaa3hVPjCfPqzyEtD2gDDS3S2bJkLD3wJJZD38A5HQ=";
        };
      })

      # coq
      (pkgs.vimUtils.buildVimPlugin {
        name = "coqtail";
        src = pkgs.fetchFromGitHub {
          owner = "whonore";
          repo = "Coqtail";
          rev = "main";
          hash = "sha256-+7uBuycYKHxpUWVtq6V0/59bH5p8P5AOTMWl7LvUGZ4=";
        };
      })

      # lean4
      (pkgs.vimUtils.buildVimPlugin {
        name = "lean4-nvim";
        src = pkgs.fetchFromGitHub {
          owner = "Julian";
          repo = "lean.nvim";
          rev = "main";
          hash = "sha256-yIfYuySk/bn3Zow+2yMsBOKjsNXtbxcfqHPG1t+TD+E=";
        };
      })

      # brainfuck
      (pkgs.vimUtils.buildVimPlugin {
        name = "brainfuck";
        src = pkgs.fetchFromGitHub {
          owner = "q60";
          repo = "vim-brainfuck";
          rev = "master";
          hash = "sha256-vHKxmgx6U3ithNknF7HY3Vvr11zWDYC3wsU1Xo1CRFM=";
        };
      })
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
