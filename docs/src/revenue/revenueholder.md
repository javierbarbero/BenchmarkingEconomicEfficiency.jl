```@meta
CurrentModule = BenchmarkingEconomicEfficiency
```

# Revenue Hölder model

The revenue Hölder model is computed by solving an output-oriented [Hölder DEA model](https://javierbarbero.github.io/DataEnvelopmentAnalysis.jl/stable/technical/holder/) for the technical inefficiency.

The Hölder norms ${{\ell }_{h}}$ ($h\in \left[ 1,\infty  \right]$) are defined over a $g$-dimensional real normed space as follows:

```math
{{\left\| \,.\, \right\|}_{h}}:z\to {{\left\| z \right\|}_{h}}=\left\{ \begin{matrix}
{{\left( \sum\limits_{j=1}^{g}{{{\left| {{z}_{j}} \right|}^{h}}} \right)}^{{1}/{h}\;}} & \text{if }h\in \left[ 1,\infty  \right[  \\ 
\underset{j=1,...,g}{\mathop{\max }}\,\left\{ \left| {{z}_{j}} \right| \right\} & \text{if }h=\infty   \\
\end{matrix} \right. 	
```

where $z=\left( {{z}_{1}},...,{{z}_{g}} \right)\in {{R}^{g}}$. 

Mirroring the options available when decomposing the [Profit Hölder model](@ref) **BenchmarkingEconomicEfficiency.jl** calculates the technical inefficiency corresponding to the output-oriented Hölder distance functions under the same norms: unit ($h=1$), infinitum ($h=\infty$), and $h=2$, corresponding to the Euclidean distance. For norm $h=1$ the Hölder distance functions are equivalent to the directional distance function presented in the [Output-oriented Directional Distance Function](https://javierbarbero.github.io/DataEnvelopmentAnalysis.jl/stable/technical/directional/) with  a specific directional vector. Pastor, Aparicio and Zofío (2022, Ch. 9) show that $T{{I}_{WH\ddot{o}lder(O)}}\left( {{\textbf{x}}_{o}},{{\textbf{y}}_{o}},1 \right)$ is calculated as the minimum of the values $T{{I}_{DDF(O)}}\left( {{\textbf{x}}_{o}},{{\textbf{y}}_{o}}, \textbf{0}_M, \left( 0,...,{{1}_{\left( {{n}'} \right)}},...0 \right) \right), {n}'=1,...,N$. In this case, the output-oriented $DDF$ is solved $N$ times, each with a unit valued element $g^-_{on'}=1$ for every $n'$ output, and the rest of the $n-1$ elements equal to zero, and considering a zero valued input directional vector. Alternatively, for norm $h=\infty$, the Hölder distance function is also equivalent to the output-oriented *DDF* model with an unitary  output directional vectors; i.e., $T{{I}_{WH\ddot{o}lder}(O) }\left( {{\textbf{x}}_{o}},{{\textbf{y}}_{o}},\infty \right) = T{{I}_{DDF(I)}}\left( {{\textbf{x}}_{o}},{{\textbf{y}}_{o}}, \textbf{0}_M, \textbf{1}_N \right)$. Calculating the technical efficiency measures based on the Hölder distance under the Euclidean norm $h=2$ is complex because determining the shortest distance requires minimizing a convex function on the complement of a convex set. Pastor, Aparicio and Zofío (2022, Ch. 9) show that Euclidean distance from firm $({{\textbf{x}}_{o}},{{\textbf{y}}_{o}})$ to the weakly efficient frontier of $P\left( {{\textbf{x}}_{o}} \right)$ can be solved resorting to quadratic optimization. In particular, by solving a bi-level linear program:

```math
\begin{split}
& T{{I}_{WH\ddot{o}lder(I)}}\left( {{\mathbf{x}}_{o}},{{\mathbf{y}}_{o}}, 2 \right)= \underset{\textbf{x},\textbf{y},\pmb{\lambda},\beta ,\pmb{\gamma} }{\mathop{\min }}\, \sqrt{\sum\limits_{n=1}^{N}{{{\left( {{y}_{n}}-{{y}_{on}} \right)}^{2}}}}  \\
	& s.t. \quad \sum\limits_{j=1}^{J}{{{\lambda }_{j}}{{x}_{jm}}}\le {{x}_{m}}, \quad  m=1,...,M  \\
	&  \quad \quad \sum\limits_{j=1}^{J}{{{\lambda }_{j}}{{y}_{jn}}}\ge {{y}_{n}}, \quad  n=1,...,N  \\
	& \quad \quad  \sum\limits_{j=1}^{J}{{{\lambda }_{j}}}=1,   \\
	& \quad \quad \beta =0, \\
	& \quad \quad \underset{\beta,\pmb{\gamma}}{\mathop{\max }}\,\,\,\,\beta    \\
	& \quad \quad s.t.\,\,\,\,\,\sum\limits_{j=1}^{J}{{{\gamma }_{j}}{{x}_{jm}}}\le {{x}_{m}}, \quad m=1,...,M  \\
	& \quad \quad \,\,\,\,\,\,\,\,\,\,\,\sum\limits_{j=1}^{J}{{{\gamma }_{j}}{{y}_{jn}}}\ge {{y}_{n}}+\beta,\quad  n=1,...,N  \\
	& \quad \quad \,\,\,\,\,\,\,\,\,\,\,\sum\limits_{j=1}^{J}{{{\gamma }_{j}}}=1, \\
	& \quad \quad {{\lambda }_{j}},{{\gamma }_{j}}\ge 0, \quad j=1,...,J  \\
	& \quad \quad {{y}_{n}}\ge 0, \quad n=1,...,N  \\
\end{split}
```
The literature presents different ways of solving Bi-level Programing models, from exact methods to heuristics and metaheuristics. Here we use the Karush-Kuhn-Tucker conditions of the linear program embedded in the previous model, corresponding to $\underset{\beta ,\pmb{\gamma}}{\mathop{\max }}\,\beta$ and its associated contraints. Pastor, Aparicio and Zofío (2022, Ch. 9) show that, substituting this program with the corresponding set of complementary constrainst, one can solve the program through second order sets (SOS). Therefore, the final model to be solved is a quadratic programming problem with SOS conditions. **BenchmarkingEconomicEfficiency.jl** solves the Hölder  model associated to the Euclidean norm using the Gurobi optimizer. This requires adding it to Julia, which can be done under a free license for academic use only, or a paid commercial version. The optimizer can be downloaded from the [company's website](https://www.gurobi.com/). A free academic license can be obtained [here](https://www.gurobi.com/downloads/end-user-license-agreement-academic/). Upon installation, add the package [Gurobi.jl](https://github.com/jump-dev/Gurobi.jl) to Julia by running the following the commands: 'using Pkg', 'Pkg.add("Gurobi")' and 'Pkg.build("Gurobi")'.    

Once the technical inefficiency measures has been calculated, we recall once again the duality results that allow the decomposition of revenue inefficiency into technical and allocative components: $R{{I}_{WH\ddot{o}lder(O)}}\left( {{\textbf{x}}_{o}},{{\textbf{y}}_{o}}, h, \tilde{{\textbf{p}}} \right)$ = $T{{I}_{WH\ddot{o}lder(O)}}\left( {{\textbf{x}}_{o}},{{\textbf{y}}_{o}, h} \right)$ + $A{{I}_{WH\ddot{o}lder(O)}}\left( {{\textbf{x}}_{o}},{{\textbf{y}}_{o}}, h, {\tilde{\textbf{p}}} \right)$. For the euclidean norm, $h=2$, this results in the following expression: 

```math
\underbrace{\frac{R \left( \mathbf{x}_o,\mathbf{p} \right) - \sum\limits_{n=1}^{N}{{{p}_{n}}{{y}_{om}}}}{{{\left\| p \right\|}_{q}}}}_{\text{Norm. Revenue Inefficiency}}=\underbrace{\underset{\textbf{y},\lambda ,\beta ,\gamma }{\mathop{\min }}\,\sqrt{\sum\limits_{n=1}^{N}{{{\left( {{y}_{on}}-y_{n}^{*} \right)}^{2}}}}}_{\text{Output Technnical Inefficiency}}+\underbrace{A{{I}_{WH\ddot{o}lder(O)}}\left( {{\textbf{x}}_{o}},{{\textbf{y}}_{o}}, h,\tilde{\textbf{p}} \right)}_{\text{Norm. Allocative Inefficiency}} \ge 0,
```

where $y^{*}_{n}$ is the solution to the technical inefficency problem. For the alternative norms $h=1$ and $h=\infty$ the decompositions are equivalent to the [Output-oriented Directional Distance Function](https://javierbarbero.github.io/DataEnvelopmentAnalysis.jl/stable/technical/directional/), where the directional vectors are set to the values previously commented. 

From the point of view of the satisfaction of properties, a critique associated with the Hölder distance functions is that they do not satisfy units' invariance because they are dependent on the units of measurement of outputs. This means that the comparison between the efficiency scores of different observations would change depending on the units of measurement chosen by the analyst. To solve this problem we can rely on the weighted version of the weakly efficient Hölder distance function (denoted as WW)--for details see Pastor, Aparicio and Zofío (2022, Ch. 9). Based on this distance function, we can decompose revenue inefficiency into technical and allocative inefficiency terms that are units' invariant: $R{{I}_{WH\ddot{o}lder(I)}}\left( {{\textbf{x}}_{o}},{{\textbf{y}}_{o}}, h, \tilde{{\textbf{p}}} \right)$= $T{{I}_{WWH\ddot{o}lder(O)}}\left( {{\textbf{x}}_{o}},{{\textbf{y}}_{o},h} \right)$ + $A{{I}_{WWH\ddot{o}lder(O)}}\left( {{\textbf{x}}_{o}},{{\textbf{y}}_{o}}, h, \tilde{\textbf{p}} \right)$. For the Euclidean norm, $h=2$, this results in: 

```math
\underbrace{\frac{R \left( \mathbf{x}_o,\mathbf{p} \right) - \sum\limits_{n=1}^{N}{{{p}_{n}}{{y}_{om}}}}{{{\left\| p \right\|}_{q}}}}_{\text{Norm. Revenue Inefficiency}}=\underbrace{\underset{\textbf{y},\lambda ,\beta ,\gamma }{\mathop{\min }}\,\sqrt{\sum\limits_{n=1}^{N}{{{\left(\frac{y_{m}^{*}-{{y}_{o}}}{{y}_{om}}\right)}^{2}}}}}_{\text{Output Technnical Inefficiency}}+\underbrace{A{{I}_{WWH\ddot{o}lder(O)}}\left( {{\textbf{x}}_{o}},{{\textbf{y}}_{o}}, h,\tilde{\textbf{p}} \right)}_{\text{Norm. Allocative Inefficiency}} \ge 0.
```

**BenchmarkingEconomicEfficiency.jl** calculates both the unweighted and weighted versions of the revenue Hölder model under the previous norms: ${{\ell }_{1}}$,  ${{\ell }_{\infty }}$, and ${{\ell }_{2}}$. The weighted version requires adding `weight=true` to the code--see below the documentation accompanying this function for the different options. 

**Reference**

Chapter 9 in Pastor, J.T., Aparicio, J. and Zofío, J.L. (2022) Benchmarking Economic Efficiency: Technical and Allocative Fundamentals, International Series in Operations Research and Management Science, Vol. 315,  Springer, Cham. 

**Example**


In this example we compute the revenue efficiency Hölder L1 measure under variable returns to scale:
```@example revenueholder
using BenchmarkingEconomicEfficiency

X = [1; 1; 1; 1; 1; 1; 1; 1];

Y = [7 7; 4 8; 8 4; 3 5; 3 3; 8 2; 6 4; 1.5 5];

P = [1 1; 1 1; 1 1; 1 1; 1 1; 1 1; 1 1; 1 1];

revenueholder = dearevenueholder(X, Y, P, l = 1)
```

Estimated economic, technical and allocative efficiency scores are returned with the `efficiency` function:
```@example revenueholder
efficiency(revenueholder, :Economic)
```

```@example revenueholder
efficiency(revenueholder, :Technical)
```

```@example revenueholder
efficiency(revenueholder, :Allocative)
```

### dearevenueholder Function Documentation

```@docs
dearevenueholder
```

