```@meta
CurrentModule = BenchmarkingEconomicEfficiency
```

# Profit Reverse Directional Distance Function model

The profit reverse directional distance function model is computed by solving a graph [Reverse *DDF* model](https://javierbarbero.github.io/DataEnvelopmentAnalysis.jl/stable/technical/reverseddf/) for the technical inefficiency.

The advantage of decomposing profit inefficiency with the $RDDF$ is that it relates existing additive measures of technical inefficiency to the popular directional distance function, $DDF$. The $RDDF$ is capable of transforming any additive measure of graph technical inefficiency, $EM(G)$, such as the [Enhanced Russell Graph](https://javierbarbero.github.io/DataEnvelopmentAnalysis.jl/stable/technical/enhancedrussell/)  or the [Modified Directional Distance Function](https://javierbarbero.github.io/DataEnvelopmentAnalysis.jl/stable/technical/modifiedddf/), into a single scalar measure corresponding to a standard $DDF$. Therefore, given the set of $J$ firms under study, ${F}_{J}$, and their projections on the frontier, denoted by ${\hat{F}_{J}}$, the $RDDF$ assigns a new $DDF$ score $\beta$ to the original $EM(G)$, compatible with the projections ${\hat{F}_{J}}$. 

To calculate the $RDDF\left( EM\left( G \right),{{F}_{J}},{{{\hat{F}}}_{J}} \right)$ for firm $\left( {{\mathbf{x}_o,\mathbf{y}_{o}}} \right)$ we need to determine the directional vector $\mathbf{g}= ({{\mathbf{g_{x}^-},\textbf{g}_\textbf{y}^+}})$ connecting the firm to its projection, $\left( {{{\hat{\textbf{x}}}}_{o}},{{{\hat{\textbf{y}}}}_{o}} \right)\in {{\hat{F}}_{J}}$. Afterwards we calculate the value of the $RDDF$. However, when calculating the new $RDDF$ scores we need to differentiate between firms that are deemed technically efficient under $EM(G)$ and those that are technically inefficient. The measure $EM(G)$ splits the sample of firms ${{F}_{J}}$ into two disjoint subsets: ${{F}_{E}}=\left\{ \left( {{\textbf{x}}_{j}},{{\textbf{y}}_{j}} \right)\in {{F}_{J}}:T{{I}_{E{{M(G)}}}}\left( {{\textbf{x}}_{j}},{{\textbf{y}}_{j}} \right)=0 \right\}$ and ${{F}_{J\sim E}}=\left\{ \left( {{\textbf{x}}_{j}},{{\textbf{y}}_{j}} \right)\in {{F}_{J}}:T{{I}_{E{{M(G)}}}}\left( {{x\textbf{}}_{j}},{{\textbf{y}}_{j}} \right)>0 \right\}$. Then, 


+ If $\left( {{\textbf{x}}_{j}},{{\textbf{y}}_{j}} \right)\in {{F}_{J\sim E}}$, define 
	

$\left( {{\textbf{g}}_{{{\textbf{x}}_{j}}}},{{\textbf{g}}_{{{\textbf{y}}_{j}}}} \right)= \left( \frac{ {{{\hat{\textbf{x}}}}_{j}}-{{\textbf{x}}_{j}} }{T{{I}_{EM\left( G \right)}}\left( {{\textbf{x}}_{j}},{{\textbf{y}}_{j}} \right)},  \frac{{{{\mathbf{\hat{y}}}}_{j}}-{{\mathbf{y}}_{j}}}{T{{I}_{EM\left( G \right)}}\left( {{\mathbf{x}}_{j}},{{\mathbf{y}}_{j}} \right)} \right), \, and \, \, \beta_{RDDF(G)}^{*}=T{{I}_{E{{M}(G)}}}\left( {{\textbf{x}}_{j}},{{\textbf{y}}_{j}} \right)>0.$


+ If $\left( {{\textbf{x}}_{j}},{{\textbf{y}}_{j}} \right)\in {{F}_{E}}$, define 
	
$\beta _{j}^{*}=T{{I}_{EM\left( I \right)}}\left( {{\textbf{x}}_{j}},{{\textbf{y}}_{j}} \right)=0, \, and \, \, \left( {{\textbf{g}}_{{{\textbf{x}}_{j}}}},{{\textbf{g}}_{{{\textbf{y}}_{j}}}} \right)= \left( {{{\vec{\textbf{k}}}}_{jM}},{{{\vec{\textbf{k}}}}_{jN}} \right)\,\in \mathbb{R}_{++}^{M+N},$
	
where ${{\vec{\textbf{k}}}_{jM}}\in \mathbb{R}_{++}^{M}$ and ${{\vec{\textbf{k}}}_{jN}}\in \mathbb{R}_{++}^{N}$ are vectors whose $M$ and $N$ components have the same units of measuremenet that $\left( {{\textbf{x}}_{j}},{{\textbf{y}}_{j}} \right)$--making profit inefficiency units' invariant. For consistency we search for a combination that yields a normalization factor for profit inefficiency whose value is equal to that associated to the underlying efficiency measure, i.e, $\sum\limits_{m=1}^{M}{w_{m}^{{}}k_{om}^{-}}+\sum\limits_{n=1}^{N}{p_{n}^{{}}k_{on}^{+}} = NF_{EM(G)}$. This choice of ${{\textbf{k}}_{j}}$  is numerically relevant because it makes the values of the normalized profit inefficiency based on the $RDDF$ and that of the original $EM(G)$ equal, and therefore their normalized allocative efficiencies can be compared to each other---their technical inefficiency values being null.    

We now present the expression corresponding to the profit inefficiency measure and its decomposition associated with the $RDDF$. From the [Profit Directional Distance Function model](@ref) , we know how to gauge and decompose profit inefficiency through the directional distance function. This results in $\Pi{{I}_{{RDDF\left( EM\left( G \right),{{F}_{J}},{{{\hat{F}}}_{J}} \right)}}}\left( {{\textbf{x}}_{o}},{{\textbf{y}}_{o}},\mathbf{g_{x}^-}, \mathbf{g_{y}^+}, \tilde{{\textbf{w}}}, \tilde{{\textbf{p}}}  \right)$ = $T{{I}_{{RDDF\left( EM\left( I \right),{{F}_{J}},{{{\hat{F}}}_{J}} \right)}}}\left( {{\textbf{x}}_{o}},{{\textbf{y}}_{o},\mathbf{g_{x}^-}},\mathbf{g_{y}^+} \right)$ + $A{{I}_{RDDF\left( EM\left( G \right),{{F}_{J}},{{{\hat{F}}}_{J}} \right)}}\left( {{\textbf{x}}_{o}},{{\textbf{y}}_{o}},\mathbf{g_{x}^-},\mathbf{g_{y}^+}, \tilde{{\textbf{w}}}, \tilde{{\textbf{p}}} \right)$; i.e., 

```math
\begin{split}
& \underbrace{\frac{\Pi \left( \mathbf{w},\mathbf{p} \right)-\left( \sum\limits_{n=1}^{N}{{{p}_{n}}{{y}_{on}}}-\sum\limits_{m=1}^{M}{{{w}_{m}}{{x}_{om}}} \right)}{\sum\limits_{m=1}^{M}{w_{m}^{{}}g_{om}^{-}}+\sum\limits_{n=1}^{N}{p_{n}^{{}}g_{on}^{+}}}}_{\text{Norm}\text{. Profit Inefficiency}}= \\ 
& \quad =\underbrace{\beta _{RDDF\left( EM\left( G \right),{{F}_{J}},{{{\hat{F}}}_{J}} \right)}^{*}}_{\text{Graph Technical Inefficiency}}+\ \,\underbrace{A{{I}_{RDDF\left( EM\left( G \right),{{F}_{J}},{{{\hat{F}}}_{J}} \right)}}\left( {{\mathbf{x}}_{o}},{{\mathbf{y}}_{o}},\mathbf{g}_{\mathbf{x}}^{\mathbf{-}},\mathbf{g}_{\mathbf{y}}^{+},\mathbf{\tilde{w}},\mathbf{\tilde{p}} \right)}_{\text{Norm}\text{. Allocative Inefficiency}} \ge 0.  
\end{split} 
```

where the efficiency score $\beta _{RDDF\left( EM\left( G \right),{{F}_{J}},{{{\hat{F}}}_{J}} \right)}^{*}$ for technically inefficient firms is obtained by solving the $DDF$ program with the associated directional vectors.  

**BenchmarkingEconomicEfficiency.jl** offers the possibility of decomposing profit inefficiency based on the $RDDF$ considering as original $EM(G)$ measure the [enhanced Russell graph measure](https://javierbarbero.github.io/DataEnvelopmentAnalysis.jl/stable/technical/enhancedrussell/). 

**Reference**

Chapter 12 in Pastor, J.T., Aparicio, J. and Zofío, J.L. (2022) Benchmarking Economic Efficiency: Technical and Allocative Fundamentals, International Series in Operations Research and Management Science, Vol. 315,  Springer, Cham. 


**Example**

In this example we compute the profit efficiency Reverse directional distance function measure for the Enhanced Russell Graph associated efficiency measure under variable returns to scale:
```@example profitrddf
using BenchmarkingEconomicEfficiency

X = [2; 4; 8; 12; 6; 14; 14; 9.412];

Y = [1; 5; 8; 9; 3; 7; 9; 2.353];

W = [1; 1; 1; 1; 1; 1; 1; 1];

P = [2; 2; 2; 2; 2; 2; 2; 2];

profitrddf = deaprofitrddf(X, Y, W, P, :ERG)
```

Estimated economic, technical and allocative efficiency scores are returned with the `efficiency` function:
```@example profitrddf
efficiency(profitrddf, :Economic)
```

```@example profitrddf
efficiency(profitrddf, :Technical)
```

```@example profitrddf
efficiency(profitrddf, :Allocative)
```

### deaprofitrddf Function Documentation

```@docs
deaprofitrddf
```

