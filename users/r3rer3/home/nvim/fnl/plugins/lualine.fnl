(let [navic (require :nvim-navic)
      lualine (require :lualine)
      window (fn [] (vim.api.nvim_win_get_number 0))]
  (lualine.setup {:options {:theme :catppuccin}
                  :extensions [:nvim-tree
                               :fugitive
                               :fzf
                               :nvim-dap-ui
                               :quickfix
                               :toggleterm
                               :trouble
                               :symbols-outline]
                  :sections {:lualine_a [{1 :mode :color {:gui :none}}]
                             :lualine_c [{1 :filename :path 1}
                                         {1 :navic
                                          :color_correction nil
                                          :navic_opts nil}]
                             :lualine_x [{1 (fn []
                                              (when (not vim.g.loaded_mcphub)
                                                (lua "return \"󰐻 -\""))
                                              (local count
                                                     (or vim.g.mcphub_servers_count
                                                         0))
                                              (local status
                                                     (or vim.g.mcphub_status
                                                         :stopped))
                                              (local executing
                                                     vim.g.mcphub_executing)
                                              (when (= status :stopped)
                                                (lua "return \"󰐻 -\""))
                                              (when (or (or executing
                                                            (= status :starting))
                                                        (= status :restarting))
                                                (local frames
                                                       ["⠋"
                                                        "⠙"
                                                        "⠹"
                                                        "⠸"
                                                        "⠼"
                                                        "⠴"
                                                        "⠦"
                                                        "⠧"
                                                        "⠇"
                                                        "⠏"])
                                                (local frame
                                                       (+ (% (math.floor (/ (vim.loop.now)
                                                                            100))
                                                             (length frames))
                                                          1))
                                                (let [___antifnl_rtn_1___ (.. "󰐻 "
                                                                              (. frames
                                                                                 frame))]
                                                  (lua "return ___antifnl_rtn_1___")))
                                              (.. "󰐻 " count))
                                          :color (fn []
                                                   (when (not vim.g.loaded_mcphub)
                                                     (let [___antifnl_rtn_1___ {:fg "#6c7086"}]
                                                       (lua "return ___antifnl_rtn_1___")))
                                                   (local status
                                                          (or vim.g.mcphub_status
                                                              :stopped))
                                                   (if (or (= status :ready)
                                                           (= status :restarted))
                                                       {:fg "#50fa7b"}
                                                       (or (= status :starting)
                                                           (= status
                                                              :restarting))
                                                       {:fg "#ffb86c"}
                                                       {:fg "#ff5555"}))}]
                             :lualine_y [window]
                             :lualine_z [{1 :location :color {:gui :none}}]}
                  :tabline {:lualine_a [{1 :buffers
                                         :mode 4
                                         :buffers_color {:active {:gui :none}}
                                         :filetype_names {:TelescopePrompt :Telescope
                                                          :NvimTree :NvimTree
                                                          :fzf :FZF
                                                          :alpha :Alpha}}]
                            :lualine_z [:tabs]}}))
