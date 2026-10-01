((. (require :img-clip) :setup) {:default {:embed_image_as_base66 false
                                           :prompt_for_file_name false
                                           :drag_and_drop {:insert_mode true}
                                           :use_absolute_path true}})

((. (require :render-markdown) :setup) {:file_types [:markdown]
                                        :sign {:enabled false}
                                        :heading {:position :inline}
                                        :latex {:enabled true
                                                :render_modes false
                                                :converter [:utftex :latex2text]
                                                :inline true
                                                :block true
                                                :highlight :RenderMarkdownMath
                                                :position :center
                                                :top_pad 0
                                                :bottom_pad 0}})
