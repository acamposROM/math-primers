---
title: "Set-Family Duality: Complements & De Morgan"
---

## The idea

Complementing every set in a family — swapping each member $A$ for $U \setminus A$ — is a
mirror that turns *union* into *intersection*. Its immediate payoff: it converts a
union-closed family into an intersection-closed one. This note explains why, and the
reason is a single tool, **De Morgan's laws**.

## Complement and universe

::: {.definition title="Universe and complement"}
Fix a [universe]{.def} $U$ — a set containing every element in play. The
[complement]{.def} of $A$ (relative to $U$) is $U \setminus A$, the elements of $U$ not
in $A$. Complementing twice does nothing: $U \setminus (U \setminus A) = A$.
:::

Given a family $\mathcal{F} \subseteq 2^{U}$, its **complemented family** is
$$\mathcal{F}^{c} = \{\, U \setminus A : A \in \mathcal{F} \,\}$$
— the same sets, each turned inside out.

## De Morgan: complement swaps ∪ and ∩

De Morgan's two laws say complementation trades union for intersection and back:
$$U \setminus (A \cup B) = (U \setminus A) \cap (U \setminus B), \qquad
  U \setminus (A \cap B) = (U \setminus A) \cup (U \setminus B)$$

The left one is what we need. Read it one element at a time: a point lies in
$(U \setminus A) \cap (U \setminus B)$ exactly when it is in *neither* $A$ nor $B$ — that
is, outside $A \cup B$ — which is precisely membership in $U \setminus (A \cup B)$.

## Why union-closed becomes intersection-closed

::: {.proposition title="Complementation swaps the two closures"}
If $\mathcal{F}$ is union-closed, then $\mathcal{F}^{c}$ is intersection-closed.
:::

Take any two members of $\mathcal{F}^{c}$. By definition they are $U \setminus A$ and
$U \setminus B$ for some $A, B \in \mathcal{F}$. Their intersection is
$$(U \setminus A) \cap (U \setminus B) = U \setminus (A \cup B)$$
by De Morgan. Here is the crux: because $\mathcal{F}$ is [union-closed]{.def}, the set
$A \cup B$ is itself a member of $\mathcal{F}$ — so $U \setminus (A \cup B)$ is the
complement of a member, hence a member of $\mathcal{F}^{c}$. The intersection stayed
inside $\mathcal{F}^{c}$, which is exactly what "intersection-closed" means.

The intuition, in one sentence: **complementation is a mirror that swaps $\cup$ and
$\cap$, so a family closed under $\cup$ becomes, in the mirror, a family closed under
$\cap$.** The union you were guaranteed becomes the intersection you now need.

## A worked example

Take the chain $\mathcal{F} = \{\emptyset, \{1\}, \{1,2\}, \{1,2,3\}\}$ with
$U = \{1,2,3\}$, and complement each member:
$$
\begin{aligned}
U \setminus \emptyset &= \{1,2,3\}, &\qquad U \setminus \{1\} &= \{2,3\},\\
U \setminus \{1,2\} &= \{3\},       &\qquad U \setminus \{1,2,3\} &= \emptyset.
\end{aligned}
$$
So $\mathcal{F}^{c} = \{\{1,2,3\}, \{2,3\}, \{3\}, \emptyset\}$ — still a chain, but now
the intersection of any two members is the *smaller* one, which is present. Union-closed
became intersection-closed.

## Application: Frankl's conjecture

Where this duality earns its keep: [Frankl's conjecture](frankl-union-closed.html) can be
attacked from either side, because complementation turns each of its ingredients into a dual.

**The abundance flip.** Complementation also flips the count Frankl cares about. An element $x$ lies in
$U \setminus A$ exactly when it does *not* lie in $A$, so for each $x$,
$$(\text{members of } \mathcal{F}^{c} \text{ containing } x) =
  |\mathcal{F}| - (\text{members of } \mathcal{F} \text{ containing } x).$$
Being in **at least half** of $\mathcal{F}$ therefore turns into being in **at most
half** of $\mathcal{F}^{c}$. In the example, element $1$ is [abundant]{.def} in
$\mathcal{F}$ (in $3$ of $4$ sets) but sits in only $1$ of the $4$ members of
$\mathcal{F}^{c}$.

**The lone exception.** The degenerate union-closed family is $\{\emptyset\}$ (only the empty set); Frankl
excludes it because it has no elements to be abundant. Its complement is
$\{U \setminus \emptyset\} = \{U\}$. That is why the intersection-closed form excludes
exactly $\{U\}$ — it is the mirror image of the excluded $\{\emptyset\}$.

**Two faces.** Frankl's conjecture then has two equivalent forms:

- **(union form)** every finite union-closed family $\neq \{\emptyset\}$ has an element
  in **at least** half its members;
- **(intersection form)** every finite intersection-closed family $\neq \{U\}$ has an
  element in **at most** half its members.

They are one theorem seen in a mirror — you can attack whichever side is more convenient.
