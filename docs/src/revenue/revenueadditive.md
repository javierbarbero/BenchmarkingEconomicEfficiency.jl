```@meta
CurrentModule = BenchmarkingEconomicEfficiency
```

# Revenue Additive model

The revenue additive model is computed by solving an [additive DEA model](https://javierbarbero.github.io/DataEnvelopmentAnalysis.jl/stable/technical/additive/) for the technical inefficiency.

The decomposition of revenue inefficiency based on the weighted additive distance function measures output-oriented  technical inefficiency based solely on output shortfalls, given by the following slack variables: $\mathbf{s}^+\mathbb{\in R}^N$. When the firm under evaluation ($\mathbf{x}_o$, $\mathbf{y}_o$) belongs to the production technology (as it is the case in cross-sectional studies), the DEA graph WADF model for measuring technical inefficiency is equivalent to the standard weighted additive model, which corresponds to the following DEA program:

```math
\begin{split}
& T{{I}_{WADF\text{(}O\text{)}}}\left( {{\textbf{x}}_{o}},{{\textbf{y}}_{o}},{{\rho }^{+}} \right)= \underset{\pmb{s}^{+},{\pmb{\lambda }} }{\mathop{\text{max}}}\, \sum\limits_{n=1}^{N}{\rho _{n}^{+}s_{n}^{+}}   \\
& s.t. \quad \sum\limits_{j=1}^{J}{{{\lambda }_{j}}{{x}_{jm}}}\le {{x}_{om}}, \quad  m=1,...,M  \\
& \quad \quad -\sum\limits_{j=1}^{J}{{{\lambda }_{j}}{{y}_{jr}}}+s_{n}^{+}\le -{{y}_{on}}, \quad  n=1,...,N  \\
& \quad \quad \sum\limits_{j=1}^{J}{{{\lambda }_{j}}}=1, \\
& \quad \quad s_{n}^{+}\ge 0,\quad  n=1,...,N  \\
& \quad \quad  {{\lambda }_{j}}\ge 0, \quad  j=1,...,J.  \\
\end{split} 
```

 For ($\mathbf{x}_o$, $\mathbf{y}_o$), this program seeks the maximum feasible increase in outputs while remaining in $P(\textbf{x}_o)$. An observation is technically efficient if the optimal solution ($\mathbf{s}^{+*}, \mathbf{\lambda}^{*}$) is $\mathbf{s}^{+*}=0$, with $T{{I}_{WA\text{(}O\text{)}}}\left( {{\textbf{x}}_{o}},{{\textbf{y}}_{o}},{{\rho }^{+}}\right)=0$. Otherwise individual output increases are feasible, and the larger the sum of the slacks, the larger the inefficiency. 

The components of ${\rho}_{\textbf{y}}^{+}=\rho_{1}^{+},...,\rho_{N}^{+} \in R_{++}^{N}$ represent the relative importance of the unit outputs and are called output *weights*. Therefore, assigning unitary values, the previous program collapse to the standard output-oriented additive model. As with the [Profit Additive model](@ref) we can change the value of the weights to obtain specific DEA models of the family known as general efficiency measures (GEMs). The relevance of these transformations is that they make the additive measures independent of the units of measurement, which is a desirable property. In the accompanying documentation for this function presented below we present the different options that are available in **Benchmarking Economic Efficiency** with *Julia*.  

 Following Pastor, Aparicio and Zofio (2022, Ch. 6) we can decompose normalized revenue inefficiency into the technical inefficiency component and the residual allocative measure of cost inefficiency, i.e, $R{{I}_{WADF\left( O \right)}}\left( {{\textbf{x}}_{o}},{{\textbf{y}}_{o}},\rho _{{}}^{+}, \tilde{{\textbf{p}}} \right)$ = $T{{I}_{WADF\left( O \right)}}\left( {{\textbf{x}}_{o}},{{\textbf{y}}_{o}} \right)$ + $A{{I}_{WADF\left( O \right)}}\left( {{\textbf{x}}_{o}},{{\textbf{y}}_{o}},\rho _{{}}^{+}, \tilde{{\textbf{p}}} \right)$:  

```math
\underbrace{\frac{R \left( \mathbf{x}_o,\mathbf{p} \right) - \sum\limits_{n=1}^{N}{{{p}_{n}}{{y}_{om}}} }{\min \left\{\frac{{{p}_{1}}}{\rho _{1}^{+}},...,\frac{{{p}_{N}}}{\rho _{N}^{+}} \right\}}}_{\text{Norm. Revenue Inefficiency}}= \\ 
 \underbrace{ \sum\limits_{n=1}^{N}{\rho _{n}^{+}s_{n}^{+}} }_{\text{Output Technical Inefficiency}}+\underbrace{A{{I}_{RM\left( O \right)}}\left( {{\textbf{x}}_{o}},{{\textbf{y}}_{o}},\rho _{{}}^{+}, \tilde{\textbf{p}} \right)}_{\text{Norm. Allocative Inefficiency}}\ge 0, \\  
```

**Reference**

Chapter 6 in Pastor, J.T., Aparicio, J. and Zofío, J.L. (2022) Benchmarking Economic Efficiency: Technical and Allocative Fundamentals, International Series in Operations Research and Management Science, Vol. 315,  Springer, Cham. 

**Example**

In this example we compute the revenue efficiency additive measure:
```@example revenueadditive
using BenchmarkingEconomicEfficiency

X = [1; 1; 1; 1; 1; 1; 1; 1];

Y = [7 7; 4 8; 8 4; 3 5; 3 3; 8 2; 6 4; 1.5 5];

P = [1 1; 1 1; 1 1; 1 1; 1 1; 1 1; 1 1; 1 1];

revenueadd = dearevenueadd(X, Y, P, :Ones)
```

Estimated economic, technical and allocative efficiency scores are returned with the `efficiency` function:
```@example revenueadditive
efficiency(revenueadd, :Economic)
```

```@example revenueadditive
efficiency(revenueadd, :Technical)
```

```@example revenueadditive
efficiency(revenueadd, :Allocative)
```

### dearevenueadd Function Documentation

```@docs
dearevenueadd
```

