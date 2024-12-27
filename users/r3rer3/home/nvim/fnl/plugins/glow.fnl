((. (require :glow) :setup))

(vim.keymap.set :n :<leader>mp (fn [] (vim.api.nvim_command :Glow)) {:desc "Preview markdown file"})
