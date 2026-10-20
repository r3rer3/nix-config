{
  config,
  lib,
  pkgs,
  ...
}: let
  # the private keys live in 1Password and are served by its SSH agent
  # (1Password → Settings → Developer → Use the SSH agent); ~/.ssh only gets
  # the public halves in ./keys
  agentSocket =
    if pkgs.stdenv.isDarwin
    then "Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
    else ".1password/agent.sock";
in {
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    settings = {
      "*" = {
        # previous programs.ssh default values
        ForwardAgent = false;
        AddKeysToAgent = "no";
        Compression = false;
        ServerAliveInterval = 0;
        ServerAliveCountMax = 3;
        HashKnownHosts = false;
        UserKnownHostsFile = "~/.ssh/known_hosts";
        ControlMaster = "no";
        ControlPath = "~/.ssh/master-%r@%n:%p";
        ControlPersist = "no";

        # quoted because the macOS path has a space in it
        IdentityAgent = ''"~/${agentSocket}"'';
        # offer only the key a host names (or ~/.ssh/id_*), not every key in
        # 1Password, which trips servers' MaxAuthTries (6 by default)
        IdentitiesOnly = true;
        PreferredAuthentications = "publickey,password";
      };

      "*sr.ht" = {
        IdentityFile = ["~/.ssh/r3rer3-sourcehut.pub"];
        AddKeysToAgent = "no";
      };

      "github.com" = {
        IdentityFile = ["~/.ssh/r3rer3-github.pub"];
        AddKeysToAgent = "no";
      };

      # the Miniflux droplet (hosts/r3rer3-rss)
      "r3rer3-rss" = {
        HostName = (import ../../../../hosts/r3rer3-rss/rss.nix).domain;
        User = "root";
        IdentityFile = ["~/.ssh/r3rer3-rss.pub"];
        AddKeysToAgent = "no";
      };
    };
  };

  # `IdentityFile ~/.ssh/<name>.pub` makes ssh ask the agent for that one key
  home.file =
    lib.mapAttrs'
    (name: _: lib.nameValuePair ".ssh/${name}" {source = ./keys/${name};})
    (builtins.readDir ./keys);

  # for tools that skip ~/.ssh/config's IdentityAgent (ssh-add -l, paramiko, …)
  home.sessionVariables.SSH_AUTH_SOCK = "${config.home.homeDirectory}/${agentSocket}";
}
