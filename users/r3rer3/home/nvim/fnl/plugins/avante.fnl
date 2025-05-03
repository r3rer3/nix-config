((. (require :img-clip) :setup) {:default {:embed_image_as_base66 false
                                           :prompt_for_file_name false
                                           :drag_and_drop {:insert_mode true}
                                           :use_absolute_path true}})

((. (require :render-markdown) :setup) {:file_types [:markdown :Avante]})

((. (require :avante_lib) :load))

((. (require :avante) :setup) {:claude {:model :claude-3-7-sonnet-latest
                                        :max_tokens 16384}
                               :system_prompt (fn [] (let [hub ((. (require :mcphub) :get_hub_instance))]
                                                       (hub:get_active_servers_prompt)))
                               :custom_tools (fn [] (let [mcp_tool ((. (require :mcphub.extensions.avante) :mcp_tool))]
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
                               :rag_service {:enabled true}
                               :file_selector {:provider :telescope}})

((. (require :mcphub) :setup) {:auto_approve false
                               :extensions {:avante {:make_slash_commands true}}})
