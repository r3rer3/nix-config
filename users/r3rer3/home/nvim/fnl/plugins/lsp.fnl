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

(local servers [{1 :arduino_language_server}
                {1 :ast_grep}
                {1 :astro}
                {1 :asm_lsp}
                {1 :autotools_ls}
                {1 :awk_ls}
                {1 :bashls}
                {1 :biome 2 :biome}
                {1 :clangd}
                {1 :cmake}
                {1 :coq_lsp}
                {1 :cssls
                 :settings {:css {:validate true
                                  :lint {:unknownAtRules :ignore}}}}
                {1 :cssmodules_ls}
                {1 :dafny}
                {1 :dhall_lsp_server}
                ; {1 :denols
                ;  :settings {:deno {:enable true :lint true :fmt true}}}
                {1 :docker_compose_language_service}
                {1 :dockerls}
                {1 :dotls}
                {1 :elixirls}
                {1 :elmls}
                {1 :erlangls}
                {1 :eslint
                 :settings {:codeActionOnSave {:enable true :mode :all}}}
                {1 :fennel_language_server
                 :settings {:fennel {:workspace {:library (vim.api.nvim_list_runtime_paths)}
                                     :diagnostics {:globals [:vim]}}}}
                {1 :futhark_lsp}
                {1 :gleam}
                {1 :glsl_analyzer}
                {1 :golangci_lint_ls}
                {1 :gopls}
                {1 :graphql}
                {1 :hoon_ls}
                {1 :html}
                {1 :htmx}
                {1 :jqls}
                {1 :jsonls}
                {1 :lua_ls
                 :settings {:Lua {:diagnostics {:globals [:vim]}
                                  :completion {:callSnippet :Replace}}}}
                {1 :marksman}
                {1 :mdx_analyzer}
                {1 :nixd
                 :settings {:nixd {:nixpkgs {:expr "import <nixpkgs> { }"}
                                   :formatting {:command {1 :alejandra}}
                                   :options {:nixos {:expr "(builtins.getFlake \"/home/r3rer3/Projects/nix-config\").nixosConfigurations.r3rer3-linux.options"}
                                             :home-manager {:expr "(builtins.getFlake \"/home/r3rer3/Projects/nix-config\").homeConfigurations.\"r3rer3@r3rer3-linux\".options"}}}}}
                {1 :nginx_language_server}
                {1 :nim_langserver}
                {1 :ocamllsp}
                {1 :pest_ls}
                {1 :prismals}
                {1 :pylsp
                 :settings {:pylsp {:plugins {:pyflakes {:enabled false}
                                              :pylint {:enabled false}
                                              :mccabe {:enabled false}
                                              :autopep8 {:enabled false}
                                              :pycodestyle {:enabled false}
                                              :yapf {:enabled false}}}}}
                {1 :pyrefly}
                {1 :pyright}
                {1 :racket_langserver}
                {1 :ruby_lsp}
                {1 :ruff}
                {1 :reason_ls}
                {1 :rescriptls}
                {1 :solargraph}
                {1 :solc}
                {1 :solidity_ls_nomicfoundation}
                {1 :sorbet}
                {1 :sqlls}
                {1 :svelte}
                {1 :postgres_lsp}
                ; {1 :tailwindcss}
                {1 :taplo}
                {1 :terraformls}
                {1 :tflint}
                {1 :ts_ls}
                {1 :ty}
                {1 :tinymist}
                {1 :vale_ls}
                {1 :veryl_ls}
                {1 :vimls}
                {1 :vls}
                {1 :wgsl_analyzer}
                {1 :yamlls
                 :settings {:yaml {:schemaStore {:enable true}
                                   :customTags [:!fn
                                                :!And
                                                :!If
                                                :!Not
                                                :!Equals
                                                :!Or
                                                "!FindInMap sequence"
                                                :!Base64
                                                :!Cidr
                                                :!Ref
                                                "!Ref Scalar"
                                                :!Sub
                                                :!GetAtt
                                                :!GetAZs
                                                :!ImportValue
                                                :!Select
                                                :!Split
                                                "!Join sequence"]}}}
                {1 :yls}
                {1 :zls}
                {1 :zk}])

(local null-ls (require :null-ls))

