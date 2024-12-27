{ username }:
{
  hosts = ["r3rer3s-MacBook-Pro" "r3rer3-linux"];

  home = import ./home { inherit username; };
}
