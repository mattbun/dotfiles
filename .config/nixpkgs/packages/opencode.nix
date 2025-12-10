{ ... }:
{
  programs.opencode.settings = {
    theme = "system";

    keybinds = {
      "app_exit" = "ctrl+c,ctrl+d,<leader>q";
    };

    disabled_providers = [
      "opencode"
    ];
  };
}
