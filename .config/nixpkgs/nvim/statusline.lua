-- Custom statusline
-- <3 https://nuxsh.is-a.dev/blog/custom-nvim-statusline.html

-- Statusline colors
local colors = {
  bg = "#" .. vim.g.base16_gui01,
  alt_bg = "#" .. vim.g.base16_gui02,
  dark_fg = "#" .. vim.g.base16_gui03,
  fg = "#" .. vim.g.base16_gui04,
  light_fg = "#" .. vim.g.base16_gui05,
  normal = "#" .. vim.g.base16_accent,

  accent = "#" .. vim.g.base16_accent,

  red = "#" .. vim.g.base16_gui08,
  orange = "#" .. vim.g.base16_gui09,
  yellow = "#" .. vim.g.base16_gui0A,
  green = "#" .. vim.g.base16_gui0B,
  cyan = "#" .. vim.g.base16_gui0C,
  blue = "#" .. vim.g.base16_gui0D,
  purple = "#" .. vim.g.base16_gui0E,
  brown = "#" .. vim.g.base16_gui0F,
}

local highlights = {
  StatuslineAccent = { fg = colors.bg, bg = colors.accent },
  StatuslineInsertAccent = { fg = colors.bg, bg = colors.green },
  StatuslineVisualAccent = { fg = colors.bg, bg = colors.blue },
  StatuslineReplaceAccent = { fg = colors.bg, bg = colors.orange },
  StatuslineCmdLineAccent = { fg = colors.bg, bg = colors.accent },
  StatuslineTerminalAccent = { fg = colors.bg, bg = colors.accent },

  StatuslineOuter = { fg = colors.light_fg, bg = colors.alt_bg },
  StatuslineInner = { fg = colors.fg, bg = colors.bg },

  StatuslineDiagnosticError = { fg = colors.red, bg = colors.bg },
  StatuslineDiagnosticWarning = { fg = colors.orange, bg = colors.bg },
  StatuslineDiagnosticInfo = { fg = colors.blue, bg = colors.bg },
  StatuslineDiagnosticHint = { fg = colors.cyan, bg = colors.bg },

  StatuslineGitAdded = { fg = colors.green, bg = colors.bg },
  StatuslineGitChanged = { fg = colors.blue, bg = colors.bg },
  StatuslineGitRemoved = { fg = colors.red, bg = colors.bg },
}

for name, colorScheme in pairs(highlights) do
  vim.api.nvim_set_hl(0, name, colorScheme)
end

-- Statusline component functions
local modes = {
  ["n"] = "NORMAL",
  ["no"] = "NORMAL",
  ["v"] = "VISUAL",
  ["V"] = "VISUAL LINE",
  [""] = "VISUAL BLOCK",
  ["s"] = "SELECT",
  ["S"] = "SELECT LINE",
  [""] = "SELECT BLOCK",
  ["i"] = "INSERT",
  ["ic"] = "INSERT",
  ["R"] = "REPLACE",
  ["Rv"] = "VISUAL REPLACE",
  ["c"] = "COMMAND",
  ["cv"] = "VIM EX",
  ["ce"] = "EX",
  ["r"] = "PROMPT",
  ["rm"] = "MOAR",
  ["r?"] = "CONFIRM",
  ["!"] = "SHELL",
  ["t"] = "TERMINAL",
}

local function mode()
  local current_mode = vim.api.nvim_get_mode().mode
  return string.format(" %s ", modes[current_mode]):upper()
end

local function update_mode_colors()
  local current_mode = vim.api.nvim_get_mode().mode
  local mode_color = "%#StatusLineAccent#"
  if current_mode == "n" then
    mode_color = "%#StatuslineAccent#"
  elseif current_mode == "i" or current_mode == "ic" then
    mode_color = "%#StatuslineInsertAccent#"
  elseif current_mode == "v" or current_mode == "V" or current_mode == "" then
    mode_color = "%#StatuslineVisualAccent#"
  elseif current_mode == "R" then
    mode_color = "%#StatuslineReplaceAccent#"
  elseif current_mode == "c" then
    mode_color = "%#StatuslineCmdLineAccent#"
  elseif current_mode == "t" then
    mode_color = "%#StatuslineTerminalAccent#"
  end
  return mode_color
end

local function filepath()
  local fpath = vim.fn.expand("%:~:.:h")
  if fpath == "" or fpath == "." then
    return ""
  end

  return string.format("%%<%s/", fpath)
end

local function filename()
  local fname = vim.fn.expand("%:t")
  if fname == "" then
    return "[No Name] "
  end
  return fname .. " "
end

local function dirname(file)
  return vim.fn.fnamemodify(file, ":~:h:t")
end

