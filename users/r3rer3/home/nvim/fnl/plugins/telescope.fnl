(let [telescope (require :telescope)]
  (telescope.setup {:defaults {:file_ignore_patterns [:tmp :undodir]}
                    :extensions {:fzf {:fuzzy true
                                       :override_generic_sorter true
                                       :override_file_sorter true
                                       :case_mode :smart_case}
                                 :ui-select {1 ((. (require :telescope.themes)
                                                   :get_dropdown) {})
                                             :codeactions false}}})
  (telescope.load_extension :fzf)
  (telescope.load_extension :ui-select)
  (telescope.load_extension :ultisnips))

(let [telescope (require :telescope.builtin)
      map vim.keymap.set]
  (map :n :<leader>ff (fn [] (telescope.find_files))
       {:desc "Telescope - find file"})
  (map :n :<leader>fg (fn [] (telescope.live_grep))
       {:desc "Telescope - find file"})
  (map :n :<leader>fb (fn [] (telescope.buffers)) {:desc "Telescope - buffers"})
  (map :n :<leader>fh (fn [] (telescope.help_tags))
       {:desc "Telescope - help tags"}))

((. (require :telescope) :load_extension) :ht)
