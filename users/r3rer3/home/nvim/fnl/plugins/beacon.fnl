((. (require :flare) :setup) {:enabled false
                              :x_threshold 20
                              :y_threshold 10
                              :fade false})

(vim.keymap.set :n :<leader>bb
                (fn []
                  ((. (require :flare) :cursor_moved) nil true))
                {:silent true :desc "Highlights where the cursor is"})
