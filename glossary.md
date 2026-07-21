<!--
Glossary of short definitions shown as hover blurbs across the primers.

  * One `## Term` heading per entry; the slug of the heading is its lookup key
    (e.g. "Union-closed" -> key `union-closed`).
  * The body is the blurb and may contain LaTeX math ($...$, $$...$$).
  * Reference a term in a primer with a pandoc span:
        [union-closed]{.def}
    or, when the displayed words differ from the key:
        [union-closed families]{.def key=union-closed}
  * If an entry grows past a blurb, promote it to its own primer page and link
    to it from here.
-->

## Family

A *family* is a set whose members are themselves sets — e.g.
$\mathcal{F} = \{\,\{1\}, \{1,2\}\,\}$ is a family of subsets of $\{1,2\}$. In
combinatorics the word just signals that the collection of sets is the object under study.

## Closed

A set is *closed* under an operation when applying that operation to its members
always yields another member — e.g. the integers $\mathbb{Z}$ are closed under
addition and multiplication, but not under division. (This algebraic sense of "closed"
is distinct from a *closed set* in topology or a *closed-form* expression.)

## Union-closed

A finite family of finite sets $\mathcal{F}$ that is closed under unions: whenever
$A, B \in \mathcal{F}$, the union $A \cup B$ is also in $\mathcal{F}$.

## Abundant

An element $x$ is *abundant* in a family $\mathcal{F}$ when it belongs to at least
half of the member sets: $\left|\{\,A \in \mathcal{F} : x \in A\,\}\right| \ge |\mathcal{F}|/2$.

## Join-irreducible

In a lattice, an element that cannot be written as the join (least upper bound) of
two elements both strictly smaller than it. Intuitively, a "building block" of the lattice.

## Entropy method

An information-theoretic proof technique that bounds combinatorial quantities using
Shannon entropy $H(X) = -\sum_i p_i \log_2 p_i$. Gilmer (2022) used it to prove the
first constant lower bound for the union-closed sets conjecture.
