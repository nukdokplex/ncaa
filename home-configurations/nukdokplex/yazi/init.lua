require("githead"):setup({
  order = {
    "__spacer__",
    "branch",
    "remote",
    "__spacer__",
    "tag",
    "__spacer__",
    "commit",
    "__spacer__",
    "behind_ahead_remote",
    "stashes",
    "state",
    "staged",
    "unstaged",
    "untracked",
  },

  show_numbers = false,

  branch_symbol = " ",
  branch_prefix = "on"
})
