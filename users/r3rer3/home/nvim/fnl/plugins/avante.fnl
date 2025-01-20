((. (require :img-clip) :setup) {:default {:embed_image_as_base64 false
                                           :prompt_for_file_name false
                                           :drag_and_drop {:insert_mode true}
                                           :use_absolute_path true}})

((. (require :render-markdown) :setup) {:file_types [:markdown :Avante]})

((. (require :avante_lib) :load))

((. (require :avante) :setup) {:claude {:model :claude-3-5-sonnet-latest
                                        :max_tokens 8192}})
