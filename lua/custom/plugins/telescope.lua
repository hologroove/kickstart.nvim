return { -- Fuzzy Finder (files, lsp, etc)

  -- {
  --   'nvim-telescope/telescope-file-browser.nvim',
  --   dependencies = { 'nvim-telescope/telescope.nvim', 'nvim-lua/plenary.nvim' },
  --   keys = {
  --     {
  --       '<leader>e',
  --       ':Telescope file_browser path=%:p:h select_buffer=true follow_symlinks=true no_ignore=true<CR>',
  --       desc = 'Browse current file',
  --     },
  --     { '<leader>e', '<leader>e', desc = 'Browse Files', remap = true },
  --   },
  -- },
  --
  {
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    branch = 'master',
    dependencies = {
      'nvim-lua/plenary.nvim',
      { -- If encountering errors, see telescope-fzf-native README for installation instructions
        'nvim-telescope/telescope-fzf-native.nvim',

        -- `build` is used to run some command when the plugin is installed/updated.
        -- This is only run then, not every time Neovim starts up.
        build = 'make',

        -- `cond` is a condition used to determine whether this plugin should be
        -- installed and loaded.
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },

      -- Useful for getting pretty icons, but requires a Nerd Font.
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
    },
    config = function()
      -- Telescope is a fuzzy finder that comes with a lot of different things that
      -- it can fuzzy find! It's more than just a "file finder", it can search
      -- many different aspects of Neovim, your workspace, LSP, and more!
      --
      -- The easiest way to use Telescope, is to start by doing something like:
      --  :Telescope help_tags
      --
      -- After running this command, a window will open up and you're able to
      -- type in the prompt window. You'll see a list of `help_tags` options and
      -- a corresponding preview of the help.
      --
      -- Two important keymaps to use while in Telescope are:
      --  - Insert mode: <c-/>
      --  - Normal mode: ?
      --
      -- This opens a window that shows you all of the keymaps for the current
      -- Telescope picker. This is really useful to discover what Telescope can
      -- do as well as how to actually do it!

      -- [[ Configure Telescope ]]
      -- See `:help telescope` and `:help telescope.setup()`
      require('telescope').setup {
        -- You can put your default mappings / updates / etc. in here
        --  All the info you're looking for is in `:help telescope.setup()`
        --
        defaults = {
          preview = {
            ls_short = true,
            mime_hook = function(filepath, bufnr, opts)
              local is_image = function(filepath)
                local image_extensions = { 'png', 'jpg', 'jpeg', 'gif' } -- Supported image formats
                local split_path = vim.split(filepath:lower(), '.', { plain = true })
                local extension = split_path[#split_path]
                return vim.tbl_contains(image_extensions, extension)
              end
              if is_image(filepath) then
                local term = vim.api.nvim_open_term(bufnr, {})
                local function send_output(_, data, _)
                  for _, d in ipairs(data) do
                    vim.api.nvim_chan_send(term, d .. '\r\n')
                  end
                end
                vim.fn.jobstart('chafa "' .. filepath .. '" --format symbols  --symbols vhalf', { on_stdout = send_output, stdout_buffered = true, pty = true })
              -- vim.fn.jobstart({
              --   'chafa',
              --   filepath, -- Terminal image viewer command
              --   ' --format symbols',
              -- }, { on_stdout = send_output, stdout_buffered = true, pty = true })
              else
                require('telescope.previewers.utils').set_preview_message(bufnr, opts.winid, 'Binary cannot be previewed')
              end
            end,
          },

          layout_config = {
            horizontal = {
              preview_width = require('telescope.config.resolve').resolve_width(function(_, max_columns, _)
                if max_columns < 100 then
                  return math.floor(max_columns * 0.4)
                else
                  return math.floor(max_columns * 0.55)
                end
              end),
            },
          },

          path_display = function(opts, path)
            local tail = require('telescope.utils').path_tail(path)
            path = string.format('%s (%s)', tail, path)

            local highlights = {
              {
                {
                  #tail, -- highlight start position
                  #path, -- highlight end position
                },
                'Comment', -- highlight group name
              },
            }

            return path, highlights
          end,

          -- -- Format path as "file.txt (path\to\file\)"
          -- path_display = function(opts, path)
          --   local tail = require('telescope.utils').path_tail(path)
          --   return string.format('%s  -  (%s)', tail, path)
          -- end,

          -- -- only display filename
          -- path_display = { 'tail' },

          mappings = {
            i = {
              ['<c-enter>'] = 'to_fuzzy_refine',
              ['<esc>'] = require('telescope.actions').close,
            },
          },
        },
        -- pickers = {}
        extensions = {
          -- file_browser = {
          --   -- theme = "ivy",
          --   hijack_netrw = true,
          --   -- mappings = {
          --   --   ["i"] = {
          --   --     -- your custom insert mode mappings
          --   --   },
          --   --   ["n"] = {
          --   --     -- your custom normal mode mappings
          --   --   },
          --   -- },
          --   display_stat = false,
          --   -- display_stat = { date = false, size = true, mode = false },
          -- },
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
        },
      }

      -- Enable Telescope extensions if they are installed
      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')
      -- pcall(require('telescope').load_extension, 'file_browser')

      -- See `:help telescope.builtin`
      local builtin = require 'telescope.builtin'
      -- vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
      -- vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
      -- vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
      -- vim.keymap.set('n', '<leader><leader>', function()
      --   builtin.git_files { use_file_path = true }
      -- end, { desc = 'Search Git Files' })
      -- vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
      -- vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
      -- --vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
      -- vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
      -- vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
      -- vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
      -- -- vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })
      -- --
      -- --vim.keymap.set('n', '<leader>bl', builtin.buffers, { desc = '[B]uffer list' })
      -- vim.keymap.set('n', '<leader>bb', function()
      --   builtin.buffers { sort_mru = true }
      -- end, { desc = '[B]uffers' })
      --
      -- vim.keymap.set('n', '<leader>gc', builtin.git_commits, { desc = '[G]it [C]ommits' })
      -- vim.keymap.set('n', '<leader>gb', builtin.git_branches, { desc = '[G]it [B]ranches' })
      -- vim.keymap.set('n', '<leader>gf', builtin.git_bcommits, { desc = '[G]it Commits of current [F]ile' })
      -- vim.keymap.set('n', '<leader>gs', builtin.git_status, { desc = '[G]it [S]tatus' })
      -- vim.keymap.set('n', '<leader>gh', builtin.git_stash, { desc = '[G]it Stas[H]' })

      -- vim.keymap.set(
      --   'n',
      --   '<leader>e',
      --   ':Telescope file_browser path=%:p:h select_buffer=true follow_symlinks=true no_ignore=true<CR>',
      --   { desc = '[S]earch File [E]ditor' }
      -- )

      -- -- Slightly advanced example of overriding default behavior and theme
      -- vim.keymap.set('n', '<leader>/', function()
      --   -- You can pass additional configuration to Telescope to change the theme, layout, etc.
      --   builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
      --     winblend = 10,
      --     previewer = false,
      --   })
      -- end, { desc = '[/] Fuzzily search in current buffer' })

      --   -- It's also possible to pass additional configuration options.
      --   --  See `:help telescope.builtin.live_grep()` for information about particular keys
      --   vim.keymap.set('n', '<leader>s/', function()
      --     builtin.live_grep {
      --       grep_open_files = true,
      --       prompt_title = 'Live Grep in Open Files',
      --     }
      --   end, { desc = '[S]earch [/] in Open Files' })
      --
      --   -- Shortcut for searching your Neovim configuration files
      --   vim.keymap.set('n', '<leader>sn', function()
      --     builtin.find_files { cwd = vim.fn.stdpath 'config' }
      --   end, { desc = '[S]earch [N]eovim files' })
    end,
  },
}
