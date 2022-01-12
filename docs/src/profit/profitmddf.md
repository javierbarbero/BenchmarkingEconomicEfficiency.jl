```@meta
CurrentModule = BenchmarkingEconomicEfficiency
DocTestSetup = quote
    using BenchmarkingEconomicEfficiency
    deaprofitmddf([1; 2; 3], [1; 1; 2], [1; 1; 1], [1; 1;1], Gx = :Observed, Gy = :Observed)
end
```

# Profit Modified Directional Distance Function model

The profit Modified Directional Distance Function **MDDF* is computed by solving the [Modified Directional Distance Function model](https://javierbarbero.github.io/DataEnvelopmentAnalysis.jl/stable/technical/modifiedddf/) for the technical efficiency.

 The $MDDF$ presents two distinctive advantages over the directional distance function model $DDF$ presented in the associated [Profit Directional Distance Function model](@ref). First, the normalization factor in the decomposition of profit inefficiency, given by ${\sum\limits_{m=1}^{M}{w_{m}^{}g_{om}^{-}}+\sum\limits_{n=1}^{N}{p_{n}^{}y_{on}^{+}}} = C_o+R_o$, has no apparent economic interpretation because it corresponds to the monetary sum of the firm's cost and revenue (dollars spent and dollars earned). In turn, the duality of the $MDDF$ with the profit function results in a normalization factor that is either cost or revenue, but not the sum of the two, which results in a meaningful interpretation of profit inefficiency as lost profit on outlay (cost) or lost profit on earnings (revenue). Second, while the $DDF$ reduces inputs and increases outputs in the same proportion $\beta$, the $MDDF$ adds flexibility to the model by allowing for unequal variation in inputs and outputs when attaining technical efficiency. Therefore, the $MDDF$ overcomes these two limitations of the standard $DDF$: 1) By presenting a dual relationship with the profit function, profit inefficiency has a sensible economic interpretation as either lost profit on outlay (dollar spent or cost) or lost profit on takings (dollar earned or revenue), and 2) it allows managers to adjust inputs and outputs asymmetrically when solving technical inefficiencies.

The $MDDF$ function can be calculated through DEA methods by solving the following model:

```math
\begin{split}
& T{{I}_{MDDF(G)}}\left( {{\textbf{x}}_{o}},{{\textbf{y}}_{o}},\textbf{g}_{\textbf{x}}^{{-}},\textbf{g}_{\textbf{y}}^{{+}} \right)=  \underset{{{\beta }_{\textbf{x}}},{{\beta }_{\textbf{y}}},{{\pmb{\lambda }}}}{\mathop{\max }}\, {{\beta }_{\textbf{x}}}+{{\beta }_{\textbf{y}}}  {}  \\
 & s.t.  \quad \sum\limits_{j=1}^{J}{{{\lambda }_{j}}{{x}_{jm}}\le {{x}_{om}}-{{\beta }_{\textbf{x}}}g_{{{x}_{m}}}^{{}},} \quad  m=1,...,M  \\
 & \quad \quad \sum\limits_{j=1}^{J}{{{\lambda }_{j}}{{y}_{jn}}\ge {{y}_{on}}+{{\beta }_{\textbf{y}}}g_{{{y}_{n}}}^{{}},} \quad  n=1,...,N  \\
 & \quad \quad \sum\limits_{j=1}^{J}{{{\lambda }_{j}}=1,} \\
 & \quad \quad  {{\lambda }_{j}}\ge 0, \quad  j=1,...,J  \\
 &  \quad \quad {{\beta }_{x}},{{\beta }_{y}}\ge 0  {}  \\
\end{split}
```
where, as in the standard *DDF*, the vector $\mathbf{g}= {\left({{\mathbf{g_{x}^-},\mathbf{g^{+}_y}}} \right)\neq\mathbf{0}_{M+N}}$, $\mathbf{g^{-}_{x}}\mathbb{\in R}^M$ and $\mathbf{g^+_{y}}\mathbb{\in R}^N$, which is specified by the researcher, sets the direction towards the production frontier. If  the directional vector corresponds is set to the observed input and output quantities of the firm under evaluation: $\mathbf{g}= \left({{\mathbf{g_{x}^-}},{\mathbf{g_{y}^+}}} \right)=\:$$\left({{\mathbf{x}_o,\textbf{y}_o}} \right)$, and observed profit is non negative: $\Pi_o \ge 0$, then the normalization factor relating the profit function and the *MDDF*, obtained through duality, is equal to observed cost. Therefore we can define the following decomposition of economic inefficiency based on the *MDDF*: $\Pi{{I}_{MDDF\left( G \right)}}\left( {{\textbf{x}}_{o}},{{\textbf{y}}_{o}},{\tilde{\textbf{w}}}, \tilde{{\textbf{p}}} \right)$ = $T{{I}_{MDDF\left( G \right)}}\left( {{\textbf{x}}_{o}},{{\textbf{y}}_{o}} \right)$ + $A{{I}_{MDDF\left( G \right)}}\left( {{\textbf{x}}_{o}},{{\textbf{y}}_{o}}, {\tilde{\textbf{w}}}, \tilde{{\textbf{p}}} \right)$. This results in the following expression: 

```math
\begin{split}
& \underbrace{\frac{\Pi \left( \mathbf{w},\mathbf{p} \right)-\left( \sum\limits_{n=1}^{N}{{{p}_{n}}{{y}_{on}}}-\sum\limits_{m=1}^{M}{{{w}_{m}}{{x}_{om}}} \right)}{C_o}}_{\text{Norm}\text{. Profit Inefficiency}}=  \\ 
& \quad =\underbrace{\beta_\textbf{x}^{*}+\beta_\textbf{y}^{*}}_{\text{Technical Inefficiency}}+\ \,\underbrace{A{{I}_{DDF(G)}}\left( {{\mathbf{x}}_{o}},{{\mathbf{y}}_{o}},\mathbf{\tilde{w}},\mathbf{\tilde{p}} \right)}_{\text{Norm}\text{. Allocative Inefficiency}} \ge 0.  
\end{split}  
```
where $\beta_\textbf{x}^{*}+\beta_\textbf{y}^{*}$ are the solutions to the DEA program. In case the observed firms incurs in economic losses presenting a negative profit, $\Pi_o<0$, Pastor, Aparicio and Zofío (2022, Ch. 11) proof that a duality between the profit function and the $MDDF$ can be established in terms of a normalization factor represented by observed revenue. Consequently, a measure of profit loss to earnings can be defined and decomposed as follows: 

```math
\begin{split}
& \underbrace{\frac{\Pi \left( \mathbf{w},\mathbf{p} \right)-\left( \sum\limits_{n=1}^{N}{{{p}_{n}}{{y}_{on}}}-\sum\limits_{m=1}^{M}{{{w}_{m}}{{x}_{om}}} \right)}{R_o}}_{\text{Norm}\text{. Profit Inefficiency}}= \\ 
& \quad =\underbrace{\beta_\textbf{x}^{*}+\beta_\textbf{y}^{*}}_{\text{Graph Technical Inefficiency}}+\ \,\underbrace{A{{I'}_{DDF(G)}}\left( {{\mathbf{x}}_{o}},{{\mathbf{y}}_{o}},\mathbf{g}_{\mathbf{x}}^{\mathbf{-}},\mathbf{g}_{\mathbf{y}}^{+},\mathbf{\tilde{w}},\mathbf{\tilde{p}} \right)}_{\text{Norm}\text{. Allocative Inefficiency}} \ge 0.  
\end{split} 
```

**Example**

In this example we compute  profit inefficiency based on the modified directional distance function:
```jldoctest 1
julia> X = [2; 4; 8; 12; 6; 14; 14; 9.412];

julia> Y = [1; 5; 8; 9; 3; 7; 9; 2.353];

julia> W = [1; 1; 1; 1; 1; 1; 1; 1];

julia> P = [2; 2; 2; 2; 2; 2; 2; 2];

julia> profitmddf = deaprofitmddf(X, Y, W, P, Gx = :Observed, Gy = :Observed)
Profit Modified DDF DEA Model 
DMUs = 8; Inputs = 1; Outputs = 1
Returns to Scale = VRS
Gx = Observed; Gy = Observed
──────────────────────────────────
     Profit  Technical  Allocative
──────────────────────────────────
1  4.0        0.0         4.0
2  0.5        0.0         0.5
3  0.0        0.0         0.0
4  0.166667   0.0         0.166667
5  1.33333    1.16667     0.166667
6  0.571429   0.571429    0.0
7  0.285714   0.142857    0.142857
8  2.69996    2.54994     0.150021
──────────────────────────────────
```

Estimated economic, technical and allocative efficiency scores are returned with the `efficiency` function:
```jldoctest 1
julia> efficiency(profitmddf, :Economic)
8-element Vector{Float64}:
 4.0
 0.5
 0.0
 0.16666666666666666
 1.3333333333333333
 0.5714285714285714
 0.2857142857142857
 2.6999575010624732
```
```jldoctest 1
julia> efficiency(profitmddf, :Technical)
8-element Vector{Float64}:
 0.0
 0.0
 0.0
 0.0
 1.1666666666666665
 0.5714285714285714
 0.14285714285714285
 2.54993625159371
```
```jldoctest 1
julia> efficiency(profitmddf, :Allocative)
8-element Vector{Float64}:
 4.0
 0.5
 0.0
 0.16666666666666666
 0.16666666666666674
 0.0
 0.14285714285714285
 0.15002124946876316
```

**Reference**

Chapter 11 in Pastor, J.T., Aparicio, J. and Zofío, J.L. (2022) Benchmarking Economic Efficiency: Technical and Allocative Fundamentals, International Series in Operations Research and Management Science, Vol. 315,  Springer, Cham. 

### deaprofitmddf Function Documentation

```@docs
deaprofitmddf
```

