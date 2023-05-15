--- This will install copilot.lua and copilot
--- This should not be used in tandem with copilot-cmp module
--- The plugins are created by one of NvChad's member: zbirenbaum :D
--- For more information, read https://github.com/zbirenbaum/copilot.lua
--- Feel free to override the defaults of copilot.lua, using a spec, such as:
--- ```
--- {
---   "zbirenbaum/copilot.lua",
---   opts = function(_, opts --[[NvChad's default opts]])
---     -- Return the modified opts table
---   end,
--- }
--- ```

---@type NvPluginSpec
local spec = {
  {
    "zbirenbaum/copilot.lua",
    event = { "InsertEnter" },
    cmd = { "Copilot" },
    opts = {
      suggestion = { enabled = false },
      panel = { enabled = false },
    }
  },
  {
    "zbirenbaum/copilot-cmp",
    config = function ()
      require("copilot_cmp").setup()
    end
  }
}

return spec
