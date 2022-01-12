```@meta
CurrentModule = BenchmarkingEconomicEfficiency
```

# Revenue Radial model

Pastor, Aparicio and Zofío (2022, Ch. 3) summarize the duality results that allow to relate numerically the value of revenue efficiency with that of Farrell's radial output measure $R(O)$---whose inverse is Shephard's output distance function. Farrell's measure represents the maximum equiproportional increase in the observed output vector necessary to the reach the production frontier. For the firm under evaluation $(\mathbf{x}_o,\mathbf{y}_o)$ it can be calculated by solving the following DEA model. 

```math
\begin{split}
& TE_{R(O)}( {{\mathbf{x}}_{o}},{{\mathbf{y}}_{o}}) = \underset{\xi ,\mathbf{\pmb{\lambda} }}{\mathop{\max }}\,\quad \xi  \\ 
& \text{s}\text{.t}\text{.}\quad \,\sum\limits_{j=1}^{J}{\lambda _{j}^{{}}x_{jm}^{{}}}\le {{x}_{om}},\ m=1,...,M\text{,}\  \\ 
& \quad \quad \sum\limits_{j=1}^{J}{\lambda _{j}^{{}}y_{jn}^{{}}}\ge \xi y_{on}^{{}},\ n=1,...,N\text{, } \\ 
& \quad \quad \sum\limits_{j=1}^{J}{\lambda _{j}^{{}}}=1, \\ 
& \quad \quad \lambda \ge 0. \\
\end{split}
```

where $\xi^*$ denotes now the optimal solution. The constraints require the observation $\left( {\mathbf{x}_o,\xi^{*}\mathbf{y}_o} \right)$ to belong to the technology $P(\textbf{x}_o$, while the objective functions seeks the maximum value of $\xi$ that projects radially the output vector $\mathbf{y}_o$ to its frontier benchmark represented by $\hat{\textbf{y}}_o=\xi^*\mathbf{y}_o$. A feasible solution signaling technical efficiency is $\xi^*=1$. Therefore if  $\xi^*>1$, the observation is technically inefficient and $(\pmb{\lambda} X, \pmb{\lambda} Y)$ outperforms  $\left( {{\mathbf{x}_o,\mathbf{y}_o}} \right)$. 

We now show the main duality result relating revenue efficiency and Farrell's radial output distance function, allowing its decomposition:   $RE^{{}}_{R(O)}\left( {{\textbf{x}}_{o}},{{\textbf{y}}_{o}},\textbf{p} \right)=TE_{R(O)}\left( {{\textbf{x}}_{o}},{{\textbf{\textbf{y}}}_{o}} \right)+AE_{R(O)}\left( {{\textbf{x}}_{o}},{{\textbf{y}}_{o}},\textbf{p} \right)$, i.e.,		
	

```math 
\begin{split}
 \underbrace{\frac{\sum\limits_{n=1}^{N}{{{p}_{n}}{{y}_{on}}}}{R(\textbf{x}_o,\textbf{p})}}_{\text{Revenue Efficiency}}=\underbrace{\xi^{*}}_{\text{Technical Efficiency}}\times \underbrace{A{{E}_{R\left( O \right)}}\left( {{\textbf{x}}_{o}},{{\textbf{y}}_{o}},{\textbf{p}} \right)}_{\text{Allocative Efficiency}} \le 1  
\end{split}
```

**Example**

In this example we compute the revnue efficiency measure:
```@example revenue
using BenchmarkingEconomicEfficiency

X = [1; 1; 1; 1; 1; 1; 1; 1];

Y = [7 7; 4 8; 8 4; 3 5; 3 3; 8 2; 6 4; 1.5 5];

P = [1 1; 1 1; 1 1; 1 1; 1 1; 1 1; 1 1; 1 1];

revenueradial = dearevenue(X, Y, P)
```

Estimated economic, technical and allocative efficiency scores are returned with the `efficiency` function:
```@example revenue
efficiency(revenueradial, :Economic)
```

```@example revenue
efficiency(revenueradial, :Technical)
```

```@example revenue
efficiency(revenueradial, :Allocative)
```

**Reference**

Chapter 3 in Pastor, J.T., Aparicio, J. and Zofío, J.L. (2022) Benchmarking Economic Efficiency: Technical and Allocative Fundamentals, International Series in Operations Research and Management Science, Vol. 315,  Springer, Cham. 

### dearevenue Function Documentation

```@docs
dearevenue
```

