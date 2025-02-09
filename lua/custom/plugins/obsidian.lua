return {
  'epwalsh/obsidian.nvim',
  version = '*', -- recommended, use latest release instead of latest commit
  lazy = false,
  ft = 'markdown',
  dependencies = { 'nvim-lua/plenary.nvim' },
  opts = {
    workspaces = {
      {
        name = 'hologroove',
        -- path = [[/Users/laszloivacs/Documents/ObsidianVaults/hologroove]],
        path = vim.fn.expand '~' .. '/Library/Mobile Documents/iCloud~md~obsidian/Documents/hologroove/',
      },
    },
    daily_notes = {
      -- Optional, if you keep daily notes in a separate directory.
      folder = 'daily-notes',
      -- Optional, if you want to change the date format for the ID of daily notes.
      --YYYY/MM/YYYY-MM-DD
      date_format = '%Y/%m/%Y-%m-%d',
      -- Optional, if you want to change the date format of the default alias of daily notes.
      -- alias_format = "%B %-d, %Y",
      -- Optional, default tags to add to each new daily note created.
      default_tags = { 'daily-note' },
      -- Optional, if you want to automatically insert a template from your template directory like 'daily.md'
      template = 'daily-notes-template-nvim.md',
    },
    disable_frontmatter = true,
    ui = {
      enable = false, -- set to false to disable all additional syntax features
      -- Define how various check-boxes are displayed
      checkboxes = {
        -- NOTE: the 'char' value has to be a single character, and the highlight groups are defined below.
        [' '] = { char = '󰄱', hl_group = 'ObsidianTodo' },
        ['x'] = { char = '', hl_group = 'ObsidianDone' },
        -- [">"] = { char = "", hl_group = "ObsidianRightArrow" },
        -- ["~"] = { char = "󰰱", hl_group = "ObsidianTilde" },
        -- ["!"] = { char = "", hl_group = "ObsidianImportant" },
        -- Replace the above with this if you don't have a patched font:
        -- [" "] = { char = "☐", hl_group = "ObsidianTodo" },
        -- ["x"] = { char = "✔", hl_group = "ObsidianDone" },
        -- You can also add more custom ones...
      },
      bullets = { char = '-', hl_group = 'ObsidianBullet' }, -- I didn't like the bullet point
    },
    templates = {
      folder = 'templates',
      date_format = '%Y-%m-%d',
      time_format = '%H:%M',
    },
    callbacks = {
      -- Runs anytime you leave the buffer for a note.
      ---@param client obsidian.Client
      ---@param note obsidian.Note
      ---@diagnostic disable-next-line: unused-local
      leave_note = function(client, note)
        vim.api.nvim_buf_call(note.bufnr or 0, function()
          vim.cmd 'silent w'
        end)
      end,
    },
  },
}
