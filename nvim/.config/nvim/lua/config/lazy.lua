-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system({
    'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath,
  })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { 'Failed to clone lazy.nvim:\n', 'ErrorMsg' },
      { out, 'WarningMsg' },
      { '\nPress any key to exit...' },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before loading lazy.nvim
-- so that mappings are correct. This is also a good place to setup other
-- settings (vim.opt)
vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

require('lazy').setup({
  spec = {
    -- Solarized Osaka
    { 'craftzdog/solarized-osaka.nvim' },
    -- File exploration and navigation
    { 'junegunn/fzf.vim' },
    -- Languages and syntax
    { 'sheerun/vim-polyglot' },
    -- Style guide and linting
    { 'dense-analysis/ale' },
    { 'editorconfig/editorconfig-vim' },
    -- TypeScript
    { 'leafgarland/typescript-vim' },
    { 'Quramy/tsuquyomi' },
    { 'Shougo/vimproc.vim', build = 'make' },
    -- GitHub integration
    { 'github/copilot.vim' },
    { 'ruanyl/vim-gh-line' },
  },
  install = { colorscheme = { 'solarized-osaka' } },
  checker = { enabled = true },
})
