```@meta
CurrentModule = BenchmarkingEconomicEfficiency
DocTestSetup = quote
    using BenchmarkingEconomicEfficiency
end
```
# Profit General Direct Approach model

The generalized direct approach, *GDA*, is introduced by Pastor, Aparicio and Zofío (2022, Ch. 13). Contrary to the standard approach that relies on duality theory to obtain a suitable Fenchel-Mahler inequality from which allocative efficiency is recovered as a residual--see [Profit Efficiency measurement](@ref), the *GDA* establishes an economic efficiency decomposition valid for any technical efficiency measure, $EM(G)$, by considering the same single equality each time. For any firm $\left( \textbf{x}_o,\textbf{y}_o\right)$ and for an already selected $EM(G)$ we just need to know two pieces of information, its technical inefficiency $T{{I}_{EM (G)}}\left( \textbf{x}_o,\textbf{y}_o \right)$ and its associated frontier projection $\left( {{{\hat{\textbf{x}}}}_{oEM(G)}},{{{\hat{\textbf{y}}}}_{oEM(G)}} \right)$. The $GDA$, providing a unifying framework for decomposing economic inefficiency, follows similar steps as the traditional approach but is easier to develop and implement since it does not rely on duality theory. It is *general*, because it can be applied to any efficiency measure; *easier* to implement, because it does not require to search for Fenchel-Mahler inequalities (although the underlying duality holds); and more *reliable*, because working with equalities instead of inequalities (and their associated normalization factors) avoids the possibility of overestimating allocative inefficiency as several traditional approaches do when failing to satisfy the essential property.

The novelty of the proposal is that it breaks up profit inefficiency of firm $\left( \textbf{x}_{o}^{{}},\textbf{y}_{o}^{{}} \right)$ into the sum of two components. The first component is the interior product of two vectors, the optimal slack vector $\left( \textbf{s}_{oEM(G)}^{-*},\textbf{s}_{oEM(G)}^{+*} \right)= \left( {{\textbf{x}}_{o}}-{{{\hat{\textbf{x}}}}_{oEM(G)}},{{{\hat{\textbf{y}}}}_{oEM(G)}}-{{\textbf{y}}_{o}} \right)$--corresponding to $L_1$-path between the firm under evaluation and its projection, and the market price vector $\left( \textbf{w},\textbf{p} \right)$; i.e. $\mathbf{p}\cdot \mathbf{s}_{oEM(G)}^{+*}+\mathbf{w}\cdot \mathbf{s}_{oEM(G)}^{-*}$. The second component corresponds to the profit inefficiency at the projection $\left( {{{\hat{\textbf{x}}}}_{oEM(G)}},{{{\hat{\textbf{y}}}}_{oEM(G)}} \right)$. Both components have the intuitive technical and allocative interpretations. This results in the following decomposition:

```math
\begin{split}
& \Pi I\left( {{\mathbf{x}}_{o}},{{\mathbf{y}}_{o}},\mathbf{w},\mathbf{p} \right)=\Pi \left( \mathbf{w},\mathbf{p} \right)-{{\Pi }_{o}}=\Pi \left( \mathbf{w},\mathbf{p} \right)-\left( \mathbf{p}\cdot \mathbf{y}_{o}^{{}}-\mathbf{w}\cdot \mathbf{x}_{o}^{{}} \right) = \\ 
& \left( \mathbf{p}\cdot \mathbf{s}_{oEM(G)}^{+*}+\mathbf{w}\cdot \mathbf{s}_{oEM(G)}^{-*} \right)+\left( \Pi \left( \mathbf{w},\mathbf{p} \right)-\left( \mathbf{p}\cdot \mathbf{\hat{y}}_{oEM(G)}^{{}}-\mathbf{w}\cdot \mathbf{\hat{x}}_{oEM(G)}^{{}} \right) \right)= \\ 
& \underbrace{\left( \mathbf{p}\cdot \mathbf{s}_{oEM(G)}^{+*}+\mathbf{w}\cdot \mathbf{s}_{oEM(G)}^{-*} \right)}_{\text{Profit}\ \text{Technological}\ \text{Gap }}+\underbrace{\Pi\left({{{\mathbf{\hat{x}}}}_{oEM(G)}},{{{\mathbf{\hat{y}}}}_{oEM(G)}},\mathbf{w},\mathbf{p}\right)}_{\text{Profit Allocative Inefficiency}}.   
\end{split}
```

