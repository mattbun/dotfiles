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

-- https://neovim.io/doc/user/vimfn/#mode()
-- Not exhaustive. `modeName()` and `modeHighlight()` only look at the first character.
local modes = {
  ["!"] = { name = "!", highlight = "StatuslineCmdLineAccent" }, -- Shell or command is executing
  ["c"] = { name = "C", highlight = "StatuslineCmdLineAccent" }, -- Command
  ["i"] = { name = "I", highlight = "StatuslineInsertAccent" }, -- Insert
  ["n"] = { name = "N", highlight = "StatuslineAccent" }, -- Normal
  ["r"] = { name = "?", highlight = "StatuslineAccent" }, -- prompt, confirmation
  ["R"] = { name = "R", highlight = "StatuslineReplaceAccent" }, -- Replace
  ["s"] = { name = "S", highlight = "StatuslineVisualAccent" }, -- Select by char
  ["S"] = { name = "S", highlight = "StatuslineVisualAccent" }, -- Select by line
  [""] = { name = "S", highlight = "StatuslineVisualAccent" }, -- Select blockwise
  ["t"] = { name = "T", highlight = "StatuslineAccent" }, -- Terminal
  ["v"] = { name = "V", highlight = "StatuslineVisualAccent" }, -- Visual by char
  ["V"] = { name = "V", highlight = "StatuslineVisualAccent" }, -- Visual by line
  [""] = { name = "V", highlight = "StatuslineVisualAccent" }, -- Visual blockwise

  default = { name = "?", highlight = "StatuslineAccent" },
}

local function mode()
  local current_mode = vim.api.nvim_get_mode().mode
  return modes[current_mode:sub(1, 1)] or modes.default
end

local function modeName()
  return string.format(" %s ", mode().name)
end

local function modeHighlight()
  return string.format("%%#%s#", mode().highlight)
end

local function relativeFilePath()
  return "%f "
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

local function readOnly()
  if vim.bo.readonly then
    return "%r "
  else
    return ""
  end
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

local function rightAlign()
  return "%="
end

-- These functions determine the layout of the statusline
Statusline = {
  active = function()
    return table.concat({
      "%#Statusline#",
      modeHighlight(),
      modeName(),
      "%#StatuslineOuter# ",
      relativeFilePath(),
      readOnly(),
      modified(),
      "%#StatuslineInner#",
      lsp(),
      vcs(),
      rightAlign(),
      filetype(),
      "%#StatuslineOuter#",
      lineinfo(),
      modeHighlight(),
      linepercent(),
    })
  end,

  inactive = function()
    return table.concat({
      "%#Statusline#",
      " -  ",
      relativeFilePath(),
      readOnly(),
      modified(),
      rightAlign(),
      "%#Statusline#",
      linepercent(),
    })
  end,

  tree_active = function(file)
    return table.concat({
      "%#Statusline#",
      modeHighlight(),
      -- " F ",
      modeName(),
      "%#StatuslineOuter# ",
      dirname(file),
      " %#StatuslineInner#",
      rightAlign(),
      modeHighlight(),
      linepercent(),
    })
  end,

  tree_inactive = function(file)
    return table.concat({
      " -  ",
      dirname(file),
      rightAlign(),
      linepercent(),
    })
  end,
}

-- These autocmds keep the statusline updated
vim.api.nvim_create_augroup("Statusline", { clear = false })

vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter" }, {
  group = "Statusline",
  pattern = "*",
  callback = function(event)
    local buftype = vim.bo[event.buf].buftype
    local filetype = vim.bo[event.buf].filetype

    if filetype == "NvimTree" then
      vim.wo.statusline = "%!v:lua.Statusline.tree_active('" .. event.file .. "')"
      return
    elseif buftype == "nofile" then
      vim.wo.statusline = ""
      return
    end

    vim.wo.statusline = "%!v:lua.Statusline.active()"
  end,
})

vim.api.nvim_create_autocmd({ "WinLeave", "BufLeave" }, {
  group = "Statusline",
  pattern = "*",
  callback = function(event)
    local buftype = vim.bo[event.buf].buftype
    local filetype = vim.bo[event.buf].filetype

    if filetype == "NvimTree" then
      vim.wo.statusline = "%!v:lua.Statusline.tree_inactive('" .. event.file .. "')"
      return
    elseif buftype == "nofile" then
      vim.wo.statusline = ""
      return
    end

    vim.wo.statusline = "%!v:lua.Statusline.inactive()"
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
