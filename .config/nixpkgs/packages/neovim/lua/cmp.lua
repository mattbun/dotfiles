local cmp = require("cmp")

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
    ["<C-Space>"] = cmp.mapping(cmp.mapping.complete({
      config = {
        sources = cmp.config.sources(sources.all),
      },
    })),
    ["<C-e>"] = cmp.mapping.close(),
    ["<CR>"] = cmp.mapping(function(fallback)
      -- use the internal non-blocking call to check if cmp is visible
      if cmp.core.view:visible() then
        cmp.confirm({ select = false })
      end

      fallback()
    end),
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
    ["<A-c>"] = cmp.mapping(cmp.mapping.complete({
      config = {
        sources = cmp.config.sources(sources.manual),
      },
    })),
  },
  sources = cmp.config.sources(sources.auto),
  performance = {
    fetching_timeout = 2000, -- longer timeout for AI completion
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
