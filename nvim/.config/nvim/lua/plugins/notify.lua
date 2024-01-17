return {
  "rcarriga/nvim-notify",
  config = function(_, opts)
    local notify = require("notify")
    opts.background_colour = "#000000"
    notify.setup(opts)
  end,
}
