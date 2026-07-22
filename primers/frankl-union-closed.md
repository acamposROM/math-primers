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
set has an abundant element.^[1](#ref-frankl)^
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
This family is a *chain* — its sets are nested, $\emptyset \subseteq \{1\} \subseteq
\{1,2\} \subseteq \{1,2,3\}$. That makes it union-closed for free: any two members are
comparable (one contains the other), and the union of nested sets is just the larger
one, since $A \subseteq B$ gives $A \cup B = B$. So a union never produces a *new* set —
you always get back one of the two members you started with, which is already present.
(By contrast $\{\{1\}, \{2\}\}$ is *not* union-closed: $\{1\} \cup \{2\} = \{1,2\}$ escapes it.) Here $|\mathcal{F}| = 4$, and element $1$ appears in
$\{1\}, \{1,2\}, \{1,2,3\}$ — that is $3 \ge 4/2$ sets. So $1$ is abundant and the
conjecture holds for this family. Note $3$ appears in only one set, so *which*
element is abundant matters; the conjecture only asks that **some** element be.

## Why it is plausible (and why it resists)

The intuition: unions only ever *add* elements, so "popular" elements should
propagate upward through the family and end up in many sets. Averaging arguments
make this feel inevitable. But union-closure and abundance live at different *levels*. Abundance is *local* — it
asks whether one specific element sits in half the sets — while union-closure is a
*global* property of the whole family, indifferent to any single element. So the
hypothesis hands you no direct lever on the quantity you care about: you cannot just
nominate an element and force it to be popular, because a family can be union-closed
while spreading membership thinly and evenly, keeping every element below half.
Turning that global structural fact into a local, pointwise guarantee is exactly the
sticking point. The conjecture has a slippery, "obviously true but no handle"
character that has defeated many elementary attempts.

## Equivalent formulations

The conjecture wears several disguises; a foothold in one may help another.

- **Intersection-closed dual.** Take [complements]{.def key=complement} relative to the
  [universe]{.def} $U$, replacing each member $A$ by $U \setminus A$. De Morgan turns
  unions into intersections:
  $$(U \setminus A) \cap (U \setminus B) = U \setminus (A \cup B)$$
  So a union-closed family becomes intersection-closed, and "at least half" flips to
  "at most half." The chain $\{\emptyset, \{1\}, \{1,2\}, \{1,2,3\}\}$ (with
  $U = \{1,2,3\}$), for instance, complements to $\{\{1,2,3\}, \{2,3\}, \{3\}, \emptyset\}$.
  So the conjecture is equivalent to: every finite intersection-closed family other than
  $\{U\}$ has an element in **at most** half its members. (Why complementation does this,
  plus the abundance flip: see [Set Duality](set-duality.html).)

- **Lattice form.** A [union-closed]{.def} family ordered by inclusion is a finite
  [lattice]{.def} (with join $=$ union). Frankl's conjecture is equivalent to the statement that
  **every finite lattice has a [join-irreducible]{.def} element $j$ lying below at most half
  of the lattice's elements.** This reframes a set-system question as a purely
  order-theoretic one. (See [Lattices](lattices.html).)

- **Graph form.** There is a formulation for the family of independent sets, and a
  well-studied special case for lattices of subgroups / bipartite graphs, each of
  which is itself open in general.

## Known results and status

The conjecture is verified in many regimes and, since 2022, has a genuine
theoretical lower bound — but the full statement is still open.

- **Small cases (computational).** True for every union-closed family whose universe
  has at most $12$ elements, and for every family with at most roughly $50$ member
  sets. Exhaustive search has therefore ruled out any *small* counterexample.^[6](#ref-bosnjak)^
  ([explore one below](#explorer))

- **Structural special cases.** True whenever $\mathcal{F}$ contains a set of size
  $1$ or $2$ (Poonen and others)^[2](#ref-poonen)^, and in various lattice-theoretic
  special cases. Early bounds (e.g. Knill^[3](#ref-knill)^) guaranteed only a *sublinear*
  abundance of about
  $\tfrac{|\mathcal{F}| - 1}{\log_2 |\mathcal{F}|}$.

- **Gilmer's breakthrough (2022).** Using an **information-theoretic / entropy**
  argument, Justin Gilmer proved the first *linear* bound: in any union-closed
  family, some element lies in at least a constant fraction $c \approx 0.01$ of the
  sets.^[4](#ref-gilmer)^ This was the first proof that abundance is bounded below by a
  positive constant proportion at all.

- **Rapid improvements.** Within weeks, several groups sharpened the entropy method
  to the bound
  $$
  c \;=\; \frac{3 - \sqrt{5}}{2} \;\approx\; 0.3819,
  $$
  and subsequent work has nudged slightly past it.^[5](#ref-improvements)^ The conjectured constant is
  $c = \tfrac12$, and closing the gap from $\approx 0.38$ to $0.5$ remains **open**.

## See it: a union-closed family explorer {#explorer}

The exhaustive-search result above is easy to *feel*. Generate a small union-closed family
below — the grid shows which sets (rows) contain which elements (columns). Some column is
always filled in **at least half** the rows: that abundant element is exactly what Frankl
predicts, and what the small-case checks confirm.

```{=html}
<div class="uc-demo">
  <div class="uc-controls">
    <button type="button" class="uc-regen">↻ New family</button>
    <label>universe size:
      <select class="uc-n"><option>3</option><option selected>4</option><option>5</option></select>
    </label>
  </div>
  <div class="uc-grid"></div>
  <p class="uc-summary"></p>
</div>
<script>
(function () {
  var host = document.currentScript.previousElementSibling;
  var grid = host.querySelector(".uc-grid"),
      summary = host.querySelector(".uc-summary"),
      nSel = host.querySelector(".uc-n");
  host.querySelector(".uc-regen").addEventListener("click", render);
  nSel.addEventListener("change", render);
  function randSubset(n){ var m=0,i; for(i=0;i<n;i++) if(Math.random()<0.5) m|=(1<<i); return m; }
  function popcount(x){ var c=0; while(x){ c+=x&1; x>>=1; } return c; }
  function label(m,n){ var e=[],i; for(i=0;i<n;i++) if(m&(1<<i)) e.push(i+1); return e.length?"{"+e.join(",")+"}":"∅"; }
  function genFamily(n){
    var gens=[], k=2+Math.floor(Math.random()*3), i, s;
    for(i=0;i<k;i++){ s=randSubset(n); if(s) gens.push(s); }
    if(!gens.length) gens.push((1<<n)-1);
    var fam={}; gens.forEach(function(g){ fam[g]=1; });
    var changed=true;
    while(changed){
      changed=false;
      var keys=Object.keys(fam).map(Number), a, b, u;
      for(a=0;a<keys.length;a++) for(b=a;b<keys.length;b++){ u=keys[a]|keys[b]; if(!fam[u]){ fam[u]=1; changed=true; } }
    }
    return Object.keys(fam).map(Number).sort(function(x,y){ return popcount(x)-popcount(y) || x-y; });
  }
  function render(){
    var n=parseInt(nSel.value,10), sets=genFamily(n), F=sets.length, i;
    var counts=[]; for(i=0;i<n;i++){ var c=0; sets.forEach(function(s){ if(s&(1<<i)) c++; }); counts.push(c); }
    var h='<table class="uc-table"><thead><tr><th>set</th>';
    for(i=0;i<n;i++) h+="<th>"+(i+1)+"</th>";
    h+="</tr></thead><tbody>";
    sets.forEach(function(s){
      h+='<tr><td class="uc-set">'+label(s,n)+"</td>";
      for(i=0;i<n;i++) h+="<td>"+((s&(1<<i))?'<span class="uc-dot"></span>':"")+"</td>";
      h+="</tr>";
    });
    h+='</tbody><tfoot><tr><td>share</td>';
    for(i=0;i<n;i++){ var ab=counts[i]/F>=0.5; h+='<td class="'+(ab?"uc-ab":"")+'">'+counts[i]+"/"+F+"</td>"; }
    h+="</tr></tfoot></table>";
    grid.innerHTML=h;
    var abund=[]; for(i=0;i<n;i++) if(counts[i]/F>=0.5) abund.push(i+1);
    summary.innerHTML="This family has <b>"+F+"</b> sets. Abundant elements (in ≥ half): <b>"
      + (abund.length?"{"+abund.join(", ")+"}":"—") + "</b>"
      + (abund.length?" — highlighted. At least one always clears 50%, as Frankl predicts.":".");
  }
  render();
})();
</script>
```

## How to run this on an AI harness

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

1. []{#ref-frankl}P. Frankl (1979) — origin of the conjecture; see D. G. Kelly and
   others for early discussion. (Predates arXiv.)
2. []{#ref-poonen}B. Poonen, *Union-closed families*, J. Combin. Theory Ser. A **59**
   (1992).
3. []{#ref-knill}E. Knill,
   [*Graph generated union-closed families of sets*](https://arxiv.org/abs/math/9409215)
   (1994) — sublinear bound.
4. []{#ref-gilmer}J. Gilmer,
   [*A constant lower bound for the union-closed sets conjecture*](https://arxiv.org/abs/2211.09055)
   (2022).
5. []{#ref-improvements}Entropy-method improvements to $\tfrac{3-\sqrt5}{2}$ (Nov 2022):
   [Sawin](https://arxiv.org/abs/2211.11504); [Chase–Lovett](https://arxiv.org/abs/2211.11689);
   [Alweiss–Huang–Sellke](https://arxiv.org/abs/2211.11731); [Pebody](https://arxiv.org/abs/2211.13139).
6. []{#ref-bosnjak}I. Bošnjak, P. Marković, and V. Vučković — computational verification
   of small cases.
