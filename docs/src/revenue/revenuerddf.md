```@meta
CurrentModule = BenchmarkingEconomicEfficiency
DocTestSetup = quote
    using BenchmarkingEconomicEfficiency
end
```

# Revenue Reverse Directional Distance Function model

The cost reverse directional distance function model is computed by solving an input-oriented [Reverse *DDF* model](https://javierbarbero.github.io/DataEnvelopmentAnalysis.jl/stable/technical/reverseddf/) for the technical inefficiency.

As their graph counterpart presented in the [Profit Reverse Directional Distance Function model](@ref), the output-oriented $RDDF$ transforms any additive measure of output technical inefficiency, $EM(O)$, such as [the Russell output measure](https://javierbarbero.github.io/DataEnvelopmentAnalysis.jl/stable/technical/russell/#Russell-Output-Model), into a single scalar measure corresponding to an output-oriented $DDF$, $\beta_O$. Therefore, given the set of $J$ firms under study, ${F}_{J}$, and their projections on the frontier, denoted by ${\hat{F}_{J}}$, the $RDDF$ assigns a new $DDF$ score to the original $EM(O)$, while keeping the same projections ${\hat{F}_{J}}$. We  denote this score by $\beta_{RDDF(EM(O), F_J, \hat{F}_{J})}$. The advantage of the *RDDF* is that it relates the additive and multiplicative measures of technical inefficiency because the ouput-oriented *DDFs* is equivalent to the Farrell's output radial measures shown in the [Revenue Radial model](@ref), i.e., $\beta_O^{*}=\phi^*-1$. 
 
To calculate this distance functions for firm $\left( {{\mathbf{x}_o,\mathbf{y}_{o}}} \right)$ we need to determine the directional vector $\mathbf{g}= ({\textbf{0}_N},{\mathbf{g_{x}^+}})$ connecting the firm to its output-oriented projection, $\left( {{{\textbf{x}}}_{o}},{{{\hat{\textbf{y}}}}_{o}} \right)\in {{\hat{F}}_{J}}$. Afterwards we calculate the value of the $RDDF(O)$. However, when calculating the new scores we need to differentiate between firms that are deemed technically efficient with $EM(O)=0$ and those that are technically inefficient. The measure $EM(O)$ splits the sample into two disjoint subsets: ${{F}_{E}}=\left\{ \left( {{x}_{j}},{{y}_{j}} \right)\in {{F}_{J}}:T{{I}_{E{{M(O)}}}}\left( {{x}_{j}},{{y}_{j}} \right)=0 \right\}$ and ${{F}_{J\sim E}}=\left\{ \left( {{x}_{j}},{{y}_{j}} \right)\in {{F}_{J}}:T{{I}_{E{{M(O)}}}}\left( {{x}_{j}},{{y}_{j}} \right)>0 \right\}$. Then, for the output orientation we define the directional vector joining the firm under evaluation and its projection as follows   

+ If $\left( {{\textbf{x}}_{j}},{{\textbf{y}}_{j}} \right)\in {{F}_{J\sim E}}$, define 
	
$\left({\textbf{g}^{-}_{\textbf{x}_{j}}},{\textbf{g}^{+}_{\textbf{y}_{j}}} \right)= \left( \textbf{0}_M,  \frac{{{{\mathbf{\hat{y}}}}_{j}}-{{\mathbf{y}}_{j}}}{T{{I}_{EM\left( G \right)}}\left( {{\mathbf{x}}_{j}},{{\mathbf{y}}_{j}} \right)} \right) \, \,  and \, \,\beta_{RDDF(O)}^{*}=T{{I}_{E{{M}(O)}}}\left( {{\textbf{x}}_{j}},{{\textbf{y}}_{j}} \right)>0.$
	
+ If $\left( {{\textbf{x}}_{j}},{{\textbf{y}}_{j}} \right)\in {{F}_{E}}$, define 
	
$\beta _{RDDF(I)}^{*}=T{{I}_{EM\left( O \right)}}\left( {{\textbf{x}}_{j}},{{\textbf{y}}_{j}} \right)=0 \, \, and \, \,\left( \textbf{0}_N, {\textbf{g}^{+}_{\textbf{y}_{j}}} \right)= \left(\textbf{0}_M,{{{\vec{\textbf{k}}}}_{jN}} \right)\,\in \mathbb{R}_{++}^{M+N},$  

where ${{\vec{\textbf{k}}}_{jN}}\in \mathbb{R}_{++}^{N}$ is a vector whose units of measurement are identical to those of the firm under evaluation $\left( {{\textbf{x}}_{j}},{{\textbf{y}}_{j}} \right)\in {{F}_{E}}$--making revenue inefficiency units' invariant. For consistency we search for a value that yields a normalization factor whose value is equal to that associated to the underlying efficiency measure, i.e, $\sum\limits_{n=1}^{N}{p_{n}^{{}}k_{jn}^{+}}= NF_{EM(O)}$. This choice of ${{\vec{\textbf{k}}}_{jN}}$ is numerically relevant because it makes the values of normalized cost inefficiency based on the $RDDF$ and the original $EM(O)$ equivalent, and therefore their normalized allocative efficiencies can be compared to each other--their technical inefficiency values being null. 

We now present the expressions corresponding to the revenue inefficiency measure and its decomposition associated with the $RDDF$. This results in $R{{I}_{{RDDF\left( EM\left( O \right),{{F}_{J}},{{{\hat{F}}}_{J}} \right)}}}\left( {{\textbf{x}}_{o}},{{\textbf{y}}_{o}},\mathbf{g_{y}^+},{\tilde{\textbf{p}}} \right)$ = $T{{I}_{{RDDF\left( EM\left( O \right),{{F}_{J}},{{{\hat{F}}}_{J}} \right)}}}\left( {{\textbf{x}}_{o}},{{\textbf{y}}_{o},\mathbf{g_{y}^+}} \right)$ + $A{{I}_{RDDF\left( EM\left( O \right),{{F}_{J}},{{{\hat{F}}}_{J}} \right)}}\left( {{\textbf{x}}_{o}},{{\textbf{y}}_{o}},\mathbf{g_{y}^+}, {\tilde{\textbf{p}}} \right)$. Hence we obtain the following expression: 

```math
\underbrace{\frac{R \left( \mathbf{x}_o,\mathbf{p} \right) - \sum\limits_{n=1}^{N}{{{p}_{n}}{{y}_{om}}} }{\sum\limits_{n=1}^{N}{{{p}_{n}}{{g}^{-}_{on}}}}}_{\text{Norm. Revenue Inefficiency}}=\underbrace{\beta _{RDDF\left( EM\left( O \right),{{F}_{J}},{{{\hat{F}}}_{J}} \right)}^{*}}_{\text{Output Technical Inefficiency}}+\underbrace{A{{I}_{RDDF\left( EM\left( O \right),{{F}_{J}},{{{\hat{F}}}_{J}} \right)}\left( {{\textbf{x}}_{o}},{{\textbf{y}}_{o}},\textbf{g}_{{{\textbf{y}}_{o}}}^{{+}}, \tilde{\textbf{p}} \right)}}_{\text{Norm. Allocative Inefficiency}} \ge 0,
```

where the efficiency scores $\beta _{RDDF\left( EM\left( O \right),{{F}_{J}},{{{\hat{F}}}_{J}} \right)}^{*}$ for technically inefficient firms is obtained by solving the [Output-oriented Directional Distance Function model](https://javierbarbero.github.io/DataEnvelopmentAnalysis.jl/stable/technical/directional/) with the corresponding directional vectors. . 

**Benchmarking Economic Efficiency** with *Julia* offers the possibility of decomposing revenue inefficiency based on the $RDDF$ considering as original measure the [Russell output-oriented model](https://javierbarbero.github.io/DataEnvelopmentAnalysis.jl/stable/technical/russell/#Russell-Output-Model). 

**Reference**

Chapter 12 in Pastor, J.T., Aparicio, J. and Zofío, J.L. (2022) Benchmarking Economic Efficiency: Technical and Allocative Fundamentals, International Series in Operations Research and Management Science, Vol. 315,  Springer, Cham. 

**Example**

In this example we compute the revenue efficiency Reverse directional distance function measure for the Russell technical inefficiency:
```jldoctest 1
julia> X = [1; 1; 1; 1; 1; 1; 1; 1];

julia> Y = [7 7; 4 8; 8 4; 3 5; 3 3; 8 2; 6 4; 1.5 5];

julia> P = [1 1; 1 1; 1 1; 1 1; 1 1; 1 1; 1 1; 1 1];

julia> revenuerddf = dearevenuerddf(X, Y, P, :ERG)
Revenue Reverse DDF DEA Model 
DMUs = 8; Inputs = 1; Outputs = 2
Returns to Scale: VRS
Associated efficiency measure = ERG
────────────────────────────────────
    Revenue  Technical    Allocative
────────────────────────────────────
1  0.0        0.0        0.0
2  0.25       0.0        0.25
3  0.25       0.0        0.25
4  0.464286   0.464286   0.0
5  0.571429   0.571429   0.0
6  0.666667   0.333333   0.333333
7  0.314286   0.314286  -5.55112e-17
8  0.818182   0.672727   0.145455
────────────────────────────────────
```

Estimated economic, technical and allocative efficiency scores are returned with the `efficiency` function:
```jldoctest 1
julia> efficiency(revenuerddf, :Economic)
8-element Vector{Float64}:
 0.0
 0.25
 0.25
 0.4642857142857143
 0.5714285714285715
 0.6666666666666667
 0.3142857142857144
 0.8181818181818182
```
```jldoctest 1
julia> efficiency(revenuerddf, :Technical)
8-element Vector{Float64}:
 0.0
 0.0
 0.0
 0.4642857142857143
 0.5714285714285715
 0.33333333333333337
 0.31428571428571445
 0.6727272727272727
```
```jldoctest 1
julia> efficiency(revenuerddf, :Allocative)
8-element Vector{Float64}:
  0.0
  0.25
  0.25
  0.0
  0.0
  0.33333333333333337
 -5.551115123125783e-17
  0.1454545454545455
```

### dearevenuerddf Function Documentation

```@docs
dearevenuerddf
```

