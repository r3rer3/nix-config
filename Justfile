update:
    nix flake update

history:
    nix profile history --profile /nix/var/nix/profiles/system

gc:
    sudo nix-collect-garbage --delete-old
    nix-collect-garbage --delete-old

clean:
    # remove all generations older than 7 days
    sudo nix profile wipe-history --profile /nix/var/nix/profiles/system --older-than 7d

repl:
    nix repl -f flake:nixpkgs

[linux]
r3rer3-nixos-debug:
    sudo nixos-rebuild switch --flake .#r3rer3-linux --show-trace -L -v

[linux]
r3rer3-nixos:
    sudo nixos-rebuild switch --flake .#r3rer3-linux

[macos]
r3rer3-darwin:
    sudo darwin-rebuild switch --flake .#r3rer3s-MacBook-Pro

[macos]
r3rer3-darwin-air:
    sudo darwin-rebuild switch --flake .#r3rer3s-MacBook-Air

# DigitalOcean custom image for the droplet's first boot
[linux]
r3rer3-rss-image:
    nix build .#nixosConfigurations.r3rer3-rss.config.system.build.digitalOceanImage

[linux]
r3rer3-rss:
    nixos-rebuild switch --flake .#r3rer3-rss --target-host r3rer3-rss

# creates a Miniflux API key for this machine's newsboat; asks for the Miniflux password
rss-token:
    #!/usr/bin/env bash
    set -euo pipefail
    domain=$(nix eval --raw --file hosts/r3rer3-rss/rss.nix domain)
    key=$(curl --fail-with-body -sS -u r3rer3 -X POST -H 'Content-Type: application/json' \
      -d "{\"description\": \"newsboat on $(hostname)\"}" "https://$domain/v1/api-keys")
    mkdir -p ~/.local/share/newsboat
    (umask 077 && jq -r .token <<<"$key" > ~/.local/share/newsboat/miniflux-token)

# stores each of this machine's PGP secret keys in 1Password as a document tagged "pgp"
pgp-backup:
    #!/usr/bin/env bash
    set -euo pipefail
    for fpr in $(gpg --list-secret-keys --with-colons | awk -F: '$1 == "sec" {sec = 1; next} $1 == "fpr" && sec {print $10; sec = 0}'); do
      uid=$(gpg --list-keys --with-colons "$fpr" | awk -F: '$1 == "uid" {print $10; exit}')
      gpg --export-secret-keys --armor "$fpr" |
        op document create - --title "PGP $uid" --file-name "$fpr.asc" --tags pgp >/dev/null
      echo "stored $fpr ($uid)"
    done

# imports the PGP secret keys stored by pgp-backup and trusts them ultimately
pgp-restore:
    #!/usr/bin/env bash
    set -euo pipefail
    for id in $(op item list --categories Document --tags pgp --format json | jq -r '.[].id'); do
      op document get "$id" | gpg --batch --import
    done
    gpg --list-secret-keys --with-colons |
      awk -F: '$1 == "sec" {sec = 1; next} $1 == "fpr" && sec {print $10 ":6:"; sec = 0}' |
      gpg --import-ownertrust