Last equality shows that profit inefficiency, expressed in monetary terms, can be decomposed into the the profit loss due to the technological gap between the firm and its projection, which we term *profit technological gap* plus the profit inefficiency of its projected benchmark under the given efficiency measure $EM(G)$, representing *profit allocative inefficiency*. The above expression represents the first step to develop the $GDA$ approach. The second step requires relating the profit technological gap, $\left( \mathbf{p}\cdot \mathbf{s}_{oEM(G)}^{+*}+\mathbf{w}\cdot \mathbf{s}_{oEM(G)}^{-*} \right)$, with the technical inefficiency measure $T{{I}_{EM(G)}}\left( {{\textbf{x}}_{o}},{{\textbf{y}}_{o}} \right)$ already calculated. The following expression modifies the previous one and shows this relationship:  

```math
\begin{split}
& \underbrace{\Pi \left( \mathbf{w},\mathbf{p} \right)-\left( \sum\limits_{n=1}^{N}{{{p}_{n}}{{y}_{on}}}-\sum\limits_{m=1}^{M}{{{w}_{m}}{{x}_{om}}} \right)}_{\text{Monetary Profit Inefficiency}}=  \\ 
&  =\underbrace{\left( \frac{\mathbf{p}\cdot \mathbf{s}_{oEM}^{+*}+\mathbf{w}\cdot \mathbf{s}_{oEM}^{-*}}{T{{I}_{EM(G)}}\left( \mathbf{x}_{o}^{{}},\mathbf{y}_{o}^{{}} \right)} \right)\times T{{I}_{EM(G)}}\left( \mathbf{x}_{o}^{{}},\mathbf{y}_{o}^{{}} \right)}_{\text{Monetary Technical Inefficiency}}+\underbrace{A{{I}_{GDA(G)}}\left( {{\mathbf{x}}_{o}},{{\mathbf{y}}_{o}},\mathbf{w},\mathbf{p} \right)}_{\text{Monetary Allocative Inefficiency}} \ge 0.  
\end{split}
```

Therefore, the profit loss associated with the profit technological gap can be decomposed into the technical inefficiency of the firm itself, $\left( \mathbf{x}_{o}^{{}},\mathbf{y}_{o}^{{}} \right)$, times a normalizing factor $N{{F}_{EM(G)}}\left( {{\textbf{x}}_{o}},{{\textbf{y}}_{o}}, \mathbf{\tilde{w}},\mathbf{\tilde{p}} \right)$ that captures the profit loss per unit of technical inefficiency--the normalizing factor being equal to the profit technological gap divided by the technical inefficiency measure. This correspond to the technical profit inefficiency of the firm and, consequently, the remaining profit inefficiency captured in the second term, which is the difference between overall profit inefficiency and technical profit inefficiency, effectively corresponds to the allocative profit inefficiency of the firm $\left( \mathbf{x}_{o}^{{}},\mathbf{y}_{o}^{{}} \right)$. As already shown, this last inefficiency is equivalent to the profit inefficiency at its projection $\left( {{{\mathbf{\hat{x}}}}_{oEM(G)}},{{{\mathbf{\hat{y}}}}_{oEM(G)}} \right)$.

