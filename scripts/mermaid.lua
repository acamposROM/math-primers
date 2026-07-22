-- mermaid.lua — pass ```mermaid code blocks through as raw <pre class="mermaid">
-- so mermaid.js can render them client-side (see scripts/mermaid-init.html).
-- Bypasses pandoc's code highlighting/escaping, which mermaid needs.
function CodeBlock(el)
  if el.classes:includes("mermaid") then
    return pandoc.RawBlock("html", '<pre class="mermaid">\n' .. el.text .. '\n</pre>')
  end
end
