((. (require :specs) :setup))

(vim.keymap.set :n :<leader>bb
                (fn []
                  ((. (require :specs) :show_specs)))
                {:silent true :desc "Highlights where the cursor is"})
