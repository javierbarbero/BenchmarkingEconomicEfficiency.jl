```@meta
CurrentModule = DataEnvelopmentAnalysis
DocTestSetup = quote
    using DataEnvelopmentAnalysis
end
```
# Profit Directional Distance Function model

The profit directional model is computed by solving a [Directional Distance Function DEA Model](https://javierbarbero.github.io/DataEnvelopmentAnalysis.jl/stable/technical/directional/) for the technical inefficiency.

The directional distance function *DDF*, projects firm $\left( {{\mathbf{x}_o,\mathbf{y}_{o}}} \right)$ to the production frontier 
in the pre-assigned direction $\mathbf{g}= {\left({{\mathbf{g_{x}^-},\mathbf{g^{+}_y}}} \right)\neq\mathbf{0}_{M+N}}$, $\mathbf{g^{-}_{x}}\mathbb{\in R}^M$ and $\mathbf{g^+_{y}}\mathbb{\in R}^N$. Inputs and outputs are respectively reduced and increased according to the scalar $\beta$, identifying as reference projection $(\hat{\mathbf{x}}_{o},\hat{\mathbf{y}}_{o})=\left( {{\textbf{x}}_{o}}-{{\beta}}\textbf{g}_{\textbf{x}}^{{-}},{{\textbf{y}}_{o}}+{{\beta}}\textbf{g}_{\textbf{y}}^{{+}} \right)$. Therefore the directional distance functions define as follows:

```math
T{{I}_{DDF(G)}}\left( {{\textbf{x}}_{o}},{{\textbf{y}}_{o}}, \textbf{g}_{\textbf{x}}^{{-}}, \textbf{g}_{\textbf{y}}^{{+}} \right)=\,\max \,\left\{ \beta :\left( {{\textbf{x}}_{o}}-{{\beta}}\textbf{g}_{\textbf{x}}^{{-}},{{\textbf{y}}_{o}}+{{\beta}}\textbf{g}_{\textbf{y}}^{{+}} \right) \in T,\ {{\beta }}\ge 0 \right\}.
```

The *DDF* is calculated through the following DEA linear program:

```math
\begin{split}
	& T{{I}_{DDF(G)}}\left( {{\mathbf{x}}_{o}},{{\mathbf{y}}_{o}} \right)=\underset{{{\beta }_{{}}},\lambda }{\mathop{\text{max}}}\,\beta \,\,  \\ 
	& s.t.  \quad  \sum\limits_{j\in J}^{{}}{{{\lambda }_{j}}{{x}_{jm}}}\le {{x}_{om}}-\beta g_{{{x}_{m}}}^{{-}},\,\,\,m=1,...,M  \\ 
	& \quad \quad \sum\limits_{j\in J}^{{}}{{{\lambda }_{j}}{{y}_{jn}}}\ge {{y}_{on}}+\beta g_{{{y}_{n}}}^{{+}},\,\,n=1,...,N  \\ 
	& \quad \quad  \sum\limits_{j\in J}^{{}}{{{\lambda }_{j}}}=1  \\ 
	& \quad \quad {{\lambda }_{j}}\ge 0,\,\,j\in J.
\end{split} 
```

A firm is technically efficient if its optimal solution is $\beta^{*}=0$. Therefore if $\beta^{*}>0$, the observation is inefficient. The decomposition of the so-called *Nerlovian* economic inefficiency based on the directional distance function:  $\Pi{{I}_{DDF\left( G \right)}}\left( {{\textbf{x}}_{o}},{{\textbf{y}}_{o}},{{\mathbf{g_{x}^-},\mathbf{g^{+}_y}}},{\tilde{\textbf{w}}}, \tilde{{\textbf{p}}} \right)$ = $T{{I}_{DDDF\left( G \right)}}\left( {{\textbf{x}}_{o}},{{\textbf{y}}_{o}},{{\mathbf{g_{x}^-},\mathbf{g^{+}_y}}} \right)$ + $A{{I}_{DDF\left( G \right)}}\left( {{\textbf{x}}_{o}},{{\textbf{y}}_{o}},{{\mathbf{g_{x}^-},\mathbf{g^{+}_y}}}, {\tilde{\textbf{w}}}, \tilde{{\textbf{p}}} \right)$. This results in the following expression: 

```math
\begin{split}
  & \underbrace{\frac{\Pi \left( \mathbf{w},\mathbf{p} \right)-\left( \sum\limits_{n=1}^{N}{{{p}_{n}}{{y}_{on}}}-\sum\limits_{m=1}^{M}{{{w}_{m}}{{x}_{om}}} \right)}{\sum\limits_{m=1}^{M}{w_{m}^{{}}g_{om}^{-}}+\sum\limits_{n=1}^{N}{p_{n}^{{}}y_{on}^{+}}}}_{\text{Norm}\text{. Profit Inefficiency}}= \\ 
  & \quad =\underbrace{\beta _{DDF(G)}^{*}}_{\text{Graph Technical Inefficiency}}+\ \,\underbrace{A{{I}_{DDF(G)}}\left( {{\mathbf{x}}_{o}},{{\mathbf{y}}_{o}},\mathbf{g}_{\mathbf{x}}^{\mathbf{-}},\mathbf{g}_{\mathbf{y}}^{+},\mathbf{\tilde{w}},\mathbf{\tilde{p}} \right)}_{\text{Norm}\text{. Allocative Inefficiency}} \ge 0.  
\end{split}  
```

**Reference**

Chapter 8 in Pastor, J.T., Aparicio, J. and Zofío, J.L. (2022) Benchmarking Economic Efficiency: Technical and Allocative Fundamentals, International Series in Operations Research and Management Science, Vol. 315,  Springer, Cham. 

**Example**

In this example we compute the profit efficiency measure considering a choice of directional vector that returns profit inefficiency in monetary terms:
```jldoctest 1
julia> X = [2; 4; 8; 12; 6; 14; 14; 9.412];

julia> Y = [1; 5; 8; 9; 3; 7; 9; 2.353];

julia> W = [1; 1; 1; 1; 1; 1; 1; 1];

julia> P = [2; 2; 2; 2; 2; 2; 2; 2];

julia> deaprofit(X, Y, W, P, Gx = :Monetary, Gy = :Monetary)
Profit DEA Model 
DMUs = 8; Inputs = 1; Outputs = 1
Returns to Scale = VRS
Gx = Monetary; Gy = Monetary
────────────────────────────────
   Profit  Technical  Allocative
────────────────────────────────
1   8.0        0.0          8.0
2   2.0        0.0          2.0
3   0.0        0.0          0.0
4   2.0        0.0          2.0
5   8.0        6.0          2.0
6   8.0        6.0          2.0
7   4.0        0.0          4.0
8  12.706     11.496        1.21
────────────────────────────────
```

### deaprofit Function Documentation

```@docs
deaprofit
```
