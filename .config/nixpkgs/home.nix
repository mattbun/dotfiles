{ config
, pkgs
, nix-colors
, username
, homeDirectory
, ...
}:
let
  gitName = "Matt Rathbun";
  gitEmail = "5514636+mattbun@users.noreply.github.com";

  packageSets = [
    # "docker"
    # "graphical"
    # "kubernetes"
  ];
  additionalPackages = [ ];

  nix-colors-lib = nix-colors.lib-contrib { inherit pkgs; };
in
{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = username;
  home.homeDirectory = homeDirectory;

  home.packages = import ./packages.nix {
    pkgs = pkgs;
    packageSets = packageSets;
    additionalPackages = additionalPackages;
  };

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "22.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  imports = [
    nix-colors.homeManagerModule
  ];

  colorScheme = nix-colors.colorSchemes.helios;
  # colorScheme = {
  #   slug = "...";
  #   name = "...";
  #   colors = {
  #     base00 = "000000"; # ----
  #     base01 = "000000"; # ---
  #     base02 = "000000"; # --
  #     base03 = "000000"; # -
  #     base04 = "000000"; # +
  #     base05 = "000000"; # ++
  #     base06 = "000000"; # +++
  #     base07 = "000000"; # ++++
  #     base08 = "000000"; # red
  #     base09 = "000000"; # orange
  #     base0A = "000000"; # yellow
  #     base0B = "000000"; # green
  #     base0C = "000000"; # aqua/cyan
  #     base0D = "000000"; # blue
  #     base0E = "000000"; # purple
  #     base0F = "000000"; # brown
  #   };
  # };

  nix = {
    enable = true;
    package = pkgs.nix;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  programs.bat = {
    enable = true;
    config = {
      theme = "base16";
    };
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;

    defaultOptions = [
      "--color=bg+:#${config.colorScheme.colors.base01}"
      "--color=bg:#${config.colorScheme.colors.base00}"
      "--color=spinner:#${config.colorScheme.colors.base0C}"
      "--color=hl:#${config.colorScheme.colors.base0D}"
      "--color=fg:#${config.colorScheme.colors.base04}"
      "--color=header:#${config.colorScheme.colors.base0D}"
      "--color=info:#${config.colorScheme.colors.base0A}"
      "--color=pointer:#${config.colorScheme.colors.base0C}"
      "--color=marker:#${config.colorScheme.colors.base0C}"
      "--color=fg+:#${config.colorScheme.colors.base06}"
      "--color=prompt:#${config.colorScheme.colors.base0A}"
      "--color=hl+:#${config.colorScheme.colors.base0D}"
    ];
  };

  programs.git = {
    enable = true;

    userName = gitName;
    userEmail = gitEmail;

    aliases = {
      s = "status";
      o = "open";
      last = "log -1 HEAD";
      main-branch = "!git symbolic-ref refs/remotes/origin/HEAD | cut -d'/' -f4";
      com = "!f(){ git checkout $(git main-branch) $@;}; f";
    };

    delta = {
      enable = true;
      options = {
        features = "line-numbers decorations";
      };
    };

    extraConfig = {
      init = {
        defaultBranch = "main";
      };
      diff = {
        tool = "nvimdiff";
      };
      merge = {
        tool = "nvimdiff";
      };
      mergetool = {
        "vimdiff" = {
          path = "${pkgs.neovim}/bin/nvim";
        };
      };
    };
  };

  xdg.configFile."nvim/init.lua".text = ''
    vim.cmd([[
      source ~/.vimrc
    ]])

    require("lsp")
    require("plugins")
    require("mappings")
    vim.cmd([[
      source ~/.config/nvim/colorscheme.vim
    ]])

    -- show substitutions
    vim.o.inccommand = "nosplit"
  '';

  xdg.configFile."nvim/colorscheme.vim".text = ''
    " Based on https://github.com/chriskempson/base16-vim, changes are denoted with 'XXX'
    " GUI color definitions
    let s:gui00        = "${config.colorScheme.colors.base00}"
    let g:base16_gui00 = "${config.colorScheme.colors.base00}"
    let s:gui01        = "${config.colorScheme.colors.base01}"
    let g:base16_gui01 = "${config.colorScheme.colors.base01}"
    let s:gui02        = "${config.colorScheme.colors.base02}"
    let g:base16_gui02 = "${config.colorScheme.colors.base02}"
    let s:gui03        = "${config.colorScheme.colors.base03}"
    let g:base16_gui03 = "${config.colorScheme.colors.base03}"
    let s:gui04        = "${config.colorScheme.colors.base04}"
    let g:base16_gui04 = "${config.colorScheme.colors.base04}"
    let s:gui05        = "${config.colorScheme.colors.base05}"
    let g:base16_gui05 = "${config.colorScheme.colors.base05}"
    let s:gui06        = "${config.colorScheme.colors.base06}"
    let g:base16_gui06 = "${config.colorScheme.colors.base06}"
    let s:gui07        = "${config.colorScheme.colors.base07}"
    let g:base16_gui07 = "${config.colorScheme.colors.base07}"
    let s:gui08        = "${config.colorScheme.colors.base08}"
    let g:base16_gui08 = "${config.colorScheme.colors.base08}"
    let s:gui09        = "${config.colorScheme.colors.base09}"
    let g:base16_gui09 = "${config.colorScheme.colors.base09}"
    let s:gui0A        = "${config.colorScheme.colors.base0A}"
    let g:base16_gui0A = "${config.colorScheme.colors.base0A}"
    let s:gui0B        = "${config.colorScheme.colors.base0B}"
    let g:base16_gui0B = "${config.colorScheme.colors.base0B}"
    let s:gui0C        = "${config.colorScheme.colors.base0C}"
    let g:base16_gui0C = "${config.colorScheme.colors.base0C}"
    let s:gui0D        = "${config.colorScheme.colors.base0D}"
    let g:base16_gui0D = "${config.colorScheme.colors.base0D}"
    let s:gui0E        = "${config.colorScheme.colors.base0E}"
    let g:base16_gui0E = "${config.colorScheme.colors.base0E}"
    let s:gui0F        = "${config.colorScheme.colors.base0F}"
    let g:base16_gui0F = "${config.colorScheme.colors.base0F}"

    " Terminal color definitions
    let s:cterm00        = "00"
    let g:base16_cterm00 = "00"
    let s:cterm03        = "08"
    let g:base16_cterm03 = "08"
    let s:cterm05        = "07"
    let g:base16_cterm05 = "07"
    let s:cterm07        = "15"
    let g:base16_cterm07 = "15"
    let s:cterm08        = "01"
    let g:base16_cterm08 = "01"
    let s:cterm0A        = "03"
    let g:base16_cterm0A = "03"
    let s:cterm0B        = "02"
    let g:base16_cterm0B = "02"
    let s:cterm0C        = "06"
    let g:base16_cterm0C = "06"
    let s:cterm0D        = "04"
    let g:base16_cterm0D = "04"
    let s:cterm0E        = "05"
    let g:base16_cterm0E = "05"
    if exists("base16colorspace") && base16colorspace == "256"
      let s:cterm01        = "18"
      let g:base16_cterm01 = "18"
      let s:cterm02        = "19"
      let g:base16_cterm02 = "19"
      let s:cterm04        = "20"
      let g:base16_cterm04 = "20"
      let s:cterm06        = "21"
      let g:base16_cterm06 = "21"
      let s:cterm09        = "16"
      let g:base16_cterm09 = "16"
      let s:cterm0F        = "17"
      let g:base16_cterm0F = "17"
    else
      let s:cterm01        = "10"
      let g:base16_cterm01 = "10"
      let s:cterm02        = "11"
      let g:base16_cterm02 = "11"
      let s:cterm04        = "12"
      let g:base16_cterm04 = "12"
      let s:cterm06        = "13"
      let g:base16_cterm06 = "13"
      let s:cterm09        = "09"
      let g:base16_cterm09 = "09"
      let s:cterm0F        = "14"
      let g:base16_cterm0F = "14"
    endif

    " Neovim terminal colours
    if has("nvim")
      let g:terminal_color_0 =  "#${config.colorScheme.colors.base00}"
      let g:terminal_color_1 =  "#${config.colorScheme.colors.base08}"
      let g:terminal_color_2 =  "#${config.colorScheme.colors.base0B}"
      let g:terminal_color_3 =  "#${config.colorScheme.colors.base0A}"
      let g:terminal_color_4 =  "#${config.colorScheme.colors.base0D}"
      let g:terminal_color_5 =  "#${config.colorScheme.colors.base0E}"
      let g:terminal_color_6 =  "#${config.colorScheme.colors.base0C}"
      let g:terminal_color_7 =  "#${config.colorScheme.colors.base05}"
      let g:terminal_color_8 =  "#${config.colorScheme.colors.base03}"
      let g:terminal_color_9 =  "#${config.colorScheme.colors.base08}"
      let g:terminal_color_10 = "#${config.colorScheme.colors.base0B}"
      let g:terminal_color_11 = "#${config.colorScheme.colors.base0A}"
      let g:terminal_color_12 = "#${config.colorScheme.colors.base0D}"
      let g:terminal_color_13 = "#${config.colorScheme.colors.base0E}"
      let g:terminal_color_14 = "#${config.colorScheme.colors.base0C}"
      let g:terminal_color_15 = "#${config.colorScheme.colors.base07}"
      let g:terminal_color_background = g:terminal_color_0
      let g:terminal_color_foreground = g:terminal_color_5
      if &background == "light"
        let g:terminal_color_background = g:terminal_color_7
        let g:terminal_color_foreground = g:terminal_color_2
      endif
    elseif has("terminal")
      let g:terminal_ansi_colors = [
            \ "#${config.colorScheme.colors.base00}",
            \ "#${config.colorScheme.colors.base08}",
            \ "#${config.colorScheme.colors.base0B}",
            \ "#${config.colorScheme.colors.base0A}",
            \ "#${config.colorScheme.colors.base0D}",
            \ "#${config.colorScheme.colors.base0E}",
            \ "#${config.colorScheme.colors.base0C}",
            \ "#${config.colorScheme.colors.base05}",
            \ "#${config.colorScheme.colors.base03}",
            \ "#${config.colorScheme.colors.base08}",
            \ "#${config.colorScheme.colors.base0B}",
            \ "#${config.colorScheme.colors.base0A}",
            \ "#${config.colorScheme.colors.base0D}",
            \ "#${config.colorScheme.colors.base0E}",
            \ "#${config.colorScheme.colors.base0C}",
            \ "#${config.colorScheme.colors.base07}",
            \ ]
    endif

    " Theme setup
    hi clear
    syntax reset
    let g:colors_name = "nix-${config.colorScheme.slug}" " XXX

    " Highlighting function
    " Optional variables are attributes and guisp
    function! g:Base16hi(group, guifg, guibg, ctermfg, ctermbg, ...)
      let l:attr = get(a:, 1, "")
      let l:guisp = get(a:, 2, "")

      " See :help highlight-guifg
      let l:gui_special_names = ["NONE", "bg", "background", "fg", "foreground"]

      if a:guifg != ""
        if index(l:gui_special_names, a:guifg) >= 0
          exec "hi " . a:group . " guifg=" . a:guifg
        else
          exec "hi " . a:group . " guifg=#" . a:guifg
        endif
      endif
      if a:guibg != ""
        if index(l:gui_special_names, a:guibg) >= 0
          exec "hi " . a:group . " guibg=" . a:guibg
        else
          exec "hi " . a:group . " guibg=#" . a:guibg
        endif
      endif
      if a:ctermfg != ""
        exec "hi " . a:group . " ctermfg=" . a:ctermfg
      endif
      if a:ctermbg != ""
        exec "hi " . a:group . " ctermbg=" . a:ctermbg
      endif
      if l:attr != ""
        exec "hi " . a:group . " gui=" . l:attr . " cterm=" . l:attr
      endif
      if l:guisp != ""
        if index(l:gui_special_names, l:guisp) >= 0
          exec "hi " . a:group . " guisp=" . l:guisp
        else
          exec "hi " . a:group . " guisp=#" . l:guisp
        endif
      endif
    endfunction


    fun <sid>hi(group, guifg, guibg, ctermfg, ctermbg, attr, guisp)
      call g:Base16hi(a:group, a:guifg, a:guibg, a:ctermfg, a:ctermbg, a:attr, a:guisp)
    endfun

    " Vim editor colors
    call <sid>hi("Normal",        s:gui05, s:gui00, s:cterm05, s:cterm00, "", "")
    call <sid>hi("Bold",          "", "", "", "", "bold", "")
    call <sid>hi("Debug",         s:gui08, "", s:cterm08, "", "", "")
    call <sid>hi("Directory",     s:gui0D, "", s:cterm0D, "", "", "")
    call <sid>hi("Error",         s:gui00, s:gui08, s:cterm00, s:cterm08, "", "")
    call <sid>hi("ErrorMsg",      s:gui08, s:gui00, s:cterm08, s:cterm00, "", "")
    call <sid>hi("Exception",     s:gui08, "", s:cterm08, "", "", "")
    call <sid>hi("FoldColumn",    s:gui0C, s:gui01, s:cterm0C, s:cterm01, "", "")
    call <sid>hi("Folded",        s:gui03, s:gui01, s:cterm03, s:cterm01, "", "")
    call <sid>hi("IncSearch",     s:gui01, s:gui09, s:cterm01, s:cterm09, "none", "")
    call <sid>hi("Italic",        "", "", "", "", "none", "")
    call <sid>hi("Macro",         s:gui08, "", s:cterm08, "", "", "")
    call <sid>hi("MatchParen",    "", s:gui03, "", s:cterm03,  "", "")
    call <sid>hi("ModeMsg",       s:gui0B, "", s:cterm0B, "", "", "")
    call <sid>hi("MoreMsg",       s:gui0B, "", s:cterm0B, "", "", "")
    call <sid>hi("Question",      s:gui0D, "", s:cterm0D, "", "", "")
    call <sid>hi("Search",        s:gui01, s:gui0A, s:cterm01, s:cterm0A,  "", "")
    call <sid>hi("Substitute",    s:gui01, s:gui0A, s:cterm01, s:cterm0A, "none", "")
    call <sid>hi("SpecialKey",    s:gui03, "", s:cterm03, "", "", "")
    call <sid>hi("TooLong",       s:gui08, "", s:cterm08, "", "", "")
    call <sid>hi("Underlined",    s:gui08, "", s:cterm08, "", "", "")
    call <sid>hi("Visual",        "", s:gui02, "", s:cterm02, "", "")
    call <sid>hi("VisualNOS",     s:gui08, "", s:cterm08, "", "", "")
    call <sid>hi("WarningMsg",    s:gui08, "", s:cterm08, "", "", "")
    call <sid>hi("WildMenu",      s:gui08, s:gui0A, s:cterm08, "", "", "")
    call <sid>hi("Title",         s:gui0D, "", s:cterm0D, "", "none", "")
    call <sid>hi("Conceal",       s:gui0D, s:gui00, s:cterm0D, s:cterm00, "", "")
    call <sid>hi("Cursor",        s:gui00, s:gui05, s:cterm00, s:cterm05, "", "")
    call <sid>hi("NonText",       s:gui03, "", s:cterm03, "", "", "")
    call <sid>hi("LineNr",        s:gui03, s:gui00, s:cterm03, s:cterm01, "", "") " XXX
    call <sid>hi("SignColumn",    s:gui03, s:gui00, s:cterm03, s:cterm01, "", "") " XXX
    call <sid>hi("StatusLine",    s:gui04, s:gui02, s:cterm04, s:cterm02, "none", "")
    call <sid>hi("StatusLineNC",  s:gui03, s:gui01, s:cterm03, s:cterm01, "none", "")
    call <sid>hi("VertSplit",     s:gui02, s:gui00, s:cterm02, s:cterm02, "none", "") " XXX
    call <sid>hi("ColorColumn",   "", s:gui01, "", s:cterm01, "none", "")
    call <sid>hi("CursorColumn",  "", s:gui01, "", s:cterm01, "none", "")
    call <sid>hi("CursorLine",    "", s:gui01, "", s:cterm01, "none", "")
    call <sid>hi("CursorLineNr",  s:gui04, s:gui01, s:cterm04, s:cterm01, "", "")
    call <sid>hi("QuickFixLine",  "", s:gui01, "", s:cterm01, "none", "")
    call <sid>hi("PMenu",         s:gui05, s:gui01, s:cterm05, s:cterm01, "none", "")
    call <sid>hi("PMenuSel",      s:gui01, s:gui05, s:cterm01, s:cterm05, "", "")
    call <sid>hi("TabLine",       s:gui03, s:gui01, s:cterm03, s:cterm01, "none", "")
    call <sid>hi("TabLineFill",   s:gui03, s:gui01, s:cterm03, s:cterm01, "none", "")
    call <sid>hi("TabLineSel",    s:gui0B, s:gui01, s:cterm0B, s:cterm01, "none", "")

    " Standard syntax highlighting
    call <sid>hi("Boolean",      s:gui09, "", s:cterm09, "", "", "")
    call <sid>hi("Character",    s:gui08, "", s:cterm08, "", "", "")
    call <sid>hi("Comment",      s:gui03, "", s:cterm03, "", "", "")
    call <sid>hi("Conditional",  s:gui0E, "", s:cterm0E, "", "", "")
    call <sid>hi("Constant",     s:gui09, "", s:cterm09, "", "", "")
    call <sid>hi("Define",       s:gui0E, "", s:cterm0E, "", "none", "")
    call <sid>hi("Delimiter",    s:gui0F, "", s:cterm0F, "", "", "")
    call <sid>hi("Float",        s:gui09, "", s:cterm09, "", "", "")
    call <sid>hi("Function",     s:gui0D, "", s:cterm0D, "", "", "")
    call <sid>hi("Identifier",   s:gui08, "", s:cterm08, "", "none", "")
    call <sid>hi("Include",      s:gui0D, "", s:cterm0D, "", "", "")
    call <sid>hi("Keyword",      s:gui0E, "", s:cterm0E, "", "", "")
    call <sid>hi("Label",        s:gui0A, "", s:cterm0A, "", "", "")
    call <sid>hi("Number",       s:gui09, "", s:cterm09, "", "", "")
    call <sid>hi("Operator",     s:gui05, "", s:cterm05, "", "none", "")
    call <sid>hi("PreProc",      s:gui0A, "", s:cterm0A, "", "", "")
    call <sid>hi("Repeat",       s:gui0A, "", s:cterm0A, "", "", "")
    call <sid>hi("Special",      s:gui0C, "", s:cterm0C, "", "", "")
    call <sid>hi("SpecialChar",  s:gui0F, "", s:cterm0F, "", "", "")
    call <sid>hi("Statement",    s:gui08, "", s:cterm08, "", "", "")
    call <sid>hi("StorageClass", s:gui0A, "", s:cterm0A, "", "", "")
    call <sid>hi("String",       s:gui0B, "", s:cterm0B, "", "", "")
    call <sid>hi("Structure",    s:gui0E, "", s:cterm0E, "", "", "")
    call <sid>hi("Tag",          s:gui0A, "", s:cterm0A, "", "", "")
    call <sid>hi("Todo",         s:gui0A, s:gui01, s:cterm0A, s:cterm01, "", "")
    call <sid>hi("Type",         s:gui0A, "", s:cterm0A, "", "none", "")
    call <sid>hi("Typedef",      s:gui0A, "", s:cterm0A, "", "", "")

    " C highlighting
    call <sid>hi("cOperator",   s:gui0C, "", s:cterm0C, "", "", "")
    call <sid>hi("cPreCondit",  s:gui0E, "", s:cterm0E, "", "", "")

    " C# highlighting
    call <sid>hi("csClass",                 s:gui0A, "", s:cterm0A, "", "", "")
    call <sid>hi("csAttribute",             s:gui0A, "", s:cterm0A, "", "", "")
    call <sid>hi("csModifier",              s:gui0E, "", s:cterm0E, "", "", "")
    call <sid>hi("csType",                  s:gui08, "", s:cterm08, "", "", "")
    call <sid>hi("csUnspecifiedStatement",  s:gui0D, "", s:cterm0D, "", "", "")
    call <sid>hi("csContextualStatement",   s:gui0E, "", s:cterm0E, "", "", "")
    call <sid>hi("csNewDecleration",        s:gui08, "", s:cterm08, "", "", "")

    " CSS highlighting
    call <sid>hi("cssBraces",      s:gui05, "", s:cterm05, "", "", "")
    call <sid>hi("cssClassName",   s:gui0E, "", s:cterm0E, "", "", "")
    call <sid>hi("cssColor",       s:gui0C, "", s:cterm0C, "", "", "")

    " Diff highlighting
    call <sid>hi("DiffAdd",      s:gui0B, s:gui00,  s:cterm0B, s:cterm01, "", "") " XXX
    call <sid>hi("DiffChange",   s:gui03, s:gui00,  s:cterm03, s:cterm01, "", "") " XXX
    call <sid>hi("DiffDelete",   s:gui08, s:gui00,  s:cterm08, s:cterm01, "", "") " XXX
    call <sid>hi("DiffText",     s:gui0D, s:gui00,  s:cterm0D, s:cterm01, "", "") " XXX
    call <sid>hi("DiffAdded",    s:gui0B, s:gui00,  s:cterm0B, s:cterm00, "", "")
    call <sid>hi("DiffFile",     s:gui08, s:gui00,  s:cterm08, s:cterm00, "", "")
    call <sid>hi("DiffNewFile",  s:gui0B, s:gui00,  s:cterm0B, s:cterm00, "", "")
    call <sid>hi("DiffLine",     s:gui0D, s:gui00,  s:cterm0D, s:cterm00, "", "")
    call <sid>hi("DiffRemoved",  s:gui08, s:gui00,  s:cterm08, s:cterm00, "", "")

    " Git highlighting
    call <sid>hi("gitcommitOverflow",       s:gui08, "", s:cterm08, "", "", "")
    call <sid>hi("gitcommitSummary",        s:gui0B, "", s:cterm0B, "", "", "")
    call <sid>hi("gitcommitComment",        s:gui03, "", s:cterm03, "", "", "")
    call <sid>hi("gitcommitUntracked",      s:gui03, "", s:cterm03, "", "", "")
    call <sid>hi("gitcommitDiscarded",      s:gui03, "", s:cterm03, "", "", "")
    call <sid>hi("gitcommitSelected",       s:gui03, "", s:cterm03, "", "", "")
    call <sid>hi("gitcommitHeader",         s:gui0E, "", s:cterm0E, "", "", "")
    call <sid>hi("gitcommitSelectedType",   s:gui0D, "", s:cterm0D, "", "", "")
    call <sid>hi("gitcommitUnmergedType",   s:gui0D, "", s:cterm0D, "", "", "")
    call <sid>hi("gitcommitDiscardedType",  s:gui0D, "", s:cterm0D, "", "", "")
    call <sid>hi("gitcommitBranch",         s:gui09, "", s:cterm09, "", "bold", "")
    call <sid>hi("gitcommitUntrackedFile",  s:gui0A, "", s:cterm0A, "", "", "")
    call <sid>hi("gitcommitUnmergedFile",   s:gui08, "", s:cterm08, "", "bold", "")
    call <sid>hi("gitcommitDiscardedFile",  s:gui08, "", s:cterm08, "", "bold", "")
    call <sid>hi("gitcommitSelectedFile",   s:gui0B, "", s:cterm0B, "", "bold", "")

    " GitGutter highlighting
    call <sid>hi("GitGutterAdd",     s:gui0B, s:gui00, s:cterm0B, s:cterm01, "", "") " XXX
    call <sid>hi("GitGutterChange",  s:gui0D, s:gui00, s:cterm0D, s:cterm01, "", "") " XXX
    call <sid>hi("GitGutterDelete",  s:gui08, s:gui00, s:cterm08, s:cterm01, "", "") " XXX
    call <sid>hi("GitGutterChangeDelete",  s:gui0E, s:gui00, s:cterm0E, s:cterm01, "", "") " XXX

    " HTML highlighting
    call <sid>hi("htmlBold",    s:gui0A, "", s:cterm0A, "", "", "")
    call <sid>hi("htmlItalic",  s:gui0E, "", s:cterm0E, "", "", "")
    call <sid>hi("htmlEndTag",  s:gui05, "", s:cterm05, "", "", "")
    call <sid>hi("htmlTag",     s:gui05, "", s:cterm05, "", "", "")

    " JavaScript highlighting
    call <sid>hi("javaScript",        s:gui05, "", s:cterm05, "", "", "")
    call <sid>hi("javaScriptBraces",  s:gui05, "", s:cterm05, "", "", "")
    call <sid>hi("javaScriptNumber",  s:gui09, "", s:cterm09, "", "", "")
    " pangloss/vim-javascript highlighting
    call <sid>hi("jsOperator",          s:gui0D, "", s:cterm0D, "", "", "")
    call <sid>hi("jsStatement",         s:gui0E, "", s:cterm0E, "", "", "")
    call <sid>hi("jsReturn",            s:gui0E, "", s:cterm0E, "", "", "")
    call <sid>hi("jsThis",              s:gui08, "", s:cterm08, "", "", "")
    call <sid>hi("jsClassDefinition",   s:gui0A, "", s:cterm0A, "", "", "")
    call <sid>hi("jsFunction",          s:gui0E, "", s:cterm0E, "", "", "")
    call <sid>hi("jsFuncName",          s:gui0D, "", s:cterm0D, "", "", "")
    call <sid>hi("jsFuncCall",          s:gui0D, "", s:cterm0D, "", "", "")
    call <sid>hi("jsClassFuncName",     s:gui0D, "", s:cterm0D, "", "", "")
    call <sid>hi("jsClassMethodType",   s:gui0E, "", s:cterm0E, "", "", "")
    call <sid>hi("jsRegexpString",      s:gui0C, "", s:cterm0C, "", "", "")
    call <sid>hi("jsGlobalObjects",     s:gui0A, "", s:cterm0A, "", "", "")
    call <sid>hi("jsGlobalNodeObjects", s:gui0A, "", s:cterm0A, "", "", "")
    call <sid>hi("jsExceptions",        s:gui0A, "", s:cterm0A, "", "", "")
    call <sid>hi("jsBuiltins",          s:gui0A, "", s:cterm0A, "", "", "")

    " LSP highlighting
    call <sid>hi("LspDiagnosticsDefaultError", s:gui08, "", s:cterm08, "", "", "")
    call <sid>hi("LspDiagnosticsDefaultWarning", s:gui09, "", s:cterm09, "", "", "")
    call <sid>hi("LspDiagnosticsDefaultHnformation", s:gui05, "", s:cterm05, "", "", "")
    call <sid>hi("LspDiagnosticsDefaultHint", s:gui03, "", s:cterm03, "", "", "")

    " Mail highlighting
    call <sid>hi("mailQuoted1",  s:gui0A, "", s:cterm0A, "", "", "")
    call <sid>hi("mailQuoted2",  s:gui0B, "", s:cterm0B, "", "", "")
    call <sid>hi("mailQuoted3",  s:gui0E, "", s:cterm0E, "", "", "")
    call <sid>hi("mailQuoted4",  s:gui0C, "", s:cterm0C, "", "", "")
    call <sid>hi("mailQuoted5",  s:gui0D, "", s:cterm0D, "", "", "")
    call <sid>hi("mailQuoted6",  s:gui0A, "", s:cterm0A, "", "", "")
    call <sid>hi("mailURL",      s:gui0D, "", s:cterm0D, "", "", "")
    call <sid>hi("mailEmail",    s:gui0D, "", s:cterm0D, "", "", "")

    " Markdown highlighting
    call <sid>hi("markdownCode",              s:gui0B, "", s:cterm0B, "", "", "")
    call <sid>hi("markdownError",             s:gui05, s:gui00, s:cterm05, s:cterm00, "", "")
    call <sid>hi("markdownCodeBlock",         s:gui0B, "", s:cterm0B, "", "", "")
    call <sid>hi("markdownHeadingDelimiter",  s:gui0D, "", s:cterm0D, "", "", "")

    " NERDTree highlighting
    call <sid>hi("NERDTreeDirSlash",  s:gui0D, "", s:cterm0D, "", "", "")
    call <sid>hi("NERDTreeExecFile",  s:gui05, "", s:cterm05, "", "", "")

    " PHP highlighting
    call <sid>hi("phpMemberSelector",  s:gui05, "", s:cterm05, "", "", "")
    call <sid>hi("phpComparison",      s:gui05, "", s:cterm05, "", "", "")
    call <sid>hi("phpParent",          s:gui05, "", s:cterm05, "", "", "")
    call <sid>hi("phpMethodsVar",      s:gui0C, "", s:cterm0C, "", "", "")

    " Python highlighting
    call <sid>hi("pythonOperator",  s:gui0E, "", s:cterm0E, "", "", "")
    call <sid>hi("pythonRepeat",    s:gui0E, "", s:cterm0E, "", "", "")
    call <sid>hi("pythonInclude",   s:gui0E, "", s:cterm0E, "", "", "")
    call <sid>hi("pythonStatement", s:gui0E, "", s:cterm0E, "", "", "")

    " Ruby highlighting
    call <sid>hi("rubyAttribute",               s:gui0D, "", s:cterm0D, "", "", "")
    call <sid>hi("rubyConstant",                s:gui0A, "", s:cterm0A, "", "", "")
    call <sid>hi("rubyInterpolationDelimiter",  s:gui0F, "", s:cterm0F, "", "", "")
    call <sid>hi("rubyRegexp",                  s:gui0C, "", s:cterm0C, "", "", "")
    call <sid>hi("rubySymbol",                  s:gui0B, "", s:cterm0B, "", "", "")
    call <sid>hi("rubyStringDelimiter",         s:gui0B, "", s:cterm0B, "", "", "")

    " SASS highlighting
    call <sid>hi("sassidChar",     s:gui08, "", s:cterm08, "", "", "")
    call <sid>hi("sassClassChar",  s:gui09, "", s:cterm09, "", "", "")
    call <sid>hi("sassInclude",    s:gui0E, "", s:cterm0E, "", "", "")
    call <sid>hi("sassMixing",     s:gui0E, "", s:cterm0E, "", "", "")
    call <sid>hi("sassMixinName",  s:gui0D, "", s:cterm0D, "", "", "")

    " Signify highlighting
    call <sid>hi("SignifySignAdd",     s:gui0B, s:gui01, s:cterm0B, s:cterm01, "", "")
    call <sid>hi("SignifySignChange",  s:gui0D, s:gui01, s:cterm0D, s:cterm01, "", "")
    call <sid>hi("SignifySignDelete",  s:gui08, s:gui01, s:cterm08, s:cterm01, "", "")

    " Spelling highlighting
    call <sid>hi("SpellBad",     "", "", "", "", "undercurl", s:gui08)
    call <sid>hi("SpellLocal",   "", "", "", "", "undercurl", s:gui0C)
    call <sid>hi("SpellCap",     "", "", "", "", "undercurl", s:gui0D)
    call <sid>hi("SpellRare",    "", "", "", "", "undercurl", s:gui0E)

    " Startify highlighting
    call <sid>hi("StartifyBracket",  s:gui03, "", s:cterm03, "", "", "")
    call <sid>hi("StartifyFile",     s:gui07, "", s:cterm07, "", "", "")
    call <sid>hi("StartifyFooter",   s:gui03, "", s:cterm03, "", "", "")
    call <sid>hi("StartifyHeader",   s:gui0B, "", s:cterm0B, "", "", "")
    call <sid>hi("StartifyNumber",   s:gui09, "", s:cterm09, "", "", "")
    call <sid>hi("StartifyPath",     s:gui03, "", s:cterm03, "", "", "")
    call <sid>hi("StartifySection",  s:gui0E, "", s:cterm0E, "", "", "")
    call <sid>hi("StartifySelect",   s:gui0C, "", s:cterm0C, "", "", "")
    call <sid>hi("StartifySlash",    s:gui03, "", s:cterm03, "", "", "")
    call <sid>hi("StartifySpecial",  s:gui03, "", s:cterm03, "", "", "")

    " Java highlighting
    call <sid>hi("javaOperator",     s:gui0D, "", s:cterm0D, "", "", "")

    " Remove functions
    delf <sid>hi

    " Remove color variables
    unlet s:gui00 s:gui01 s:gui02 s:gui03  s:gui04  s:gui05  s:gui06  s:gui07  s:gui08  s:gui09 s:gui0A  s:gui0B  s:gui0C  s:gui0D  s:gui0E  s:gui0F
    unlet s:cterm00 s:cterm01 s:cterm02 s:cterm03 s:cterm04 s:cterm05 s:cterm06 s:cterm07 s:cterm08 s:cterm09 s:cterm0A s:cterm0B s:cterm0C s:cterm0D s:cterm0E s:cterm0F
  '';

  programs.neovim = {
    enable = true;
  };

  programs.tealdeer = {
    enable = true;
    settings = {
      updates = {
        auto_update = true;
      };
    };
  };

  programs.tmux = {
    enable = true;
    escapeTime = 0;

    extraConfig = ''
      # No status bar!
      set -g status off

      # Mouse mode!
      set -g mouse on

      # True Color!
      set -g default-terminal "screen-256color"
      set -ga terminal-overrides ",xterm-256color*:Tc"

      # Use zsh!
      set -g default-command "${pkgs.zsh}/bin/zsh"

      # Name windows after the current directory!
      set-option -g status-interval 5
      set-option -g automatic-rename on
      set-option -g automatic-rename-format '#{b:pane_current_path}'

      # Colors!
      # default statusbar colors
      set-option -g status-style "fg=#${config.colorScheme.colors.base04},bg=#${config.colorScheme.colors.base01}"
      
      # default window title colors
      set-window-option -g window-status-style "fg=#${config.colorScheme.colors.base04},bg=default"
      
      # active window title colors
      set-window-option -g window-status-current-style "fg=#${config.colorScheme.colors.base0A},bg=default"
      
      # pane border
      set-option -g pane-border-style "fg=#${config.colorScheme.colors.base01}"
      set-option -g pane-active-border-style "fg=#${config.colorScheme.colors.base02}"
      
      # message text
      set-option -g message-style "fg=#${config.colorScheme.colors.base05},bg=#${config.colorScheme.colors.base01}"
      
      # pane number display
      set-option -g display-panes-active-colour "#${config.colorScheme.colors.base0B}"
      set-option -g display-panes-colour "#${config.colorScheme.colors.base0A}"
      
      # clock
      set-window-option -g clock-mode-colour "#${config.colorScheme.colors.base0B}"
      
      # copy mode highligh
      set-window-option -g mode-style "fg=#${config.colorScheme.colors.base04},bg=#${config.colorScheme.colors.base02}"
      
      # bell
      set-window-option -g window-status-bell-style "fg=#${config.colorScheme.colors.base01},bg=#${config.colorScheme.colors.base08}"
    '';
  };

  programs.bash = {
    enable = true;
    initExtra = ''
      source ~/.shrc

      # Set up shell color scheme
      sh ${nix-colors-lib.shellThemeFromScheme { scheme = config.colorScheme; }}
    '';
  };

  programs.zsh = {
    enable = true;
    autocd = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    enableSyntaxHighlighting = true;
    dotDir = ".config/zsh";

    # TODO can `.shrc` be converted to this file?
    initExtra = ''
      # Common shell settings to share with bash
      source ~/.shrc

      # Set up shell color scheme
      sh ${nix-colors-lib.shellThemeFromScheme { scheme = config.colorScheme; }}

      # Set up powerlevel10k, this should always come last
      [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
    '';

    zplug = {
      enable = true;
      plugins = [
        {
          name = "plugins/asdf";
          tags = [ "from:oh-my-zsh" ];
        }
        {
          name = "plugins/git";
          tags = [ "from:oh-my-zsh" ];
        }
        {
          name = "plugins/git-auto-fetch";
          tags = [ "from:oh-my-zsh" ];
        }
        {
          name = "paulirish/git-open";
          tags = [ "as:plugin" ];
        }
        {
          name = "romkatv/powerlevel10k";
          tags = [ "as:theme" "depth:1" ];
        }
        {
          name = "agkozak/zsh-z";
        }
      ];
    };
  };

  programs.alacritty = {
    enable = builtins.elem "graphical" packageSets;
    settings = {
      font = {
        normal = {
          family = "Hack";
        };
        size = 13.0;
      };
      selection = {
        save_to_clipboard = true;
      };
      shell = {
        program = "${pkgs.tmux}/bin/tmux";
      };
      colors = {
        # Default color;
        primary = {
          background = "0x${config.colorScheme.colors.base00}";
          foreground = "0x${config.colorScheme.colors.base05}";
        };

        # Colors the cursor will use if `custom_cursor_colors` is tru";
        cursor = {
          text = "0x${config.colorScheme.colors.base00}";
          cursor = "0x${config.colorScheme.colors.base05}";
        };

        # Normal color";
        normal = {
          black = "0x${config.colorScheme.colors.base00}";
          red = "0x${config.colorScheme.colors.base08}";
          green = "0x${config.colorScheme.colors.base0B}";
          yellow = "0x${config.colorScheme.colors.base0A}";
          blue = "0x${config.colorScheme.colors.base0D}";
          magenta = "0x${config.colorScheme.colors.base0E}";
          cyan = "0x${config.colorScheme.colors.base0C}";
          white = "0x${config.colorScheme.colors.base05}";
        };

        # Bright color";
        bright = {
          black = "0x${config.colorScheme.colors.base03}";
          red = "0x${config.colorScheme.colors.base09}";
          green = "0x${config.colorScheme.colors.base01}";
          yellow = "0x${config.colorScheme.colors.base02}";
          blue = "0x${config.colorScheme.colors.base04}";
          magenta = "0x${config.colorScheme.colors.base06}";
          cyan = "0x${config.colorScheme.colors.base0F}";
          white = "0x${config.colorScheme.colors.base07}";
        };
      };

      draw_bold_text_with_bright_colors = false;
    };
  };

  programs.k9s = {
    enable = builtins.elem "kubernetes" packageSets;
    skin = {
      k9s =
        let
          default = "default";
          foreground = "#${config.colorScheme.colors.base05}";
          background = "#${config.colorScheme.colors.base00}";
          comment = "#${config.colorScheme.colors.base03}";
          current_line = "#${config.colorScheme.colors.base01}";
          selection = "#${config.colorScheme.colors.base02}";

          red = "#${config.colorScheme.colors.base08}";
          orange = "#${config.colorScheme.colors.base09}";
          yellow = "#${config.colorScheme.colors.base0A}";
          green = "#${config.colorScheme.colors.base0B}";
          cyan = "#${config.colorScheme.colors.base0C}";
          blue = "#${config.colorScheme.colors.base0D}";
          magenta = "#${config.colorScheme.colors.base0E}";
        in
        {
          # General K9s styles
          body = {
            fgColor = foreground;
            bgColor = default;
            logoColor = magenta;
          };
          # Command prompt styles
          prompt = {
            fgColor = foreground;
            bgColor = background;
            suggestColor = orange;
          };
          # ClusterInfoView styles.
          info = {
            fgColor = blue;
            sectionColor = foreground;
          };
          # Dialog styles.
          dialog = {
            fgColor = foreground;
            bgColor = default;
            buttonFgColor = foreground;
            buttonBgColor = magenta;
            buttonFocusFgColor = yellow;
            buttonFocusBgColor = blue;
            labelFgColor = orange;
            fieldFgColor = foreground;
          };
          frame = {
            # Borders styles.
            border = {
              fgColor = selection;
              focusColor = current_line;
            };
            menu = {
              fgColor = foreground;
              keyColor = blue;
              # Used for favorite namespaces
              numKeyColor = blue;
              # CrumbView attributes for history navigation.
            };
            crumbs = {
              fgColor = foreground;
              bgColor = current_line;
              activeColor = current_line;
            };
            # Resource status and update styles
            status = {
              newColor = cyan; # RIGHT HERE!
              modifyColor = magenta;
              addColor = green;
              errorColor = red;
              highlightcolor = orange;
              killColor = comment;
              completedColor = comment;
            };
            # Border title styles.
            title = {
              fgColor = foreground;
              bgColor = current_line;
              highlightColor = orange;
              counterColor = magenta;
              filterColor = blue;
            };
          };
          views = {
            # Charts skins...
            charts = {
              bgColor = default;
              defaultDialColors = [ magenta red ];
              defaultChartColors = [ magenta red ];
            };
            # TableView attributes.
            table = {
              fgColor = foreground;
              bgColor = default;
              # Header row styles.
              header = {
                fgColor = foreground;
                bgColor = default;
                sorterColor = cyan;
              };
            };
            # Xray view attributes.
            xray = {
              fgColor = foreground;
              bgColor = default;
              cursorColor = current_line;
              graphicColor = magenta;
              showIcons = false;
            };
            # YAML info styles.
            yaml = {
              keyColor = blue;
              colonColor = magenta;
              valueColor = foreground;
            };
            # Logs styles.
            logs = {
              fgColor = foreground;
              bgColor = default;
              indicator = {
                fgColor = foreground;
                bgColor = magenta;
              };
              help = {
                fgColor = foreground;
                bgColor = background;
                indicator = {
                  fgColor = red;
                };
              };
            };
          };
        };
    };
  };
}
