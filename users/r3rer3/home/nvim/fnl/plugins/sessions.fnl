((. (require :auto-session) :setup) {:auto_session_create_enabled false
                                     :auto_session_use_git_branch true
                                     :pre_save_cmds ["NvimTreeClose"]
                                     :post_save_cmds ["NvimTreeOpen"]
                                     :post_restore_cmds ["NvimTreeOpen"]})

(vim.keymap.set :n :<leader>5 (fn []
                                ((. (require :auto-session.session-lens) :search_session))) {:desc "Opens list of sessions"})

