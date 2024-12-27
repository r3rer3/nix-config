((. (require :ts_context_commentstring) :setup) { :enable_autocmd false })

((. (require :Comment) :setup) {
                                :prehook ((. (require :ts_context_commentstring.integrations.comment_nvim) :create_pre_hook))})

((. (require :todo-comments) :setup) {:signs false
                                      :highlight {:pattern ".*<(KEYWORDS)\\s*"}
                                      :search {:pattern "\\b(KEYWORDS)\\b"}})
