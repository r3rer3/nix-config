(let [iron (require :iron.core)
      view (require :iron.view)
      common (require :iron.fts.common)]
  (iron.setup {:config {:scratch_repl true
                        :repl_definition {:sh {:command [:fish]}
                                          :python {:command [:ipython :--no-autoindent]}}
                        :repl_open_cmd (view.split.vertical.topleft "30%")}

               :keymaps {:toggle_repl "<space>rr"
                         :restart_repl "<space>rR"
                         :send_motion "<space>sc"
                         :visual_send "<space>sc"
                         :send_file "<space>sf"
                         :send_line "<space>sl"
                         :send_paragraph "<space>sp"
                         :send_until_cursor "<space>su"
                         :send_code_block "<space>sb"
                         :send_code_block_and_move "<space>sn"
                         :interrupt "<space>s<space>"
                         :exit "<space>sq"
                         :clear "<space>cl"}
               :ignore_blank_lines true})

  (vim.keymap.set :n "<space>rf" "<cmd>IronFocus<cr>"))
