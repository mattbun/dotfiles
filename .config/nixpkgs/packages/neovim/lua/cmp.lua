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
})

cmp.setup.filetype("gitcommit", {
  sources = cmp.config.sources({
    { name = "git_commits" },
  }),
})

-- Add parentheses after selecting functions or methods
local cmp_autopairs = require("nvim-autopairs.completion.cmp")
cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
