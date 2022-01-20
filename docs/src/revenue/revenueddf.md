```@meta
CurrentModule = BenchmarkingEconomicEfficiency
```

# Revenue Directional Distance Function model

The revenue directional distance function model is computed by solving a [directional distance function DEA model](https://javierbarbero.github.io/DataEnvelopmentAnalysis.jl/stable/technical/directional/) for the technical efficiency.

The directional distance function *DDF*, projects firm $\left( {{\mathbf{x}_o,\mathbf{y}_{o}}} \right)$ to the production frontier 
in the pre-assigned direction $\mathbf{g}= {\left({{\mathbf{g_{x}^-},\mathbf{g^{+}_y}}} \right)\neq\mathbf{0}_{M+N}}$, $\mathbf{g^{-}_{x}}\mathbb{\in R}^M$ and $\mathbf{g^+_{y}}\mathbb{\in R}^N$. Decomposing  revenue inefficiency requires defining the output-oriented directional distance functions. Departing from the general definition this implies setting the output or input directional vectors to zero; i.e., $\mathbf{g}= \left({{\mathbf{g_{x}^-}},{\mathbf{g_{y}^+}}} \right)=\:$$\left({{\textbf{0},\textbf{g}_{\textbf{y}}^+}} \right)$, respectively. Therefore the output-oriented directional distance functions defines as follows:

```math
T{{I}_{DDF(O)}}\left( {{\textbf{x}}_{o}},{{\textbf{y}}_{o}}, \textbf{0},\textbf{g}_{\textbf{y}}^{{+}} \right)=\,\max \,\left\{ \beta_O :\left( {{\textbf{x}}_{o}},{{\textbf{y}}_{o}}+{{\beta_O}}\textbf{g}_{\textbf{y}}^{{+}} \right)\in P(\textbf{x}_o),\ {{\beta_O}}\ge 0 \right\}.
```

The linear programs that allows calculating this measure is: 

```math
\begin{split}
& T{{I}_{DDF(O)}}\left( {{\mathbf{x}}_{o}},{{\mathbf{y}}_{o}} \right)=\underset{{{\beta_O }_{{}}},\lambda }{\mathop{\text{max}}}\,\beta_O \,\,   \\ 
& s.t. \quad \sum\limits_{j\in J}^{{}}{{{\lambda }_{j}}{{x}_{jm}}}\le {{x}_{om}},\,\,\,m=1,...,M  \\ 
& \quad \quad \sum\limits_{j\in J}^{{}}{{{\lambda }_{j}}{{y}_{jn}}}\ge {{y}_{on}}+\beta g_{{{y}_{n}}}^{{+}},\,\,n=1,...,N  \\ 
& \quad \quad \sum\limits_{j\in J}^{{}}{{{\lambda }_{j}}}=1  \\ 
& \quad \quad {{\lambda }_{j}}\ge 0,\,\,j\in J. 
\end{split}
```

Once again, as in the graph case already presented for the [Profit Directional Distance Function model](@ref), the choice of directional vector corresponds to the
researcher. Customarily, to keep consistency with the radial models, the observed amounts of outputs set the direction:
$\mathbf{g}= \left({{\mathbf{g_{x}^-}},{\mathbf{g_{y}^+}}} \right)=\:$$\left({\textbf{0},{\mathbf{y}_o}}\right)$. In this case it can be shown that the directional
model nests  [Radial Output Oriented Model](https://javierbarbero.github.io/DataEnvelopmentAnalysis.jl/stable/technical/radial/#Radial-Output-Oriented-Model). Indeed, if
$\left({{\mathbf{g_{x}^-},\mathbf{g^+_y}}} \right)=\:\left( {\mathbf{0},{\mathbf{y}_o}} \right)$, then $\beta_O^{*}=\phi^*-1$ (in the [Revenue Radial model](@ref).
However, other choices are available, which are included as options in **BenchmarkingEconomicEfficiency.jl**--see the documentation below accompanying this function.       

The notion of *Nerlovian* revenue inefficiency corresponds to the decompostion of economic efficiency based on the output-oriented directional distance function: $R{{I}_{DDF\left( O \right)}}\left( {{\textbf{x}}_{o}},{{\textbf{y}}_{o}},\mathbf{g_{y}^+},{\tilde{\textbf{p}}} \right)$ = $T{{I}_{DDF\left( O \right)}}\left( {{\textbf{x}}_{o}},{{\textbf{y}}_{o},\mathbf{g_{y}^+}} \right)$ + $A{{I}_{DDF\left( O \right)}}\left( {{\textbf{x}}_{o}},{{\textbf{y}}_{o}},\mathbf{g_{y}^+}, {\tilde{\textbf{p}}} \right)$. This results in the following expression: 

```math
\underbrace{\frac{R \left( \mathbf{x}_o,\mathbf{p} \right) - \sum\limits_{n=1}^{N}{{{p}_{n}}{{y}_{om}}} }{\sum\limits_{n=1}^{N}{p_{n}^{{}}g_{on}^{+}}}}_{\text{Norm. Revenue Inefficiency}}=\underbrace{\beta_{{I}}^{*}}_{\text{Technical Inefficiency}}+\underbrace{A{{I}_{DDF\left( I \right)}}\left( {{\textbf{x}}_{o}},{{\textbf{y}}_{o}},\mathbf{g_{y}^+},\tilde{\textbf{p}} \right)}_{\text{Norm. Allocative Inefficiency}} \ge 0.
```
**Reference**

Chapter 8 in Pastor, J.T., Aparicio, J. and Zofío, J.L. (2022) Benchmarking Economic Efficiency: Technical and Allocative Fundamentals, International Series in Operations Research and Management Science, Vol. 315,  Springer, Cham. 

**Example**

In this example we compute the revenue efficiency directional distance function measure using the option `Gy=:Monetary`.
```@example revenueddf
using BenchmarkingEconomicEfficiency

X = [1; 1; 1; 1; 1; 1; 1; 1];

Y = [7 7; 4 8; 8 4; 3 5; 3 3; 8 2; 6 4; 1.5 5];

P = [1 1; 1 1; 1 1; 1 1; 1 1; 1 1; 1 1; 1 1];

revenueddf = dearevenueddf(X, Y, P, Gy = :Monetary)
```

Estimated economic, technical and allocative efficiency scores are returned with the `efficiency` function:
```@example revenueddf
efficiency(revenueddf, :Economic)
```

```@example revenueddf
efficiency(revenueddf, :Technical)
```

```@example revenueddf
efficiency(revenueddf, :Allocative)
```

### dearevenueddf Function Documentation

```@docs
dearevenueddf
```

