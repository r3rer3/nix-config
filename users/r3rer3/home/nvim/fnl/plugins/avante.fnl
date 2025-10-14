((. (require :img-clip) :setup) {:default {:embed_image_as_base66 false
                                           :prompt_for_file_name false
                                           :drag_and_drop {:insert_mode true}
                                           :use_absolute_path true}})

((. (require :render-markdown) :setup) {:file_types [:markdown :Avante]})

((. (require :avante_lib) :load))

((. (require :avante) :setup) {:provider :claude
                               :providers {:claude {:model :claude-sonnet-4-5-20250929}}
                               :auto_suggestions_provider :claude
                               :behaviour {:enable_token_counting false
                                           :auto_approve_tool_permissions false}
                               :system_prompt (fn []
                                                (let [hub ((. (require :mcphub)
                                                              :get_hub_instance))]
                                                  (hub:get_active_servers_prompt)))
                               :custom_tools (fn []
                                               (let [mcp_tool ((. (require :mcphub.extensions.avante)
                                                                  :mcp_tool))]
                                                 [mcp_tool]))
                               :disabled_tools [:python
                                                :list_files
                                                :search_files
                                                :read_file
                                                :create_file
                                                :delete_file
                                                :rename_file
                                                :create_dir
                                                :delete_dir
                                                :rename_dir
                                                :bash]
                               :rag_service {:enabled true
                                             :host_mount (.. (os.getenv :HOME)
                                                             :/Projects)}
                               :file_selector {:provider :telescope}})

((. (require :mcphub) :setup) {:auto_approve false
                               :extensions {:avante {:enabled true
                                                     :make_slash_commands true}}})
