```@meta
CurrentModule = BenchmarkingEconomicEfficiency
DocTestSetup = quote
    using BenchmarkingEconomicEfficiency
    deaprofitrussell([1; 2; 3], [1; 1; 2], [1; 1; 1], [1; 1;1])
end
```

# Profit Russell model

The profit Russell model is computed by solving a [Russell graph DEA model](https://javierbarbero.github.io/DataEnvelopmentAnalysis.jl/stable/technical/russell/#Russell-Graph-Model) for the technical efficiency.

The decomposition of profit inefficiency based on the duality between tbe profit function and the Russell measure begins with the calulation of the later according to the following DEA program:

```math
\begin{split}
	& T{{E}_{RM(G)}}\left( {{\textbf{x}}_{o}},{{\textbf{y}}_{o}} \right)= \underset{\begin{smallmatrix} \pmb{\theta},\pmb{\phi}, \pmb{\lambda} \end{smallmatrix}}{\mathop{\min }}\, \frac{1}{M+N}\left( \sum\limits_{m=1}^{M}{{{\theta }_{m}}}+\sum\limits_{n=1}^{N}{\frac{1}{{{\phi }_{n}}}} \right) \\
	& s.t. \quad \sum\limits_{j=1}^{J}{{{\lambda }_{j}}{{x}_{jm}}}={{\theta }_{m}}{{x}_{om}}, \quad m=1,...,M   \\
	& \quad \quad \sum\limits_{j=1}^{J}{{{\lambda }_{j}}{{y}_{jn}}}={{\phi }_{n}}{{y}_{on}}, \quad n=1,...,N  \\
	& \quad \quad \sum\limits_{j=1}^{J}{{{\lambda }_{j}}}=1  \\
	& \quad \quad {{\theta }_{m}}\le 1, \quad m=1,...,M  \\
	& \quad \quad {{\phi }_{n}}\ge 1, \quad n=1,...,N  \\
	& \quad \quad {{\lambda }_{j}}\ge 0, \quad j=1,...,J  \\
\end{split}
```

The optimal solutions of this program: $\theta^*_{m}$ and $\phi^*_{n}$, evaluate the relative proportional reduction of input $m, m=1,...,M$, and the relative proportional increase of output $n, n=1,...,N$, respectively. The objective function averages these proportional rates of inputs contraction and outputs expansion. The reference frontier corresponds to the supporting hyperplane defined by the linear combination of the observations that serve as reference benchmark for $(\mathbf{x}_o,\mathbf{y}_o)$. Those observations, ($\mathbf{\lambda}\mathbf{X},\mathbf{\lambda}\mathbf{X}$), whose associated $\lambda_j$ multipliers are greater than zero define the enveloping hyperplane. Although the Russell graph model is non-linear, it is possible to reformulate it as a semidefinite programming (SDP) model. On the one hand, the SDP reformulation of the Russell measure can be solved efficiently using standard SDP solvers. On the other, the dual program allows establishing, for the first time, a dual relationship between the profit function and the Russell measure.

Departing from $T{{E}_{RM(G)}}({{\textbf{x}}_{o}},{{\textbf{y}}_{o}})$ we can define its technical inefficiency counterpart as $T{I}_{RM(G)}( {\textbf{x}_{o}},{\textbf{y}_{o}})=1-T{{E}_{RM(G)}} ({\textbf{x}_{o}},{\textbf{y}_{o}})$. It is then possible to decompose profit inefficiency into technical and allocative components: $\Pi{{I}_{RM\left( G \right)}}\left( {{\textbf{x}}_{o}},{{\textbf{y}}_{o}},{\tilde{\textbf{w}}}, {\tilde{\textbf{p}}} \right)$ = $T{{I}_{RM\left( G \right)}}\left( {{\textbf{x}}_{o}},{{\textbf{y}}_{o}} \right)$ + $A{{I}_{RM\left( G \right)}}\left( {{\textbf{x}}_{o}},{{\textbf{y}}_{o}}, {\textbf{w}}, {\textbf{p}} \right)$; i.e.,    

```math
\begin{split}
	& \underbrace{\frac{\Pi \left( \textbf{w},\textbf{p} \right)-\left( \sum\limits_{n=1}^{N}{{{p}_{n}}{{y}_{on}}}-\sum\limits_{m=1}^{M}{{{w}_{m}}{{x}_{om}}} \right)}{\left( M+N \right)\min \left\{ {{w}_{1}}{{x}_{o1}},...,{{w}_{M}}{{x}_{oM}},{{p}_{1}}{{y}_{o1}},...,{{p}_{N}}{{y}_{oN}} \right\}}}_{\text{Norm. Profit Inefficiency}}= \\ 
	& \quad = \underbrace{\left[ 1-\frac{1}{M+N}\left( \sum\limits_{m=1}^{M}{\theta _{m}^{*}}+\sum\limits_{n=1}^{N}{\frac{1}{\phi _{n}^{*}}} \right) \right]}_{\text{Graph Technical Inefficiency}}+\underbrace{A{{I}_{RM\left( G \right)}}\left( {{\textbf{x}}_{o}},{{\textbf{y}}_{o}},\tilde{\textbf{w}},\tilde{\textbf{p}} \right)}_{\text{Norm. Allocative Inefficiency}}\ge 0. \\ 
\end{split}
```
**Reference**

Chapter 5 in Pastor, J.T., Aparicio, J. and Zofío, J.L. (2022) Benchmarking Economic Efficiency: Technical and Allocative Fundamentals, International Series in Operations Research and Management Science, Vol. 315,  Springer, Cham. 

**Example**

In this example we compute the profit efficiency Russell measure:
```jldoctest 1
julia> X = [2; 4; 8; 12; 6; 14; 14; 9.412];

julia> Y = [1; 5; 8; 9; 3; 7; 9; 2.353];

julia> W = [1; 1; 1; 1; 1; 1; 1; 1];

julia> P = [2; 2; 2; 2; 2; 2; 2; 2];

julia> profitrussell = deaprofitrussell(X, Y, W, P)
Russell Profit DEA Model 
DMUs = 8; Inputs = 1; Outputs = 1
Orientation = Graph; Returns to Scale = VRS
─────────────────────────────────────
       Profit   Technical  Allocative
─────────────────────────────────────
1  2.0         3.50173e-7  2.0
2  0.25        2.49141e-8  0.25
3  2.84063e-8  8.48991e-9  1.99164e-8
4  0.0833334   2.9862e-8   0.0833333
5  0.666667    0.366667    0.3
6  0.285714    0.276786    0.0089286
7  0.142857    0.0714286   0.0714286
8  1.34998     0.552205    0.797773
─────────────────────────────────────
```

Estimated economic, technical and allocative efficiency scores are returned with the `efficiency` function:
```jldoctest 1
julia> efficiency(profitrussell, :Economic)
8-element Vector{Float64}:
 2.000000113625293
 0.2500000568126466
 2.8406323293594937e-8
 0.08333335227088219
 0.6666667045417644
 0.28571430194647046
 0.14285715908932758
 1.349978798820779
```
```jldoctest 1
julia> efficiency(profitrussell, :Technical)
8-element Vector{Float64}:
 3.5017295285655337e-7
 2.4914090124283916e-8
 8.48991321689141e-9
 2.9861977113299076e-8
 0.36666667736489755
 0.2767857062834501
 0.07142859511479327
 0.5522053118262116
```
```jldoctest 1
julia> efficiency(profitrussell, :Allocative)
8-element Vector{Float64}:
 1.9999997634523403
 0.25000003189855646
 1.9916410076703528e-8
 0.08333332240890508
 0.3000000271768668
 0.008928595663020344
 0.07142856397453431
 0.7977734869945674
```

### deaprofitrussell Function Documentation

```@docs
deaprofitrussell
```

