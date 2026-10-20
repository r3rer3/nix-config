{config, ...}: let
  rss = import ../../../hosts/r3rer3-rss/rss.nix;
  dataDir = "${config.xdg.dataHome}/newsboat";
in {
  programs.newsboat = {
    enable = true;

    # Subscriptions and read state live in Miniflux on the r3rer3-rss droplet,
    # so every machine sees the same feeds (listed in hosts/r3rer3-rss/rss.nix)
    # and the same unread articles. `just rss-token` sets up a machine's token.
    extraConfig = ''
      urls-source "miniflux"
      miniflux-url "https://${rss.domain}/"
      miniflux-tokenfile "${dataDir}/miniflux-token"
      # per feed; high enough that the whole unread backlog shows up
      miniflux-min-items 1000
      miniflux-show-special-feeds no

      delete-read-articles-on-quit yes
    '';
  };
}