local function lsp()
  local errors = ""
  local warnings = ""
  local hints = ""
  local info = ""

  local count = vim.diagnostic.count(0)
  local severity = vim.diagnostic.severity

  if count[severity.ERROR] ~= nil then
    errors = "%#StatuslineDiagnosticError# E:" .. count[severity.ERROR]
  end
  if count[severity.WARN] ~= nil then
    warnings = "%#StatuslineDiagnosticWarning# W:" .. count[severity.WARN]
  end
  if count[severity.HINT] ~= nil then
    hints = "%#StatuslineDiagnosticHint# H:" .. count[severity.HINT]
  end
  if count[severity.INFO] ~= nil then
    info = "%#StatuslineDiagnosticInfo# I:" .. count[severity.INFO]
  end

  return errors .. warnings .. hints .. info .. " %#StatuslineInner#"
end

local function filetype()
  if vim.bo.filetype == "" then
    return ""
  end
  return string.format(" %s ", vim.bo.filetype)
end

local function lineinfo()
  if vim.bo.filetype == "alpha" then
    return ""
  end
  return " %l:%c "
end

local function linepercent()
  return " %P "
end

local function modified()
  if vim.bo.modified then
    return "%m "
  else
    return ""
  end
end

-- Falls back to mode if git branch is unavailable
local gitbranch = function()
  local git_info = vim.b.gitsigns_status_dict
  if not git_info or git_info.head == "" then
    return mode()
  end
  return " " .. git_info.head .. " "
end

local vcs = function()
  local git_info = vim.b.gitsigns_status_dict
  if not git_info or git_info.head == "" then
    return ""
  end

  local added = ""
  local changed = ""
  local removed = ""

  if git_info.added ~= nil and git_info.added ~= 0 then
    added = "%#StatuslineGitAdded#+" .. git_info.added .. " "
  end
  if git_info.added ~= nil and git_info.changed ~= 0 then
    changed = "%#StatuslineGitChanged#~" .. git_info.changed .. " "
  end
  if git_info.added ~= nil and git_info.removed ~= 0 then
    removed = "%#StatuslineGitRemoved#-" .. git_info.removed .. " "
  end

  return table.concat({
    added,
    changed,
    removed,
    " %#StatusLineInner#",
  })
end

-- These functions determine the layout of the statusline
Statusline = {
  active = function()
    return table.concat({
      "%#Statusline#",
      update_mode_colors(),
      mode(),
      "%#StatuslineOuter# ",
      filepath(),
      filename(),
      modified(),
      "%#StatuslineInner#",
      lsp(),
      vcs(),
      "%=", -- Right align
      filetype(),
      "%#StatuslineOuter#",
      lineinfo(),
      update_mode_colors(),
      linepercent(),
    })
  end,

  inactive = function()
    return table.concat({
      "%F",
      modified(),
      "%=", -- Right align
      linepercent(),
    })
  end,

  tree_active = function(file)
    return table.concat({
      "%#Statusline#",
      update_mode_colors(),
      " TREE ",
      "%#StatuslineOuter# ",
      dirname(file),
      " %#StatuslineInner#",
      "%=", -- Right align
      update_mode_colors(),
      linepercent(),
    })
  end,

  tree_inactive = function(file)
    return table.concat({
      dirname(file),
      "%=", -- Right align
      linepercent(),
    })
  end,
}

-- These autocmds keep the statusline updated
vim.api.nvim_create_augroup("Statusline", { clear = false })

vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter" }, {
  group = "Statusline",
  pattern = "*",
  callback = function()
    vim.wo.statusline = "%!v:lua.Statusline.active()"
  end,
})

vim.api.nvim_create_autocmd({ "WinLeave", "BufLeave" }, {
  group = "Statusline",
  pattern = "*",
  callback = function()
    vim.wo.statusline = "%!v:lua.Statusline.inactive()"
  end,
})

vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter", "FileType" }, {
  group = "Statusline",
  pattern = "*NvimTree*",
  callback = function(event)
    vim.wo.statusline = "%!v:lua.Statusline.tree_active('" .. event.file .. "')"
  end,
})

vim.api.nvim_create_autocmd({ "WinLeave", "BufLeave", "FileType" }, {
  group = "Statusline",
  pattern = "*NvimTree*",
  callback = function(event)
    vim.wo.statusline = "%!v:lua.Statusline.tree_inactive('" .. event.file .. "')"
  end,
})

vim.api.nvim_create_autocmd("DiagnosticChanged", {
  callback = function()
    vim.wo.statusline = "%!v:lua.Statusline.active()"
  end,
})

vim.api.nvim_create_autocmd("User", {
  pattern = "GitSignsUpdate",
  callback = function()
    vim.wo.statusline = "%!v:lua.Statusline.active()"
  end,
})

-- hide messages below the status bar when changing mode
vim.api.nvim_create_autocmd({ "ModeChanged" }, {
  pattern = { "[^c]:*" },
  callback = function()
    vim.print("")
  end,
})

-- hide mode since it's part of the status line
vim.opt.showmode = false
