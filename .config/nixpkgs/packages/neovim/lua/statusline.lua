-- Custom statusline
-- <3 https://nuxsh.is-a.dev/blog/custom-nvim-statusline.html

local highlights = {
  StatuslineAccent = {
    fg = vim.g.base16_01,
    bg = vim.g.base16_accent,
    ctermfg = "black",
    ctermbg = vim.g.ansi_accent,
  },
  StatuslineInsertAccent = {
    fg = vim.g.base16_01,
    bg = vim.g.base16_green,
    ctermfg = "black",
    ctermbg = "green",
  },
  StatuslineVisualAccent = {
    fg = vim.g.base16_01,
    bg = vim.g.base16_blue,
    ctermfg = "black",
    ctermbg = "blue",
  },
  StatuslineReplaceAccent = {
    fg = vim.g.base16_01,
    bg = vim.g.base16_yellow,
    ctermfg = "black",
    ctermbg = "yellow",
  },
  StatuslineCmdLineAccent = {
    fg = vim.g.base16_01,
    bg = vim.g.base16_red,
    ctermfg = "black",
    ctermbg = "red",
  },
  StatuslineTerminalAccent = {
    fg = vim.g.base16_01,
    bg = vim.g.base16_accent,
    ctermfg = "black",
    ctermbg = vim.g.ansi_accent,
  },

  StatuslineOuter = {
    fg = vim.g.base16_05,
    bg = vim.g.base16_02,
    ctermfg = "white",
    ctermbg = "darkgray",
  },
  StatuslineInner = {
    fg = vim.g.base16_05,
    bg = vim.g.base16_01,
    ctermfg = "white",
    ctermbg = "black",
  },

  StatuslineDiagnosticError = {
    fg = vim.g.base16_error,
    bg = vim.g.base16_01,
    ctermfg = "red",
    ctermbg = "black",
  },
  StatuslineDiagnosticWarning = {
    fg = vim.g.base16_warning,
    bg = vim.g.base16_01,
    ctermfg = "yellow",
    ctermbg = "black",
  },
  StatuslineDiagnosticInfo = {
    fg = vim.g.base16_info,
    bg = vim.g.base16_01,
    ctermfg = "blue",
    ctermbg = "black",
  },
  StatuslineDiagnosticHint = {
    fg = vim.g.base16_hint,
    bg = vim.g.base16_01,
    ctermfg = "cyan",
    ctermbg = "black",
  },

  StatuslineGitAdded = {
    fg = vim.g.base16_added,
    bg = vim.g.base16_01,
    ctermfg = "green",
    ctermbg = "black",
  },
  StatuslineGitChanged = {
    fg = vim.g.base16_changed,
    bg = vim.g.base16_01,
    ctermfg = "blue",
    ctermbg = "black",
  },
  StatuslineGitRemoved = {
    fg = vim.g.base16_removed,
    bg = vim.g.base16_01,
    ctermfg = "red",
    ctermbg = "black",
  },

  StatuslineInactive = {
    fg = vim.g.base16_04,
    bg = vim.g.base16_01,
    ctermfg = "white",
    ctermbg = "darkgray",
  },
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
  if git_info.changed ~= nil and git_info.changed ~= 0 then
    changed = "%#StatuslineGitChanged#~" .. git_info.changed .. " "
  end
  if git_info.removed ~= nil and git_info.removed ~= 0 then
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
      "%#Statusline#",
      " %t",
      " %m",
      "%=", -- Right align
      "%#Statusline#",
      filetype(),
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
