vim.g.switch_mapping = "-"
vim.g.switch_custom_definitions = {
  { "!=", "==" },
  { "'", '"' },
  { "-", "_" },
  { "0", "1" },
  {
    _type = "normalized_case_words",
    _definition = { "on", "off" },
  },
  {
    _type = "normalized_case_words",
    _definition = { "yes", "no" },
  },
}
