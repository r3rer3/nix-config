(local map vim.keymap.set)
(local autocmd vim.api.nvim_create_autocmd)

(lambda add-new [name pattern ?event ?callback]
  (let [event (if (= ?event nil) :FileType ?event)
        callback (if (= ?callback nil) (fn []
                                         (set vim.bo.tabstop 2)
                                         (set vim.bo.shiftwidth 2)) ?callback)
        augroup vim.api.nvim_create_augroup
        ag-opts {:clear true}
        ag (augroup (.. "filetype_" name) ag-opts)]
    (autocmd event { :group ag : pattern : callback})
    ag))

(lambda update-ag [ag pattern event callback]
  (autocmd event { :group ag : pattern : callback}))


; Protobuf
(add-new :proto :proto)

; Typst
(add-new :typst :typst)

; TOML
(add-new :toml :toml)

; Dafny
(add-new :dafny :dafny)

; Gleam
(add-new :gleam :gleam)

; Javascript and Typescript
(add-new "js_ts" ["*.ts" "*.js" "*.jsx" "*.tsx"] [:BufRead :BufNewFile])

; JSON
(add-new :json :json)

; Rescript
(add-new :rescript ["*.res" "*.resi"] [:BufRead :BufNewFile])

; CSS
(add-new :css :css)

; Markdown
(add-new :markdown ["*.md" "*.markdown"] [:BufRead :BufNewFile] (fn []
                                                                  (set vim.wo.wrap true)))

; Makefile
(add-new :make :Makefile [:BufRead :BufNewFile] (fn []
                                                  (set vim.bo.expandtab false)
                                                  (set vim.bo.tabstop 2)
                                                  (set vim.bo.shiftwidth 2)))

; C and C++
(add-new "c_cpp" [:c :cpp])

; Haskell
(add-new :haskell :haskell)

; OCaml
(let [ag-ocaml (add-new :ocaml :ocaml)]
     (update-ag ag-ocaml "*.mli" [:BufRead :BufNewFile] (fn []
                                                         (set vim.bo.filetype :ocamlinterface)))
     (update-ag ag-ocaml "*.mly" [:BufRead :BufNewFile] (fn []
                                                         (set vim.bo.filetype :menhir)))
     (update-ag ag-ocaml "*.mll" [:BufRead :BufNewFile] (fn []
                                                         (set vim.bo.filetype :ocamllex))))

; Nix
(add-new :nix :nix)

; Coq
(add-new :coq :coq)
; TODO do Coq colors
;vim.cmd [[
;augroup CoqtailHighlights
;  autocmd!
;  autocmd ColorScheme *
;    \  hi def CoqtailChecked ctermbg=236 guibg=#113311
;    \| hi def CoqtailSent    ctermbg=237 guibg=#007630
;augroup END
;]]

; Terraform
(add-new :terraform :terraform)

;  Quickfix and Loclist
(add-new "qf-loc" :qf nil (fn [info]
                            (let [getbufinfo vim.fn.getbufinfo
                                  buf-info (. (. (getbufinfo info.buf) 1) :windows)]
                              (when (not= nil (next buf-info))
                                (let [win-id (. buf-info 1)
                                      win-info (. (vim.fn.getwininfo win-id) 1)
                                      {: nvim_command} vim.api]
                                  (if (= win-info.loclist 1)
                                    (do
                                      (map :n "<localleader>j" (fn [] (nvim_command :lnext)) {:desc "Goes to next item on Loclist"})
                                      (map :n "<localleader>k" (fn [] (nvim_command :lprev)) {:desc "Goes to previous item on Loclist"})
                                      (map :n "<C-c>" (fn [] (nvim_command :lclose)) {:desc "Closes Loclist"}))
                                    (do
                                      (map :n "<localleader>j" (fn [] (nvim_command :cn)) {:desc "Goes to next item on Quickfix"})
                                      (map :n "<localleader>k" (fn [] (nvim_command :cp)) {:desc "Goes to previous item on Quickfix"})
                                      (map :n "<C-c>" (fn [] (nvim_command :cclose)) {:desc "Closes Quickfix"}))))))))
