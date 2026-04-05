((. (require :snacks) :setup) {:image {:resolve (fn [path src]
                                                  (local api
                                                         (require :obsidian.api))
                                                  (when (api.path_is_note path)
                                                    (api.resolve_attachment_path src)))}})
