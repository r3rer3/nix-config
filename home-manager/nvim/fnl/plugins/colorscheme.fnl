(let [catppuccin (require :catppuccin)]
  (catppuccin.setup {
                     :termcolors true
                     :integrations {
                                    :alpha true
                                    :beacon true
                                    :fidget true
                                    :lsp_trouble true
                                    :lsp_saga true
                                    :which_key true
                                    :cmp true
                                    :rainbow_delimiters true
                                    :nvimtree true
                                    :indent_blankline {
                                                       :enabled true
                                                       :scope_color :lavender}}}))
                                        
(vim.cmd "colorscheme catppuccin-mocha")
