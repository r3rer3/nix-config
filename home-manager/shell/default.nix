{
  lib,
  config,
  pkgs,
  ...
}: {
  programs.fish = {
    enable = true;

    shellAliases = {
      nvim = "nvim --startuptime /tmp/nvim-startuptime";
      tv = " tidy-viewer";
      bu = "btc-utils";
      wee = "TERM=tmux-256color weechat";
    };

    functions = let
      nix-your-shell = "${pkgs.nix-your-shell}/bin/nix-your-shell";
    in
    {
      nix-shell = "${nix-your-shell} fish nix-shell -- $argv";
      nix = "${nix-your-shell} fish nix -- $argv";
    };

    shellInit = ''
      set -g fish_key_bindings fish_vi_key_bindings
    '';

    plugins = [
      {
        name = "fish-abbreviation-tips";
        src = pkgs.fetchFromGitHub {
          owner = "gazorby";
          repo = "fish-abbreviation-tips";
          rev = "8ed76a62bb044ba4ad8e3e6832640178880df485";
          sha256 = "F1t81VliD+v6WEWqj1c1ehFBXzqLyumx5vV46s/FZRU=";
        };
      }
    ];
  };

  programs.starship = {
    enable = true;

    settings = {
      nix_shell = {
        heuristic = true;
        symbol = "❄️";
        format = "via [$symbol( \($name\))]($style) ";
      };
    };
  };
}
