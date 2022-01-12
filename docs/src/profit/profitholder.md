```@meta
CurrentModule = BenchmarkingEconomicEfficiency
```
# Profit Hölder model

The profit Hölder distance function model is computed by solving a graph [Hölder DEA model](https://javierbarbero.github.io/DataEnvelopmentAnalysis.jl/stable/technical/holder/) for the technical efficiency.

The Hölder distance functions conform with the Principle of Least Action (PLA) searching for the closest or 'least distance' to the production frontier. This in contrast to some of the previous models, particularly, those based on slacks such as the [Profit Additive model](@ref), that maximize the distance to the production frontier, i.e., searches for the furthest targets.  

The Hölder norms ${{\ell }_{h}}$ ($h\in \left[ 1,\infty  \right]$) are defined over a $g$-dimensional real normed space as follows:

```math
{{\left\| \,.\, \right\|}_{h}}:z\to {{\left\| z \right\|}_{h}}=\left\{ \begin{matrix}
{{\left( \sum\limits_{j=1}^{g}{{{\left| {{z}_{j}} \right|}^{h}}} \right)}^{{1}/{h}\;}} & \text{if }h\in \left[ 1,\infty  \right[  \\ 
\underset{j=1,...,g}{\mathop{\max }}\,\left\{ \left| {{z}_{j}} \right| \right\} & \text{if }h=\infty   \\
\end{matrix} \right. 	
```

where $z=\left( {{z}_{1}},...,{{z}_{g}} \right)\in {{R}^{g}}$. 

The choice of a meaningful norm $h$ corresponds to the researcher. **Benchmarking Economic Efficiency** with *Julia* implements the Hölder function under the following norms: unit ($h=1$), infinitum ($h=\infty$), and $h=2$, corresponding to the Euclidean distance. Computationally, the Hölder distance functions are related to non-linear optimization programs. However, for $h=1$ and $h=\infty$ it is possible to resort to linear DEA models because the topological balls associated with these norms define polyhedral sets. In these two cases the Hölder distance functions are equivalent to the directional distance function with a specific choice of directional vector. For $h=1$ it can be shown that $T{{I}_{WH\ddot{o}lder(G)}}\left( {{\textbf{x}}_{o}},{{\textbf{y}}_{o}},1 \right)$ is calculated as the minimum of the values $T{{I}_{DDF(I)}}\left( {{\textbf{x}}_{o}},{{\textbf{y}}_{o}}, \left(0,...,{{1}_{\left( {{m}'} \right)}},...0 \right), \textbf{0}_N \right), {m}'=1,...,M$, and the values $T{{I}_{DDF(O)}}\left( {{x}_{o}},{{y}_{o}}, \textbf{0}_M, \left( 0,...,{{1}_{\left( {{n}'} \right)}},...0 \right) \right), {n}'=1,...,N$. These correspond to the input-oriented $DDF$ model, which is solved $M$ times, each with a unit valued element $g^-_{om'}=1$ for every $m'$ input, and the rest of the $m-1$ elements equal to zero, plus the output-oriented $DDF$ model, which is solved $N$ times, again with a unit valued element, $g^+_{on'}=1$ for  every $n'$ output and the rest of the elements equal to zero. In the case of $h=\infty$,  $T{{I}_{WH\ddot{o}lder(G)}}\left( {{x}_{o}},{{y}_{o}}, \infty \right)$ is identical to the [$DDF$ model](https://javierbarbero.github.io/DataEnvelopmentAnalysis.jl/stable/technical/directional/)  with the directional vector fixed at $\left({{\mathbf{g_{x}^-},\mathbf{g^+_y}}} \right)= \:$$\left( {{\mathbf{1}_M,\mathbf{1}_N}} \right)$. The case of the Euclidean norm $h=2$ is complex because determining the shortest distance requires minimizing a convex function on the complement of a convex set. Pastor, Aparicio and Zofío (2022, Ch. 9) show that this distance can be calculated resorting to quadratic optimization. The first step to do that consists in writing the Euclidean distance from firm $\left( {{\mathbf{x}_o,\mathbf{y}_{o}}} \right)$  to the weakly efficient frontier as a bi-level linear program, which is a linear program that includes another linear program among its constraints:

```math
\begin{split}
& T{{I}_{WH\ddot{o}lder(G)}}\left( {{\mathbf{x}}_{o}},{{\mathbf{y}}_{o}}, 2 \right)= \underset{\textbf{x},\textbf{y},\pmb{\lambda},\beta ,\pmb{\gamma} }{\mathop{\min }}\, \sqrt{\sum\limits_{m=1}^{M}{{{\left( {{x}_{om}}-{{x}_{m}} \right)}^{2}}}+\sum\limits_{n=1}^{N}{{{\left( {{y}_{n}}-{{y}_{on}} \right)}^{2}}}}  \\
	& s.t. \quad \sum\limits_{j=1}^{J}{{{\lambda }_{j}}{{x}_{jm}}}\le {{x}_{m}}, \quad  m=1,...,M  \\
	&  \quad \quad \sum\limits_{j=1}^{J}{{{\lambda }_{j}}{{y}_{jn}}}\ge {{y}_{n}}, \quad  n=1,...,N  \\
	& \quad \quad  \sum\limits_{j=1}^{J}{{{\lambda }_{j}}}=1,   \\
	& \quad \quad \beta =0, \\
	& \quad \quad \underset{\beta,\pmb{\gamma}}{\mathop{\max }}\,\,\,\,\beta    \\
	& \quad \quad s.t.\,\,\,\,\,\sum\limits_{j=1}^{J}{{{\gamma }_{j}}{{x}_{jm}}}\le {{x}_{m}}-\beta, \quad m=1,...,M  \\
	& \quad \quad \,\,\,\,\,\,\,\,\,\,\,\sum\limits_{j=1}^{J}{{{\gamma }_{j}}{{y}_{jn}}}\ge {{y}_{n}}+\beta,\quad  n=1,...,N  \\
	& \quad \quad \,\,\,\,\,\,\,\,\,\,\,\sum\limits_{j=1}^{J}{{{\gamma }_{j}}}=1, \\
	& \quad \quad {{\lambda }_{j}},{{\gamma }_{j}}\ge 0, \quad j=1,...,J  \\
	& \quad \quad {{x}_{m}}\ge 0, \quad m=1,...,M  \\
	& \quad \quad {{y}_{n}}\ge 0, \quad n=1,...,N  \\
\end{split}
```

The literature presents different ways of solving Bi-level Programing models, from exact methods to heuristics and metaheuristics. Here we use the Karush-Kuhn-Tucker conditions of the linear program embedded in the previous model, corresponding to $\underset{\beta ,\pmb{\gamma}}{\mathop{\max }}\,\beta$ and its associated contraints. Pastor, Aparicio and Zofío (2022, Ch. 9) show that, substituting this program with the corresponding set of complementary constrainst, one can solve the program through second order sets (SOS). Therefore, the final model to be solved is a quadratic programming problem with SOS conditions. **Benchmarking Economic Efficiency** with *Julia* solves the Hölder  model associated to the Euclidean norm using the Gurobi optimizer. This requires adding it to Julia, which can be done under a free license for academic use only, or a paid commercial version. The optimizer can be downloaded from the [company's website](https://www.gurobi.com/). A free academic license can be obtained [here](https://www.gurobi.com/downloads/end-user-license-agreement-academic/). Upon installation, add the package [Gurobi.jl](https://github.com/jump-dev/Gurobi.jl) to Julia by running the following the commands: 'using Pkg', 'Pkg.add("Gurobi")' and 'Pkg.build("Gurobi")'.    

We now recall the duality results that allow the decomposition of profit inefficiency into technical and allocative components: $\Pi{I}_{WH\ddot{o}lder(G)}\left( {{\textbf{x}}_{o}},{{\textbf{y}}_{o}}, h, {\tilde{\textbf{w}}, \tilde{\textbf{p}}} \right)$ = $T{{I}_{WH\ddot{o}lder(G)}}\left( {{\textbf{x}}_{o}},{{\textbf{y}}_{o},h} \right)$ + $A{{I}_{WH\ddot{o}lder(G)}}\left( {{\textbf{x}}_{o}},{{\textbf{y}}_{o}},h, \tilde{\textbf{w}}, \tilde{\textbf{p}} \right)$. For the Euclidean norm $h=2$, this results in the following expression: 

```math
\begin{split} 
	& \underbrace{\frac{\Pi \left( \mathbf{w},\mathbf{p} \right)-\left( \sum\limits_{n=1}^{N}{{{p}_{n}}{{y}_{on}}}-\sum\limits_{m=1}^{M}{{{w}_{m}}{{x}_{om}}} \right)}{{{\left\| \left( w,p \right) \right\|}_{q}}}}_{\text{Norm}\text{.}\ \text{Profit Inefficiency}}= \\ 
	& \quad \underbrace{\sqrt{\sum\limits_{m=1}^{M}{{{\left( {{x}_{om}}-x_{m}^{*} \right)}^{2}}}+\sum\limits_{n=1}^{N}{{{\left( y_{n}^{*}-{{y}_{on}} \right)}^{2}}}}}_{\text{Graph Technnical Inefficiency}}+\underbrace{A{{I}_{WH\ddot{o}lder\left( G \right)}}\left( {{\textbf{x}}_{o}},{{\textbf{y}}_{o}},\tilde{\textbf{w}},\tilde{\textbf{p}},h \right)}_{\text{Norm}\text{.}\ \text{Profit Inefficiency}}\ge 0, \\ 
\end{split}
```

where $x^{*}_{m}$ and $y^{*}_{n}$ are the solution to the DEA problem.

From the point of view of the satisfaction of properties, a critique associated with the Hölder distance functions is that they do not satisfy units' invariance because they are dependent on the units of measurement of inputs and outputs. This means that the comparison between the efficiency scores of different observations would change depending on the units of measurement chosen by the analyst. To solve this problem we can rely on the weighted version of the weakly efficient Hölder distance function (denoted as WW)--for details see Pastor, Aparicio and Zofío (2022, Ch. 9). Based on this distance function, we can decompose profit inefficiency into technical and allocative inefficiency terms that are units' invariant: $\Pi{I}_{WWH\ddot{o}lder(G)}\left( {{\textbf{x}}_{o}},{{\textbf{y}}_{o}}, h, {\tilde{\textbf{w}}, \tilde{\textbf{p}}} \right)$ = $T{{I}_{WWH\ddot{o}lder(G)}}\left( {{\textbf{x}}_{o}},{{\textbf{y}}_{o},h} \right)$ + $A{{I}_{WWH\ddot{o}lder(G)}}\left( {{\textbf{x}}_{o}},{{\textbf{y}}_{o}},h, \tilde{\textbf{w}}, \tilde{\textbf{p}} \right)$: 

```math
\begin{split} 
& \underbrace{\frac{\Pi \left( \mathbf{w},\mathbf{p} \right)-\left( \sum\limits_{n=1}^{N}{{{p}_{n}}{{y}_{on}}}-\sum\limits_{m=1}^{M}{{{w}_{m}}{{x}_{om}}} \right)}{{{\left\| \left( {{w}_{1}}{{x}_{o1}},...,{{w}_{M}}{{x}_{oM}},{{p}_{1}}{{y}_{o1}},...,{{p}_{N}}{{y}_{oN}} \right) \right\|}_{q}}}}_{\text{Norm}\text{.}\ \text{Profit Inefficiency}}= \\ 
& \quad \underbrace{\sqrt{\sum\limits_{m=1}^{M}{{\left(\frac{{{x}_{om}}-x_{m}^{*}}{{x}_{om}}\right)}^{2}}+\sum\limits_{n=1}^{N}{{{\left(\frac{y_{m}^{*}-{{y}_{o}}}{{y}_{om}}\right)}^{2}}}}}_{\text{Graph Technnical Inefficiency}}+\underbrace{A{{I}_{WWH\ddot{o}lder\left( G \right)}}\left( {{\textbf{x}}_{o}},{{\textbf{y}}_{o}},h,\tilde{\textbf{w}},\tilde{\textbf{p}} \right)}_{\text{Norm}\text{.}\ \text{Profit Inefficiency}}\ge 0. \\ 
\end{split}
``` 
 
 **Benchmarking Economic Efficiency** with *Julia* calculates both the unweighted and weighted versions of the profit Hölder model under the previous norms: ${{\ell }_{1}}$,  ${{\ell }_{\infty }}$, and ${{\ell }_{2}}$. The weighted version requires adding `weight=true` to the code--see below the documentation accompanying this function for different options.   

**Reference**

Chapter 9 in Pastor, J.T., Aparicio, J. and Zofío, J.L. (2022) Benchmarking Economic Efficiency: Technical and Allocative Fundamentals, International Series in Operations Research and Management Science, Vol. 315,  Springer, Cham.


**Example**

In this example we compute the profit efficiency Hölder under the L1 norm considering the unweighted version:

```@example profitholder
using BenchmarkingEconomicEfficiency

X = [2; 4; 8; 12; 6; 14; 14; 9.412];

Y = [1; 5; 8; 9; 3; 7; 9; 2.353];

W = [1; 1; 1; 1; 1; 1; 1; 1];

P = [2; 2; 2; 2; 2; 2; 2; 2];

profitholderl1 = deaprofitholder(X, Y, W, P, l = 1)
```

Estimated economic, technical and allocative efficiency scores are returned with the `efficiency` function:
```@example profitholder
efficiency(profitholderl1, :Economic)
```

```@example profitholder
efficiency(profitholderl1, :Technical)
```

```@example profitholder
efficiency(profitholderl1, :Allocative)
```


### deaprofitholder Function Documentation

```@docs
deaprofitholder
```

