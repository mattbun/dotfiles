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
          # Use hex value for accent if it's not one of the first 16 ansi colors
          accent = if config.colorScheme.accentIsAnsi then config.colorScheme.accentAnsiNumber else "#${accentColor}";
          black = 0;
          red = 1;
          green = 2;
          yellow = 3;
          blue = 4;
          magenta = 5;
          cyan = 6;
          white = 7;
          bright-black = 8;
          bright-white = 15;
        };

        colors = {
          # Core UI
          accent = "accent";
          border = "bright-black";
          borderAccent = "accent";
          borderMuted = "black";
          success = "green";
          error = "red";
          warning = "yellow";
          muted = "bright-black";
          dim = "bright-black";
          text = "";
          thinkingText = "bright-black";

          # Backgrounds & Content
          selectedBg = "black";
          userMessageBg = "black";
          userMessageText = "";
          customMessageBg = "black";
          customMessageText = "";
          customMessageLabel = "accent";
          toolPendingBg = "black";
          toolSuccessBg = "black";
          toolErrorBg = "black";
          toolTitle = "accent";
          toolOutput = "";

          # Markdown
          mdHeading = "accent";
          mdLink = "accent";
          mdLinkUrl = "bright-black";
          mdCode = "blue";
          mdCodeBlock = "";
          mdCodeBlockBorder = "bright-black";
          mdQuote = "bright-black";
          mdQuoteBorder = "bright-black";
          mdHr = "bright-black";
          mdListBullet = "cyan";

          # Tool Diffs
          toolDiffAdded = "green";
          toolDiffRemoved = "red";
          toolDiffContext = "bright-black";

          # Syntax Highlighting
          syntaxComment = "bright-black";
          syntaxKeyword = "accent";
          syntaxFunction = "blue";
          syntaxVariable = "yellow";
          syntaxString = "green";
          syntaxNumber = "magenta";
          syntaxType = "blue";
          syntaxOperator = "accent";
          syntaxPunctuation = "bright-black";

          # Thinking Level Borders
          thinkingOff = "bright-black";
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
