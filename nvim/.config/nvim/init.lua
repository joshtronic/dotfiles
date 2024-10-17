-- Plugins
require('config.lazy');

-- Color scheme and syntax highlighting
vim.cmd('syntax on')
vim.cmd('colorscheme solarized-osaka')
vim.o.background = 'dark'

-- Ensures misspellings are highlighted
vim.cmd('highlight SpellBad ctermfg=white ctermbg=red')

-- Global settings
vim.o.autoindent = true
vim.o.colorcolumn = '80,100,120'
vim.o.expandtab = true
vim.o.hidden = true
vim.o.hlsearch = true
vim.o.ignorecase = true
vim.o.incsearch = true
vim.o.laststatus = 2
vim.o.number = true
vim.o.relativenumber = true
vim.o.shiftwidth = 2
vim.o.smartindent = true
vim.o.softtabstop = 2
vim.o.tabstop = 2
vim.o.undofile = true

-- Filetype-specific settings
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'gitcommit',
  callback = function()
    vim.opt_local.colorcolumn = '50,72'
    vim.opt_local.textwidth = 72
  end
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = {'gitcommit', 'markdown', 'text'},
  callback = function()
    vim.opt_local.smartindent = false
    vim.opt_local.spell = true
  end
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = {'markdown', 'text'},
  callback = function()
    vim.opt_local.textwidth = 80
    vim.opt_local.wrapmargin = 2
  end
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = {'php', 'python'},
  callback = function()
    vim.opt_local.shiftwidth = 4
    vim.opt_local.softtabstop = 4
    vim.opt_local.tabstop = 4
  end
})

-- Strip trailing whitespace on save
vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = '*',
  command = [[%s/\s\+$//e]]
})

-- Set runtime path for fzf based on the operating system
if vim.fn.has('macunix') == 1 then
  vim.opt.rtp:append('/opt/homebrew/opt/fzf')
elseif vim.fn.executable('apt') == 1 then
  vim.opt.rtp:append('/usr/share/doc/fzf/examples')
elseif vim.fn.executable('pacman') == 1 then
  vim.opt.rtp:append('~/.fzf')
end
