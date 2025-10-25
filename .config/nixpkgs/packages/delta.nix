{ config, lib, ... }: {
  programs.git.delta = {
    enable = lib.mkDefault true;

    options = {
      navigate = true; # use n and N to move between diff sections
      line-numbers = true;
      features = "line-numbers";
      dark = true;
      syntax-theme = "none"; # disabled because it can be hard to read colors on colors
      file-style = "white";
      file-decoration-style = "none";
      file-added-label = "[+]";
      file-copied-label = "[<>]";
      file-modified-label = "[~]";
      file-removed-label = "[-]";
      file-renamed-label = "[->]";
      hunk-header-decoration-style = ''blue box ul'';
      plus-style = "green black";
      plus-emph-style = "black green";
      minus-style = "red black";
      minus-emph-style = "black red";
      line-numbers-minus-style = "red";
      line-numbers-plus-style = "green";
      whitespace-error-style = "orange bold";
      blame-palette = ''#${config.colorScheme.palette.base00} #${config.colorScheme.palette.base01} #${config.colorScheme.palette.base02}'';
      merge-conflict-begin-symbol = "~";
      merge-conflict-end-symbol = "~";
      merge-conflict-ours-diff-header-style = "yellow bold";
      merge-conflict-ours-diff-header-decoration-style = ''"#${config.colorScheme.palette.base01}" box'';
      merge-conflict-theirs-diff-header-style = "yellow bold";
      merge-conflict-theirs-diff-header-decoration-style = ''"#${config.colorScheme.palette.base01}" box'';
    };
  };
}
