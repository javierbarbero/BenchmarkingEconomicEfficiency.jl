```@meta
CurrentModule = BenchmarkingEconomicEfficiency
```

# Revenue Russell model

The revenue Russell model is computed by solving am output-oriented [Russell DEA model](https://javierbarbero.github.io/DataEnvelopmentAnalysis.jl/stable/technical/#Russell-Output-Model/) for the technical efficiency.

Taking the Russell measure as reference, Pastor, Aparicio and Zofío (2022, Ch. 5) present the Fenchel-Mahler inequality obtained from the dual correspondence between the revenue function and this measure of output technical inefficiency. The Russell output-oriented measure quantifying the technical inefficiency of a firm can be calculated through DEA methods by solving the following program:   

```math
\begin{split}
& T{{E}_{RM(O)}}\left( {{\textbf{x}}_{o}},{{\textbf{y}}_{o}} \right)= \underset{\begin{smallmatrix} \pmb{\phi}, \lambda \end{smallmatrix}}{\mathop{\min }}\, \frac{1}{N} \sum\limits_{n=1}^{N}{{{\phi }_{n}}}  \\
& s.t. \quad \sum\limits_{j=1}^{J}{{{\lambda }_{j}}{{x}_{jm}}}={{x}_{om}}, \quad  m=1,...,M   \\
& \quad \quad \sum\limits_{j=1}^{J}{{{\lambda }_{j}}{{y}_{jn}}}={{\phi }_{n}}{{y}_{on}}, \quad  n=1,...,N  \\
& \quad \quad \sum\limits_{j=1}^{J}{{{\lambda }_{j}}}=1,  \\
& \quad \quad {{\phi }_{n}}\ge 1, \quad n=1,...,N  \\
& \quad \quad {{\lambda }_{j}}\ge 0, \quad  j=1,...,J  \\
\end{split}
```

In this program $\phi^*_{n}$ evaluates the relative proportional increase of output $n, n=1,...,N$. The objective function averages these proportional rates of output expansion. Contrary to the [Russell graph DEA model](https://javierbarbero.github.io/DataEnvelopmentAnalysis.jl/stable/technical/russell/#Russell-Graph-Model), this program is linear and therefore easy to calculate through the simplex method. 

Considering $T{{E}_{RM(O)}}({{\textbf{x}}_{o}},{{\textbf{y}}_{o}})$ we can define its technical inefficiency counterparts as $T{I}_{RM(O)}( {\textbf{x}_{o}},{\textbf{y}_{o}})=1-T{{E}_{RM(O)}} ({\textbf{x}_{o}},{\textbf{y}_{o}})$. It is then possible to decompose revenue inefficiency into technical and allocative components: $R{{I}_{RM\left( O \right)}}\left( {{\textbf{x}}_{o}},{{\textbf{y}}_{o}},{\tilde{\textbf{p}}} \right)$ = $T{{I}_{RM\left( O \right)}}\left( {{\textbf{x}}_{o}},{{\textbf{y}}_{o}} \right)$ + $A{{I}_{RM\left( O \right)}}\left( {{\textbf{x}}_{o}},{{\textbf{y}}_{o}}, ,\tilde{\textbf{p}}  \right)$. That is    

```math
\underbrace{\frac{R \left( \mathbf{x}_o,\mathbf{p} \right) - \sum\limits_{n=1}^{N}{{{p}_{n}}{{y}_{om}}} }{ N \min \left\{ {{p}_{1}}{{y}_{o1}},...,{{p}_{M}}{{y}_{oM}}\right\}}}_{\text{Norm. Revenue Inefficiency}}= 
\underbrace{1-\frac{1}{M}\sum\limits_{n=1}^{N}{\phi _{n}^{*}} }_{\text{Output Technical Inefficiency}}+\underbrace{A{{I}_{RM\left( O \right)}}\left( {{\textbf{x}}_{o}},{{\textbf{y}}_{o}},\tilde{\textbf{p}} \right)}_{\text{Norm. Allocative Inefficiency}}\ge 0. \\ 
```
**Reference**

Chapter 5 in Pastor, J.T., Aparicio, J. and Zofío, J.L. (2022) Benchmarking Economic Efficiency: Technical and Allocative Fundamentals, International Series in Operations Research and Management Science, Vol. 315,  Springer, Cham. 

**Example**

In this example we compute the revenue efficiency Russell measure under variable returns to scale:
```@example revenuerussell
using BenchmarkingEconomicEfficiency

X = [1; 1; 1; 1; 1; 1; 1; 1];

Y = [7 7; 4 8; 8 4; 3 5; 3 3; 8 2; 6 4; 1.5 5];

P = [1 1; 1 1; 1 1; 1 1; 1 1; 1 1; 1 1; 1 1];

revenuerussell = dearevenuerussell(X, Y, P)
```

Estimated economic, technical and allocative efficiency scores are returned with the `efficiency` function:
```@example revenuerussell
efficiency(revenuerussell, :Economic)
```

```@example revenuerussell
efficiency(revenuerussell, :Technical)
```

```@example revenuerussell
efficiency(revenuerussell, :Allocative)
```

### dearevenuerussell Function Documentation

```@docs
dearevenuerussell
```

