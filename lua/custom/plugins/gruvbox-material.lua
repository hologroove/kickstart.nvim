if true then
  return {}
end
return {
  'f4z3r/gruvbox-material.nvim',
  name = 'gruvbox-material',
  lazy = false,
  priority = 1000,
  opts = {
    contrast = 'hard',
  },
}

--   return {
--   'sainnhe/gruvbox-material',
--   config = function()
--     -- Optionally configure and load the colorscheme
--     -- directly inside the plugin declaration.
--     vim.g.gruvbox_material_enable_italic = true,
--     vim.g.gruvbox_material_background = 'hard',
--     vim.g.gruvbox_material_foreground = material
--     vim.cmd.colorscheme 'gruvbox-material'
--   end,
-- }
