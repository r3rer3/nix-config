((. (require :beacon) :setup))

(vim.keymap.set :n :<leader>bb
                 (fn []
                   ((. (require :beacon) :highlight_cursor)))
                {:silent true :desc "Highlights where the cursor is"})
