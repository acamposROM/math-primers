---
title: "Euler's Sum of Powers Conjecture"
status: "disproved"
---

## The conjecture

In 1769 Euler conjectured a generalization of Fermat's Last Theorem. For
integers $n > 2$, he claimed that a sum of fewer than $n$ positive $n$-th
powers can never itself be an $n$-th power. Formally:

$$
\sum_{i=1}^{k} a_i^{\,n} = b^{\,n},\quad a_i, b \in \mathbb{Z}^{+}
\;\Longrightarrow\; k \ge n .
$$

For $n = 3$ this is exactly Fermat's Last Theorem (you need at least
$k = 3$ cubes to sum to a cube, e.g. $3^3 + 4^3 + 5^3 = 6^3$). Euler's leap
was to assert the pattern continues: at least $4$ fourth powers, at least
$5$ fifth powers, and so on.

## Why it looked plausible

The conjecture holds for $n = 3$ and resisted counterexample for nearly
two centuries. The heuristic: $n$-th powers grow fast, so the "density" of
representable sums thins out as $n$ grows, making a short sum landing exactly
on an $n$-th power seem vanishingly unlikely.

## The disproof

The conjecture is **false**. The first counterexample, found by Lander and
Parkin in 1966 via a direct computer search on a CDC 6600, is a sum of only
*four* fifth powers equal to a fifth power ($k = 4 < 5 = n$):

$$
27^5 + 84^5 + 110^5 + 133^5 = 144^5 .
$$

Check the magnitude: both sides equal $61{,}917{,}364{,}224$. This single
identity refutes the $n = 5$ case, and hence the general conjecture.

A later, smaller $n=4$ counterexample (Elkies, Frye, 1988) is
$$
95800^4 + 217519^4 + 414560^4 = 422481^4 ,
$$
a sum of *three* fourth powers — even more economical relative to $n = 4$.

## Why this is a good harness target

- **The counterexample is a finite, explicit, checkable object**: four
  integers and an equation. Certifying it in Lean is just evaluating both
  sides and using `decide`/`norm_num` — no deep theory required.
- It cleanly separates the two hard problems: *finding* the witness (a search
  problem, historically brute force) versus *certifying* it (trivial once found).
- It is a genuine, historically important disproof — a faithful dry run of the
  pipeline on ground truth we already trust.

## Formalization sketch

A first-pass Lean statement of the $n = 5$, $k = 4$ instance:

```lean
-- The conjecture predicts NO such quadruple exists for n = 5.
-- The disproof: exhibit one and evaluate.
example : 27^5 + 84^5 + 110^5 + 133^5 = 144^5 := by norm_num
```

To disprove the *general* statement you would state Euler's claim as a
`Prop` quantified over $n, k, a_i, b$, then instantiate it at the Lander–Parkin
witness. See `conjectures/EXAMPLE.md` for the workflow.

## References

- L. J. Lander, T. R. Parkin, *Counterexample to Euler's conjecture on sums of
  like powers*, Bull. Amer. Math. Soc. **72** (1966).
- N. Elkies, *On $A^4 + B^4 + C^4 = D^4$*, Math. Comp. **51** (1988).
