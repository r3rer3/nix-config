(set vim.g.beacon_enable false)
(set vim.g.beacon_timeout 1000)
(set vim.g.beacon_size 50)

(vim.keymap.set :n :<leader>bb
                 (fn []
                   (vim.api.nvim_command "Beacon"))
                {:silent true :desc "Highlights where the cursor is"})
