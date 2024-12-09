update:
    nix flake update

history:
    nix profile history --profile /nix/var/nix/profiles/system

gc:
    sudo nix-collect-garbage --delete-old
    nix-collect-garbage --delete-old

clean:
    # remove all generations older than 7 days
    sudo nix profile wipe-history --profile /nix/var/nix/profiles/system  --older-than 7d

repl:
    nix repl -f flake:nixpkgs

r3rer3-nixos-debug:
    sudo nixos-rebuild switch --flake .#r3rer3-linux --show-trace -L -v

r3rer3-nixos:
    sudo nixos-rebuild switch --flake .#r3rer3-linux

r3rer3-home-manager:
    home-manager switch --flake ./#r3rer3@r3rer3-linux
