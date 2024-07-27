; change leader key to space
(set vim.g.mapleader " ")

; change localleader key to \
(set vim.g.maplocalleader "\\")

(let [map vim.keymap.set
      {: nvim_command} vim.api
      nop "<nop>"]

  ; arrows are unvimlike
  (map [:n :i :v] "<up>" nop { :desc "Makes 'up' key do nothing" })
  (map [:n :i :v] "<down>" nop { :desc "Makes 'down' key do nothing" })
  (map [:n :i :v] "<left>" nop { :desc "Makes 'left' key do nothing" })
  (map [:n :i :v] "<right>" nop { :desc "Makes 'right' key do nothing" })

  ; change key for leaving insert mode to jk
  (map :i "<Esc>" nop { :desc "Makes 'esc' key do nothing" })
  (map :i "jk" "<Esc>" { :desc "Makes jk leave insert mode" })

  ; spell
  (map :n "<leader>f" "1z=" { :desc "Gives Spelling suggestion" })
  (map :n "<leader>sc"
       (fn []
         (set vim.opt.spell (not
                              (vim.opt.spell:get)))) { :desc "Toggles spell on/off" })

  ; tabs
  (map :n "<leader>tt" (fn [] (nvim_command "tabnew")) { :desc "Creates a new tab after the current one" })
  (map :n "<leader>tp" (fn [] (nvim_command "-tabnew")) { :desc "Creates a new tab before the current one" })
  (map :n "<leader>tf" (fn [] (nvim_command "0tabnew")) { :desc "Creates a new tab before the first one" })
  (map :n "<leader>tl" (fn [] (nvim_command "$tabnew")) { :desc "Creates a new tab after the last one" })
  (map :n "<leader>tn" (fn [] (nvim_command "tabnext")) { :desc "Goes to next tab" })
  (map :n "<leader>tp" (fn [] (nvim_command "tabprevious")) { :desc "Goes to previous tab" })

  ; buffer
  (map :n "<leader>bt" (fn [] (nvim_command "enew")) { :desc "Creates a new buffer" })
  (map :n "<leader>bn" (fn [] (nvim_command "bn")) { :desc "Goes to next buffer" })
  (map :n "<leader>bp" (fn [] (nvim_command "bp")) { :desc "Goes to previous buffer" })

  ; create splits
  (map :n "<leader>ss" "<c-w>s" { :desc "Creates horizontal split" })
  (map :n "<leader>v" "<c-w>v" { :desc "Creates vertical split" })

  ; navigate splits
  (map :n "<leader>h" "<c-w>h" { :desc "Goes to split to the left of current one" })
  (map :n "<leader>l" "<c-w>l" { :desc "Goes to split to the right of current one" })
  (map :n "<leader>k" "<c-w>k" { :desc "Goes to split above the current one" })
  (map :n "<leader>j" "<c-w>j" { :desc "Goes to split below the current one" })

  ; resize splits
  (map :n "<leader>>" "<c-w>>" { :desc "Increases split's width" })
  (map :n "<leader><" "<c-w><" { :desc "Decreases split's width" })
  (map :n "<leader>+" "<c-w>+" { :desc "Increases split's height" })
  (map :n "<leader>-" "<c-w>-" { :desc "Decreases split's height" })

  ; folding
  (map :n "," "za" { :desc "Toggles folding" })
  (map :n "zO" "zR" { :desc "Opens all folds" })
  (map :n "zC" "zM" { :desc "Closes all folds" })
  (map :n "zc" "zc" { :desc "Closes current fold" })
  (map :n "zf" "mzzMzvzz" { :desc "Closes all folds except the current one" })

  ; wow very magic search
  (map :n "/" "/\\v" { :desc "wow so much magic search" }))
