vim.g.mapleader = " "
vim.g.maplocalleader = ","

local opts = {
  number = true,
  relativenumber = true,
  signcolumn = "yes",
  expandtab = true,
  shiftwidth = 2,
  tabstop = 2,
  smartindent = true,
  clipboard = "unnamedplus",
  termguicolors = true,
  ignorecase = true,
  smartcase = true,
  scrolloff = 6,
  updatetime = 200,
}

for k, v in pairs(opts) do
  vim.opt[k] = v
end

vim.cmd("filetype plugin indent on")
vim.cmd("syntax enable")

local is_apple_terminal = vim.env.TERM_PROGRAM == "Apple_Terminal"
local in_tmux = vim.env.TMUX ~= nil and vim.env.TMUX ~= ""
if is_apple_terminal and not in_tmux then
  vim.opt.termguicolors = false
end

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  pcall(vim.fn.system, {
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

local ok_lazy, lazy = pcall(require, "lazy")
if ok_lazy then
  lazy.setup({
    { "neovim/nvim-lspconfig" },
    {
      "p00f/clangd_extensions.nvim",
      ft = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
      config = function()
        require("clangd_extensions").setup({})
      end,
    },
    {
      "folke/which-key.nvim",
      event = "VeryLazy",
      config = function()
        require("which-key").setup({})
      end,
    },
    {
      "nvimdev/lspsaga.nvim",
      event = "LspAttach",
      dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "nvim-tree/nvim-web-devicons",
      },
      config = function()
        require("lspsaga").setup({})
      end,
    },
    {
      "williamboman/mason.nvim",
      build = ":MasonUpdate",
      config = function()
        require("mason").setup({ ui = { border = "rounded" } })
      end,
    },
    {
      "williamboman/mason-lspconfig.nvim",
      dependencies = { "williamboman/mason.nvim" },
      config = function()
        local mlsp = require("mason-lspconfig")
        local uv = vim.uv or vim.loop

        mlsp.setup({
          ensure_installed = { "clangd", "lua_ls" },
          automatic_enable = false,
        })

        local capabilities = vim.lsp.protocol.make_client_capabilities()
        local ok_cmp_lsp, cmp_lsp = pcall(require, "cmp_nvim_lsp")
        if ok_cmp_lsp then
          capabilities = cmp_lsp.default_capabilities(capabilities)
        end

        local function lsp_on_attach(client, bufnr)
          local function map(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
          end

          map("n", "gD", vim.lsp.buf.declaration, "Goto Declaration")
          map("n", "gd", "<cmd>Lspsaga goto_definition<CR>", "Goto Definition")
          map("n", "gr", "<cmd>Lspsaga finder<CR>", "References")
          map("n", "gi", vim.lsp.buf.implementation, "Goto Implementation")
          map("n", "gy", vim.lsp.buf.type_definition, "Goto Type Definition")
          map("n", "K", "<cmd>Lspsaga hover_doc<CR>", "Hover")
          map("n", "<leader>ca", "<cmd>Lspsaga code_action<CR>", "Code Action")
          map("n", "<leader>rn", "<cmd>Lspsaga rename<CR>", "Rename")
          map("n", "<leader>d", "<cmd>Lspsaga show_line_diagnostics<CR>", "Line Diagnostics")
          map("n", "[d", "<cmd>Lspsaga diagnostic_jump_prev<CR>", "Prev Diagnostic")
          map("n", "]d", "<cmd>Lspsaga diagnostic_jump_next<CR>", "Next Diagnostic")
          map("n", "<leader>o", "<cmd>Lspsaga outline<CR>", "Outline")

          if client and client.name == "clangd" then
            map("n", "<leader>ch", "<cmd>ClangdSwitchSourceHeader<CR>", "Switch Header/Source")
            map("n", "<leader>th", "<cmd>ClangdTypeHierarchy<CR>", "Type Hierarchy")
            map("n", "<leader>si", "<cmd>ClangdSymbolInfo<CR>", "Symbol Info")
          end
        end

        local function find_compdb_dir(root)
          if not root or root == "" then
            return nil
          end
          local candidates = {
            root,
            root .. "/build",
            root .. "/cmake-build-debug",
            root .. "/cmake-build-release",
            root .. "/out/build",
          }
          for _, dir in ipairs(candidates) do
            if uv.fs_stat(dir .. "/compile_commands.json") then
              return dir
            end
          end
          return nil
        end

        local clangd_base_cmd = {
          "clangd",
          "--background-index",
          "--clang-tidy",
          "--completion-style=detailed",
          "--header-insertion=iwyu",
          "--all-scopes-completion",
          "--cross-file-rename",
          "--function-arg-placeholders=0",
          "--pch-storage=memory",
        }

        vim.lsp.config("clangd", {
          cmd = vim.deepcopy(clangd_base_cmd),
          on_attach = lsp_on_attach,
          capabilities = capabilities,
          root_markers = {
            "compile_commands.json",
            "compile_flags.txt",
            "CMakeLists.txt",
            ".git",
          },
          on_new_config = function(new_config, new_root_dir)
            local compdb_dir = find_compdb_dir(new_root_dir)
            if compdb_dir then
              table.insert(new_config.cmd, "--compile-commands-dir=" .. compdb_dir)
            end
          end,
          init_options = {
            clangdFileStatus = true,
          },
        })
        vim.lsp.enable("clangd")

        vim.lsp.config("lua_ls", {
          on_attach = function(client, bufnr)
            lsp_on_attach(client, bufnr)
            vim.keymap.set("n", "<leader>f", function()
              vim.lsp.buf.format({
                async = false,
                filter = function(c)
                  return c.name == "lua_ls"
                end,
              })
            end, { buffer = bufnr, desc = "Format Lua" })
          end,
          capabilities = capabilities,
          settings = {
            Lua = {
              runtime = { version = "LuaJIT" },
              diagnostics = { globals = { "vim" } },
              workspace = {
                library = vim.api.nvim_get_runtime_file("", true),
                checkThirdParty = false,
              },
              telemetry = { enable = false },
            },
          },
        })
        vim.lsp.enable("lua_ls")
      end,
    },
    {
      "hrsh7th/nvim-cmp",
      dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "saadparwaiz1/cmp_luasnip",
        "L3MON4D3/LuaSnip",
      },
    },
    { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
    { "nvim-lua/plenary.nvim" },
    {
      "nvim-neo-tree/neo-tree.nvim",
      branch = "v3.x",
      dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
        "MunifTanjim/nui.nvim",
      },
      keys = {
        { "<leader>e", "<cmd>Neotree toggle<CR>", desc = "Explorer Toggle" },
        { "<leader>er", "<cmd>Neotree reveal<CR>", desc = "Explorer Reveal File" },
      },
      config = function()
        require("neo-tree").setup({
          close_if_last_window = true,
          popup_border_style = "rounded",
          enable_git_status = true,
          enable_diagnostics = true,
          filesystem = {
            follow_current_file = {
              enabled = true,
            },
            filtered_items = {
              hide_dotfiles = false,
            },
          },
          window = {
            position = "left",
            width = 34,
          },
        })
      end,
    },
    {
      "nvim-telescope/telescope.nvim",
      dependencies = {
        {
          "nvim-telescope/telescope-fzf-native.nvim",
          build = "make",
          cond = function()
            return vim.fn.executable("make") == 1
          end,
        },
        "fdschmidt93/telescope-egrepify.nvim",
        "debugloop/telescope-undo.nvim",
        "isak102/telescope-git-file-history.nvim",
      },
    },
    {
      "linrongbin16/lsp-progress.nvim",
      config = function()
        require("lsp-progress").setup({})
      end,
    },
    {
      "nvim-lualine/lualine.nvim",
      dependencies = { "nvim-tree/nvim-web-devicons" },
      config = function()
        local ok_lp, lp = pcall(require, "lsp-progress")
        require("lualine").setup({
          options = {
            theme = "gruvbox",
            globalstatus = true,
          },
          sections = {
            lualine_c = {
              "filename",
            },
            lualine_x = {
              ok_lp and {
                lp.progress,
                color = { fg = "#d79921" },
              } or "encoding",
              "filetype",
            },
          },
        })
      end,
    },
    { "tpope/vim-commentary" },
    {
      "ellisonleao/gruvbox.nvim",
      priority = 1000,
      config = function()
        require("gruvbox").setup({ undercurl = true, transparent = false })
        if vim.opt.termguicolors:get() then
          pcall(vim.cmd, "colorscheme gruvbox")
        end
      end,
    },
  })
else
  vim.schedule(function()
    pcall(vim.notify, "lazy.nvim unavailable; using minimal setup", vim.log.levels.WARN)
  end)
end

if not vim.g.colors_name or vim.g.colors_name == "" then
  pcall(vim.cmd, "colorscheme elflord")
end

local ok_cmp, cmp = pcall(require, "cmp")
if ok_cmp then
  cmp.setup({
    snippet = {
      expand = function(args)
        require("luasnip").lsp_expand(args.body)
      end,
    },
    mapping = cmp.mapping.preset.insert({
      ["<CR>"] = cmp.mapping.confirm({ select = true }),
      ["<Tab>"] = cmp.mapping.select_next_item(),
      ["<S-Tab>"] = cmp.mapping.select_prev_item(),
    }),
    sources = cmp.config.sources({
      { name = "nvim_lsp" },
      { name = "luasnip" },
      { name = "path" },
    }, {
      { name = "buffer" },
    }),
  })
end

local ok_ts, tsconfigs = pcall(require, "nvim-treesitter.configs")
if ok_ts then
  local parser_install_dir = vim.fn.stdpath("data") .. "/site"
  if not string.find(vim.o.runtimepath, parser_install_dir, 1, true) then
    vim.opt.runtimepath:prepend(parser_install_dir)
  end
  tsconfigs.setup({
    parser_install_dir = parser_install_dir,
    ensure_installed = { "cpp", "c", "cmake", "bash", "lua", "vim", "json" },
    highlight = { enable = true },
    incremental_selection = { enable = true },
    indent = { enable = true },
  })
end

local ok_telescope, telescope = pcall(require, "telescope")
if ok_telescope then
  local ok_gfh = pcall(require, "telescope._extensions.git_file_history")
  local last_egrepify_prompt = ""
  local egrepify_remembered = function(opts)
    opts = opts or {}
    if opts.default_text == nil then
      opts.default_text = last_egrepify_prompt
    end

    local user_cb = opts.on_input_filter_cb
    opts.on_input_filter_cb = function(prompt)
      last_egrepify_prompt = prompt
      if user_cb then
        return user_cb(prompt)
      end
      return { prompt = prompt }
    end

    local ext = telescope.extensions and telescope.extensions.egrepify
    local picker = ext and ext.egrepify
    if type(picker) == "function" then
      return picker(opts)
    end
    return require("telescope.builtin").live_grep(opts)
  end

  telescope.setup({
    defaults = {
      path_display = { "truncate" },
      file_ignore_patterns = {
        "^%.git/",
        "^build/",
        "^out/",
      },
      preview = { treesitter = false },
    },
    extensions = {
      egrepify = {
        AND = true,
        permutations = false,
      },
      undo = {},
      git_file_history = ok_gfh and {
        browser_command = nil,
      } or {},
    },
  })
  pcall(telescope.load_extension, "fzf")
  pcall(telescope.load_extension, "egrepify")
  pcall(telescope.load_extension, "undo")
  pcall(telescope.load_extension, "git_file_history")

  vim.keymap.set("n", "<leader>fg", function()
    egrepify_remembered({})
  end, { desc = "Grep (egrepify)" })
  vim.keymap.set("n", "<leader>*", function()
    local word = vim.fn.expand("<cword>")
    egrepify_remembered({ default_text = word })
  end, { desc = "Grep current word" })
  vim.keymap.set("n", "<leader>fu", function()
    telescope.extensions.undo.undo()
  end, { desc = "Undo history" })
end

local ok_tb, tb = pcall(require, "telescope.builtin")
if ok_tb then
  vim.keymap.set("n", "<leader>ff", tb.find_files, { desc = "Files" })
  vim.keymap.set("n", "<leader>fb", tb.buffers, { desc = "Buffers" })
  vim.keymap.set("n", "<leader>fr", tb.oldfiles, { desc = "Recent Files" })
  vim.keymap.set("n", "<leader>ds", tb.lsp_document_symbols, { desc = "Document Symbols" })
  vim.keymap.set("n", "<leader>ws", tb.lsp_workspace_symbols, { desc = "Workspace Symbols" })
  vim.keymap.set("n", "<leader>fd", tb.diagnostics, { desc = "Diagnostics" })
end
