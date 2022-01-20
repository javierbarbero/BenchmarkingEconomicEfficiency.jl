```@meta
CurrentModule = BenchmarkingEconomicEfficiency
```

# Cost Reverse Directional Distance Function model

The cost reverse directional distance function model is computed by solving an input-oriented [Reverse *DDF* model](https://javierbarbero.github.io/DataEnvelopmentAnalysis.jl/stable/technical/reverseddf/) for the technical inefficiency.

As their graph counterpart presented in the [Profit Reverse Directional Distance Function model](@ref), the input-oriented $RDDF$ transforms any additive measure of input technical inefficiency, $EM(I)$, such as [the Russell input measure](https://javierbarbero.github.io/DataEnvelopmentAnalysis.jl/stable/technical/russell/#Russell-Input-Model), into a single scalar measure corresponding to an input-oriented $DDF$, $\beta_I$. Therefore, given the set of $J$ firms under study, ${F}_{J}$, and their projections on the frontier, denoted by ${\hat{F}_{J}}$, the $RDDF$ assigns a new $DDF$ score to the original $EM(I)$, while keeping the same projections ${\hat{F}_{J}}$. We  denote this score by $\beta_{RDDF(EM(I), F_J, \hat{F}_{J})}$.  The advantage of the input-oriented *RDDF* is that it relates the additive and multiplicative measures of technical inefficiency because the input-oriented *DDFs* is equivalent to Farrell's input radial measure shown in the [Cost Radial model](@ref), i.e., $\beta_I^{*}=1-\theta^{*}$.

To calculate this distance function for firm $\left( {{\mathbf{x}_o,\mathbf{y}_{o}}} \right)$ we need to determine the directional vector $\mathbf{g}= ({{\mathbf{g_{x}^-},\textbf{0}_M}})$ connecting the firm to its input-oriented  projection, $\left( {{{\hat{\textbf{x}}}}_{o}},{{\textbf{y}}_{o}} \right)\in {{\hat{F}}_{J}}$. Afterwards we calculate the value of the $RDDF(I)$. However, when calculating the new scores we need to differentiate between firms that are deemed technically efficient with $EM(I)=0$ and those that are technically inefficient. The measure $EM(I)$ splits the sample of firms ${{F}_{J}}$ into two disjoint subsets: ${{F}_{E}}=\left\{ \left( {{x}_{j}},{{y}_{j}} \right)\in {{F}_{J}}:T{{I}_{E{{M(I)}}}}\left( {{x}_{j}},{{y}_{j}} \right)=0 \right\}$ and ${{F}_{J\sim E}}=\left\{ \left( {{x}_{j}},{{y}_{j}} \right)\in {{F}_{J}}:T{{I}_{E{{M(I)}}}}\left( {{x}_{j}},{{y}_{j}} \right)>0 \right\}$. Then, for the input orientation we define the directional vector joining the firm under evaluation and its projection as follows   

+ If $\left( {{\textbf{x}}_{j}},{{\textbf{y}}_{j}} \right)\in {{F}_{J\sim E}}$, define 

$\left({\textbf{g}^{-}_{\textbf{x}_{j}}},{\textbf{g}^{+}_{\textbf{y}_{j}}} \right)=\left( \frac{{{{\hat{\textbf{x}}}}_{j}} -{{\textbf{x}}_{j}}}{T{{I}_{EM\left( I \right)}}\left( {{\textbf{x}}_{j}},{{\textbf{y}}_{j}} \right)},\textbf{0}_M \right) \, \, and \, \,\beta_{RDDF(I)}^{*}=T{{I}_{E{{M}(I)}}}\left( {{\textbf{x}}_{j}},{{\textbf{y}}_{j}} \right)>0.$

+ If $\left( {{\textbf{x}}_{j}},{{\textbf{y}}_{j}} \right)\in {{F}_{E}}$, define 

$\beta _{RDDF(I)}^{*}=T{{I}_{EM\left( I \right)}}\left( {{\textbf{x}}_{j}},{{\textbf{y}^+}_{j}} \right)=0 \, \, and \, \,\left( {\textbf{g}^{-}_{\textbf{x}_{j}}}, \textbf{0}_M \right)= \left({{{\vec{\textbf{k}}}}_{jM}},\textbf{0}_N \right)\,\in \mathbb{R}_{++}^{M+N},$  

where ${{\vec{\textbf{k}}}_{jM}}\in \mathbb{R}_{++}^{M}$ is a vector whose units of measurement are identical to those of the firm under evaluation $\left( {{\textbf{x}}_{j}},{{\textbf{y}}_{j}} \right)\in {{F}_{E}}$--making cost inefficiency units' invariant. For consistency we search for a value that yields a normalization factor whose value is equal to that associated to the underlying efficiency measure, i.e, $\sum\limits_{m=1}^{M}{w_{m}^{{}}k_{jm}^{-}}= NF_{EM(I)}$. This choice of ${{\vec{\textbf{k}}}_{jM}}$ is numerically relevant because it makes the values of normalized cost inefficiency based on the $RDDF$ and the original $EM(I)$ equivalent, and therefore their normalized allocative efficiencies can be compared to each other--their technical inefficiency values being null. 

We now present the expression corresponding to the cost inefficiency measure and its decomposition associated with the $RDDF$. This results in $C{{I}_{{RDDF\left( EM\left( I \right),{{F}_{J}},{{{\hat{F}}}_{J}} \right)}}}\left( {{\textbf{x}}_{o}},{{\textbf{y}}_{o}},\mathbf{g_{x}^-},{\tilde{\textbf{w}}} \right)$ = $T{{I}_{{RDDF\left( EM\left( I \right),{{F}_{J}},{{{\hat{F}}}_{J}} \right)}}}\left( {{\textbf{x}}_{o}},{{\textbf{y}}_{o},\mathbf{g_{x}^-}} \right)$ + $A{{I}_{RDDF\left( EM\left( I \right),{{F}_{J}},{{{\hat{F}}}_{J}} \right)}}\left( {{\textbf{x}}_{o}},{{\textbf{y}}_{o}},\mathbf{g_{x}^-}, {\tilde{\textbf{w}}} \right)$. Hence we obtain the following expressions: 

```math
\underbrace{\frac{\sum\limits_{m=1}^{M}{{{w}_{m}}{{x}_{om}}}-C\left( \textbf{w},{{\textbf{y}}_{o}} \right)}{\sum\limits_{m=1}^{M}{{{w}_{m}}{{g}^{-}_{om}}}}}_{\text{Norm. Cost Inefficiency}}=\underbrace{\beta _{RDDF\left( EM\left( I \right),{{F}_{J}},{{{\hat{F}}}_{J}} \right)}^{*}}_{\text{Input Technical Inefficiency}}+\underbrace{A{{I}_{RDDF\left( EM\left( I \right),{{F}_{J}},{{{\hat{F}}}_{J}} \right)}\left( {{\textbf{x}}_{o}},{{\textbf{y}}_{o}},\textbf{g}_{{{\textbf{x}}_{o}}}^{{-}}, \tilde{\textbf{w}} \right)}}_{\text{Norm. Allocative Inefficiency}}\ge 0,
```
where the efficiency score $\beta _{RDDF\left( EM\left( I \right),{{F}_{J}},{{{\hat{F}}}_{J}} \right)}^{*}$ for technically inefficient firms is obtained by solving the [Input-oriented Directional Distance Function model](https://javierbarbero.github.io/DataEnvelopmentAnalysis.jl/stable/technical/directional/) with the corresponding directional vector. 

**BenchmarkingEconomicEfficiency.jl** offers the possibility of decomposing cost inefficiency based on the $RDDF$ considering as original measure the [Russell input-oriented model](https://javierbarbero.github.io/DataEnvelopmentAnalysis.jl/stable/technical/russell/#Russell-Input-Model). 

**Reference**

Chapter 12 in Pastor, J.T., Aparicio, J. and Zofío, J.L. (2022) Benchmarking Economic Efficiency: Technical and Allocative Fundamentals, International Series in Operations Research and Management Science, Vol. 315,  Springer, Cham. 

**Example**

In this example we compute the cost efficiency Reverse directional distance function measure for the Russell technical inefficiency:
```@example costrddf
using BenchmarkingEconomicEfficiency

X = [2 2; 1 4; 4 1; 4 3; 5 5; 6 1; 2 5; 1.6 8];

Y = [1; 1; 1; 1; 1; 1; 1; 1];

W = [1 1; 1 1; 1 1; 1 1; 1 1; 1 1; 1 1; 1 1];

costrddf = deacostrddf(X, Y, W, :ERG)
```

Estimated economic, technical and allocative efficiency scores are returned with the `efficiency` function:
```@example costrddf
efficiency(costrddf, :Economic)
```

```@example costrddf
efficiency(costrddf, :Technical)
```

```@example costrddf
efficiency(costrddf, :Allocative)
```

### deacostrddf Function Documentation

```@docs
deacostrddf
```

