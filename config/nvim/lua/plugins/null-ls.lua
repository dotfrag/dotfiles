return {
  "jose-elias-alvarez/null-ls.nvim",
  opts = function(_, opts)
    local nls = require("null-ls")
    vim.list_extend(opts.sources, {
      -- bash
      nls.builtins.formatting.shfmt.with({ extra_args = { "-i", "2", "-ci" } }),

      -- python
      nls.builtins.formatting.black,
    })
  end,
}
