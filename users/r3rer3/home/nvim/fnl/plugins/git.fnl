((. (require :git-conflict) :setup))

((. (require :gitblame) :setup) {:enabled false})

(vim.keymap.set :n :<leader>gb (fn []
                                 (vim.api.nvim_command :GitBlameToggle)) {:desc "Toggles virtual text of git blame"})
