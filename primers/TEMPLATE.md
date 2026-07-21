---
title: "Primer — <topic>"
---

<!--
Author in Markdown + LaTeX math. Build with:
    scripts/primer.sh primers/<this-file>.md --open
Inline math: $...$   Display math: $$ ... $$
This file (TEMPLATE.md) is skipped by `scripts/primer.sh --all`.
-->

## The statement

State the problem/conjecture precisely. Inline math like $a_i^n = b^n$,
display math like:
$$
\sum_{i=1}^{k} a_i^{\,n} = b^{\,n}.
$$

## Context / why it matters

Background, history, and the intuition for why it is true or false.

## Key results / status

What is known. If disproved, give the counterexample explicitly.

## Connection to the harness

How would a counterexample be represented and certified in Lean?
Link the matching `conjectures/<slug>.md`.

## References

- Author, *Title*, Venue (Year).
