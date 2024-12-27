(let [navic (require :nvim-navic)
      lualine (require :lualine)
      window (fn [] (vim.api.nvim_win_get_number 0))]
  (lualine.setup {
                  :options {:theme "catppuccin"}
                  :extensions [:nvim-tree :fugitive :fzf :nvim-dap-ui :quickfix :toggleterm :trouble :symbols-outline]
                  :sections {:lualine_a [{1 "mode" :color {:gui "none"}}]
                             :lualine_c [{1 "filename" :path 1}
                                         {1 :navic :color_correction nil :navic_opts nil}]
                             :lualine_y [window]
                             :lualine_z [{1 "location" :color {:gui "none"}}]}
                  :tabline {:lualine_a [{1 "buffers" 
                                         :mode 4 
                                         :buffers_color {:active {:gui "none"}} 
                                         :filetype_names {:TelescopePrompt "Telescope"
                                                          :NvimTree "NvimTree"
                                                          :fzf "FZF"
                                                          :alpha "Alpha"}}]
                            :lualine_z [:tabs]}}))
