; TODO take a look at https://github.com/neovim/nvim-lspconfig/wiki/User-contributed-tips

(fn filter [f list]
  (var result [])
  (each [_ v (ipairs list)]
    (if (f v)
      (table.insert result v)))
  result)

(fn split-filter [f list]
  (var yes [])
  (var no [])
  (each [_ v (ipairs list)]
    (if (f v)
      (table.insert yes v)
      (table.insert no v)))
  [yes no])

(fn has-value? [tab val]
  (each [_ value (ipairs tab)]
    (when (= value val)
      (lua "return true")))
  false)

(local servers [{1 "arduino_language_server"}
                {1 "ast_grep"}
                {1 "astro"}
                {1 "asm_lsp"}
                {1 "autotools_ls"}
                {1 "awk_ls"}
                {1 "bashls"}
                {1 "clangd"}
                {1 "cmake"}
                {1 "coq_lsp"}
                {1 "cssls"
                 :settings {:css {:validate true
                                  :lint {:unknownAtRules "ignore"}}}}
                {1 "cssmodules_ls"}
                {1 "dafny"}
                {1 "dhall_lsp_server"}
                {1 "denols"}
                {1 "docker_compose_language_service"}
                {1 "dockerls"}
                {1 "dotls"}
                {1 "elixirls"}
                {1 "elmls"}
                {1 "erlangls"}
                {1 "eslint"
                 :settings {:codeActionOnSave {:enable true
                                               :mode "all"}}}
                {1 "fennel_language_server"}
                {1 "gleam"}
                {1 "glsl_analyzer"}
                {1 "golangci_lint_ls"}
                {1 "graphql"}
                {1 "hoon_ls"}
                {1 "html"}
                {1 "htmx"}
                {1 "jqls"}
                {1 "jsonls"}
                {1 "lua_ls"
                 :settings {:Lua {:diagnostics {:globals ["vim"]}
                                  :completion {:callSnippet "Replace"}}}}
                {1 "marksman"}
                {1 "mdx_analyzer"}
                {1 "nil_ls"}
                {1 "nginx_language_server"}
                {1 "nim_langserver"}
                {1 "ocamllsp"}
                {1 "pest_ls"}
                {1 "prismals"}
                {1 "pylsp"
                 :settings {:pylsp {:plugins {:pyflakes {:enabled false}
                                              :pylint {:enabled false}
                                              :mccabe {:enabled false}
                                              :autopep8 {:enabled false}
                                              :pycodestyle {:enabled false}
                                              :yapf {:enabled false}}}}}
                {1 "racket_langserver"}
                {1 "ruby_lsp"}
                {1 "ruff_lsp"}
                {1 "reason_ls"}
                {1 "rescriptls"}
                {1 "solargraph"}
                {1 "solc"}
                {1 "solidity_ls_nomicfoundation"}
                {1 "sorbet"}
                {1 "sqlls"}
                {1 "svelte"}
                {1 "tailwindcss"}
                {1 "taplo"}
                {1 "terraformls"}
                {1 "tflint"}
                {1 "tsserver"}
                {1 "typst_lsp"}
                {1 "vale_ls"}
                {1 "veryl_ls"}
                {1 "vimls"}
                {1 "vls"}
                {1 "wgsl_analyzer"}
                {1 "yamlls"
                 :settings {:yaml {:schemaStore {:enable true}
                                   :customTags ["!fn"
                                                "!And"
                                                "!If"
                                                "!Not"
                                                "!Equals"
                                                "!Or"
                                                "!FindInMap sequence"
                                                "!Base64"
                                                "!Cidr"
                                                "!Ref"
                                                "!Ref Scalar"
                                                "!Sub"
                                                "!GetAtt"
                                                "!GetAZs"
                                                "!ImportValue"
                                                "!Select"
                                                "!Split"
                                                "!Join sequence"]}}}
                {1 "yls"}
                {1 "zls"}
                {1 "zk"}])

(local null-ls (require :null-ls))

(local linters [null-ls.builtins.formatting.alejandra
                null-ls.builtins.formatting.asmfmt
                null-ls.builtins.formatting.shfmt
                null-ls.builtins.formatting.cmake_format
                null-ls.builtins.formatting.elm_format
                null-ls.builtins.formatting.ocamlformat
                null-ls.builtins.formatting.fnlfmt
                null-ls.builtins.formatting.prettier
                null-ls.builtins.formatting.rubyfmt
                null-ls.builtins.formatting.sql_formatter
                null-ls.builtins.formatting.sqlfmt
                null-ls.builtins.formatting.nixfmt
                null-ls.builtins.diagnostics.actionlint
                null-ls.builtins.diagnostics.cmake_lint
                null-ls.builtins.diagnostics.commitlint
                null-ls.builtins.diagnostics.deadnix
                null-ls.builtins.diagnostics.hadolint
                null-ls.builtins.diagnostics.markdownlint
                null-ls.builtins.diagnostics.statix
                null-ls.builtins.diagnostics.tfsec
                null-ls.builtins.diagnostics.vint
                null-ls.builtins.diagnostics.yamllint
                null-ls.builtins.diagnostics.write_good
                null-ls.builtins.code_actions.statix])

