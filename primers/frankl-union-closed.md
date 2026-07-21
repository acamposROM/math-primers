---
title: "Frankl's Union-Closed Sets Conjecture"
status: "open"
---

## The statement

::: {.definition title="Union-closed family"}
A finite [family]{.def} of finite sets $\mathcal{F}$ is *union-closed* if it is [closed]{.def} under
taking unions:
$$
A, B \in \mathcal{F} \;\Longrightarrow\; A \cup B \in \mathcal{F}
$$
:::

Call an element $x$ *abundant* in $\mathcal{F}$ if it lies in at least half of the
member sets:
$$
\left|\{\, A \in \mathcal{F} : x \in A \,\}\right| \;\ge\; \frac{|\mathcal{F}|}{2}
$$

::: {.conjecture title="Frankl, 1979"}
Every finite union-closed family $\mathcal{F}$ that contains at least one non-empty
set has an [abundant]{.def} element.
:::

The exclusion of the degenerate family $\mathcal{F} = \{\emptyset\}$ is necessary:
it has no elements at all, so nothing can be abundant. Everything else — including
families that happen to contain $\emptyset$ alongside non-empty sets — is in scope.

It sounds almost too simple to be hard. It is not: despite more than four decades
of attention it remains **open**, and it is one of the most notorious easy-to-state
problems in combinatorics.

## A worked micro-example

Let $U = \{1,2,3\}$ and
$$
\mathcal{F} = \bigl\{\, \emptyset,\ \{1\},\ \{1,2\},\ \{1,2,3\} \,\bigr\}
$$
This is a chain, so it is trivially union-closed (the union of two comparable sets
is the larger one). Here $|\mathcal{F}| = 4$, and element $1$ appears in
$\{1\}, \{1,2\}, \{1,2,3\}$ — that is $3 \ge 4/2$ sets. So $1$ is [abundant]{.def} and the
conjecture holds for this family. Note $3$ appears in only one set, so *which*
element is abundant matters; the conjecture only asks that **some** element be.

## Why it is plausible (and why it resists)

The intuition: unions only ever *add* elements, so "popular" elements should
propagate upward through the family and end up in many sets. Averaging arguments
make this feel inevitable. But the difficulty is that union-closure is a *global*
constraint with very little *local* structure to grab onto — you cannot simply
point to a distinguished element, and adversarial families can spread membership
out in subtle ways. The conjecture has a slippery, "obviously true but no handle"
character that has defeated many elementary attempts.

## Equivalent formulations

The conjecture wears several disguises; a foothold in one may help another.

- **Intersection-closed dual.** By complementing every set, a union-closed family
  becomes intersection-closed. The conjecture becomes: every finite
  intersection-closed family (other than $\{U\}$) has an element in **at most** half
  its members.

- **Lattice form.** A [union-closed]{.def} family ordered by inclusion is a finite lattice
  (with join $=$ union). Frankl's conjecture is equivalent to the statement that
  **every finite lattice has a [join-irreducible]{.def} element $j$ lying below at most half
  of the lattice's elements.** This reframes a set-system question as a purely
  order-theoretic one.

- **Graph form.** There is a formulation for the family of independent sets, and a
  well-studied special case for lattices of subgroups / bipartite graphs, each of
  which is itself open in general.

## Known results and status

The conjecture is verified in many regimes and, since 2022, has a genuine
theoretical lower bound — but the full statement is still open.

- **Small cases (computational).** True for every union-closed family whose universe
  has at most $12$ elements, and for every family with at most roughly $50$ member
  sets. Exhaustive search has therefore ruled out any *small* counterexample.

- **Structural special cases.** True whenever $\mathcal{F}$ contains a set of size
  $1$ or $2$ (Poonen and others), and in various lattice-theoretic special cases.
  Early bounds (e.g. Knill) guaranteed only a *sublinear* abundance of about
  $\tfrac{|\mathcal{F}| - 1}{\log_2 |\mathcal{F}|}$.

- **Gilmer's breakthrough (2022).** Using an **information-theoretic / entropy**
  argument, Justin Gilmer proved the first *linear* bound: in any union-closed
  family, some element lies in at least a constant fraction $c \approx 0.01$ of the
  sets. This was the first proof that abundance is bounded below by a positive
  constant proportion at all.

- **Rapid improvements.** Within weeks, several groups sharpened the entropy method
  to the bound
  $$
  c \;=\; \frac{3 - \sqrt{5}}{2} \;\approx\; 0.3819,
  $$
  and subsequent work has nudged slightly past it. The conjectured constant is
  $c = \tfrac12$, and closing the gap from $\approx 0.38$ to $0.5$ remains **open**.

## Connection to the harness — an honest appraisal

This primer's harness is built to **disprove** conjectures by certifying explicit
counterexamples. Frankl's conjecture is a poor fit for that mode, and it is worth
being clear about why:

- It is **believed true**, and every *small* case has been exhaustively checked, so
  a brute-force search for a tiny counterexample will find nothing. Contrast this
  with `euler-sum-of-powers`, where a genuine counterexample exists and the only job
  is to certify it.

- The realistic roles for a formal harness here are the *opposite* of disproof:

  1. **Certify small cases.** For a fixed finite family, "some element is abundant"
     is decidable — a `decide`/`Finset` computation. Good for building trust and for
     formalizing the base cases.
  2. **Formalize partial results.** The singleton/doubleton cases, the lattice
     reformulation, or eventually the entropy bound, are formalization targets rather
     than search targets.
  3. **Explore variants.** Generate union-closed families and measure abundance to
     build intuition, or probe *nearby* statements that might actually be false.

In short: treat Frankl as a **learning and formalization** target, not a
counterexample hunt. If disproof is the goal, the fruitful move is to look for a
*sharper* or *generalized* variant of Frankl that overreaches — those can be false.

## Formalization sketch

An illustrative (not yet type-checked) Lean 4 statement, to fix ideas:

```lean
-- x is abundant in F: it lies in at least half of F's member sets.
def Abundant {α : Type*} [DecidableEq α]
    (F : Finset (Finset α)) (x : α) : Prop :=
  2 * (F.filter (fun A => x ∈ A)).card ≥ F.card

-- Frankl's conjecture: every finite, union-closed family with a nonempty
-- member has an abundant element.
def Frankl : Prop :=
  ∀ (α : Type) [Fintype α] [DecidableEq α] (F : Finset (Finset α)),
    (∀ A ∈ F, ∀ B ∈ F, A ∪ B ∈ F) →   -- union-closed
    (∃ A ∈ F, A.Nonempty) →            -- not the degenerate {∅}
    ∃ x, Abundant F x
```

A *single fixed* family (like the micro-example above) can be checked with `decide`
once encoded as a concrete `Finset (Finset (Fin n))`. The universally-quantified
`Frankl` is, of course, the open problem.

## References

- P. Frankl (1979), origin of the conjecture; see D. G. Kelly and others for early
  discussion.
- B. Poonen, *Union-closed families*, J. Combin. Theory Ser. A **59** (1992).
- E. Knill, *Graph generated union-closed families of sets* (1994) — sublinear bound.
- J. Gilmer, *A constant lower bound for the union-closed sets conjecture* (2022).
- Sawin; Chase–Lovett; Alweiss–Huang–Sellke; Pebody (2022–23) — entropy-method
  improvements to $\tfrac{3-\sqrt5}{2}$ and slightly beyond.
- I. Bošnjak, P. Marković, and V. Vučković — computational verification of small cases.
