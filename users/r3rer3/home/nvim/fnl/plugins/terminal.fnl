((. (require :toggleterm) :setup))

(let [map vim.keymap.set]
  (map :t :jk "<C-\\><C-n>" {:desc "Exits terminal mode"})
  (map [:n :t] :<leader>otr (fn []
                              (var term-to-toggle "")
                              (when (not= vim.v.count 0)
                                (set term-to-toggle vim.v.count))
                              (vim.api.nvim_command (.. term-to-toggle "ToggleTerm")))
       {:desc "Toggles terminal in a window"})
  (map [:n :t] :<leader>ota (fn []
                              (vim.api.nvim_command "ToggleTermToggleAll"))
       {:desc "Toggles all terminals"})
  (map [:n :t] :<leader>ott (fn []
                              (vim.api.nvim_command "ToggleTerm direction=tab"))
       {:desc "Toggles terminal in a tab"})
  (map [:n :t] :<leader>otn (fn []
                              (var terminal-count 1)
                              (set terminal-count (+ terminal-count 1))
                              (vim.api.nvim_command (.. terminal-count "ToggleTerm"))))

  ; navigate splits when in terminal mode
  (map :t :<C-h> "<C-\\><C-n><C-W>h" {:desc "Goes to split to the left of current one"})
  (map :t :<C-l> "<C-\\><C-n><C-W>l" {:desc "Goes to split to the right of current one"})
  (map :t :<C-k> "<C-\\><C-n><C-W>k" {:desc "Goes to split above the current one"})
  (map :t :<C-j> "<C-\\><C-n><C-W>j" {:desc "Goes to split below the current one"}))
