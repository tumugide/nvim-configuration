call plug#begin('~/.local/share/nvim/plugged')
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.8' }
Plug 'phpactor/phpactor', {'for': 'php', 'tag': '*', 'do': 'composer install --no-dev -o'}
Plug 'akinsho/toggleterm.nvim', {'tag' : '*'}
Plug 'njorquera98/monokai_remastered.nvim'
Plug 'rafi/awesome-vim-colorschemes'
Plug 'folke/tokyonight.nvim'
Plug 'EmranMR/tree-sitter-blade'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'preservim/nerdtree'
Plug 'jiangmiao/auto-pairs'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-commentary'
Plug 'yaegassy/coc-blade', {'do': 'yarn install --frozen-lockfile'}
Plug 'ThePrimeagen/harpoon'
Plug 'f-person/git-blame.nvim'
Plug 'tpope/vim-fugitive' 
call plug#end()

lua require("toggleterm").setup()
lua <<EOF
require('nvim-treesitter.parsers').get_parser_configs().blade = {
  install_info = {
    url = 'https://github.com/EmranMR/tree-sitter-blade',
    files = {'src/parser.c'},
    branch = 'main',
  },
  filetype = 'blade',
}
-- Ensure the Treesitter parser for Blade is installed
require'nvim-treesitter.configs'.setup {
  ensure_installed = { "blade" },
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
}

-- Associate .blade.php files with the Blade filetype
vim.filetype.add({
  extension = {
    blade = "blade",
  },
})

EOF

" Define global extensions for CoC to ensure they are installed
let g:coc_global_extensions = [
  \ 'coc-tsserver',
  \ 'coc-eslint',       
  \ 'coc-prettier',     
  \ 'coc-json',         
  \ 'coc-html',         
  \ 'coc-css',          
  \ 'coc-angular',      
  \ 'coc-phpactor',  
  \ 'coc-blade',
  \ 'coc-pyright'
  \ ]

inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

inoremap kj <Esc>
cnoremap kj <Esc>
vnoremap kj <Esc>

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice.
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
"Ultisnips Settings
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"

" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"
set clipboard=unnamedplus
set number
set termguicolors     " enable true colors support
colorscheme tokyonight

" autocmd BufWritePre *.ts,*.tsx,*.js,*.jsx :EslintFixAll

"Adding line numbers
nnoremap <leader>ln :set number!<CR>
"Find files
nnoremap <leader>ff <cmd>Telescope fd hidden=false<cr>
" Grep in files
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
" Buffer search
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <silent> <leader>f :CocCommand prettier.formatFile<CR>

nnoremap <leader>tt <cmd>ToggleTerm direction=float<cr>
" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list
nmap <silent><nowait> [g <Plug>(coc-diagnostic-prev)
nmap <silent><nowait> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation
nmap <silent><nowait> gd <Plug>(coc-definition)
nmap <silent><nowait> gy <Plug>(coc-type-definition)
nmap <silent><nowait> gi <Plug>(coc-implementation)
nmap <silent><nowait> gr <Plug>(coc-references)
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)
" Apply the most preferred quickfix action to fix diagnostic on the current line
nmap <leader>qf  <Plug>(coc-fix-current)
nnoremap <silent> <leader>e :CocCommand eslint.executeAutofix<CR>
" Remap keys for applying refactor code actions
nmap <silent> <leader>re <Plug>(coc-codeaction-refactor)
nmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)
" Use K to show documentation in preview window
nnoremap <silent> K :call ShowDocumentation()<CR>

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" Mappings for CoCList
" Show all diagnostics
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>

lua << EOF
function _G.clear_harpoon_marks()
    require('harpoon.mark').clear_all()
    print("All Harpoon marks have been cleared.")
end
EOF
" Harpoon key mappings
nnoremap <leader>aa :lua require("harpoon.mark").add_file()<CR>
nnoremap <C-e> :lua require("harpoon.ui").toggle_quick_menu()<CR>
nnoremap <C-h> :lua require("harpoon.ui").nav_file(1)<CR>
nnoremap <C-t> :lua require("harpoon.ui").nav_file(2)<CR>
nnoremap <C-n> :lua require("harpoon.ui").nav_file(3)<CR>
nnoremap <C-s> :lua require("harpoon.ui").nav_file(4)<CR>
nnoremap <leader>hc :lua clear_harpoon_marks()<CR>

" Enabling the autorelod when changes are made
set autoread
