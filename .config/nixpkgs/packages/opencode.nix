{ ... }:
{
  programs.opencode = {
    tui = {
      theme = "system";

      keybinds = {
        "app_exit" = "ctrl+c,ctrl+d,<leader>q";
      };
    };

    settings = {
      disabled_providers = [
        "opencode"
      ];
    };
  };
}
