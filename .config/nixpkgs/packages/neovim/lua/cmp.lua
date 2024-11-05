local cmp = require("cmp")

local Job = require("plenary.job")
local git_commits_source = {
  cached = false,
  cached_commits = {},
}

function git_commits_source:is_available()
  return true
end

function git_commits_source:complete(_, callback)
  if self.cached then
    callback(self.cached_commits)
  else
    Job:new({
      command = "git",
      args = {
        "log",
        "--author",
        "Matt Rathbun",
        "-n",
        "100",
        "--since",
        "2 weeks",
        "--pretty=format:%s",
      },
      on_exit = vim.schedule_wrap(function(job, code)
        if code ~= 0 then
          callback({})
          return
        end

        -- local commits = {}
        for _, commit in ipairs(job:result()) do
          table.insert(self.cached_commits, {
            label = commit,
          })
        end

        self.cached = true
        callback(self.cached_commits)
      end),
    }):start()
  end
end

function git_commits_source:execute(completion_item, callback)
  callback(completion_item)
end

cmp.register_source("git_commits", git_commits_source)

local compare = cmp.config.compare

-- https://github.com/hrsh7th/nvim-cmp/issues/156#issuecomment-916338617
local lsp_kind_priorities = function(priorities)
  local lsp_types = require("cmp.types").lsp
  return function(entry1, entry2)
    if entry1.source.name ~= "nvim_lsp" then
      if entry2.source.name == "nvim_lsp" then
        return false
      else
        return nil
      end
    end
    local kind1 = lsp_types.CompletionItemKind[entry1:get_kind()]
    local kind2 = lsp_types.CompletionItemKind[entry2:get_kind()]

    local priority1 = priorities[kind1] or 0
    local priority2 = priorities[kind2] or 0
    if priority1 == priority2 then
      return nil
    end
    return priority2 < priority1
  end
end

local alphabetical = function(entry1, entry2)
  return string.lower(entry1.completion_item.label) < string.lower(entry2.completion_item.label)
end

cmp.setup({
  preselect = cmp.PreselectMode.None,
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  mapping = {
    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.close(),
    ["<CR>"] = cmp.mapping.confirm({ select = false }),
    ["<Down>"] = cmp.mapping(cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }), { "i" }),
    ["<Up>"] = cmp.mapping(cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }), { "i" }),
    ["<PageDown>"] = cmp.mapping(
      cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select, count = 20 }),
      { "i" }
    ),
    ["<PageUp>"] = cmp.mapping(
      cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select, count = 20 }),
      { "i" }
    ),
  },
  sources = {
    { name = "nvim_lsp" },
    { name = "nvim_lsp_signature_help" },
    { name = "vsnip" },
    { name = "buffer" },
    { name = "emoji", insert = true },
    { name = "calc" },
    { name = "path" },
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  sorting = {
    comparators = {
      compare.offset,
      compare.exact,
      compare.score,
      lsp_kind_priorities({
        Class = 5,
        Color = 5,
        Constant = 10,
        Constructor = 1,
        Enum = 10,
        EnumMember = 10,
        Event = 10,
        Field = 11,
        File = 8,
        Folder = 8,
        Function = 10,
        Interface = 5,
        Keyword = 2,
        Method = 11,
        Module = 5,
        Operator = 10,
        Property = 11,
        Reference = 10,
        Snippet = 0,
        Struct = 10,
        Text = 1,
        TypeParameter = 1,
        Unit = 1,
        Value = 1,
        Variable = 10,
      }),
      alphabetical,
    },
  },
})

cmp.setup.filetype("gitcommit", {
  sources = cmp.config.sources({
    { name = "git_commits" },
  }),
})

-- Add parentheses after selecting functions or methods
local cmp_autopairs = require("nvim-autopairs.completion.cmp")
cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
