{

  plugins.cmp = {
    enable = true;
    autoEnableSources = true;
    settings = {
      sources = [
        { name = "luasnip"; }
        { name = "nvim_lsp"; }
        { name = "nvim_lsp_signature_help"; }
        { name = "path"; }
        { name = "buffer"; }
      ];

      snippet.expand = ''
        function(args)
          require('luasnip').lsp_expand(args.body)
        end
      '';

      mapping = {
        "<up>" = "cmp.mapping.select_prev_item()";
        "<TAB>" = "cmp.mapping.select_prev_item()";
        "<down>" = "cmp.mapping.select_next_item()";
        "<S-TAB>" = "cmp.mapping.select_next_item()";

        "<C-b>" = "cmp.mapping.scroll_docs(-4)";
        "<C-f>" = "cmp.mapping.scroll_docs(4)";

        "<M-Space>" = "cmp.mapping.complete()";

        "<C-e>" = "cmp.mapping.abort()";
        "<CR>" = "cmp.mapping.confirm({ select = true })";

        "<C-l>" = ''
          cmp.mapping(function()
            if luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            end
          end, { 'i', 's' })
        '';
        "<C-h>" = ''
          cmp.mapping(function()
            if luasnip.locally_jumpable(-1) then
              luasnip.jump(-1)
            end
          end, { 'i', 's' })
        '';
      };
    };
  };
  plugins.cmp-nvim-lsp-signature-help.enable = true;
}
