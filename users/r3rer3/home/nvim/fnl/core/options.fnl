; some filetype options
(vim.cmd "filetype plugin indent on")

(let [opt vim.opt
      config-dir (vim.fn.stdpath :config)] ; don't make a backup before overwriting a file
  (set opt.backup false)
  (set opt.writebackup false) ; keep swap files in one location
  (set opt.directory [(.. config-dir :/tmp/)]) ; undo (set undo folder, file, and level)
  (set opt.undofile true)
  (set opt.undodir [(.. config-dir :/undodir)])
  (set opt.undolevels 2000)
  (set opt.undoreload 20000) ; do not highlight all search results
  (set opt.hlsearch false) ; start highlight of search while typing
  (set opt.incsearch true) ; case-insensitive searching
  (set opt.ignorecase true) ; case-sensitive if expression contains a capital letter
  (set opt.smartcase true) ; disable mouse
  (set opt.mouse "") ; make copy and paste work between vim and computer
  (set opt.clipboard :unnamedplus) ; display incomplete commands
  (set opt.showcmd true) ; intuitive backspacing
  (set opt.backspace [:indent :eol :start]) ; show hybrid line number
  (set opt.number true)
  (set opt.relativenumber true) ; set size of width of column where number line appears
  (set opt.numberwidth 2) ; highlight row where the cursor is ; (set opt.cursorline true) ; set tab and shift, and convert tab to space
  (set opt.tabstop 4)
  (set opt.shiftwidth 4)
  (set opt.expandtab true) ; handle multiple buffers better
  (set opt.hidden true) ; enhanced command line completion
  (set opt.wildmenu true) ; highlight ruler at column 80
  (set opt.colorcolumn :80) ; turn off line wrapping
  (set opt.wrap false) ; show 10 lines of context around the cursor
  (set opt.scrolloff 10) ; set the terminal's title
  (set opt.title true) ; set terminal's title to filename
  (set opt.titlestring "%t") ; set spell options
  (set opt.spell false)
  (set opt.spelllang "en_us,pt_br") ; enable true colors support
  (set opt.termguicolors true) ; set background to dark
  (set opt.background :dark) ; folding
  (set opt.foldlevelstart 50)
  (set opt.foldmethod :expr) ; set sign column to always show
  (set opt.signcolumn :yes))
