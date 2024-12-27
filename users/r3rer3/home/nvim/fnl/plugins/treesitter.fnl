(let [conf {:highlight {:enable true :additional_vim_regex_highlighting false}
            :indent {:enable true}
            :matchup {:enable true :disable_virtual_text true}
            :textobjects {:select {:enable true
                                   :lookahead true
                                   :keymaps {:af "@function.outer"
                                             :if "@function.inner"
                                             :ac "@class.outer"
                                             :ic "@class.inner"}}
                          :swap {:enable true
                                 :swap_next {:<leader>sn "@parameter.inner"}
                                 :swap_previous {:<leader>sp "@parameter.inner"}}}}]
  ((. (require :nvim-treesitter.configs) :setup) conf))

((. (require :nvim-ts-autotag) :setup) {})
((. (require :rainbow-delimiters.setup) :setup) {})
