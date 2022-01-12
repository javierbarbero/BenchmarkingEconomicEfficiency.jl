```@meta
CurrentModule = BenchmarkingEconomicEfficiency
```

# Cost Radial model


Pastor, Aparicio and Zofío (2022, Ch. 3) summarize the duality results that allow to relate numerically the value of cost efficiency with that of Farrell's radial input measure $R(I)$--whose inverse is Shephard's input distance function. Farrell's measure represents the maximum equiproportional reduction in the observed input vector necessary to the reach the production frontier. For the firm under evaluation $(\mathbf{x}_o,\mathbf{y}_o)$ it can be calculated by solving the following DEA model. 

```math
\begin{split}
& TE_{R(I)}( {{\mathbf{x}}_{o}},{{\mathbf{y}}_{o}}) = \underset{\theta ,\mathbf{\pmb{\lambda} }}{\mathop{\min }}\,\quad \theta  \\ 
& \text{s}\text{.t}\text{.}\quad \,\sum\limits_{j=1}^{J}{\lambda _{j}^{{}}x_{jm}^{{}}}\le \theta{{x}_{om}},\ m=1,...,M\text{,}\  \\ 
& \quad \quad \sum\limits_{j=1}^{J}{\lambda _{j}^{{}}y_{jn}^{{}}}\ge y_{n}^{{}},\ n=1,...,N\text{, } \\ 
& \quad \quad \sum\limits_{j=1}^{J}{\lambda _{j}^{{}}}=1, \\ 
& \quad \quad \lambda \ge 0. \\
\end{split}
```

Denoting the optimal solution to this program by $\theta^*$, the constraints require the projection $\left( {\theta^{*}\mathbf{x}_o,\mathbf{y}_o} \right)$ to belong to the technology $L(\textbf{y}_o)$, while the objective functions seeks the minimum value of $\theta$ that projects radially the input vector $\mathbf{x}_o$ to its frontier benchmark represented by $\hat{\textbf{x}}_o=\theta^*\mathbf{x}_o$. A feasible solution signaling technical efficiency is $\theta^*=1$. Therefore if  $\theta^*<1$, the observation is technically inefficient and $(\pmb{\lambda} X,\pmb{\lambda} Y)$ outperforms  $\left( {{\mathbf{x}_o,\mathbf{y}_o}} \right)$. 

We can now show the main duality result relating cost efficiency and Farrell's radial input distance function $R(I)$, allowing its decomposition:   $CE^{{}}_{R(I)}\left( {{\textbf{x}}_{o}},{{\textbf{y}}_{o}},\textbf{w} \right)=TE_{R(I)}\left( {{\textbf{x}}_{o}},{{\textbf{\textbf{y}}}_{o}} \right)+AE_{R(I)}\left( {{\textbf{x}}_{o}},{{\textbf{y}}_{o}},\textbf{w} \right)$, i.e.,		

```math 
\begin{split}
 \underbrace{\frac{C(\textbf{y}_o,\textbf{w})}{\sum\limits_{m=1}^{M}{{{w}_{m}}{{x}_{om}}}}}_{\text{Cost Efficiency}}=\underbrace{\theta^{*}}_{\text{Technical Efficiency}}\times \underbrace{A{{E}_{R\left( I \right)}}\left( {{\textbf{x}}_{o}},{{\textbf{y}}_{o}},{\textbf{w}} \right)}_{\text{Allocative Efficiency}} \le 1. 
\end{split}
```


**Example**

In this example we compute the cost efficiency measure:
```@example cost
using BenchmarkingEconomicEfficiency

X = [2 2; 1 4; 4 1; 4 3; 5 5; 6 1; 2 5; 1.6 8];

Y = [1; 1; 1; 1; 1; 1; 1; 1];

W = [1 1; 1 1; 1 1; 1 1; 1 1; 1 1; 1 1; 1 1];

costradial = deacost(X, Y, W)
```

Estimated economic, technical and allocative efficiency scores are returned with the `efficiency` function:
```@example cost
efficiency(costradial, :Economic)
```

```@example cost
efficiency(costradial, :Technical)
```

```@example cost
efficiency(costradial, :Allocative)
```

**Reference**

Chapter 3 in Pastor, J.T., Aparicio, J. and Zofío, J.L. (2022) Benchmarking Economic Efficiency: Technical and Allocative Fundamentals, International Series in Operations Research and Management Science, Vol. 315,  Springer, Cham. 


### deacost Function Documentation

```@docs
deacost
```

