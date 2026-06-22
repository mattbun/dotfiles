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
    fg = vim.g.base16_deleted,
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

Statusline = {
  -- Show statusline on these buftypes
  buftypes = {
    [""] = true, -- regular buffer
    ["help"] = true,
    ["terminal"] = true,
  },

  -- Show statusline on these filetypes regardless of buftype
  filetypes = {
    ["codecompanion"] = true,
    ["NvimTree"] = true,
  },

  -- https://neovim.io/doc/user/vimfn/#mode()
  -- Matched only on first character
  modes = {
    ["!"] = { name = "!", highlight = "StatuslineCmdLineAccent" }, -- Shell or command is executing
    ["c"] = { name = "C", highlight = "StatuslineCmdLineAccent" }, -- Command
    ["i"] = { name = "I", highlight = "StatuslineInsertAccent" }, -- Insert
    ["n"] = { name = "N", highlight = "StatuslineAccent" }, -- Normal
    ["r"] = { name = "?", highlight = "StatuslineAccent" }, -- prompt, confirmation
    ["R"] = { name = "R", highlight = "StatuslineReplaceAccent" }, -- Replace
    ["s"] = { name = "S", highlight = "StatuslineVisualAccent" }, -- Select by char
    ["S"] = { name = "S", highlight = "StatuslineVisualAccent" }, -- Select by line
    [""] = { name = "S", highlight = "StatuslineVisualAccent" }, -- Select blockwise
    ["t"] = { name = "T", highlight = "StatuslineInsertAccent" }, -- Terminal
    ["v"] = { name = "V", highlight = "StatuslineVisualAccent" }, -- Visual by char
    ["V"] = { name = "V", highlight = "StatuslineVisualAccent" }, -- Visual by line
    [""] = { name = "V", highlight = "StatuslineVisualAccent" }, -- Visual blockwise

    default = { name = "?", highlight = "StatuslineAccent" },
    inactive = { name = "-", highlight = "Statusline" },
  },

  mode = function(active)
    if active then
      local modeName = vim.api.nvim_get_mode().mode
      return Statusline.modes[modeName:sub(1, 1)] or Statusline.modes.default
    else
      return Statusline.modes.inactive
    end
  end,

  filename = function(bufnr)
    local buf = vim.bo[bufnr]

    if buf.buftype == "help" then
      return "[help/%f]"
    elseif buf.buftype == "terminal" then
      return string.format("[%s]", vim.b[bufnr].term_title)
    elseif buf.buftype == "" then
      local bufname = vim.api.nvim_buf_get_name(bufnr)
      if bufname == "" then
        return "[No Name]" -- empty file
      else
        return vim.fn.fnamemodify(bufname, ":~:.:f")
      end
    else
      return string.format("[%s]", buf.filetype or buf.buftype)
    end
  end,

  build = function(bufnr, active)
    local buf = vim.bo[bufnr]

    local isActive = (active == 1)
    local isRegularBuffer = (buf.buftype == "")

    local mode = Statusline.mode(isActive)
    local diagnostics = vim.diagnostic.count(bufnr) or {}
    local vcs = vim.b[bufnr].gitsigns_status_dict or {}
    local hasVcs = (vcs.head ~= "")

    local components = {
      { hi = mode.highlight },
      { text = " " .. mode.name .. " " },

      { hi = "StatuslineOuter", cond = isActive },
      { text = " " .. Statusline.filename(bufnr) .. " " },
      { text = "[RO] ", cond = buf.readonly and buf.buftype ~= "help" },
      { text = "[+] ", cond = buf.modified },

      { hi = "StatuslineInner", cond = isActive },
      -- diagnostics
      {
        fn = function()
          return " E" .. diagnostics[vim.diagnostic.severity.ERROR]
        end,
        hi = "StatuslineDiagnosticError",
        cond = isActive and diagnostics[vim.diagnostic.severity.ERROR] ~= nil,
      },
      {
        fn = function()
          return " W" .. diagnostics[vim.diagnostic.severity.WARN]
        end,
        hi = "StatuslineDiagnosticWarning",
        cond = isActive and diagnostics[vim.diagnostic.severity.WARN] ~= nil,
      },
      {
        fn = function()
          return " H" .. diagnostics[vim.diagnostic.severity.HINT]
        end,
        hi = "StatuslineDiagnosticHint",
        cond = isActive and diagnostics[vim.diagnostic.severity.HINT] ~= nil,
      },
      {
        fn = function()
          return " I" .. diagnostics[vim.diagnostic.severity.INFO]
        end,
        hi = "StatuslineDiagnosticInfo",
        cond = isActive and diagnostics[vim.diagnostic.severity.INFO] ~= nil,
      },
      -- vcs
      {
        fn = function()
          return " +" .. vcs.added
        end,
        hi = "StatuslineGitAdded",
        cond = isActive and hasVcs and vcs.added ~= nil and vcs.added > 0,
      },
      {
        fn = function()
          return " ~" .. vcs.changed
        end,
        hi = "StatuslineGitChanged",
        cond = isActive and hasVcs and vcs.changed ~= nil and vcs.changed > 0,
      },
      {
        fn = function()
          return " -" .. vcs.removed
        end,
        hi = "StatuslineGitRemoved",
        cond = isActive and hasVcs and vcs.removed ~= nil and vcs.removed > 0,
      },
      { hi = "StatuslineInner", cond = isActive }, -- undo any formatting from previous components

      { text = "%=" }, -- right align

      { text = " " .. buf.filetype .. " ", cond = isActive and isRegularBuffer },

      { hi = "StatuslineOuter", cond = isActive },
      { text = " %l:%c ", cond = isActive }, -- line info

      { hi = mode.highlight },
      { text = " %P " }, -- line percent
    }

    local statusline = ""
    for _, s in ipairs(components) do
      if s.cond == nil or s.cond then
        local content = s.text or ""

        if s.fn ~= nil then
          content = s.fn()
        end

        if s.hi ~= nil then
          content = string.format("%%#%s#%s", s.hi, content)
        end

        statusline = statusline .. content
      end
    end
    return statusline
  end,
}

-- These autocmds keep the statusline updated
vim.api.nvim_create_augroup("Statusline", { clear = false })

vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter", "FileType" }, {
  group = "Statusline",
  pattern = "*",
  callback = function(event)
    local buftype = vim.bo[event.buf].buftype
    local filetype = vim.bo[event.buf].filetype

    if Statusline.buftypes[buftype] or Statusline.filetypes[filetype] then
      vim.wo.statusline = "%!v:lua.Statusline.build(" .. event.buf .. ", 1)"
    else
      vim.wo.statusline = ""
    end
  end,
})

vim.api.nvim_create_autocmd({ "WinLeave", "BufLeave" }, {
  group = "Statusline",
  pattern = "*",
  callback = function(event)
    local buftype = vim.bo[event.buf].buftype
    local filetype = vim.bo[event.buf].filetype

    if Statusline.buftypes[buftype] or Statusline.filetypes[filetype] then
      vim.wo.statusline = "%!v:lua.Statusline.build(" .. event.buf .. ", 0)"
    else
      vim.wo.statusline = ""
    end
  end,
})

vim.api.nvim_create_autocmd("DiagnosticChanged", {
  callback = function(event)
    vim.wo.statusline = "%!v:lua.Statusline.build(" .. event.buf .. ", 1)"
  end,
})

vim.api.nvim_create_autocmd("User", {
  pattern = "GitSignsUpdate",
  callback = function(event)
    vim.wo.statusline = "%!v:lua.Statusline.build(" .. event.buf .. ", 1)"
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
