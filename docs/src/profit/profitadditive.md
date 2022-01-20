```@meta
CurrentModule = BenchmarkingEconomicEfficiency
```

# Profit Additive model

The profit additive model is computed by solving an [additive DEA model](https://javierbarbero.github.io/DataEnvelopmentAnalysis.jl/stable/technical/additive/) for the technical inefficiency.

The decomposition of profit inefficiency based on the weighted additive distance function measures graph technical inefficiency based solely on input excesses and output shortfalls, given by the following slack variables: $\mathbf{s}^-\mathbb{\in R}^M$ and $\mathbf{s}^+\mathbb{\in R}^N$. When the firm under evaluation ($\mathbf{x}_o$, $\mathbf{y}_o$) belongs to the production technology (as it is the case in cross-sectional studies), the DEA graph WADF model for measuring technical inefficiency is equivalent to the standard weighted additive model, which corresponds to the following program:

```math
\begin{split}
	&	T{{I}_{WADF\text{(}G\text{)}}}\left( {{\textbf{x}}_{o}},{{\textbf{y}}_{o}},{{\rho }^{-}},{{\rho }^{+}} \right)= \underset{
		\textbf{s}^{-},\textbf{s}^{+},{{\pmb{\lambda}}} 
	}{\mathop{\text{max}}}\, \sum\limits_{m=1}^{M}{\rho _{m}^{-}s_{m}^{-}}+\sum\limits_{n=1}^{N}{\rho _{n}^{+}s_{n}^{+}}  \\
	& s.t. \quad \sum\limits_{j=1}^{J}{{{\lambda }_{j}}{{x}_{jm}}}+s_{m}^{-}\le {{x}_{om}},  \quad m=1,...,M  \\
	& \quad \quad -\sum\limits_{j=1}^{J}{{{\lambda }_{j}}{{y}_{jr}}}+s_{n}^{+}\le -{{y}_{on}}, \quad n=1,...,N  \\
	& \quad \quad \sum\limits_{j=1}^{J}{{{\lambda }_{j}}}=1,   \\
	& \quad \quad s_{m}^{-}\ge 0, \quad m=1,...,M  \\
    & \quad \quad s_{n}^{+}\ge 0, \quad n=1,...,N  \\
	& \quad	\quad {{\lambda }_{j}}\ge 0, \quad j=1,...,J  \\
\end{split} 
```

 For ($\mathbf{x}_o$, $\mathbf{y}_o$), this program seeks the maximum feasible reduction in inputs and increase in outputs while remaining in $T$. An observation is technically efficient if the optimal solution ($\mathbf{s}^{-*}, \mathbf{s}^{+*},\lambda^*$) is $\mathbf{s}^{-*}=\mathbf{s}^{+*}=0$, so	$T{{I}_{WA\text{(}G\text{)}}}\left( {{\textbf{x}}_{o}},{{\textbf{y}}_{o}},{{\rho }^{-}},{{\rho }^{+}} \right)=0$. Otherwise individual input reductions or output expansions are feasible, and the larger the sum of the slacks, the larger the inefficiency. 

 The elements of the vectors of inputs' and outputs' weights: ${\rho}_{\textbf{x}}^{-}=\rho_{1}^{-},...,\rho_{M}^{-} \in R_{++}^{M}$ and ${\rho}_{\textbf{y}}^{-}=\rho_{1}^{+},...,\rho_{N}^{+} \in R_{++}^{N}$ represent the relative importance of each input and output when measuring technical inefficiency--hence the name of the measure. Therefore, assigning unit values (:Ones), the program corresponds to the standard additive model. However, by choosing alternative weights the $WADF$ encompasses a wide class of different DEA models known as general efficiency measures (GEMs).  As we show below, **BenchmarkingEconomicEfficiency.jl** allows to choose among a wide range of models. 
     
We can decompose normalized profit inefficiency into the technical inefficiency component and the residual allocative measure, $\Pi{{I}_{WADF\left( G \right)}}\left( {{\textbf{x}}_{o}},{{\textbf{y}}_{o}},\rho _{{}}^{-},\rho _{{}}^{+},{\tilde{\textbf{w}}}, \tilde{{\textbf{p}}} \right)$ = $T{{I}_{WADF\left( G \right)}}\left( {{\textbf{x}}_{o}},{{\textbf{y}}_{o}} \right)$ + $A{{I}_{WADF\left( G \right)}}\left( {{\textbf{x}}_{o}},{{\textbf{y}}_{o}},\rho _{{}}^{-},\rho _{{}}^{+}, {\tilde{\textbf{w}}}, \tilde{{\textbf{p}}} \right)$:  

```math
\begin{split}
	& \underbrace{\frac{\Pi \left( \textbf{w},\textbf{p} \right)-\left( \sum\limits_{n=1}^{N}{{{p}_{n}}{{y}_{on}}}-\sum\limits_{m=1}^{M}{{{w}_{m}}{{x}_{om}}} \right)}{\min \left\{ \frac{{{w}_{1}}}{\rho _{1}^{-}},...,\frac{{{w}_{M}}}{\rho _{M}^{-}},\frac{{{p}_{1}}}{\rho _{1}^{+}},...,\frac{{{p}_{N}}}{\rho _{N}^{+}} \right\}}}_{\text{Norm}\text{. Profit Inefficiency}}= \\ 
	& \quad =\underbrace{\sum\limits_{m=1}^{M}{\rho _{m}^{-}s_{m}^{-*}}+\sum\limits_{n=1}^{N}{\rho _{n}^{+}s_{n}^{+*}}}_{\text{Graph Technical Inefficiency}}+\ \,\underbrace{A{{I}_{WADF(G)}}\left( {{\textbf{x}}_{o}},{{\textbf{y}}_{o}},{{\rho }^{-}},{{\rho }^{+}},\tilde{\textbf{w}},\tilde{\textbf{p}} \right)}_{\text{Norm}\text{. Allocative Inefficiency}} \ge 0,  
\end{split}
```

**Reference**

Chapter 6 in Pastor, J.T., Aparicio, J. and Zofío, J.L. (2022) Benchmarking Economic Efficiency: Technical and Allocative Fundamentals, International Series in Operations Research and Management Science, Vol. 315,  Springer, Cham. 


**Example**

In this example we compute the profit efficiency additive measure:
```@example profitadditive
using BenchmarkingEconomicEfficiency

X = [2; 4; 8; 12; 6; 14; 14; 9.412];

Y = [1; 5; 8; 9; 3; 7; 9; 2.353];

W = [1; 1; 1; 1; 1; 1; 1; 1];

P = [2; 2; 2; 2; 2; 2; 2; 2];

profitadd = deaprofitadd(X, Y, W, P, :Ones)
```

Estimated economic, technical and allocative efficiency scores are returned with the `efficiency` function:
```@example profitadditive
efficiency(profitadd, :Economic)
```

```@example profitadditive
efficiency(profitadd, :Technical)
```

```@example profitadditive
efficiency(profitadd, :Allocative)
```

### deaprofitadd Function Documentation

```@docs
deaprofitadd
```