(local linters [; null-ls.builtins.formatting.alejandra
                null-ls.builtins.formatting.asmfmt
                null-ls.builtins.formatting.black
                null-ls.builtins.formatting.isort
                null-ls.builtins.formatting.usort
                null-ls.builtins.formatting.shfmt
                null-ls.builtins.formatting.cmake_format
                ; null-ls.builtins.formatting.clang_format
                null-ls.builtins.formatting.elm_format
                null-ls.builtins.formatting.ocamlformat
                null-ls.builtins.formatting.fnlfmt
                null-ls.builtins.formatting.prettier
                null-ls.builtins.formatting.rubyfmt
                null-ls.builtins.formatting.sql_formatter
                null-ls.builtins.formatting.sqlfmt
                null-ls.builtins.formatting.nixfmt
                null-ls.builtins.formatting.typstyle
                null-ls.builtins.diagnostics.actionlint
                null-ls.builtins.diagnostics.cmake_lint
                null-ls.builtins.diagnostics.commitlint
                null-ls.builtins.diagnostics.deadnix
                null-ls.builtins.diagnostics.hadolint
                null-ls.builtins.diagnostics.markdownlint
                null-ls.builtins.diagnostics.mypy
                null-ls.builtins.diagnostics.pylint
                null-ls.builtins.diagnostics.statix
                null-ls.builtins.diagnostics.tfsec
                null-ls.builtins.diagnostics.vint
                null-ls.builtins.diagnostics.yamllint
                null-ls.builtins.diagnostics.write_good
                null-ls.builtins.code_actions.statix])

; to avoid conflicts with zls
(set vim.g.zig_fmt_autosave 0)

