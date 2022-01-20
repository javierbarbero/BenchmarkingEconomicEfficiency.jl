```@meta
CurrentModule = BenchmarkingEconomicEfficiency
```

# Profitability model

The profitability directional model is computed by solving the [Generalized Distance Function DEA Model](https://javierbarbero.github.io/DataEnvelopmentAnalysis.jl/stable/technical/generalizeddf/) for the technical efficiency.

*Profitability inefficiency* studies economic performance considering as economic goal the maximization of revenue to cost. The profitability function represents the maximum revenue to cost given the technology and input and output prices. It defines as follows:

$\Gamma \left(\mathbf{w},\mathbf{p}\right)=\underset{\mathbf{x},\mathbf{y}}{\mathop{\text{max}}}\,\Big\{\mathbf{p}\cdot \mathbf{y}/\mathbf{w}\cdot \mathbf{x}\,| \, {\mathbf{x}} \ge X\mathbf{\lambda},\;{\mathbf{y}} \leqslant Y{\mathbf{\lambda }, \lambda } \ge {\mathbf{0}} \Big\}, \mathbf{w}\in \mathbb{R}_{++}^{M},\ \mathbf{p}\in \mathbb{R}_{++}^{N},$ 

Calculating maximum profitability along with the optimal output and input quantities requires solving:

```math
\begin{split}
& \Gamma \left( \mathbf{w},\mathbf{p} \right)=\underset{\textbf{x},\textbf{y},\pmb{\lambda}}{\mathop{\max }}\,\ \ \sum\limits_{n=1}^{N}{{{p}_{n}}{{y}_{n}}}/\sum\limits_{m=1}^{M}{{{w}_{m}}{{x}_{m}}}\quad  \\ 
& \text{s}\text{.t}\text{.}\quad \,\sum\limits_{j=1}^{J}{\lambda _{j}x_{jm}^{{}}}\le {{x}_{m}},\ m=1,...,M\text{,}\  \\ 
& \quad \quad \sum\limits_{j=1}^{J}{\lambda _{j}y_{jn}^{{}}}\ge y_{n}^{{}},\ n=1,...,N\text{, } \\ 
& \quad \quad \sum\limits_{j=1}^{J}{\lambda _{j}^{{}}=1,} \\ 
& \quad \quad \lambda \ge 0, 
\end{split}
```

Note that this program allows for variable returns to scale, while the technology exhibits *local* constant returns at the optimal solution ($\textbf{x}^*,\textbf{y}^*,\pmb{\lambda}^*$). 

For firm $\left( \textbf{x}_{o}^{{}},\textbf{y}_{o}^{{}} \right)\in \mathbb{R}_{+}^{M+N},\ \textbf{x}_{o}^{{}}\ne {{0}_{M}},\textbf{y}_{o}^{{}}\ne {{0}_{N}}$, *Profitability inefficiency* defines as the ratio between observed profitability to maximum profitability; i.e., 

$\Gamma E\left( \mathbf{x}_o,\mathbf{y}_o,\mathbf{w},\mathbf{p} \right)=\frac{{{\Gamma }_{o}}}{\Gamma (\mathbf{p},\mathbf{w})}=\frac{\mathbf{p}\cdot {{\mathbf{y}}_{o}}/\mathbf{w}\cdot {{\mathbf{x}}_{o}}}{\Gamma (\mathbf{p},\mathbf{w})}=\frac{\sum\limits_{n=1}^{N}{{{p}_{n}}{{y}_{on}}}/\sum\limits_{m=1}^{M}{{{w}_{m}}{{x}_{om}}}}{\Gamma (\mathbf{p},\mathbf{w})}\le 1.$ 
 

Based on duality, profitability efficiency is decomposed through graph multiplicative measures that simultaneously reduce inputs and increase outputs. The most popular measure is the hyperbolic graph measure, which is a particular case of the so-called generalized distance function $GDF$--see Pastor, Aparicio and Zofío (2022, Ch. 4). 

The technical efficiency measure for firm $\left( \textbf{x}_{o}^{{}},\textbf{y}_{o}^{{}} \right)$ in terms of the $GDF$ under constant returns to scale can be calculated through DEA methods by solving the following program:  

```math
\begin{split}
& TE^{CRS}_{GDF}\left( {{\mathbf{x}}_{o}},{{\mathbf{y}}_{o}};\alpha  \right)=\underset{\text{ }\!\!\delta\!\!\text{ },\mathbf{\pmb{\lambda} }}{\mathop{\text{min}}}\,\, {{\delta }^{{CRS}}} \\ 
& \text{s}\text{.t}\text{.} \,\,\,\ \sum\nolimits_{j=1}^{J}{\lambda _{j}^{{}}x_{jm}^{{}}}\le {{\left( {{\delta }^{{CRS}}} \right)}^{1-\alpha }}{{x}_{om}},\ m=1,...,M\text{,}\  \\ 
& \quad \quad \sum\nolimits_{j=1}^{J}{\lambda _{j}^{{}}y_{jn}^{{}}}\ge y_{on}^{{}}/{{\left( {{\delta }^{{CRS}}} \right)}^{\alpha }},\ n=1,...,N\text{,} \\ 
& \quad \quad {{\lambda }_{j}}\ge 0,   
\end{split}
```

where the parameter $\alpha$ sets the direction towards the production frontier. The $GDF$ generalizes existing measures, such as the input distance function ($\alpha = 0$) and the output distance function ($\alpha = 1$). As already mentioned, it also nests the graph (hyperbolic) efficiency technical measure when $\alpha = 0.5$. 

The fact that the reference benchmark maximizing profitability satisfies constant returns to scale implies that any firm producing under increasing or decreasing returns to scale incurs scale inefficiencies which carry losses in profitability. Therefore, the sources of productive inefficiency can be technical, i.e., the firm lays within the production possibility set, or related to a suboptimal scale, i.e. although the firm (or its projection) may belong to the frontier, it is does not produce under constant returns to scale. This implies that technical efficiency under constant returns to scale can be decomposed into the usual technical efficiency under variables returns to scale times a factor representing scale inefficiency; i.e. $TE_{GDF}^{CRS}\left( \mathbf{x},\mathbf{y},\alpha  \right)=TE_{GDF}^{{}}\left( \mathbf{x},\mathbf{y},\alpha  \right)\times SE_{GDF}^{{}}\left( \mathbf{x},\mathbf{y}, \alpha  \right)=\delta \times \left( {{\delta }^{CRS}}/\delta  \right)\le 1$. In this expression, $TE_{GDF}^{{}}\left( \mathbf{x},\mathbf{y},\alpha  \right) = \delta$ is the generalized distance function under the variable returns to scale technology $T$. Its calculation requires solving the previous program but adding the constraint $\sum\nolimits_{j=1}^{J}{{{\lambda }_{j}}=1}$. Since both the profitability and the generalized distance function programs are non-linear, **BenchmarkingEconomicEfficiency.jl** resorts to the 'JuMP' package combined with the `Ipopt' solver.  

Once both technical efficiency measures have been calculated, we can recall the duality between the profitability function and the $GDF$. Duality allows establishing the Fenchel-Mahler inequality by which profitability efficiency is greater or equal in value to the technical efficiency measure under CRS, i.e,. $\mathit{ \Gamma E(\textbf{x}_o,\textbf{y}_o,\textbf{w}, \textbf{p})} \ge TE^{CRS}_{GDF}\left( {{\mathbf{x}}_{o}},{{\mathbf{y}}_{o}},\alpha  \right)$. Considering the decomposition of $TE^{CRS}_{GDF}\left( {{\mathbf{x}}_{o}},{{\mathbf{y}}_{o}},\alpha  \right)$ into variable returns  efficiency and scale efficiency, and closing the inequality with the addition of the residual term capturing allocative inefficiency, yields the following decomposition:  

```math
\begin{split}
& \underbrace{\frac{\sum\limits_{n=1}^{N}{{{p}_{n}}{{y}_{on}}}/\sum\limits_{m=1}^{M}{{{w}_{m}}{{x}_{om}}}}{\Gamma (\mathbf{p},\mathbf{w})}}_{\text{Profitability Inefficiency}}=\underbrace{TE^{CRS}_{GDF}\left( {{\mathbf{x}}_{o}},{{\mathbf{y}}_{o}},\alpha  \right)}_{\text{Graph Technical Efficiency} \, CRS}\times \underbrace{A{{E}_{GDF}}\left( {{\mathbf{x}}_{o}},{{\mathbf{y}}_{o}},\mathbf{w},\mathbf{p} \right)}_{\text{Allocative Inefficiency}} = \\
& \underbrace{TE_{GDF}\left( {{\mathbf{x}}_{o}},{{\mathbf{y}}_{o}},\alpha  \right)}_{\text{Graph Technical Efficiency} \, VRS} \times 
\underbrace{SE_{GDF}\left( {{\mathbf{x}}_{o}},{{\mathbf{y}}_{o}},\alpha  \right)}_{\text{Scale Efficiency}} \times
 \underbrace{A{{E}_{GDF}}\left( {{\mathbf{x}}_{o}},{{\mathbf{y}}_{o}},\mathbf{w},\mathbf{p} \right)}_{\text{Allocative Inefficiency}}  \ge 0. 
\end{split}  
```

**Reference**

Chapter 4 in Pastor, J.T., Aparicio, J. and Zofío, J.L. (2022) Benchmarking Economic Efficiency: Technical and Allocative Fundamentals, International Series in Operations Research and Management Science, Vol. 315,  Springer, Cham. 


**Example**

In this example we compute the profitability efficiency measure:
```@example profitability
using BenchmarkingEconomicEfficiency

X = [2; 4; 8; 12; 6; 14; 14; 9.412];

Y = [1; 5; 8; 9; 3; 7; 9; 2.353];

W = [1; 1; 1; 1; 1; 1; 1; 1];

P = [2; 2; 2; 2; 2; 2; 2; 2];

profitability = deaprofitability(X, Y, W, P)
```

Estimated economic, technical (CRS and VRS), scale, and allocative efficiency scores are returned with the `efficiency` function:
```@example profitability
efficiency(profitability, :Economic)
```

```@example profitability
efficiency(profitability, :CRS)
```

```@example profitability
efficiency(profitability, :VRS)
```

```@example profitability
efficiency(profitability, :Scale)
```

```@example profitability
efficiency(profitability, :Allocative)
```

### deaprofitability Function Documentation

```@docs
deaprofitability
```
