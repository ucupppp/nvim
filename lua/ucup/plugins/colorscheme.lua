return {
  {
    "folke/tokyonight.nvim",
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      local bg = "#011628"
      local bg_dark = "#011423"
      local bg_highlight = "#143652"
      local bg_search = "#0A64AC"
      local bg_visual = "#275378"
      local fg = "#CBE0F0"
      local fg_dark = "#B4D0E9"
      local fg_gutter = "#627E97"
      local border = "#547998"


      require("tokyonight").setup({
        style = "night",
        on_colors = function(colors)
          colors.bg = bg
          colors.bg_dark = bg_dark
          colors.bg_float = bg_dark
          colors.bg_highlight = bg_highlight
          colors.bg_popup = bg_dark
          colors.bg_search = bg_search
          colors.bg_sidebar = bg_dark
          colors.bg_statusline = bg_dark
          colors.bg_visual = bg_visual
          colors.fg = fg
          colors.border = border
          colors.fg_dark = fg_dark
          colors.fg_float = fg
          colors.fg_gutter = fg_gutter
          colors.fg_sidebar = fg_dark
        end,
        on_highlights = function(hl, c)
          hl.Normal = { bg = "NONE" }
          hl.NormalFloat = { bg = "NONE" }
          hl.VertSplit = { fg = c.border, bg = "NONE" }
          hl.LineNr = { bg = "NONE" }
          hl.StatusLine = { bg = "NONE" }
          hl.Pmenu = { bg = "NONE" }
          hl.PmenuSel = { bg = c.bg_highlight }
          hl.FloatBorder = { bg = "NONE" }
          hl.CursorLine = { bg = c.bg_highlight }
        end,
      })
      -- load the colorscheme here
      vim.cmd([[colorscheme tokyonight]])
    end,
  },
}
