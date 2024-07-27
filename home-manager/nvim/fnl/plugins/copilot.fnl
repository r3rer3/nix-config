(set vim.g.copilot_no_tab_map true)

(let [map vim.api.nvim_set_keymap
      options {:silent false :expr false}]
  (map :i :<C-j> "copilot#Accept(\"CR>\")" {:silent true :expr true})
  (map :i "<C-[>" "<Plug>(copilot-previous)" options)
  (map :i "<C-]>" "<Plug>(copilot-next)" options)
  (map :i "<C-l>" "<Plug>(copilot-accept-word)" options)
  (map :i :<C-M-l> "<Plug>(copilot-accept-line)" options))
