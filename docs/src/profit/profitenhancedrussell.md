```@meta
CurrentModule = BenchmarkingEconomicEfficiency
DocTestSetup = quote
    using BenchmarkingEconomicEfficiency
end
```

# Profit Enhanced Russell Graph Slack Based Measure

The profit enhanced Russell graph-slack based measure is computed by solving an [enhanced Russell graph-slack based measure model](https://javierbarbero.github.io/DataEnvelopmentAnalysis.jl/stable/technical/enhancedrussell/) for the technical efficiency.

The *enhanced* Russell graph measure $ERG$ (or slack-based measure) was designed as a new global efficiency measure to overcome the computational difficulties of the  [Profit Russell model](@ref). The novelty lays on the definition of a non-radial model that accounts for both inputs and outputs (graph or non-oriented) as the Russell proposal, but that is easier to compute through linear programming--as opposed to the standard Russell model. The *ERG=SBM* measure is formulated resorting to the same variables as the Russell graph measure: the 'thetas' ($\theta$'s) for the proportional individual reduction of each of the $M$ inputs, the 'phys' ($\phi$'s) for the proportional individual output increase of each of the $N$ outputs, and the `lambdas' ($\lambda$'s) defining the reference hyperplanes from the obeservations that constitute the production frontier. The technical efficiency model corresponds to: 

```math
\begin{split}
	T{{E}_{ERG=SBM(G)}}\left( {{x}_{o}},{{y}_{o}} \right) = \, & \underset{\pmb{\theta} , \pmb{\phi} ,\pmb{\lambda} }{\mathop{\min }} \, \frac{\frac{1}{M}\sum\limits_{m=1}^{M}{{{\theta }_{m}}}}{\frac{1}{N}\sum\limits_{n=1}^{N}{{{\phi }_{n}}}} \\
	& s.t. \quad \sum\limits_{j=1}^{J}{{{\lambda }_{j}}{{x}_{mj}}}={{\theta }_{m}}{{x}_{om}}, \quad m=1,...,M   \\
	& \quad \quad \sum\limits_{j=1}^{J}{{{\lambda }_{j}}{{y}_{nj}}}={{\phi }_{n}}{{y}_{on}}, \quad n=1,...,N \\
	& \quad \quad \sum\limits_{j=1}^{J}{{{\lambda }_{j}}}=1, \\
	& \quad \quad {{\theta }_{m}}\le 1, \quad m=1,...,M \\
	& \quad \quad {{\phi }_{n}}\ge 1, \quad n=1,...,N   \\
	& \quad \quad {{\lambda }_{j}}\ge 0, \quad j=1,...,J  \\
\end{split}
```
 
 Comparing this model with that defining the Russell graph measure the only difference is the objective function, originally formulated as $\frac{1}{M+N}\left( \sum\limits_{m=1}^{M}{{{\theta }_{m}}}+\sum\limits_{n=1}^{N}{\frac{1}{{{\phi }_{n}}}} \right)$. From the perspective of finding the solution of this model this difference is relevant because we have replaced the original nonlinear objective function with a linear fractional objective function, i.e., a fraction of two linear expressions, that is easier to solve.

For this purpose, after performing a change of variables that formulates the model in terms of slacks instead of the multiplicative reduction of each input and increase of each output, and introducing a variable $\beta$ corresponding to the inverse of the denominator of the resulting objective function--see Pastor, Aparicio and Zofío (2022, Ch. 7)--we obtain the final linear program that calculates the value of the *ERG=SMB* measure of technical efficiency:   

```math
\begin{split}
 	 T{{E}_{ERG=SBM(G)}}\left( {{\textbf{x}}_{o}},{{\textbf{y}}_{o}} \right)= & \underset{\textbf{t}_{{}}^{-},\textbf{t}_{{}}^{+},\pmb{\mu} ,\pmb{\beta} }{\mathop{\min }}\,  \beta -\frac{1}{M}\sum\limits_{m=1}^{M}{\frac{t_{m}^{-}}{{{x}_{om}}}}   \\
 		& s.t. \quad \beta +\frac{1}{N}\sum\limits_{n=1}^{N}{\frac{t_{n}^{+}}{{{y}_{on}}}=1} \\ 
 		& \quad \quad \sum\limits_{j=1}^{J}{{{\mu }_{j}}{{x}_{jm}}}=\beta {{x}_{om}}-t_{m}^{-},  \quad m=1,...,M   \\
 		& \quad \quad \sum\limits_{j=1}^{J}{{{\mu }_{j}}{{y}_{jn}}}=\beta {{y}_{on}}+t_{n}^{+},  \quad n=1,...,N   \\
 		& \quad \quad \sum\limits_{j=1}^{J}{{{\mu }_{j}}}=\beta ,  \\
 		& \quad \quad \beta \ge 0,\,\,  \\
 		& \quad \quad t_{m}^{-}\ge 0,t_{n}^{+}\ge 0, \quad \forall m,n,  \\
 		& \quad \quad{{\mu }_{j}}\ge 0, \quad j=1,...,J.   \\
\end{split}
```

From the solution to this program we can recover the following measure of technical inefficiency: 

```math
\begin{split}
	& T{{I}_{ERG=SBM(G)}}\left( {{\textbf{x}}_{o}},{{\textbf{y}}_{o}} \right)=1-T{{E}_{ERG=SBM(G)}}\left( {{\textbf{x}}_{o}},{{\textbf{y}}_{o}} \right)=  \\ 
	& \quad 1-\frac{1-\frac{1}{M}\sum\limits_{m=1}^{M}{\frac{s_{m}^{-*}}{{{x}_{om}}}}}{1+\frac{1}{N}\sum\limits_{n=1}^{N}{\frac{s_{n}^{+*}}{y_{on}^{{}}}}}=\frac{\frac{1}{N}\sum\limits_{n=1}^{N}{\frac{s_{n}^{+*}}{y_{on}^{{}}}}+\frac{1}{M}\sum\limits_{m=1}^{M}{\frac{s_{m}^{-*}}{{{x}_{om}}}}}{1+\frac{1}{N}\sum\limits_{n=1}^{N}{\frac{s_{n}^{+*}}{y_{no}^{{}}}}}.   
\end{split}
```

Resorting to the duality between this expression and the profit function we can establish the associated decomposition of profit inefficiency:  $\Pi I_{ERG=SBM(G)}^{{}}\left( {{\textbf{x}}_{o}},{{\textbf{y}}_{o}},\tilde{\textbf{w}},\tilde{\textbf{p}} \right)=T{{I}_{ERG=SBM(G)}}\left( {{\textbf{x}}_{o}},{{\textbf{\textbf{y}}}_{o}} \right)+A{{I}_{ERG=SBM(G)}}\left( {{\textbf{x}}_{o}},{{\textbf{y}}_{o}},\tilde{\textbf{w}},\tilde{\textbf{p}} \right)$; i.e.,		   

```math
\begin{split}
& \underbrace{\frac{\Pi \left( \mathbf{w},\mathbf{p} \right)-\left( \sum\limits_{n=1}^{N}{{{p}_{n}}{{y}_{on}}}-\sum\limits_{m=1}^{M}{{{w}_{m}}{{x}_{om}}} \right)}{{{\delta }_{\left( {{\textbf{x}}_{o}},{{\textbf{y}}_{o}},\textbf{p},\textbf{w} \right)}}\left( 1+\frac{1}{N}\sum\limits_{n=1}^{N}{\frac{s_{n}^{+*}}{y_{on}^{{}}}} \right)}}_{\text{Norm}\text{.}\ \text{Profit}\ \text{Inefficency}}=  \\ 
& \quad =\underbrace{\left( \frac{\frac{1}{N}\sum\limits_{n=1}^{N}{\frac{s_{n}^{+*}}{y_{on}^{{}}}+}\frac{1}{M}\sum\limits_{m=1}^{M}{\frac{s_{m}^{-*}}{x_{om}^{{}}}}}{\left( 1+\frac{1}{N}\sum\limits_{n=1}^{N}{\frac{s_{n}^{+*}}{y_{on}^{{}}}} \right)} \right)}_{\text{Graph Techncial Inefficency}}+\underbrace{A{{I}_{ERG=SBM(G)}}\left( {{\mathbf{x}}_{o}},{{\mathbf{y}}_{o}},\tilde{\textbf{p}},\tilde{\textbf{w}} \right)}_{\text{Norm}\text{.}\ \text{Allocative}\ \text{Inefficency}}\ge 0, 
\end{split}
```

where ${{\delta }_{\left( {{\textbf{x}}_{o}},{{\textbf{y}}_{o}},\textbf{p},\textbf{w} \right)}}=\min \left\{ N{{p}_{n}}y_{on}^{{}},n=1,...,N,M{{w}_{m}}x_{om}^{{}},m=1,...,M \right\}$ in the normalization factor of the *ERG=SBM*. 

**Reference**

Chapter 7 in Pastor, J.T., Aparicio, J. and Zofío, J.L. (2022) Benchmarking Economic Efficiency: Technical and Allocative Fundamentals, International Series in Operations Research and Management Science, Vol. 315,  Springer, Cham. 

**Example**

In this example we compute the profit efficiency Enhanced Russell Graph Slack Based measure:
```jldoctest 1
julia> X = [2; 4; 8; 12; 6; 14; 14; 9.412];

julia> Y = [1; 5; 8; 9; 3; 7; 9; 2.353];

julia> W = [1; 1; 1; 1; 1; 1; 1; 1];

julia> P = [2; 2; 2; 2; 2; 2; 2; 2];

julia> profiterg = deaprofiterg(X, Y, W, P)
Enhanced Russell Graph Slack Based Measure Profit DEA Model 
DMUs = 8; Inputs = 1; Outputs = 1
Returns to Scale = VRS
──────────────────────────────────
     Profit  Technical  Allocative
──────────────────────────────────
1  4.0        0.0         4.0
2  0.5        0.0         0.5
3  0.0        0.0         0.0
4  0.166667   0.0         0.166667
5  0.8        0.6         0.2
6  0.571429   0.52381     0.047619
7  0.285714   0.142857    0.142857
8  1.2706     0.8         0.4706
──────────────────────────────────
```

Estimated economic, technical and allocative efficiency scores are returned with the `efficiency` function:
```jldoctest 1
julia> efficiency(profiterg, :Economic)
8-element Vector{Float64}:
 4.0
 0.5
 0.0
 0.16666666666666666
 0.8
 0.5714285714285714
 0.2857142857142857
 1.2705999999999997

julia> efficiency(profiterg, :Technical)
8-element Vector{Float64}:
 0.0
 0.0
 0.0
 0.0
 0.6000000000000001
 0.5238095238095238
 0.14285714285714257
 0.8

julia> efficiency(profiterg, :Allocative)
8-element Vector{Float64}:
 4.0
 0.5
 0.0
 0.16666666666666666
 0.19999999999999996
 0.04761904761904756
 0.14285714285714313
 0.4705999999999997
```


### deaprofiterg Function Documentation

```@docs
deaprofiterg
```

