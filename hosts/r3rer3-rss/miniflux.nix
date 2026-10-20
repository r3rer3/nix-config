{
  config,
  lib,
  pkgs,
  ...
}: let
  rss = import ./rss.nix;

  credentials = "/var/lib/miniflux-admin/credentials";
  listenAddr = config.services.miniflux.config.LISTEN_ADDR;

  reconcileFeeds = pkgs.writeShellApplication {
    name = "miniflux-feeds";
    runtimeInputs = [pkgs.curl pkgs.jq];
    text = builtins.readFile ./miniflux-feeds.sh;
  };
  feeds = pkgs.writeText "miniflux-feeds.json" (builtins.toJSON rss.feeds);
in {
  services.miniflux = {
    enable = true;
    adminCredentialsFile = credentials;

    config = {
      BASE_URL = "https://${rss.domain}/";
      # never archive unread entries; part of the backlog was imported from
      # newsboat and can't be fetched again
      CLEANUP_ARCHIVE_UNREAD_DAYS = -1;
    };
  };

  # Generated on first boot so no secret has to be provisioned. Log in to the
  # web UI with it: ssh r3rer3-rss cat /var/lib/miniflux-admin/credentials
  systemd.services.miniflux-admin-credentials = {
    description = "Generate Miniflux admin credentials";
    requiredBy = ["miniflux.service"];
    before = ["miniflux.service"];
    path = [pkgs.openssl];
    script = ''
      if [ ! -s ${credentials} ]; then
        printf 'ADMIN_USERNAME=r3rer3\nADMIN_PASSWORD=%s\n' "$(openssl rand -hex 16)" > ${credentials}
      fi
    '';
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      StateDirectory = "miniflux-admin";
      StateDirectoryMode = "0700";
      UMask = "0077";
    };
  };

  # reruns on every deploy that changes rss.nix
  systemd.services.miniflux-feeds = {
    description = "Reconcile Miniflux subscriptions with rss.nix";
    wantedBy = ["multi-user.target"];
    requires = ["miniflux.service"];
    after = ["miniflux.service"];
    environment.MINIFLUX_URL = "http://${listenAddr}";
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      EnvironmentFile = credentials;
      ExecStart = "${lib.getExe reconcileFeeds} ${feeds}";
    };
  };

  services.caddy = {
    enable = true;
    virtualHosts.${rss.domain}.extraConfig = ''
      reverse_proxy ${listenAddr}
    '';
  };
}
