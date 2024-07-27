((. (require :mini.trailspace) :setup))
((. (require :mini.bufremove) :setup))

(vim.api.nvim_set_hl 0 :MiniTrailspace {:bg "red"})

(var highlight-enabled true)

(let [map vim.keymap.set
      {: nvim_create_user_command : nvim_create_autocmd} vim.api]
  (nvim_create_user_command :ToggleTrim (fn [] (set vim.g.minitrailspace_disable (not vim.g.minitrailspace_disable))) {})
  (nvim_create_autocmd :BufWritePre {:pattern ["*"]
                                     :callback (fn []
                                                 (when (not vim.g.minitrailspace_disable)
                                                   (MiniTrailspace.trim)))})

  (map :n :<leader>th (fn []
                        (if highlight-enabled
                          (do
                            (MiniTrailspace.unhighlight)
                            (set highlight-enabled false))
                          (do
                            (MiniTrailspace.highlight)
                            (set highlight-enabled true))))
       {:desc "Toggles trailing space highlighting"})

  (map :n :<leader>bd (fn []
                        (if (= vim.bo.filetype "toggleterm")
                          (vim.api.nvim_command :bd!)
                          (vim.api.nvim_command :bd)))
       {:desc "Closes buffer using :bdelete"})

  (map :n :<leader>bu (fn []
                        (MiniBufremove.unshow_in_window 0))
       {:desc "Stops showing buffer in window, but does not delete it"})

  (map :n :<leader>bc (fn []
                        (if (= vim.bo.filetype "toggleterm")
                          (MiniBufremove.wipeout 0 true)
                          (MiniBufremove.wipeout 0 false)))
       {:desc "Closes buffer using bwipeout"}))