The final step consists in characterizing the normalizing factor $N{{F}_{EM(G)}}\left( {{\textbf{x}}_{o}},{{\textbf{y}}_{o}},\mathbf{\tilde{w}},\mathbf{\tilde{p}} \right)$, which allows us to define a measure of normalized profit inefficiency that is, as the previous ones, units' invariant. For this purpose we differentiate if the firm under evaluation is technically inefficient: $T{{I}_{EM(G)}}\left( {{\textbf{x}}_{o}},{{\textbf{y}}_{o}} \right)>0$, with $\left( {{\mathbf{x}}_{o}},{{\mathbf{y}}_{o}} \right)\ne \left( \mathbf{\hat{x}}_{oEM(G)}^{{}},\mathbf{\hat{y}}_{oEM(G)}^{{}} \right)$, or technically efficient: $T{{I}_{EM(G)}}\left( {{\textbf{x}}_{o}},{{\textbf{y}}_{o}} \right) = 0$, with $\left( {{\mathbf{x}}_{o}},{{\mathbf{y}}_{o}} \right) = \left( \mathbf{\hat{x}}_{oEM(G)}^{{}},\mathbf{\hat{y}}_{oEM(G)}^{{}} \right)$. Hence, we define

```math
NF_{EM(G)}^{GDA}\left( \mathbf{x}_{o}^{{}},\mathbf{y}_{o}^{{}},\mathbf{w},\mathbf{p} \right)=\left\{ 
\begin{split}
& \frac{\left( \mathbf{p}\cdot \mathbf{s}_{EM(G)}^{+*}+\mathbf{w}\cdot \mathbf{s}_{EM}^{-*} \right)}{T{{I}_{EM(G)}}\left( \mathbf{x}_{o}^{{}},\mathbf{y}_{o}^{{}} \right)},\,\,\left( {{\mathbf{x}}_{o}},{{\mathbf{y}}_{o}} \right)\ne \left( \mathbf{\hat{x}}_{oEM(G)}^{{}},\mathbf{\hat{y}}_{oEM(G)}^{{}} \right) \\ 
& \,\,\,\,\,\,\,\,{{k}_{o\$}}\,,\,\,{{k}_{o}}>0\,,\,\,\,\,\,\,\,\,\left({{\mathbf{x}}_{o}},{{\mathbf{y}}_{o}}\right)=\left(\mathbf{\hat{x}}_{oEM(G)}^{{}},\mathbf{\hat{y}}_{oEM(G)}^{{}}\right)\\
\end{split}
\right\}
```

where the dollar-valued $k_{o}$ is a normalization factor for technically efficient firms that, being expressed in the same monetary units, simply translates a null technical efficiency score into the same currency values. With this qualification in mind we can introduce the normalized version of the general direct approach and its associated decomposition: $\Pi{{I}_{GDA\left( G \right)}}\left( {{\textbf{x}}_{o}},{{\textbf{y}}_{o}},{\tilde{\textbf{w}}}, \tilde{{\textbf{p}}} \right)$ = $T{{I}_{GDA\left( G \right)}}\left( {{\textbf{x}}_{o}},{{\textbf{y}}_{o}} \right)$ +  $A{{I}_{GDA\left( G \right)}}\left( {{\textbf{x}}_{o}},{{\textbf{y}}_{o}}, {\tilde{\textbf{w}}}, \tilde{{\textbf{p}}} \right)$. This results in the following expression: 

