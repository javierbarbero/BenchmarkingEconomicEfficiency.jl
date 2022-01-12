```@meta
CurrentModule = BenchmarkingEconomicEfficiency
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
```@example profitrussell
using BenchmarkingEconomicEfficiency

X = [2; 4; 8; 12; 6; 14; 14; 9.412];

Y = [1; 5; 8; 9; 3; 7; 9; 2.353];

W = [1; 1; 1; 1; 1; 1; 1; 1];

P = [2; 2; 2; 2; 2; 2; 2; 2];

profitrussell = deaprofitrussell(X, Y, W, P)
```

Estimated economic, technical and allocative efficiency scores are returned with the `efficiency` function:
```@example profitrussell
efficiency(profitrussell, :Economic)
```

```@example profitrussell
efficiency(profitrussell, :Technical)
```

```@example profitrussell
efficiency(profitrussell, :Allocative)
```

### deaprofitrussell Function Documentation

```@docs
deaprofitrussell
```

