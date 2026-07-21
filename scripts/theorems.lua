-- theorems.lua — pandoc Lua filter for LaTeX-style theorem environments.
--
-- Author an environment as a fenced div with a recognized class and an optional
-- title:
--
--     ::: {.definition title="Union-closed family"}
--     A finite family ... closed under unions: $A,B\in\mathcal F \Rightarrow A\cup B\in\mathcal F$.
--     :::
--
-- becomes a styled, auto-numbered box whose first line reads e.g.
-- "Definition 1 (Union-closed family)." Styling lives in primer.css (`.thm`).
--
-- Recognized classes: theorem, lemma, proposition, corollary, definition,
-- example, remark, conjecture, claim. Add `.unnumbered` to omit the number.

local display = {
  theorem = "Theorem", lemma = "Lemma", proposition = "Proposition",
  corollary = "Corollary", definition = "Definition", example = "Example",
  remark = "Remark", conjecture = "Conjecture", claim = "Claim",
}

local counters = {}

function Div(el)
  local kind
  for _, c in ipairs(el.classes) do
    if display[c] then kind = c break end
  end
  if not kind then return nil end

  -- Build the label: "Definition 3 (Title)."
  local label = display[kind]
  if not el.classes:includes("unnumbered") then
    counters[kind] = (counters[kind] or 0) + 1
    label = label .. " " .. counters[kind]
  end

  local title = el.attributes.title or el.attributes.name
  local label_html = '<span class="thm-label">' .. label
  if title and title ~= "" then
    label_html = label_html .. ' <span class="thm-title">(' .. title .. ')</span>'
  end
  label_html = label_html .. '.</span> '
  local label_inline = pandoc.RawInline("html", label_html)

  -- Prepend the label to the first paragraph so it flows inline with the text.
  local blocks = el.content
  if #blocks > 0 and (blocks[1].t == "Para" or blocks[1].t == "Plain") then
    table.insert(blocks[1].content, 1, label_inline)
  else
    table.insert(blocks, 1, pandoc.Plain({ label_inline }))
  end

  el.classes:insert("thm")          -- generic hook for CSS (type class kept too)
  el.attributes.title = nil          -- avoid a stray HTML title tooltip
  el.attributes.name = nil
  return el
end
