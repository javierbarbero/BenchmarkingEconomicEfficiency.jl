```@meta
CurrentModule = BenchmarkingEconomicEfficiency
```

# Cost Hölder model


The cost Hölder model is computed by solving an input-oriented [Hölder distance function DEA model](https://javierbarbero.github.io/DataEnvelopmentAnalysis.jl/stable/technical/holder/) for the technical inefficiency.

The Hölder norms ${{\ell }_{h}}$ ($h\in \left[ 1,\infty  \right]$) are defined over a $g$-dimensional real normed space as follows:

```math
{{\left\| \,.\, \right\|}_{h}}:z\to {{\left\| z \right\|}_{h}}=\left\{ \begin{matrix}
{{\left( \sum\limits_{j=1}^{g}{{{\left| {{z}_{j}} \right|}^{h}}} \right)}^{{1}/{h}\;}} & \text{if }h\in \left[ 1,\infty  \right[  \\ 
\underset{j=1,...,g}{\mathop{\max }}\,\left\{ \left| {{z}_{j}} \right| \right\} & \text{if }h=\infty   \\
\end{matrix} \right. 	
```

where $z=\left( {{z}_{1}},...,{{z}_{g}} \right)\in {{R}^{g}}$. 

Mirroring the options available when decomposing the [Profit Hölder model](@ref), **BenchmarkingEconomicEfficiency.jl** calculates the technical inefficiency corresponding to the input-oriented Hölder distance functions under the same norms: unit ($h=1$), infinitum ($h=\infty$), and $h=2$, corresponding to the Euclidean distance. For norm $h=1$ the Hölder distance functions are equivalent to the directional distance function presented in the [Input-oriented Directional Distance Function](https://javierbarbero.github.io/DataEnvelopmentAnalysis.jl/stable/technical/directional/) with a specific directional vector. Pastor, Aparicio and Zofío (2022, Ch. 9) show that the  $T{{I}_{WH\ddot{o}lder(I)}}\left( {{\textbf{x}}_{o}},{{\textbf{y}}_{o}},1 \right)$ is calculated as the minimum of the values $T{{I}_{DDF(I)}}\left( {{\textbf{x}}_{o}},{{\textbf{y}}_{o}}, \left(0,...,{{1}_{\left( {{m}'} \right)}},...0 \right), \textbf{0}_N \right), {m}'=1,...,M$. These are input-oriented *DDF* models which are solved $M$ times, each with a unit valued element $g^-_{om'}=1$ for every $m'$ input, and the rest of the $m-1$ elements equal to zero, and assigning a zero valued output directional vector. Alternatively, for norm $h=\infty$, the Hölder distance function is also equivalent to the oriented *DDF* model with an unitary input directional vector; i.e., $T{{I}_{WH\ddot{o}lder}(I) }\left( {{\textbf{x}}_{o}},{{\textbf{y}}_{o}},\infty \right) = T{{I}_{DDF(I)}}\left( {{\textbf{x}}_{o}},{{\textbf{y}}_{o}}, \textbf{1}_M, \textbf{0}_N \right)$. Calculating the technical inefficiency measure based on the Hölder distance under the Euclidean norm $h=2$ is complex because determining the shortest distance requires minimizing a convex function on the complement of a convex set. Pastor, Aparicio and Zofío (2022, Ch. 9) show that the Euclidean distance from firm $({{\textbf{x}}_{o}},{{\textbf{y}}_{o}})$ to the weakly efficient frontier of $L\left( {{\textbf{y}}_{o}} \right)$ can be solved through quadratic optimization. In particular, by solving a bi-level linear program:

```math
\begin{split}
& T{{I}_{WH\ddot{o}lder(I)}}\left( {{\mathbf{x}}_{o}},{{\mathbf{y}}_{o}}, 2 \right)= \underset{\textbf{x},\textbf{y},\pmb{\lambda},\beta ,\pmb{\gamma} }{\mathop{\min }}\, \sqrt{\sum\limits_{m=1}^{M}{{{\left( {{x}_{om}}-{{x}_{m}} \right)}^{2}}}}  \\
	& s.t. \quad \sum\limits_{j=1}^{J}{{{\lambda }_{j}}{{x}_{jm}}}\le {{x}_{m}}, \quad  m=1,...,M  \\
	&  \quad \quad \sum\limits_{j=1}^{J}{{{\lambda }_{j}}{{y}_{jn}}}\ge {{y}_{n}}, \quad  n=1,...,N  \\
	& \quad \quad  \sum\limits_{j=1}^{J}{{{\lambda }_{j}}}=1,   \\
	& \quad \quad \beta =0, \\
	& \quad \quad \underset{\beta,\pmb{\gamma}}{\mathop{\max }}\,\,\,\,\beta    \\
	& \quad \quad s.t.\,\,\,\,\,\sum\limits_{j=1}^{J}{{{\gamma }_{j}}{{x}_{jm}}}\le {{x}_{m}}-\beta, \quad m=1,...,M  \\
	& \quad \quad \,\,\,\,\,\,\,\,\,\,\,\sum\limits_{j=1}^{J}{{{\gamma }_{j}}{{y}_{jn}}}\ge {{y}_{n}},\quad  n=1,...,N  \\
	& \quad \quad \,\,\,\,\,\,\,\,\,\,\,\sum\limits_{j=1}^{J}{{{\gamma }_{j}}}=1, \\
	& \quad \quad {{\lambda }_{j}},{{\gamma }_{j}}\ge 0, \quad j=1,...,J  \\
	& \quad \quad {{x}_{m}}\ge 0, \quad m=1,...,M  \\
\end{split}
```

The literature presents different ways of solving Bi-level Programing models, from exact methods to heuristics and metaheuristics. Here we use the Karush-Kuhn-Tucker conditions of the linear program embedded in the previous model, corresponding to $\underset{\beta ,\pmb{\gamma}}{\mathop{\max }}\,\beta$ and its associated contraints. Pastor, Aparicio and Zofío (2022, Ch. 9) show that, substituting this program with the corresponding set of complementary constrainst, one can solve the program through second order sets (SOS). Therefore, the final model to be solved is a quadratic programming problem with SOS conditions. **BenchmarkingEconomicEfficiency.jl** solves the Hölder  model associated to the Euclidean norm using the Gurobi optimizer. This requires adding it to Julia, which can be done under a free license for academic use only, or a paid commercial version. The optimizer can be downloaded from the [company's website](https://www.gurobi.com/). A free academic license can be obtained [here](https://www.gurobi.com/downloads/end-user-license-agreement-academic/). Upon installation, add the package [Gurobi.jl](https://github.com/jump-dev/Gurobi.jl) to Julia by running the following the commands: 'using Pkg', 'Pkg.add("Gurobi")' and 'Pkg.build("Gurobi")'.    


Once the technical inefficiency measures has been calculated, we recall the duality results that allow the decomposition of cost inefficiency into technical and allocative components: $C{{I}_{WH\ddot{o}lder(I)}}\left( {{\textbf{x}}_{o}},{{\textbf{y}}_{o}}, h, \tilde{{\textbf{w}}} \right)$ = $T{{I}_{WH\ddot{o}lder(I)}}\left( {{\textbf{x}}_{o}},{{\textbf{y}}_{o}, h} \right)$ + $A{{I}_{WH\ddot{o}lder(I)}}\left( {{\textbf{x}}_{o}},{{\textbf{y}}_{o}}, h, {\tilde{\textbf{w}}} \right)$. For the euclidean norm, $h=2$, this results in the following expression: 

```math
\underbrace{\frac{\sum\limits_{m=1}^{M}{{{w}_{m}}{{x}_{om}}}-C\left( {{\textbf{y}}_{o}}, \textbf{w} \right)}{{{\left\| w \right\|}_{q}}}}_{\text{Norm. Cost Inefficiency}}=\underbrace{\underset{\textbf{x},\lambda ,\beta ,\gamma }{\mathop{\min }}\,\sqrt{\sum\limits_{m=1}^{M}{{{\left( {{x}_{om}}-x_{m}^{*} \right)}^{2}}}}}_{\text{Input Technnical Inefficiency}}+\underbrace{A{{I}_{WH\ddot{o}lder(I)}}\left( {{\textbf{x}}_{o}},{{\textbf{y}}_{o}}, h,\tilde{\textbf{w}} \right)}_{\text{Norm. Allocative Inefficiency}} \ge 0,
```

where $x^{*}_{m}$ is the solution to the technical inefficency problem. For the alternative norms $h=1$ and $h=\infty$ the decompositions are equivalent to the [Input-oriented Directional Distance Function](https://javierbarbero.github.io/DataEnvelopmentAnalysis.jl/stable/technical/directional/), where the directional vectors are set to the values previously commented. 

From the point of view of the satisfaction of properties, a critique associated with the Hölder distance functions is that they do not satisfy units' invariance because they are dependent on the units of measurement of inputs and outputs. This means that the comparison between the efficiency scores of different observations would change depending on the units of measurement chosen by the analyst. To solve this problem we can rely on the weighted version of the weakly efficient Hölder distance function (denoted as WW)--for details see Pastor, Aparicio and Zofío (2022, Ch. 9). Based on this distance function, we can decompose cost inefficiency into technical and allocative inefficiency terms that are units' invariant: $C{I}_{WWH\ddot{o}lder(I)}\left( {{\textbf{x}}_{o}},{{\textbf{y}}_{o}}, h, {\tilde{\textbf{w}}} \right)$ = $T{{I}_{WWH\ddot{o}lder(I)}}\left( {{\textbf{x}}_{o}},{{\textbf{y}}_{o},h} \right)$ + $A{{I}_{WWH\ddot{o}lder(I)}}\left( {{\textbf{x}}_{o}},{{\textbf{y}}_{o}},h, \tilde{\textbf{w}}\right)$. For the Euclidean norm, $h=2$, this results in: 

```math
\underbrace{\frac{\sum\limits_{m=1}^{M}{{{w}_{m}}{{x}_{om}}}-C\left({{\textbf{y}}_{o}}, \textbf{w} \right)}{{{\left\| w \right\|}_{q}}}}_{\text{Norm. Cost Inefficiency}}=\underbrace{\underset{\textbf{x},\lambda ,\beta ,\gamma }{\mathop{\min }}\,\sqrt{\sum\limits_{m=1}^{M}{{{\left(\frac{{{x}_{om}}-x_{m}^{*}}{{x}_{om}}\right)}^{2}}}}}_{\text{Input Technnical Inefficiency}}+\underbrace{A{{I}_{WWH\ddot{o}lder(I)}}\left( {{\textbf{x}}_{o}},{{\textbf{y}}_{o}}, h,\tilde{\textbf{w}} \right)}_{\text{Norm. Allocative Inefficiency}} \ge 0.
```

**Benchmarking Economic Efficiency** with *Julia* calculates both the unweighted and weighted versions of the cost Hölder model under the previous norms: ${{\ell }_{1}}$,  ${{\ell }_{\infty }}$, and ${{\ell }_{2}}$. The weighted version requires adding `weight=true` to the code--see below the documentation accompanying this function for the different options. 

**Reference**

Chapter 9 in Pastor, J.T., Aparicio, J. and Zofío, J.L. (2022) Benchmarking Economic Efficiency: Technical and Allocative Fundamentals, International Series in Operations Research and Management Science, Vol. 315,  Springer, Cham. 


**Example**

In this example we compute the Hölder L1 efficiency measure under variable returns to scale:
```@example costholder
using BenchmarkingEconomicEfficiency

X = [2 2; 1 4; 4 1; 4 3; 5 5; 6 1; 2 5; 1.6 8];

Y = [1; 1; 1; 1; 1; 1; 1; 1];

W = [1 1; 1 1; 1 1; 1 1; 1 1; 1 1; 1 1; 1 1];

costholderl1 = deacostholder(X, Y, W, l = 1)
```

Estimated economic, technical and allocative efficiency scores are returned with the `efficiency` function:
```@example costholder
efficiency(costholderl1, :Economic)
```

```@example costholder
efficiency(costholderl1, :Technical)
```

```@example costholder
efficiency(costholderl1, :Allocative)
```


### deacostholder Function Documentation

```@docs
deacostholder
```

