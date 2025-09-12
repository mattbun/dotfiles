{ config
, ...
}:
let
  colorScheme = config.colorScheme;
  palette = colorScheme.palette;
in
{
  xdg.configFile."nvim/colorscheme.vim".text = /* vim */ ''
    let g:colors_name = "nix-${colorScheme.slug}"
    let g:tinted_background_transparent=1

    " Some handy shortcuts to use in other vim configs
    let g:base16_accent  = "#${colorScheme.accentColor}"
    let g:base16_00      = "#${colorScheme.palette.base00}"
    let g:base16_01      = "#${colorScheme.palette.base01}"
    let g:base16_02      = "#${colorScheme.palette.base02}"
    let g:base16_03      = "#${colorScheme.palette.base03}"
    let g:base16_04      = "#${colorScheme.palette.base04}"
    let g:base16_05      = "#${colorScheme.palette.base05}"
    let g:base16_06      = "#${colorScheme.palette.base06}"
    let g:base16_07      = "#${colorScheme.palette.base07}"
    let g:base16_red     = "#${colorScheme.palette.base08}"
    let g:base16_orange  = "#${colorScheme.palette.base09}"
    let g:base16_yellow  = "#${colorScheme.palette.base0A}"
    let g:base16_green   = "#${colorScheme.palette.base0B}"
    let g:base16_cyan    = "#${colorScheme.palette.base0C}"
    let g:base16_blue    = "#${colorScheme.palette.base0D}"
    let g:base16_magenta = "#${colorScheme.palette.base0E}"
    let g:base16_brown   = "#${colorScheme.palette.base0F}"

    let g:base16_added     = g:base16_green
    let g:base16_changed   = g:base16_blue
    let g:base16_deleted   = g:base16_red
    let g:base16_untracked = g:base16_yellow
    let g:base16_error     = g:base16_red
    let g:base16_warning   = g:base16_orange
    let g:base16_info      = g:base16_blue
    let g:base16_hint      = g:base16_cyan

    let g:ansi_accent = "${colorScheme.accentAnsi}"

    " These are used in colors.vim
    let s:gui00 = "${palette.base00}"
    let s:gui01 = "${palette.base01}"
    let s:gui02 = "${palette.base02}"
    let s:gui03 = "${palette.base03}"
    let s:gui04 = "${palette.base04}"
    let s:gui05 = "${palette.base05}"
    let s:gui06 = "${palette.base06}"
    let s:gui07 = "${palette.base07}"
    let s:gui08 = "${palette.base08}"
    let s:gui09 = "${palette.base09}"
    let s:gui0A = "${palette.base0A}"
    let s:gui0B = "${palette.base0B}"
    let s:gui0C = "${palette.base0C}"
    let s:gui0D = "${palette.base0D}"
    let s:gui0E = "${palette.base0E}"
    let s:gui0F = "${palette.base0F}"
    let s:gui10 = "${palette.base10}"
    let s:gui11 = "${palette.base11}"
    let s:gui12 = "${palette.base12}"
    let s:gui13 = "${palette.base13}"
    let s:gui14 = "${palette.base14}"
    let s:gui15 = "${palette.base15}"
    let s:gui16 = "${palette.base16}"
    let s:gui17 = "${palette.base17}"

    " 256 colors
    let s:cterm00  = "00"
    let s:cterm01  = "18"
    let s:cterm02  = "19"
    let s:cterm03  = "08"
    let s:cterm04  = "20"
    let s:cterm05  = "21"
    let s:cterm06  = "07"
    let s:cterm07  = "15"
    let s:cterm08  = "01"
    let s:cterm09  = "16"
    let s:cterm0A  = "03"
    let s:cterm0B  = "02"
    let s:cterm0C  = "06"
    let s:cterm0D  = "04"
    let s:cterm0E  = "05"
    let s:cterm0F  = "17"
    let s:cterm10  = s:cterm00
    let s:cterm11  = s:cterm00
    let s:cterm12  = "09"
    let s:cterm13  = "11"
    let s:cterm14  = "10"
    let s:cterm15  = "14"
    let s:cterm16  = "12"
    let s:cterm17  = "13"

    " Only use 16 colors for cterm
    let s:cterm01 = s:cterm00
    let s:cterm02 = s:cterm03
    let s:cterm04 = s:cterm03
    let s:cterm05 = s:cterm06
    let s:cterm07 = s:cterm06
    let s:cterm09 = s:cterm08
    let s:cterm0F = s:cterm08

    let s:colors = [
      \ "#${palette.base00}",
      \ "#${palette.base08}",
      \ "#${palette.base0B}",
      \ "#${palette.base0A}",
      \ "#${palette.base0D}",
      \ "#${palette.base0E}",
      \ "#${palette.base0C}",
      \ "#${palette.base05}",
      \ "#${palette.base03}",
      \ "#${palette.base12}",
      \ "#${palette.base14}",
      \ "#${palette.base13}",
      \ "#${palette.base16}",
      \ "#${palette.base17}",
      \ "#${palette.base15}",
      \ "#${palette.base07}"
    \]

    " colors.vim
  ''
  + builtins.readFile ./vim/colors.vim;
}
