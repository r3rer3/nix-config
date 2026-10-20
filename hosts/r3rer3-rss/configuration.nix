# DigitalOcean droplet running Miniflux, the sync server newsboat uses on every
# machine. Built as a custom image (`just r3rer3-rss-image`) for the first boot
# and deployed from r3rer3-linux afterwards (`just r3rer3-rss`).
{modulesPath, ...}: {
  imports = [
    (modulesPath + "/virtualisation/digital-ocean-image.nix")
    ./miniflux.nix
  ];

  networking.hostName = "r3rer3-rss";

  nix = {
    settings.experimental-features = "nix-command flakes";

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };
  };

  # deploys build on r3rer3-linux and copy the closure over as root
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN+C5/74L7+qRacWzvnrcsnUA8Li4UGs3jkNUefJJUNX r3rer3-rss"
  ];

  # the smallest droplet has 512 MB of RAM and no swap
  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 1024;
    }
  ];

  networking.firewall.allowedTCPPorts = [80 443];

  system.stateVersion = "26.05";
}
