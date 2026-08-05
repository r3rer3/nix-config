{
  lib,
  config,
  pkgs,
  ...
}: {
  programs.gh = {
    enable = true;
  };

  programs.gh-dash = {
    enable = true;
  };

  programs.delta = {
    enable = true;
  };

  programs.difftastic = {
    enable = true;
  };

  programs.git = {
    enable = true;

    signing = {
      signByDefault = true;
      key =
        if pkgs.stdenv.isLinux
        then "64AD34EE9F81A26316380DE08C8AA931EB03536D"
        else "~/.ssh/r3rer3-github.pub";
      format =
        if pkgs.stdenv.isLinux
        then "openpgp"
        else "ssh";
    };

    settings = {
      user = {
        email = "r3rer3@startmail.com";
        name = "r3rer3";
      };

      alias = {
        cm = "commit";
        i = "init";
        cl = "clone";
        st = "status";
        br = "branch";
        last = "log -1 HEAD";
        unstage = "reset HEAD --";
        visual = "!gitk";

        # Difftastic aliases, so `git dlog -p` is `git log -p`
        # with difftastic and likewise for the other subcommands.
        dlog = "-c diff.external=difft log --ext-diff";
        dshow = "-c diff.external=difft show --ext-diff";
        ddiff = "-c diff.external=difft diff";

        # `git log` with patches shown with difftastic.
        dl = "-c diff.external=difft log -p --ext-diff";
        # Show the most recent commit with difftastic.
        ds = "-c diff.external=difft show --ext-diff";
        # `git diff` with difftastic.
        dft = "-c diff.external=difft diff";
      };

      core = {
        editor = "nvim";
        autocrlg = "input";
      };

      commit.template = "${./gitmessage.txt}";

      fetch.prune = true;

      init.defaultBranch = "master";

      diff.tool = "nvimdiff";
      merge.tool = "nvimdiff";

      rerere.enabled = true;

      user.useconfigonly = true;

      credential.usehttppath = true;

      sendemail = {
        smtpserver = "smtp.startmail.com";
        smtpuser = "r3rer3@startmail.com";
        smtpencryption = "ssl";
        smtpserverport = "465";
        annotate = "yes";
      };
    };

    ignores = [
      "*~"
      "*.swp"
      ".DS_Store"
      "build"
      "node_modules"
    ];

    lfs = {
      enable = true;
    };
  };
}