(let [map vim.keymap.set
      {: nvim_create_user_command : nvim_create_autocmd} vim.api
      cmp-nvim-lsp (require :cmp_nvim_lsp)
      gotop (require :goto-preview)
      lspsaga (require :lspsaga)
      telescope (require :telescope.builtin)
      navic (require :nvim-navic)
      get-default-settings (fn [server]
                             (let [cmd (. vim.lsp.config server :cmd)]
                               (if (= :function (type cmd))
                                   {}
                                   (. cmd :settings))))
      lsp-binary-exists? (fn [server-info]
                           (let [server (. server-info 1)
                                 conf (. vim.lsp.config server)]
                             (if (= nil conf) false
                                 (= nil (. conf :cmd)) false
                                 (let [binary (if (= nil (. server-info 2))
                                                  (. conf :cmd 1)
                                                  (. server-info 2))]
                                   (= 1 (vim.fn.executable binary))))))
      linter-binary-exists? (fn [builtin]
                              (let [cmd builtin._opts.command]
                                (if (= nil cmd) false
                                    (= 1 (vim.fn.executable cmd)))))
      [available-lsps non-available-lsps] (split-filter (fn [server-info]
                                                          (lsp-binary-exists? server-info))
                                                        servers)
      [available-linters non-available-linters] (split-filter linter-binary-exists?
                                                              linters)
      capabilities (cmp-nvim-lsp.default_capabilities)
      base-on-attach (fn [client bufnr]
                       (when client.server_capabilities.documentSymbolProvider
                         (navic.attach client bufnr)) ; ; lsp maps for buffers
                       (map :n :gpi (fn [] (gotop.goto_preview_implementation))
                            {:desc "Preview implementation" :buffer bufnr})
                       (map :n :gP (fn [] (gotop.close_all_win))
                            {:desc "Closes all floating LSP windows"
                             :buffer bufnr})
                       (map :n :gr (fn [] (telescope.lsp_references))
                            {:desc "Go to references" :buffer bufr})
                       (map :n :gpd
                            (fn []
                              (vim.api.nvim_command "Lspsaga peek_definition"))
                            {:desc "Preview definition" :buffer bufr})
                       (map :n :gpt
                            (fn []
                              (vim.api_nvim_command "Lspsaga peek_type_definition"))
                            {:desc "Preview type definition" :buffer bufr})
                       (map :n :gd (fn [] (vim.lsp.buf.definition))
                            {:desc "Go to definition" :buffer bufr})
                       (map :n :gt
                            (fn []
                              (vim.api.nvim_command "Lspsaga goto_type_definition"))
                            {:desc "Go to type definition" :buffer bufr})
                       (map :n :gD (fn [] (vim.lsp.buf.declaration))
                            {:desc "Go to declaration" :buffer bufr})
                       (map :n :go
                            (fn [] (vim.api.nvim_command "Lspsaga outline"))
                            {:desc :Outline :buffer bufnr})
                       (map :n :gF
                            (fn [] (vim.api.nvim_command "Lspsaga finder"))
                            {:desc "Find where word under the cursor is used"
                             :buffer bufnr})
                       (map :n :K
                            (fn [] (vim.api.nvim_command "Lspsaga hover_doc"))
                            {:desc "Hover to get info" :buffer bufnr})
                       (map :n :gi (fn [] (vim.lsp.buf.implementation))
                            {:desc "Go to implementation" :buffer bufnr})
                       (map :n :<localleader>ca
                            (fn [] (vim.lsp.buf.code_action)
                              {:desc "Code action"}
                              :buffer
                              bufnr))
                       nil)]
  (let [lsp-cond (fn [filetype]
                   (fn [server]
                     (let [name (. server 1)
                           filetypes (. vim.lsp.config name :filetypes)]
                       (has-value? filetypes filetype))))
        linter-cond (fn [filetype]
                      (fn [linter]
                        (let [{: filetypes} linter]
                          (has-value? filetypes filetype))))]
    (nvim_create_user_command :InfoLsps
                              (fn []
                                (let [available-lsps-for-filetype (filter (lsp-cond vim.bo.filetype
                                                                                    available-lsps))
                                      non-available-lsps-for-filetype (filter (lsp-cond vim.bo.filetype)
                                                                              non-available-lsps)]
                                  (print "****** Available LSPs ******")
                                  (each [_ server (ipairs available-lsps-for-filetype)]
                                    (print (. server 1)))
                                  (print "\n\n\n")
                                  (print "****** Non-available LSPs ******")
                                  (each [_ server (ipairs non-available-lsps-for-filetype)]
                                    (print (. server 1)))))
                              {})
    (nvim_create_user_command :InfoLinters
                              (fn []
                                (let [available-linters-for-filetype (filter (linter-cond vim.bo.filetype)
                                                                             available-linters)
                                      non-available-linters-for-filetype (filter (linter-cond vim.bo.filetype)
                                                                                 non-available-linters)]
                                  (print "****** Available Linters ******")
                                  (each [_ linter (ipairs available-linters-for-filetype)]
                                    (print (. linter :name)))
                                  (print "\n\n\n")
                                  (print "****** Non-available Linters ******")
                                  (each [_ linter (ipairs non-available-linters-for-filetype)]
                                    (print (. linter :name)))))
                              {}))
  (gotop.setup [])
  (lspsaga.setup {:lightbulb {:enable_in_insert false :virtual_text false}
                  :code_action {:keys {:quit :<C-c>}}
                  :hover {:open_link :gx}})
  (map :n "]d" (fn [] (vim.api.nvim_command "Lspsaga diagnostic_jump_prev"))
       {:desc "Go to prev diagnostic"})
  (map :n "[d" (fn [] (vim.api.nvim_command "Lspsaga diagnostic_jump_next"))
       {:desc "Go to next diagnostic"})
  (map :n :<leader>dl
       (fn [] (vim.api.nvim_command "Trouble diagnostics toggle"))
       {:desc "Opens diagnostics"})
  (map :n :<leader>rn (fn [] (vim.lsp.buf.rename)) {:desc "Rename node"})
  (map :n :<leader>ca (fn [] (vim.api.nvim_command "Lspsaga code_action"))
       {:desc "Displays code action menu"})
  (each [_ server (ipairs available-lsps)]
    (let [name (. server 1)
          settings (if (= nil server.settings)
                       (get-default-settings name)
                       server.settings)
          config {: settings : capabilities}]
      ((. vim.lsp.config) name config)
      ((. vim.lsp.enable) name)))
  (nvim_create_autocmd :LspAttach
                       {:callback (fn [args]
                                    (let [client (vim.lsp.get_client_by_id args.data.client_id)
                                          bufnr args.buf]
                                      (base-on-attach client bufnr)))})
  (null-ls.setup {:sources available-linters})
  ((. (require :go) :setup))
  ((. (require :lean) :setup) {:mappings true})
  ((. (require :clangd_extensions) :setup) {})
  (set vim.g.haskell_tools
       {:hls {:on_attach (fn [client bufnr ht]
                           (let [opts {:silent true
                                       :buffer bufnr
                                       :noremap true}]
                             (map :n :<localleader>hs
                                  ht.hoogle.hoogle_signature opts)
                             (map :n :K vim.lsp.buf.hover opts)
                             (map :n :<localleader>hr ht.repl.toggle opts)
                             (map :n :<localleader>hf
                                  (fn []
                                    (ht.repl.toggle (vim.api.nvim_buf_get_name 0)))
                                  opts)
                             (map :n :<leader>rq ht.repl.quit opts)
                             nil))}})
  (set vim.g.rustaceanvim {:server {:on_attach (fn [client bufnr]
                                                 (map :n :<leader>rr
                                                      (fn []
                                                        (vim.cmd.RustLsp :runnables))
                                                      {:desc "Run runnables"
                                                       :silent true
                                                       :buffer bufnr})
                                                 (map :n :<leader>re
                                                      (fn []
                                                        (vim.cmd.RustLsp :expandMacro))
                                                      {:desc "Expand macros recursively"
                                                       :silent true
                                                       :buffer bufnr})
                                                 (map :n :<leader>ee
                                                      (fn []
                                                        (vim.cmd.RustLsp :explainError))
                                                      {:desc "Explain Rust error"
                                                       :silent true
                                                       :buffer bufnr})
                                                 (map :n :<leader>rd
                                                      (fn []
                                                        (vim.cmd.RustLsp :renderDiagnostic))
                                                      {:desc "Render diagnostics"
                                                       :silent true
                                                       :buffer bufnr})
                                                 (map :n :<localleader>k
                                                      (fn []
                                                        (vim.cmd.RustLsp [:hover
                                                                          :actions]))
                                                      {:desc "Rust hover actions"
                                                       :silent true
                                                       :buffer bufnr})
                                                 (map :n :<leader>rk
                                                      (fn []
                                                        (vim.cmd.RustLsp [:hover
                                                                          :range]))
                                                      {:desc "Rust hover range"
                                                       :silent true
                                                       :buffer bufnr})
                                                 (map :n :<leader>ro
                                                      (fn []
                                                        (vim.cmd.RustLsp :openDocs))
                                                      {:desc "Open docs.rs documentation for the symbol under the cursor"
                                                       :silent true
                                                       :buffer bufnr})
                                                 (map :n :<leader>rp
                                                      (fn []
                                                        (vim.cmd.RustLsp :parentModule))
                                                      {:desc "Go to parent module"
                                                       :silent true
                                                       :buffer bufnr})
                                                 nil)
                                    :default_settings {:rust-analyzer {:files {:excludeDirs {1 :.direnv}}}}
                                    : capabilities}})
  (var format-enabled true)
  (nvim_create_user_command :ToggleAutoFormat
                            (fn [] (set format-enabled (not format-enabled))) {})
  (nvim_create_autocmd :BufWritePre
                       {:group (vim.api.nvim_create_augroup :LspFormatting
                                                            {:clear true})
                        :pattern "*"
                        :callback (fn []
                                    (when (and format-enabled
                                               (> (length (vim.lsp.buf_get_clients))
                                                  1))
                                      (if (= :go vim.bo.filetype)
                                          ((. (require :go.format) :goimport))
                                          (= :lean vim.bo.filetype)
                                          nil
                                          (vim.lsp.buf.format {:async false}))))})
  (nvim_create_user_command :ToggleInlayHints
                            (fn []
                              (vim.lsp.inlay_hint.enable (not (vim.lsp.inlay_hint.is_enabled))))
                            {})
  ((. (require :fidget) :setup) {})
  ((. (require :illuminate) :configure) {})
  (map :n :<leader>3 :<cmd>Outline<CR> {:desc "Toggle Outline"})
  ((. (require :outline) :setup) {})
  (var is-vista-open false)
  (map :n :<leader>1 (fn []
                       (if is-vista-open
                           (do
                             (vim.api.nvim_command :Vista!!)
                             (set is-vista-open false))
                           (do
                             (vim.api.nvim_command "Vista nvim_lsp")
                             (set is-vista-open true))))))
