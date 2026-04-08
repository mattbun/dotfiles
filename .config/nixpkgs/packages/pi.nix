{ config
, lib
, pkgs
, ...
}:

let
  accentColor = config.colorScheme.accentColor;
  palette = config.colorScheme.palette;
  cfg = config.programs.pi;
in

{
  options.programs.pi = {
    enable = lib.mkEnableOption "pi";

    settings = lib.mkOption {
      type = lib.types.attrs;
      default = { };
      description = "Settings for pi, stored in ~/.pi/agent/settings.json";
    };

    models = lib.mkOption {
      type = lib.types.attrs;
      default = { };
      description = "Models for pi, stored in ~/.pi/agent/models.json";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [ pi-coding-agent ];

    home.sessionVariables = {
      # Don't show "Update Available" message on startup
      PI_SKIP_VERSION_CHECK = "1";
    };

    programs.pi.settings = {
      theme = "dotfiles";
      quietStartup = true;
    };

    home.file = {
      ".pi/agent/settings.json".text = builtins.toJSON cfg.settings;
      ".pi/agent/models.json".text = builtins.toJSON cfg.models;

      ".pi/agent/themes/dotfiles.json".text = builtins.toJSON {
        name = "dotfiles";

        vars = {
          accent = "#${accentColor}";
          base00 = "#${palette.base00}";
          base01 = "#${palette.base01}";
          base02 = "#${palette.base02}";
          base03 = "#${palette.base03}";
          base04 = "#${palette.base04}";
          base05 = "#${palette.base05}";
          base06 = "#${palette.base06}";
          base07 = "#${palette.base07}";
          base08 = "#${palette.base08}";
          base09 = "#${palette.base09}";
          base0A = "#${palette.base0A}";
          base0B = "#${palette.base0B}";
          base0C = "#${palette.base0C}";
          base0D = "#${palette.base0D}";
          base0E = "#${palette.base0E}";
          base0F = "#${palette.base0F}";

          red = "#${palette.base08}";
          yellow = "#${palette.base0A}";
          green = "#${palette.base0B}";
          cyan = "#${palette.base0C}";
          blue = "#${palette.base0D}";
          magenta = "#${palette.base0E}";
        };

        colors = {
          # Core UI
          accent = "accent";
          border = "base03";
          borderAccent = "accent";
          borderMuted = "base02";
          success = "green";
          error = "red";
          warning = "yellow";
          muted = "base04";
          dim = "base03";
          text = "";
          thinkingText = "base04";

          # Backgrounds & Content
          selectedBg = "base02";
          userMessageBg = "base01";
          userMessageText = "";
          customMessageBg = "base01";
          customMessageText = "";
          customMessageLabel = "accent";
          toolPendingBg = "base01";
          toolSuccessBg = "base01";
          toolErrorBg = "base01";
          toolTitle = "accent";
          toolOutput = "";

          # Markdown
          mdHeading = "accent";
          mdLink = "accent";
          mdLinkUrl = "base04";
          mdCode = "blue";
          mdCodeBlock = "";
          mdCodeBlockBorder = "base03";
          mdQuote = "base04";
          mdQuoteBorder = "base03";
          mdHr = "base03";
          mdListBullet = "cyan";

          # Tool Diffs
          toolDiffAdded = "green";
          toolDiffRemoved = "red";
          toolDiffContext = "base04";

          # Syntax Highlighting
          syntaxComment = "base03";
          syntaxKeyword = "accent";
          syntaxFunction = "blue";
          syntaxVariable = "yellow";
          syntaxString = "green";
          syntaxNumber = "magenta";
          syntaxType = "blue";
          syntaxOperator = "accent";
          syntaxPunctuation = "base03";

          # Thinking Level Borders
          thinkingOff = "base03";
          thinkingMinimal = "accent";
          thinkingLow = "blue";
          thinkingMedium = "cyan";
          thinkingHigh = "magenta";
          thinkingXhigh = "red";

          # Bash Mode
          bashMode = "yellow";
        };
      };
    };
  };
}
