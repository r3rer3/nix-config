{
  pkgs,
  lib,
  self,
  hostPlatform,
  users ? [],
  ...
}: {
  system.primaryUser = "r3rer3";

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    vim
    gnupg
  ];

  programs.fish.enable = true;

  environment.shells = [pkgs.fish];

  users.users = lib.genAttrs users (user: {
    home = "/Users/${user}";
    shell = pkgs.fish;
  });

  homebrew = {
    enable = true;
    onActivation.cleanup = "uninstall";

    taps = [];

    brews = [
      "kubectl"
    ];

    casks = [
      "librewolf"
      "chromium"
      "1password"
      "whatsapp"
      "docker"
    ];
  };

  # TODO duplicate with nixos
  fonts.packages =
    (builtins.filter pkgs.lib.isDerivation (builtins.attrValues pkgs.nerd-fonts))
    ++ (with pkgs; [
      inter
      monaspace
      noto-fonts-emoji
      roboto
      newcomputermodern
      eb-garamond
    ]);

  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = hostPlatform;

  # Set Git commit hash for darwin-version.
  system.configurationRevision = self.rev or self.dirtyRev or null;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 5;
}
