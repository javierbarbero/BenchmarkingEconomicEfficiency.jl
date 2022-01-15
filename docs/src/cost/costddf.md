```@meta
CurrentModule = BenchmarkingEconomicEfficiency
```

# Cost Directional Distance Function model

The cost directional distance function model is computed by solving an input-oriented [directional distance function DEA model](https://javierbarbero.github.io/DataEnvelopmentAnalysis.jl/stable/technical/directional/) for the technical efficiency.

The directional distance function *DDF*, projects firm $\left( {{\mathbf{x}_o,\mathbf{y}_{o}}} \right)$ to the production frontier 
in the pre-assigned direction $\mathbf{g}= {\left({{\mathbf{g_{x}^-},\mathbf{g^{+}_y}}} \right)\neq\mathbf{0}_{M+N}}$, $\mathbf{g^{-}_{x}}\mathbb{\in R}^M$ and $\mathbf{g^+_{y}}\mathbb{\in R}^N$.  
Decomposing cost  inefficiency requires defining the input-oriented directional distance functions. Departing from the general definition this implies setting the output directional vector to zero; i.e., $\mathbf{g}= \left({{\mathbf{g_{x}^-}},{\mathbf{g_{y}^+}}} \right)=\:$$\left({{\mathbf{g}_{\textbf{x}}^-,\textbf{0}}} \right)$. Therefore the input-oriented directional distance functions define as follows:

```math
T{{I}_{DDF(I)}}\left( {{\textbf{x}}_{o}},{{\textbf{y}}_{o}}, \textbf{g}_{\textbf{x}}^{{-}}, \textbf{0} \right)=\,\max \,\left\{ \beta_I :\left( {{\textbf{x}}_{o}}-{{\beta_I}}\textbf{g}_{\textbf{x}}^{{-}},{{\textbf{y}}_{o}} \right) \in L(\textbf{y}_o),\ {{\beta_I }}\ge 0 \right\}.
```

The linear programs that allows calculating this measure is: 

```math
\begin{split}
& T{{I}_{DDF(I)}}\left( {{\mathbf{x}}_{o}},{{\mathbf{y}}_{o}} \right)=\underset{{{\beta_I}_{{}}},\lambda }{\mathop{\text{max}}}\,\beta_I \,\,  \\ 
& s.t. \quad  \sum\limits_{j\in J}^{{}}{{{\lambda }_{j}}{{x}_{jm}}}\le {{x}_{om}}-\beta_I g_{{{x}_{m}}}^{{-}},\,\,\,m=1,...,M  \\ 
& \quad \quad \sum\limits_{j\in J}^{{}}{{{\lambda }_{j}}{{y}_{jn}}}\ge {{y}_{on}}\,\,n=1,...,N \\ 
& \quad \quad \sum\limits_{j\in J}^{{}}{{{\lambda }_{j}}}=1 \\ 
& \quad \quad {{\lambda }_{j}}\ge 0,\,\,j\in J.  
\end{split}
```

Once again, as in the graph case already presented for the [Profit Directional Distance Function model](@ref), the choice of directional vector corresponds to the
researcher. Customarily, to keep consistency with the radial models, the observed amounts of inputs set the direction:
$\mathbf{g}= \left({{\mathbf{g_{x}^-}},{\mathbf{g_{y}^+}}} \right)=\:$$\left({{\mathbf{x}_o,\textbf{0}}}\right)$. In this case it can be shown that the directional
model nests the [Radial Input Oriented Model](https://javierbarbero.github.io/DataEnvelopmentAnalysis.jl/stable/technical/radial/#Radial-Input-Oriented-Model). Indeed, if $\left({{\mathbf{g_{x}^-},\mathbf{g^+_y}}} \right)= \:$$\left( {{\mathbf{x}_o,\mathbf{0}}} \right)$, then $\beta_I^{*}=1-\theta^*$ (in the [Cost Radial model](@ref). However, other choices are available, which are included as options in **BenchmarkingEconomicEfficiency.jl**--see the documentation below accompanying this function.     

The notion of *Nerlovian* cost inefficiency corresponds to the decompostion of economic efficiency based on the input-oriented directional distance function: $C{{I}_{DDF\left( I \right)}}\left( {{\textbf{x}}_{o}},{{\textbf{y}}_{o}},\mathbf{g_{x}^-},{\tilde{\textbf{w}}} \right)$ = $T{{I}_{DDF\left( I \right)}}\left( {{\textbf{x}}_{o}},{{\textbf{y}}_{o},\mathbf{g_{x}^-}} \right)$ + $A{{I}_{DDF\left( I \right)}}\left( {{\textbf{x}}_{o}},{{\textbf{y}}_{o}},\mathbf{g_{x}^-},  {\tilde{\textbf{w}}} \right)$. This results in the following expression: 

```math
\underbrace{\frac{\sum\limits_{m=1}^{M}{{{w}_{m}}{{x}_{om}}}-C\left( {{\textbf{y}}_{o}}, \textbf{w} \right)}{\sum\limits_{m=1}^{M}{w_{m}^{{}}g_{om}^{-}}}}_{\text{Norm. Cost Inefficiency}}=\underbrace{\beta_{{O}}^{*}}_{\text{Technical Inefficiency}}+\underbrace{A{{I}_{DDF\left( I \right)}}\left( {{\textbf{x}}_{o}},{{\textbf{y}}_{o}},\mathbf{g_{x}^-},\tilde{\textbf{w}} \right)}_{\text{Norm. Allocative Inefficiency}} \ge 0,
```

**Reference**

Chapter 8 in Pastor, J.T., Aparicio, J. and Zofío, J.L. (2022) Benchmarking Economic Efficiency: Technical and Allocative Fundamentals, International Series in Operations Research and Management Science, Vol. 315,  Springer, Cham. 

**Example**

In this example we compute the cost efficiency directional distance function measure using the option `Gx=:Monetary`.
```@example costddf
using BenchmarkingEconomicEfficiency

X = [2 2; 1 4; 4 1; 4 3; 5 5; 6 1; 2 5; 1.6 8];

Y = [1; 1; 1; 1; 1; 1; 1; 1];

W = [1 1; 1 1; 1 1; 1 1; 1 1; 1 1; 1 1; 1 1];

costddf = deacostddf(X, Y, W, Gx = :Monetary)
```

Estimated economic, technical and allocative efficiency scores are returned with the `efficiency` function:
```@example costddf
efficiency(costddf, :Economic)
```

```@example costddf
efficiency(costddf, :Technical)
```

```@example costddf
efficiency(costddf, :Allocative)
```

### deacostddf Function Documentation

```@docs
deacostddf
```

