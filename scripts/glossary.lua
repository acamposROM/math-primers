-- glossary.lua — pandoc Lua filter for hover-glossary blurbs.
--
-- Turns spans marked `[term]{.def}` into a term with an embedded popover that
-- contains the rendered definition (math included). Definitions come from the
-- Markdown file named in the GLOSSARY_FILE environment variable, one per
-- `## Heading` (the heading's slug is the lookup key).
--
-- Wiring is done in primer.sh:  GLOSSARY_FILE=... pandoc --lua-filter glossary.lua ...

local glossary = nil  -- lazily-loaded map: key -> { title = string, html = string }

-- Writer options for rendering definition fragments: inherit ONLY the page's
-- math method (so math becomes mathjax `\(...\)`), not standalone/template.
local frag_opts = nil
local function writer_opts()
  if not frag_opts then
    frag_opts = pandoc.WriterOptions { html_math_method = PANDOC_WRITER_OPTIONS.html_math_method }
  end
  return frag_opts
end

-- Slugify a heading/term into a lookup key: lowercase, non-alphanumerics -> "-".
local function slug(s)
  return (s:lower():gsub("[^%w]+", "-"):gsub("^%-+", ""):gsub("%-+$", ""))
end

local function load_glossary()
  local map = {}
  local path = os.getenv("GLOSSARY_FILE")
  if not path then return map end
  local fh = io.open(path, "r")
  if not fh then return map end
  local text = fh:read("*a"); fh:close()

  local doc = pandoc.read(text, "markdown")
  local key, title, blocks = nil, nil, {}
  local function flush()
    if key then
      -- The popover lives inside an inline <span>, which may NOT contain block
      -- elements like <p> (the HTML parser ejects them, dropping the definition).
      -- So flatten the definition's paragraphs into inline content, separated by
      -- a blank line, and render that. Math (inline or display) is preserved.
      local inlines = {}
      for _, b in ipairs(blocks) do
        if b.t == "Para" or b.t == "Plain" then
          if #inlines > 0 then
            table.insert(inlines, pandoc.RawInline("html", "<br><br>"))
          end
          for _, inl in ipairs(b.content) do
            table.insert(inlines, inl)
          end
        end
      end
      map[key] = {
        title = title,
        html = pandoc.write(pandoc.Pandoc({ pandoc.Plain(inlines) }), "html", writer_opts()),
      }
    end
    blocks = {}
  end
  for _, b in ipairs(doc.blocks) do
    if b.t == "Header" then
      flush()
      title = pandoc.utils.stringify(b)
      key = slug(title)
    elseif key then
      table.insert(blocks, b)
    end
  end
  flush()
  return map
end

-- Rewrite `[text]{.def}` spans into hover-glossary markup.
function Span(el)
  if not el.classes:includes("def") then return nil end

  glossary = glossary or load_glossary()
  local key = el.attributes.key
  if not key or key == "" then key = slug(pandoc.utils.stringify(el)) end

  local entry = glossary[key]
  if not entry then
    io.stderr:write("glossary: no entry for key '" .. key .. "' — leaving term as plain text\n")
    return pandoc.Span(el.content)  -- drop the .def class; render as ordinary text
  end

  local term_html = pandoc.write(pandoc.Pandoc({ pandoc.Plain(el.content) }), "html", writer_opts())
  local popover =
    '<span class="gloss-pop" role="tooltip">' ..
      '<span class="gloss-title">' .. (entry.title or key) .. '</span>' ..
      entry.html ..
    '</span>'
  local html = '<span class="gloss" tabindex="0">' .. term_html .. popover .. '</span>'
  return pandoc.RawInline("html", html)
end
