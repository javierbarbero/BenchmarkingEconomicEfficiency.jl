```@meta
CurrentModule = BenchmarkingEconomicEfficiency
```

# Cost Additive model

The cost additive model is computed by solving an input-oriented [additive DEA model](https://javierbarbero.github.io/DataEnvelopmentAnalysis.jl/stable/technical/additive/) for the technical inefficiency.

The decomposition of cost inefficiency based on the weighted additive distance function measures input-oriented  technical inefficiency based solely on input excesses, given by the following slack variables: $\mathbf{s}^-$$\mathbb{\in R}^M$. When the firm under evaluation ($\mathbf{x}_o$, $\mathbf{y}_o$) belongs to the production technology (as it is the case in cross-sectional studies), the DEA graph WADF model for measuring technical inefficiency is equivalent to the standard weighted additive model, which corresponds to the following DEA program:

```math
\begin{split}
& T{{I}_{WADF\left( I \right)}}\left( {{\textbf{x}}_{o}},{{\textbf{y}}_{o}},{{\rho }^{-}} \right)= \underset{\begin{smallmatrix} \pmb{s}^{-}, \pmb{\lambda} \end{smallmatrix}}{\mathop{\max }}\, \sum\limits_{m=1}^{M}{\rho _{m}^{-}s_{m}^{-}} \\
& s.t. \quad \sum\limits_{j=1}^{J}{{{\lambda }_{j}}{{x}_{jm}}}+s_{m}^{-}\le {{x}_{om}}, \quad m=1,...,M   \\
& \quad \quad -\sum\limits_{j=1}^{J}{{{\lambda }_{j}}{{y}_{jn}}}\le -{{y}_{on}}, \quad  n=1,...,N   \\
& \quad \quad \sum\limits_{j=1}^{J}{{{\lambda }_{j}}}=1,  \\
& \quad \quad s_{m}^{-}\ge 0, \quad  m=1,...,M  \\
& \quad \quad {{\lambda }_{j}}\ge 0, \quad  j=1,...,J.   \\
\end{split} 
```

 For ($\mathbf{x}_o$, $\mathbf{y}_o$), this program seeks the maximum feasible reduction in inputs while remaining in $L(\textbf{y}_o)$. An observation is technically efficient if the optimal solution ($\mathbf{s}^{-*}, \mathbf{\lambda}^{*}$) is $\mathbf{s}^{-*}=0$, with $T{{I}_{WA\text{(}O\text{)}}}\left( {{\textbf{x}}_{o}},{{\textbf{y}}_{o}},{{\rho }^{-}}\right)=0$. Otherwise individual input reductions are feasible, and the larger the sum of the slacks, the larger the inefficiency. 

The components of ${\rho}_{\textbf{x}}^{-}=\rho_{1}^{-},...,\rho_{M}^{-} \in R_{++}^{M}$ represent the relative importance of the unit inputs and are called input *weights*. Therefore, assigning unitary values, the previous program collapse to the standard input-oriented additive model. As with the [Profit Additive model](@ref) we can change the value of the weights to obtain specific DEA models of the family known as general efficiency measures (GEMs). The relevance of these transformations is that they make the additive measures independent of the units of measurement, which is a desirable property. In the accompanying documentation for this function presented below we present the different options that are available in **BenchmarkingEconomicEfficiency.jl**. 
 
 Following Pastor, Aparicio and Zofio (2022, Ch. 6) we can  decompose normalized cost inefficiency into the technical inefficiency component and the residual allocative measure of cost inefficiency, i.e., $C{{I}_{WADF\left( I \right)}}\left( {{\textbf{x}}_{o}},{{\textbf{y}}_{o}},\rho _{{}}^{-},{\tilde{\textbf{w}}} \right)$ = $T{{I}_{WADF\left( I \right)}}\left( {{\textbf{x}}_{o}},{{\textbf{y}}_{o}} \right)$ + $A{{I}_{WADF\left( I \right)}}\left( {{\textbf{x}}_{o}},{{\textbf{y}}_{o}},\rho _{{}}^{-}, {\tilde{\textbf{w}}} \right)$:  

```math
\underbrace{\frac{\sum\limits_{m=1}^{M}{{{w}_{m}}{{x}_{om}}} - C \left( \mathbf{y}_o,\mathbf{w} \right)}{\min \left\{ \frac{{{w}_{1}}}{\rho _{1}^{-}},...,\frac{{{w}_{M}}}{\rho _{M}^{-}} \right\}}}_{\text{Norm. Cost Inefficiency}}= \underbrace{ \sum\limits_{m=1}^{M}{\rho _{m}^{-}s_{m}^{-}}}_{\text{Input Technical Inefficiency}}+\underbrace{A{{I}_{WADF\left( I \right)}}\left( {{\textbf{x}}_{o}},{{\textbf{y}}_{o}},\rho _{{}}^{-},\tilde{\textbf{w}} \right)}_{\text{Norm. Allocative Inefficiency}}\ge 0, \\  
```

**Reference**

Chapter 6 in Pastor, J.T., Aparicio, J. and Zofío, J.L. (2022) Benchmarking Economic Efficiency: Technical and Allocative Fundamentals, International Series in Operations Research and Management Science, Vol. 315,  Springer, Cham. 

**Example**


In this example we compute the cost efficiency additive measure:
```@example costadditive
using BenchmarkingEconomicEfficiency

X = [2 2; 1 4; 4 1; 4 3; 5 5; 6 1; 2 5; 1.6 8];

Y = [1; 1; 1; 1; 1; 1; 1; 1];

W = [1 1; 1 1; 1 1; 1 1; 1 1; 1 1; 1 1; 1 1];

costadd = deacostadd(X, Y, W, :Ones)
```

Estimated economic, technical and allocative efficiency scores are returned with the `efficiency` function:
```@example costadditive
efficiency(costadd, :Economic)
```

```@example costadditive
efficiency(costadd, :Technical)
```

```@example costadditive
efficiency(costadd, :Allocative)
```

### deacostadd Function Documentation

```@docs
deacostadd
```