(let [map vim.keymap.set
      { : nvim_create_user_command : nvim_create_autocmd } vim.api

      lspconfig (require :lspconfig)
      cmp-nvim-lsp (require :cmp_nvim_lsp)
      gotop (require :goto-preview)
      lspsaga (require :lspsaga)
      telescope (require :telescope.builtin)

      get-default-settings (fn [server]
                             (. lspconfig server :document_config :default_config :settings))

      lsp-binary-exists? (fn [server]
                           (let [cmd (. lspconfig server :document_config :default_config :cmd)]
                             (if (= nil cmd)
                               false
                               (let [binary (. cmd 1)]
                                 (= 1 (vim.fn.executable binary))))))

      linter-binary-exists? (fn [builtin]
                              (let [cmd builtin._opts.command]
                                (if (= nil cmd)
                                  false
                                  (= 1 (vim.fn.executable cmd)))))

      [available-lsps non-available-lsps] (split-filter (fn [server]
                                                          (lsp-binary-exists? (. server 1)))
                                                        servers)

      [available-linters non-available-linters] (split-filter linter-binary-exists? linters)

      capabilities (cmp-nvim-lsp.default_capabilities
                     (vim.lsp.protocol.make_client_capabilities))

      base-on-attach (fn [client bufnr]
                       (when client.server_capabilities.documentSymbolProvider
                         (navic.attach client bufnr))
                       ((. (require :illuminate) :on_attach) client)

                       (when (and
                               (not= nil client.resolved_capabilities)
                               (client.resolved_capabilities.code_lens))
                         (let [codelens (vim.api.nvim_create_augroup "LSPCodeLens" {:clear true})]
                           (nvim_create_autocmd [:BufEnter :InsertLeave :CursorHold]
                                                {:group codelens
                                                 :callback (fn []
                                                             (vim.lsp.codelens.refresh))
                                                 :buffer bufnr})))

                       ; lsp maps for buffers
                       (map :n :gpi (fn [] (gotop.goto_preview_implementation)) {:desc "Preview implementation" :buffer true})
                       (map :n :gP (fn [] (gotop.close_all_win)) {:desc "Closes all floating LSP windows" :buffer true})
                       (map :n :gr (fn [] (telescope.lsp_references)) {:desc "Go to references" :buffer true})
                       (map :n :gpd (fn [] (vim.api.nvim_command "Lspsaga peek_definition")) {:desc "Preview definition" :buffer true})
                       (map :n :gpt (fn [] (vim.api_nvim_command "Lspsaga peek_type_definition")) {:desc "Preview type definition" :buffer true})
                       (map :n :gd (fn [] (vim.lsp.buf.definition)) {:desc "Go to definition" :buffer true})
                       (map :n :gt (fn [] (vim.api.nvim_command "Lspsaga goto_type_definition")) {:desc "Go to type definition" :buffer true})
                       (map :n :gD (fn [] (vim.lsp.buf.declaration)) {:desc "Go to declaration" :buffer true})
                       (map :n :go (fn [] (vim.api.nvim_command "Lspsaga outline")) {:desc "Outline" :buffer true})
                       (map :n :gF (fn [] (vim.api.nvim_command "Lspsaga finder")) {:desc "Find where word under the cursor is used" :buffer true})
                       (map :n :K (fn [] (vim.api.nvim_command "Lspsaga hover_doc")) {:desc "Hover to get info" :buffer true})
                       (map :n :gi (fn [] (vim.lsp.buf.implementation)) {:desc "Go to implementation" :buffer true}))]

  ; commands to show available and non-available servers and linters for the current filetype
  (let [lsp-cond (fn [filetype]
                   (fn [server]
                     (let [name (. server 1)
                           filetypes (. lspconfig name :document_config :default_config :filetypes)]
                       (has-value? filetypes filetype))))

        linter-cond (fn [filetype]
                      (fn [linter]
                        (let [{ : filetypes} linter]
                         (has-value? filetypes filetype))))]

    (nvim_create_user_command "InfoLsps" (fn []
                                           (let [available-lsps-for-filetype (filter (lsp-cond vim.bo.filetype) available-lsps)
                                                 non-available-lsps-for-filetype (filter (lsp-cond vim.bo.filetype) non-available-lsps)]
                                             (print "****** Available LSPs ******")
                                             (each [_ server (ipairs available-lsps-for-filetype)]
                                               (print (. server 1)))
                                             (print "\n\n\n")
                                             (print "****** Non-available LSPs ******")
                                             (each [_ server (ipairs non-available-lsps-for-filetype)]
                                               (print (. server 1)))))
                              {})
    (nvim_create_user_command "InfoLinters" (fn []
                                              (let [available-linters-for-filetype (filter (linter-cond vim.bo.filetype) available-linters)
                                                    non-available-linters-for-filetype (filter (linter-cond vim.bo.filetype) non-available-linters)]
                                                (print "****** Available Linters ******")
                                                (each [_ linter (ipairs available-linters-for-filetype)]
                                                  (print (. linter :name)))
                                                (print "\n\n\n")
                                                (print "****** Non-available Linters ******")
                                                (each [_ linter (ipairs non-available-linters-for-filetype)]
                                                  (print (. linter :name)))))
                              {}))

  (gotop.setup [])

  (lspsaga.setup {:lightbulb {:enable_in_insert false
                              :virtual_text false}
                  :code_action {:keys {:quit "<C-c>"}}
                  :hover {:open_link "gx"}})

  ; diagnostic mappings
  (map :n "]d" (fn [] (vim.api.nvim_command "Lspsaga diagnostic_jump_prev"))
       {:desc "Go to prev diagnostic"})
  (map :n "[d" (fn [] (vim.api.nvim_command "Lspsaga diagnostic_jump_next"))
       {:desc "Go to next diagnostic"})
  (map :n "<leader>dl" (fn [] (vim.api.nvim_command "Trouble diagnostics toggle"))
       {:desc "Opens diagnostics"})

  ; rename node
  (map :n "<leader>rn" (fn [] (vim.lsp.buf.rename))
       {:desc "Rename node"})

  ; code action mappings
  (map :n :<leader>ca (fn [] (vim.api.nvim_command "Lspsaga code_action"))
       {:desc "Displays code action menu"})

  ; setup lsp servers
  (each [_ server (ipairs available-lsps)]
    (let [name (. server 1)
          settings (if (= nil server.settings)
                     (get-default-settings name)
                     server.settings)
          on-attach (if (= nil server.on-attach)
                      base-on-attach
                      (fn [client bufnr]
                        (base-on-attach client bufnr)
                        (server.on-attach client bufnr)))]
      ((. lspconfig name :setup) {: settings : capabilities :on_attach on-attach})))

  ; null-ls setup
  (null-ls.setup {:sources available-linters})

  ; language-specific setup
  ((. (require :go) :setup))
  ((. (require :lean) :setup) {:mappings true})
  ((. (require :clangd_extensions) :setup) {})

  (set vim.g.rustaceanvim {:tools {}
                           :server {: capabilities
                                    :on_attach (fn [client bufnr]
                                                 (base-on-attach client bufnr)
                                                 (map :n :<localleader>k (fn [] (vim.lsp.buf.hover)) {:buffer true :desc "Hover to get info"})
                                                 (map :n :<space>hs ht.hoogle.hoogle_signature {:desc "Hoogle signature"})
                                                 (map :n :<leader>hr ht.repl_toggle {:desc "Toggle GHC repl"})
                                                 (map :n :<leader>hf (fn []
                                                                       (ht.repl.toggle (vim.api.nvim_buf_get_name 0)))
                                                      {:buffer true :desc "Toggle GHC repl"})
                                                 (map :n :<leader>rq ht.repl.quit {:desc "Quit GHC repl"}))}})

  ; format on save
  (var format-enabled true)
  (nvim_create_user_command "ToggleAutoFormat" (fn [] (set format-enabled (not format-enabled))) {})
  (nvim_create_autocmd "BufWritePre" {:pattern "*"
                                      :callback (fn []
                                                  (when format-enabled
                                                    (if (= "go" vim.bo.filetype)
                                                      ((. (require :go.format) :goimport))
                                                      (vim.lsp.buf.format {:async true}))))})

  ; fidget setup
  ((. (require :fidget) :setup) {})

  (nvim_create_user_command "ToggleAutoFormat" (fn [] (set format-enabled (not format-enabled))) {})
  (nvim_create_autocmd "BufWritePre" {:pattern "*"
                                      :callback (fn []
                                                  (when (and
                                                          format-enabled
                                                          (> (length (vim.lsp.buf_get_clients)) 1)) ; greater than one to account for Copilot
                                                    (if (= "go" vim.bo.filetype)
                                                      ((. (require :go.format) :goimport))
                                                      (vim.lsp.buf.format {:async true}))))})

  ; fidget setup
  ((. (require :fidget) :setup) {})

  ; outline
  (map :n :<leader>3 "<cmd>Outline<CR>" {:desc "Toggle Outline"})
  ((. (require :outline) :setup) {})

  ; vista
  (var is-vista-open false)
  (map :n :<leader>1 (fn []
                       (if is-vista-open
                         (do (vim.api.nvim_command "Vista!!")
                             (set is-vista-open false))
                         (do (vim.api.nvim_command "Vista nvim_lsp")
                             (set is-vista-open true))))))
