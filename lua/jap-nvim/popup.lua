       -- JapConfig
       local width = 100
       local height = 30
       local opts = {}
       util.make_floating_popup_options(width, height, opts)
       local floating_bufnr, floating_winnr = util.open_floating_preview({"THIS IS THE CONTENT"}, "text", opts)


