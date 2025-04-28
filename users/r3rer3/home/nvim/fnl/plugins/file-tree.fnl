(let [tree (require :nvim-tree)
      tree-api (require :nvim-tree.api)]
  (tree.setup {:open_on_tab true
               :update_focused_file {:enable true}
               :diagnostics {:enable true :show_on_dirs true}
               :actions {:open_file {:resize_window true}}
               :view {:width 50}
               :renderer {:highlight_opened_files :all :highlight_git true}
               :modified {:enable true
                          :show_on_dirs true
                          :show_on_open_dirs true}})
  (vim.keymap.set :n :<leader>2
                  (fn []
                    (tree-api.tree.toggle))
                  {:desc "Open/Close file tree"}))

(vim.keymap.set :n :<leader>r
                (fn []
                  (vim.api.nvim_command :NvimTreeRefresh))
                {:desc "Refreshes file tree"})
