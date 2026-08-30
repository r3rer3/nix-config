{
  inputs,
  config,
  ...
}: {
  imports = [inputs.hermes-agent.homeManagerModules.default];

  services.hermes-agent = {
    enable = true;

    # Managed mode: `hermes setup` and `hermes config set` are blocked, so all
    # configuration lives here and is rendered to ~/.hermes/config.yaml.
    settings = {
      # OpenRouter model id; set settings.model.base_url to use a provider directly.
      model.default = "anthropic/claude-sonnet-4";
    };

    # Secrets stay out of the Nix store. Create the file before enabling:
    #   install -m 0600 /dev/null ~/.secrets/hermes.env
    #   echo "OPENROUTER_API_KEY=sk-or-..." >> ~/.secrets/hermes.env
    # environmentFiles = ["${config.home.homeDirectory}/.secrets/hermes.env"];

    # Messaging gateway (Telegram, Discord, Slack, ...) as a user service.
    # Only useful once environmentFiles provides the platform tokens.
    # On Linux also set `users.users.r3rer3.linger = true;` at the host level,
    # or the service stops at logout.
    # gateway.enable = true;
  };

  # hermes CLI on PATH + HERMES_HOME exported for the session
  programs.hermes-agent.enable = true;
}
