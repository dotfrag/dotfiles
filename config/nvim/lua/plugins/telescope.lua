return {
  "nvim-telescope/telescope.nvim",
  keys = {
    {
      "<leader>fl",
      function()
        require("telescope.builtin").find_files({ cwd = require("lazy.core.config").options.root })
      end,
      desc = "Find Plugin Files",
    },
    {
      "<leader>fL",
      function()
        require("telescope.builtin").live_grep({ cwd = require("lazy.core.config").options.root })
      end,
      desc = "Grep Plugin Files",
    },
  },
  opts = {
    defaults = {
      mappings = {
        i = {
          ["<C-n>"] = function(...)
            return require("telescope.actions").cycle_history_next(...)
          end,
          ["<C-p>"] = function(...)
            return require("telescope.actions").cycle_history_prev(...)
          end,
          ["<C-j>"] = function(...)
            return require("telescope.actions").move_selection_next(...)
          end,
          ["<C-k>"] = function(...)
            return require("telescope.actions").move_selection_previous(...)
          end,
        },
      },
    },
  },
}
