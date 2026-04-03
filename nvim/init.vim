" ==============================================================================
" CORE FUNCTIONALITY AND FILETYPE
" ==============================================================================
syntax on                               " Enable syntax highlighting
filetype plugin indent on               " Enable filetype detection, plugins, and smart indentation
set encoding=utf-8                      " Set file and terminal encoding to UTF-8
set noswapfile

" ==============================================================================
" INDENTATION AND TABS (Using 4-space soft tabs)
" ==============================================================================
set autoindent                          " Copy indentation from the previous line
set smartindent                         " Enable smarter automatic indentation
set expandtab                           " Use spaces instead of actual tabs
set tabstop=4                           " A Tab character is rendered as 4 spaces wide
set shiftwidth=4                        " Auto-indent commands (e.g., >>) use 4 spaces
set softtabstop=4                       " Tab/Backtab keys use 4 spaces when inserting

" Forzar 4 espacios específicamente en C/C++ para evitar overrides
augroup FileTypeSettings
    autocmd!
    autocmd FileType c,cpp setlocal tabstop=4 shiftwidth=4 softtabstop=4
augroup END

" ==============================================================================
" UI AND APPEARANCE
" ==============================================================================
set number                              " Show absolute line number
set showmatch                           " Briefly show the matching bracket/parenthesis
set wildmenu                            " Enhanced command-line completion menu
set mouse=a                             " Enable mouse support
set updatetime=250                      " Sets the delay (ms) for showing diagnostics and tooltips (important for LSP)


" ==============================================================================
" SEARCH
" ==============================================================================
set path+=** " Allow searching for files recursively (e.g., :find filename)
set incsearch                           " Show results as you type the search pattern (incremental search)
set hlsearch                            " Highlight all matches of the last search pattern
set ignorecase                          " Ignore case when searching
set smartcase                           " Override ignorecase if the search pattern contains uppercase letters

" ==============================================================================
" BEHAVIOR AND SYSTEM INTEGRATION
" ==============================================================================
set backspace=indent,eol,start          " Ensures backspace works as expected
set clipboard=unnamedplus               " Integrate with system clipboard for yank/put (requires external tool like xclip/wl-copy)
set noswapfile                          " Disable swap files to prevent clutter
set undofile                            " Enable persistent undo history

" Specify a directory for undo files and create it if it doesn't exist
let s:undo_dir = expand('~/.config/nvim/undodir')
if !isdirectory(s:undo_dir)
    call mkdir(s:undo_dir, "p")
endif
let &undodir = s:undo_dir

" ==============================================================================
" LEADER KEY
" ==============================================================================
let mapleader = " "                      " Sets the Leader key to <Space> (used for custom keybinds like <leader>ca)

" ==============================================================================
" PLUGIN MANAGEMENT (vim-plug)
" ==============================================================================
call plug#begin('~/.config/nvim/plugins')

" Completion Engine
Plug 'hrsh7th/cmp-nvim-lsp'             " LSP source for nvim-cmp
Plug 'hrsh7th/cmp-buffer'               " Buffer source for nvim-cmp
Plug 'hrsh7th/cmp-path'                 " Path source for nvim-cmp
Plug 'hrsh7th/cmp-cmdline'              " Cmdline source for nvim-cmp
Plug 'hrsh7th/nvim-cmp'                 " The completion engine plugin

" Snippets (Required for nvim-cmp)
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/vim-vsnip'

" Utilities
Plug 'ntpeters/vim-better-whitespace'   " This plugin highlights all trailing whitespaces

" Colorscheme
Plug 'catppuccin/nvim', { 'as': 'catppuccin' }
Plug 'morhetz/gruvbox', { 'as': 'gruvbox' }
Plug 'kaicataldo/material.vim', { 'branch': 'main' }
Plug 'ayu-theme/ayu-vim'

call plug#end()

" ==============================================================================
" COLOR SCHEME
" ==============================================================================
set termguicolors

"colorscheme catppuccin

"let g:gruvbox_contrast_dark = 'hard'
"colorscheme gruvbox

"let g:material_theme_style = 'default' | 'palenight' | 'ocean' | 'lighter' | 'darker' | 'default-community' | 'palenight-community' | 'ocean-community' | 'lighter-community' | 'darker-community'
"let g:material_theme_style = 'darker-community'
"let g:material_theme_style = 'ocean'
"colorscheme material

let ayucolor="dark"
colorscheme ayu

" ==============================================================================
" LUA CONFIGURATION (LSP, AUTO-FORMAT, AND AUTOCOMPLETE)
" ==============================================================================
lua <<EOF
  local cmp = require('cmp')
  local capabilities = require('cmp_nvim_lsp').default_capabilities()

  -- Глобальные настройки диагностики
  vim.diagnostic.config({
    virtual_text = true,
    signs = true,
    underline = true,
    update_in_insert = false, -- Ошибки появятся только при выходе из Insert Mode
    float = { border = "rounded" },
  })

  -- Настройка PYRIGHT (установлен через npm -g)
  vim.lsp.config('pyright', {
    cmd = { "pyright-langserver", "--stdio" },
    filetypes = { "python" },
    root_markers = { ".git", "pyproject.toml", "setup.py", "requirements.txt", "pyrightconfig.json" },
    capabilities = capabilities,
    settings = {
      python = {
        analysis = {
          typeCheckingMode = "basic",
          autoSearchPaths = true,
          useLibraryCodeForTypes = true
        }
      }
    },
    on_init = function(client)
      client.server_capabilities.documentFormattingProvider = false
    end,
  })
  vim.lsp.enable('pyright')

  -- Настройка RUFF (установлен через uv tool)
  vim.lsp.config('ruff', {
    cmd = { "ruff", "server" },
    filetypes = { "python" },
    root_markers = { ".git", "pyproject.toml", "ruff.toml", ".ruff.toml" },
    capabilities = capabilities,
  })
  vim.lsp.enable('ruff')

  -- Настройка автокомплита (ТОЛЬКО по Ctrl+Space)
  cmp.setup({
    completion = { autocomplete = false },
    snippet = {
      expand = function(args) vim.fn["vsnip#anonymous"](args.body) end,
    },
    mapping = cmp.mapping.preset.insert({
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }),
      ['<Tab>'] = cmp.mapping.select_next_item(),
      ['<S-Tab>'] = cmp.mapping.select_prev_item(),
    }),
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'vsnip' },
    }, {
      { name = 'buffer' },
    })
  })


  vim.lsp.config('vimls', {
    cmd = { "vim-language-server", "--stdio" },
    root_markers = { ".git", "init.vim", "init.lua" }
  })
  vim.lsp.enable('vimls')

EOF

