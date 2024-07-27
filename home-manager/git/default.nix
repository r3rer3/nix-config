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

  programs.git = {
    enable = true;

    userEmail = "r3rer3@startmail.com";
    userName = "r3rer3";

    signing = {
      key = "64AD34EE9F81A26316380DE08C8AA931EB03536D";
      signByDefault = true;
    };

    aliases = {
      cm = "commit";
      i = "init";
      cl = "clone";
      st = "status";
      br = "branch";
      last = "log -1 HEAD";
      unstage = "reset HEAD --";
      visual = "!gitk";
    };

    ignores = [
      "*~"
      "*.swp"
      ".DS_Store"
      "build"
      "node_modules"
    ];

    extraConfig = {
      core = {
        editor = "nvim";
        autocrlg = "input";
      };

      commit.template = "${./gitmessage.txt}";

      fetch.prune = true;

      init.defaultBranch = "main";

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

    delta = {
      enable = false;
    };

    diff-so-fancy = {
      enable = false;
    };

    difftastic = {
      enable = true;
    };

    lfs = {
      enable = true;
    };
  };
}
