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
      nvim-treesitter.withAllGrammars
      nvim-treesitter-textobjects
      nvim-ts-context-commentstring
      nvim-ts-autotag
      pkgs-unstable.vimPlugins.rainbow-delimiters-nvim

      # lsp
      (pkgs.vimUtils.buildVimPlugin {
        name = "nvim-lspconfig";
        src = pkgs.fetchFromGitHub {
          owner = "neovim";
          repo = "nvim-lspconfig";
          rev = "d696e36d5792daf828f8c8e8d4b9aa90c1a10c2a";
          hash = "sha256-R9SjpxYawdrwfXy6XBumy249P3MSWS77yXtdM/oY6GI=";
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
          hash = "sha256-o0za2NxFtzHZa7PRIm9U/P1/fwJrxS1G79ukdGLhJ4Q=";
        };
      })
      (pkgs.vimUtils.buildVimPlugin {
        name = "lspkind";
        src = pkgs.fetchFromGitHub {
          owner = "onsails";
          repo = "lspkind.nvim";
          rev = "master";
          hash = "sha256-OCvKUBGuzwy8OWOL1x3Z3fo+0+GyBMI9TX41xSveqvE=";
        };
      })
      (pkgs-unstable.vimUtils.buildVimPlugin {
        name = "outline.nvim";
        doCheck = false;
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
          hash = "sha256-lHwzOCYH/L5HmyG7A3ocaHIhkSvh/EP3yNLl6T1uQLM=";
        };
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
      pkgs-unstable.vimPlugins.todo-comments-nvim

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
          rev = "ba6253d9673daf0cf394b87b2c2ecb7630944c7d";
          hash = "sha256-Tw3lf9DJx/f+/GtlLA7FKPdd+fxzgFffhY3OotN+AFs=";
        };
      })

      # AI
      pkgs-unstable.vimPlugins.copilot-vim
      (pkgs-unstable.vimPlugins.avante-nvim.overrideAttrs (oldAttrs: {
        src = pkgs.fetchFromGitHub {
          owner = "yetone";
          repo = "avante.nvim";
          rev = "7f48770e66684e9a7d4d5b9c47505a23e0167a6e";
          hash = "sha256-U8RnTBGW+dR26JATQ10JbM8R03qX/ovPjvelHw2J7fc=";
        };

        nvimSkipModules = oldAttrs.nvimSkipModules ++ ["avante.providers.ollama" "avante.providers.vertex_claude" "avante.providers.vertex" "avante.providers.gemini"];
      }))
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
          hash = "sha256-siNZB32fFZhgT3P6KyiZGxpek+ZlPIfG5iVMqsCrM4c=";
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
          rev = "v0.13.0";
          hash = "sha256-dB+v1kJYyCEzC5N5s6Sbf05ZEU2MJnFrkV3w5b2ZuYY=";
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
          hash = "sha256-G+sU7e9EyASEYzdIfBRI2BF5R2upFfOFClU6ERlfp3A=";
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
          hash = "sha256-+7x567W7ky/rchm10hSh72cOUWfs2umw87+K4++n3YM=";
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
          rev = "b3ed3e79c32421ba0e8bed215cc2566da8e56e8a";
          hash = "sha256-j2IoCWDEYQsUcJqv1CHiQunIVHfJJDSzobkUqHAyLMk=";
        };
      })

      # agda
      (pkgs.vimUtils.buildVimPlugin {
        name = "cornelis";
        src = pkgs.fetchFromGitHub {
          owner = "agda";
          repo = "cornelis";
          rev = "master";
          hash = "sha256-HC/pEz5NQ/seKcbDxV2YxTnLk5bt4vpjgviSEaLdps4=";
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
