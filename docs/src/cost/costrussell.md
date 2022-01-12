```@meta
CurrentModule = BenchmarkingEconomicEfficiency
```

# Cost Russell model

The cost Russell model is computed by solving an input-oriented [Russell DEA model](https://javierbarbero.github.io/DataEnvelopmentAnalysis.jl/stable/technical/#Russell-Input-Model/) for the technical efficiency.

Taking the Russell measure as reference, Pastor, Aparicio and Zofío (2022, Ch. 5) present the Fenchel-Mahler inequality obtained from the dual correspondence between the cost function and this measure of input technical inefficiency. The Russell input-oriented measure quantifying the technical inefficiency of a firm can be calculated through DEA methods by solving the following program:   

```math
\begin{split}
& T{{E}_{RM(I)}}\left( {{\textbf{x}}_{o}},{{\textbf{y}}_{o}} \right)= \underset{\begin{smallmatrix}	\pmb{\theta} , \pmb{\lambda} \end{smallmatrix}}{\mathop{\min }}\, \frac{1}{M} \sum\limits_{m=1}^{M}{{{\theta }_{m}}}  \\
& s.t. \quad \sum\limits_{j=1}^{J}{{{\lambda }_{j}}{{x}_{jm}}}={{\theta }_{m}}{{x}_{om}}, \quad  m=1,...,M  \\
& \quad \quad \sum\limits_{j=1}^{J}{{{\lambda }_{j}}{{y}_{jn}}}={{y}_{on}}, \quad  n=1,...,N   \\
& \quad \quad \sum\limits_{j=1}^{J}{{{\lambda }_{j}}}=1,   \\
& \quad \quad {{\theta }_{m}}\le 1, \quad  m=1,...,M   \\
& \quad \quad {{\lambda }_{j}}\ge 0, \quad  j=1,...,J   \\
\end{split}
```
In this program, $\theta^*_{m}$ evaluates the relative proportional reduction of input $m, m=1,...,M$. The objective function averages these proportional rates of input contraction. Contrary to the [Russell graph DEA model](https://javierbarbero.github.io/DataEnvelopmentAnalysis.jl/stable/technical/russell/#Russell-Graph-Model), this program is linear and therefore easy to calculate through the simplex method. 

Considering $T{{E}_{RM(I)}}({{\textbf{x}}_{o}},{{\textbf{y}}_{o}})$ we can define is technical inefficiency counterparts as $T{I}_{RM(I)}( {\textbf{x}_{o}},{\textbf{y}_{o}})=1-T{{E}_{RM(I)}} ({\textbf{x}_{o}},{\textbf{y}_{o}})$. It is then possible to decompose cost inefficiency into technical and allocative components: $C{{I}_{RM\left( I \right)}}\left( {{\textbf{x}}_{o}},{{\textbf{y}}_{o}},{\tilde{\textbf{w}}} \right)$ = $T{{I}_{RM\left( I \right)}}\left( {{\textbf{x}}_{o}},{{\textbf{y}}_{o}} \right)$ + $A{{I}_{RM\left( I \right)}}\left( {{\textbf{x}}_{o}},{{\textbf{y}}_{o}}, ,\tilde{\textbf{w}} \right)$. That is  

```math
\underbrace{\frac{\sum\limits_{m=1}^{M}{{{w}_{m}}{{x}_{om}}} - C \left( \mathbf{y}_o,\mathbf{w} \right)}{ M \min \left\{ {{w}_{1}}{{x}_{o1}},...,{{w}_{M}}{{x}_{oM}}\right\}}}_{\text{Norm. Cost Inefficiency}} = \underbrace{1-\frac{1}{M}\sum\limits_{m=1}^{M}{\theta _{m}^{*}} }_{\text{Input Technical Inefficiency}}+\underbrace{A{{I}_{RM\left( I \right)}}\left( {{\textbf{x}}_{o}},{{\textbf{y}}_{o}},\tilde{\textbf{w}} \right)}_{\text{Norm. Allocative Inefficiency}}\ge 0. \\ 
```
**Reference**

Chapter 5 in Pastor, J.T., Aparicio, J. and Zofío, J.L. (2022) Benchmarking Economic Efficiency: Technical and Allocative Fundamentals, International Series in Operations Research and Management Science, Vol. 315,  Springer, Cham. 


**Example**


In this example we compute the cost efficiency Russell measure under variable returns to scale:
```@example costrussell
using BenchmarkingEconomicEfficiency

X = [2 2; 1 4; 4 1; 4 3; 5 5; 6 1; 2 5; 1.6 8];

Y = [1; 1; 1; 1; 1; 1; 1; 1];

W = [1 1; 1 1; 1 1; 1 1; 1 1; 1 1; 1 1; 1 1];

costrussell = deacostrussell(X, Y, W)
```

Estimated economic, technical and allocative efficiency scores are returned with the `efficiency` function:
```@example costrussell
efficiency(costrussell, :Economic)
```

```@example costrussell
efficiency(costrussell, :Technical)
```

```@example costrussell
efficiency(costrussell, :Allocative)
```

### deacostrussell Function Documentation

```@docs
deacostrussell
```