```math
\begin{split}
& \underbrace{\frac{\Pi \left( \mathbf{w},\mathbf{p} \right)-\left( \sum\limits_{n=1}^{N}{{{p}_{n}}{{y}_{on}}}-\sum\limits_{m=1}^{M}{{{w}_{m}}{{x}_{om}}} \right)}{NF_{EM(G)}^{GDA}\left( \mathbf{x}_{o}^{{}},\mathbf{y}_{o}^{{}},\mathbf{w},\mathbf{p} \right)}}_{\text{Norm}\text{. Profit Inefficiency}}= \\ 
& \quad =\underbrace{T{{I}_{EM(G)}}\left( \mathbf{x}_{o}^{{}},\mathbf{y}_{o}^{{}} \right)}_{\text{Graph Technical Inefficiency}}+ \underbrace{A{{I}_{GDA(G)}}\left( {{\mathbf{x}}_{o}},{{\mathbf{y}}_{o}},\mathbf{\tilde{w}},\mathbf{\tilde{p}} \right)}_{\text{Norm}\text{. Allocative Inefficiency}} \ge 0.  
\end{split}
```  
where the last term represents normalized allocative inefficiency: $A{{I}_{GDA(G)}}\left( {{\mathbf{x}}_{o}},{{\mathbf{y}}_{o}},\mathbf{\tilde{w}},\mathbf{\tilde{p}} \right) = A{{I}_{GDA(G)}}\left( {{\mathbf{x}}_{o}},{{\mathbf{y}}_{o}},\mathbf{w},\mathbf{p} \right) / NF_{EM(G)}^{GDA}\left(\mathbf{x}_{o}^{{}},\mathbf{y}_{o}^{{}},\mathbf{w},\mathbf{p} \right)$ 

**Benchmarking Economic Efficiency** with *Julia* implements the profit inefficiency decomposition associated with the general direct approach considering the [Enhanced Russell graph model](https://javierbarbero.github.io/DataEnvelopmentAnalysis.jl/stable/technical/enhancedrussell/). The decomposition can be calculated both in normalized terms, and monetary terms. For this last option one needs to add `monetary=true` to the syntax--see the documentation below accompanying this function.  

**Reference**

Chapter 13 in Pastor, J.T., Aparicio, J. and Zofío, J.L. (2022) Benchmarking Economic Efficiency: Technical and Allocative Fundamentals, International Series in Operations Research and Management Science, Vol. 315,  Springer, Cham. 

**Example**

In this example we compute the profit efficiency General Direct Approach measure for the enhanced Russell graph associated efficiency measure:
```jldoctest 1
julia> X = [2; 4; 8; 12; 6; 14; 14; 9.412];

julia> Y = [1; 5; 8; 9; 3; 7; 9; 2.353];

julia> W = [1; 1; 1; 1; 1; 1; 1; 1];

julia> P = [2; 2; 2; 2; 2; 2; 2; 2];

julia> profitgda = deaprofitgda(X, Y, W, P, :ERG)
General Direct Approach Profit DEA Model 
DMUs = 8; Inputs = 1; Outputs = 1
Returns to Scale = VRS
Associated efficiency measure = ERG
──────────────────────────────────
     Profit  Technical  Allocative
──────────────────────────────────
1  4.0        0.0         4.0
2  0.5        0.0         0.5
3  0.0        0.0         0.0
4  0.166667   0.0         0.166667
5  0.8        0.6         0.2
6  0.571429   0.52381     0.047619
7  0.285714   0.142857    0.142857
8  0.949449   0.8         0.149449
──────────────────────────────────
```

Estimated economic, technical and allocative efficiency scores are returned with the `efficiency` function:
```jldoctest 1
julia> efficiency(profitgda, :Economic)
8-element Vector{Float64}:
 4.0
 0.5
 0.0
 0.16666666666666666
 0.8000000000000002
 0.5714285714285715
 0.2857142857142859
 0.9494489071548665
```
```jldoctest 1
julia> efficiency(profitgda, :Technical)
8-element Vector{Float64}:
 0.0
 0.0
 0.0
 0.0
 0.6000000000000001
 0.5238095238095238
 0.14285714285714257
 0.8
```
```jldoctest 1
julia> efficiency(profitgda, :Allocative)
8-element Vector{Float64}:
 4.0
 0.5
 0.0
 0.16666666666666666
 0.20000000000000004
 0.047619047619047644
 0.14285714285714332
 0.14944890715486644
```

### deaprofitgda Function Documentation

```@docs
deaprofitgda
```

