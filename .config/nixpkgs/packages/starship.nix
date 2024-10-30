{ lib
, ...
}:
{
  programs.starship = {
    enableBashIntegration = false;

    settings = {
      add_newline = false;
      format = lib.concatStrings [
        "$username"
        "$hostname"
        "$directory"
        "$git_branch"
        "$git_state"
        "$git_status"
        "$cmd_duration"
        "$status"
        "$character"
      ];
      username = {
        format = "[$user]($style)";
        style_user = "bright-black";
        style_root = "red";
        detect_env_vars = [
          "SSH_CONNECTION"
        ];
      };
      hostname = {
        format = "[@$hostname]($style) ";
        style = "bright-black";
      };
      directory = {
        style = "blue";
        read_only = " [RO]";
      };
      git_branch = {
        format = "[$branch]($style) ";
        style = "bright-black";
      };
      git_status = {
        format = "[$modified$untracked](bright-black)[$deleted](red)[$staged$renamed](green)[$conflicted](yellow)[$ahead_behind](cyan)";

        staged = "+$count ";
        deleted = "×$count ";
        renamed = "~$count ";

        conflicted = "=$count ";
        modified = "!$count ";
        untracked = "?$count ";

        ahead = "⇡$count ";
        behind = "⇣$count ";
        diverged = "$ahead_count⇕$behind_count ";
      };
      cmd_duration = {
        format = "[$duration]($style) ";
        style = "yellow";
      };
      status = {
        format = "[$common_meaning$signal_name\\($status\\)]($style) ";
        pipestatus_format = "$pipestatus|$common_meaning$signal_name\\($status\\)]($style) ";
        disabled = false;
      };
      character = {
        success_symbol = "\\$";
        error_symbol = "[\\$](red)";
      };
    };
  };
}
