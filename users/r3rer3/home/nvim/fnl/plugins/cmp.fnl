(let [cmp (require :cmp)
      luasnip (require :luasnip)
      lspkind (require :lspkind)
      has-words-before? (fn []
                          (let [(line col) (unpack (vim.api.nvim_win_get_cursor 0))]
                            (and (not= col 0)
                                 (= (: (: (. (vim.api.nvim_buf_get_lines 0
                                                                         (- line
                                                                            1)
                                                                         line
                                                                         true)
                                             1)
                                          :sub col col)
                                       :match "%s")
                                    nil))))]
  (cmp.setup {:snippet {:expand (fn [args]
                                  (luasnip.lsp_expand args.body)
                                  nil)}
              :window {:completion (cmp.config.window.bordered {:border :rounded})
                       :documentation (cmp.config.window.bordered {:border :rounded})}
              :preselect cmp.PreselectMode.None
              :mapping {:<C-b> (cmp.mapping.scroll_docs -4)
                        :<C-f> (cmp.mapping.scroll_docs 4)
                        "<C-\\>" (cmp.mapping.complete)
                        :<C-e> (cmp.mapping.abort)
                        :<CR> (cmp.mapping.confirm {:behavior cmp.ConfirmBehavior.Replace
                                                    :select false})
                        :<Tab> (cmp.mapping (fn [fallback]
                                              (if (cmp.visible)
                                                  (cmp.select_next_item)
                                                  (luasnip.expand_or_jumpable)
                                                  (luasnip.expand_or_jump)
                                                  (has-words-before?)
                                                  (cmp.complete)
                                                  (fallback)))
                                            [:i :s])
                        :<S-Tab> (cmp.mapping (fn [fallback]
                                                (if (cmp.visible)
                                                    (cmp.select_prev_item)
                                                    (luasnip.jumpable -1)
                                                    (luasnip.jump -1)
                                                    (fallback)))
                                              [:i :s])}
              :sources [{:name :nvim_lsp :priority 0 :group_index 1}
                        {:name :luasnip :priority 1 :group_index 1}
                        {:name :nvim_lsp_signature_help
                         :priority 2
                         :group_index 1}
                        {:name :path :priority 3 :group_index 1}
                        {:name :buffer
                         :priority 1
                         :group_index 2
                         :keyword_length 4}
                        {:name :rg :priority 2 :group_index 2}]
              :formatting {:format (lspkind.cmp_format {:mode :symbol_text
                                                        :maxwidth 50
                                                        :ellipsis_char "..."})}
              :comparators [cmp.config.compare.offset
                            cmp.config.compare.exact
                            cmp.config.compare.score
                            (require :cmp-under-comparator)
                            .under
                            cmp.config.compare.kind
                            cmp.config.compare.sort_text
                            cmp.config.compare.length
                            cmp.config.compare.order]}))
