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
    enable = false;
  };

  programs.diff-so-fancy = {
    enable = false;
  };

  programs.difftastic = {
    enable = true;
  };

  programs.git = {
    enable = true;

    signing = {
      key = "64AD34EE9F81A26316380DE08C8AA931EB03536D";
      signByDefault = true;
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
