local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local t = ls.text_node
local fmt = require("luasnip.extras.fmt").fmt

return {
  -- pub async fn with name, params, return type
  s(
    "paf",
    fmt(
      [[
    pub async fn {}({}) -> {} {{
        {}
    }}
  ]],
      {
        i(1, "function_name"),
        i(2, "params: Type"), -- parameter
        i(3, "Result<(), Box<dyn std::error::Error>>"), -- return type
        i(4, "// body"), -- function body
      }
    )
  ),

  -- pub struct with fields and types
  s(
    "ps",
    fmt(
      [[
    pub struct {} {{
        {}: {},
        {}: {},
    }}
  ]],
      {
        i(1, "MyStruct"),
        i(2, "field1"),
        i(3, "Type1"),
        i(4, "field2"),
        i(5, "Type2"),
      }
    )
  ),
  -- pub struct with pub fields and types
  s(
    "pspf",
    fmt(
      [[
    pub struct {} {{
       pub {}: {},
       pub {}: {},
    }}
  ]],
      {
        i(1, "MyStruct"),
        i(2, "field1"),
        i(3, "Type1"),
        i(4, "field2"),
        i(5, "Type2"),
      }
    )
  ),
}
