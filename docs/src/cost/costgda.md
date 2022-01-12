```@meta
CurrentModule = BenchmarkingEconomicEfficiency
```
# Cost General Direct Approach model

The generalized direct approach, *GDA*, is introduced by Pastor, Aparicio and Zofío (2022, Ch. 13). Contrary to the standard approach that relies on duality theory to obtain a suitable Fenchel-Mahler inequality from which allocative efficiency is recovered as a residual--see [Cost (In)Efficiency measurement](@ref), the *GDA* establishes an economic efficiency decomposition valid for any technical efficiency measure, $EM(I)$, by considering the same single equality each time. For any firm $\left( \textbf{x}_o,\textbf{y}_o\right)$ and for an already selected $EM(I)$ we just need to know two pieces of information, its technical inefficiency $T{{I}_{EM (I)}}\left( \textbf{x}_o,\textbf{y}_o \right)$ and its associated frontier projection $\left( {{{\hat{\textbf{x}}}}_{oEM(I)}},{{{\textbf{y}_o}}} \right)$. The $GDA$, providing a unifying framework for decomposing economic inefficiency, follows similar steps as the traditional approach but is easier to develop and implement since it does not rely on duality theory. It is *general*, because it can be applied to any efficiency measure; *easier* to implement, because it does not require to search for Fenchel-Mahler inequalities (although the underlying duality holds); and more *reliable*, because working with equalities instead of inequalities (and their associated normalization factors) avoids the possibility of overestimating allocative inefficiency as several traditional approaches do when failing to satisfy the essential property.

The *GDA* approach breaks up cost inefficiency of firm $\left( \textbf{x}_{o}^{{}},\textbf{y}_{o}^{{}} \right)$ into the sum of two components. The first one corresponds to a technological term which is the interior product of two vectors: the optimal input slack vector $\textbf{s}_{oEM(G)}^{-*}= ({{\textbf{x}}_{o}}-{{{\hat{\textbf{x}}}}_{oEM(I)}})$--corresponding to $L_1$-path between the firm under evaluation and its projection on the frontier of the input production possibility set $L(\textbf{y}_o)$, and the input price vector $\textbf{w}$. The second allocative component corresponds to cost inefficiency at the projection $\left( {{{\hat{\textbf{x}}}}_{oEM(I)}},{{{\textbf{y}_o}}} \right)$. Both components have the intuitive technical and allocative interpretations. This results in the following decomposition:
```math
\begin{split}
& CI\left( {{\mathbf{x}}_{o}},{{\mathbf{y}}_{o}},\mathbf{w} \right)={{C}_{o}} - C\left(\mathbf{y}_o,\mathbf{w} \right)= \mathbf{w}\cdot \mathbf{x}_{o}^{{}} - C\left(\mathbf{y}_o,\mathbf{w} \right) =  \\ 
& \mathbf{w}\cdot \mathbf{s}_{oEM(I)}^{-*} + (\mathbf{w}\cdot \mathbf{\hat{x}}_{oEM(I)}^{{}} - C\left(\mathbf{y}_o,\mathbf{w} \right)) = \\ 
& \underbrace{\mathbf{w}\cdot \mathbf{s}_{oEM(I)}^{-*} }_{\text{Cost}\ \text{Technological}\ \text{Gap }}+\underbrace{CI\left({{{\mathbf{\hat{x}}}}_{oEM(I)}},{{{\mathbf{y}}}_{o}},\mathbf{w}\right)}_{\text{Cost Allocative Inefficiency}}. 
\end{split}
```
Last equality shows that cost inefficiency, measured in monetary values, can be decomposed into the cost excess due  to the technological gap between the firm and its projection, which we term *cost technological gap*, plus the cost inefficiency of the projected benchmark under the given efficiency measures $EM(I)$, representing *cost allocative inefficiency*.  Subsequently we can relate the cost technological gap, $\mathbf{w}\cdot \mathbf{s}_{oEM(I)}^{-*}$, with the technical inefficiency measurse $T{{I}_{EM(I)}}\left( {{\textbf{x}}_{o}},{{\textbf{y}}_{o}} \right)$ of the firm under evaluation, which has been already calculated. The following expression shows this relationship:  

```math
CI\left( {{\mathbf{x}}_{o}},{{\mathbf{y}}_{o}},\mathbf{w}\right)= 
\left( \frac{\mathbf{w}\cdot \mathbf{s}_{oEM}^{-*}}{{T{{I}_{EM(I)}}}\left( \mathbf{x}_{o}^{{}},\mathbf{y}_{o}^{{}} \right)} \right)\times T{{I}_{EM(I)}}\left( \mathbf{x}_{o}^{{}},\mathbf{y}_{o}^{{}} \right)+CI\left( {{{\mathbf{\hat{x}}}}_{oEM(I)}},{{{\mathbf{y}}}_{o}},\mathbf{w}\right).  
```
Therefore, the cost excess associated with the cost technological gap can be decomposed into the technical inefficiency of the firm itself, $\left( \mathbf{x}_{o}^{{}},\mathbf{y}_{o}^{{}} \right)$, times a normalizing factor $N{{F}_{EM(I)}}\left( {{\textbf{x}}_{o}},{{\textbf{y}}_{o}},\mathbf{\tilde{w}} \right)$ that captures the cost excess per unit of technical inefficiency--the normalizing factor being equal to the cost technological gap divided by the technical inefficiency measure. This corresponds to the technical cost inefficiency of the firm and, consequently, the remaining cost inefficiency captured in the second term, which is the difference between overall cost inefficiency and technical cost inefficiency, effectively corresponds to the allocative cost inefficiency of the firm under evaluation $\left( \mathbf{x}_{o}^{{}},\mathbf{y}_{o}^{{}} \right)$. As already shown, this last inefficiency is equivalent to the cost inefficiency at its projection $\left( {{{\mathbf{\hat{x}}}}_{oEM(I)}},{{{\mathbf{y}_o}}} \right)$. 

The final step consists in characterizing the normalizing factor for the cost decompositions: $N{{F}_{EM(I)}^{GDA}}\left( {{\textbf{x}}_{o}},{{\textbf{y}}_{o}},\mathbf{\tilde{w}} \right)$, which allow us to define a measure of normalized economic inefficiency that is, as the previous ones, units' invariant. For this purpose we differentiate if the firm under evaluation is technically inefficient or not. That is, if $T{{I}_{EM(I)}}\left( {{\textbf{x}}_{o}},{{\textbf{y}}_{o}} \right)>0$, with $\left( {{\mathbf{x}}_{o}},{{\mathbf{y}}_{o}} \right)\ne \left( \mathbf{\hat{x}}_{oEM(I)}^{{}},\mathbf{y}_{o}^{{}} \right)$, or $T{{I}_{EM(I)}}\left( {{\textbf{x}}_{o}},{{\textbf{y}}_{o}} \right) = 0$, with $\left( {{\mathbf{x}}_{o}},{{\mathbf{y}}_{o}} \right) = \left( \mathbf{\hat{x}}_{oEM(I)}^{{}},\mathbf{y}_{o}^{{}} \right)$. Hence, we define:

```math
NF_{EM(I)}^{GDA}\left( \mathbf{x}_{o}^{{}},\mathbf{y}_{o}^{{}},\mathbf{w} \right)=\left\{ 
\begin{split}
& \frac{\mathbf{w}\cdot \mathbf{s}_{EM}^{-*} }{T{{I}_{EM(I)}}\left( \mathbf{x}_{o}^{{}},\mathbf{y}_{o}^{{}} \right)},\,\,\left( {{\mathbf{x}}_{o}},{{\mathbf{y}}_{o}} \right)\ne \left( \mathbf{\hat{x}}_{oEM(I)}^{{}},\mathbf{y}_{o}^{{}} \right) \\ 
& \,\,\,\,\,\,\,\,{{k}_{o\$}}\,,\,\,{{k}_{o}}>0\,,\,\,\,\,\,\,\,\,\left({{\mathbf{x}}_{o}},{{\mathbf{y}}_{o}}\right)=\left(\mathbf{\hat{x}}_{oEM(I)}^{{}},\mathbf{y}_{o}^{{}}\right)\\
\end{split}
\right\}
```
where the dollar-valued $k_{o}$ is a normalization factor for technically efficient firms that, being expressed in the same monetary units, simply translates a null technical efficiency score into the same currency values. We can introduce the normalized version of the general direct approach and its associated cost decomposition: $C{{I}_{GDA\left( I \right)}}\left( {{\textbf{x}}_{o}},{{\textbf{y}}_{o}},{\tilde{\textbf{w}}} \right)$ = $T{{I}_{GDA\left( I \right)}}\left( {{\textbf{x}}_{o}},{{\textbf{y}}_{o}} \right)$ +  $A{{I}_{GDA\left( I \right)}}\left( {{\textbf{x}}_{o}},{{\textbf{y}}_{o}}, {\tilde{\textbf{w}}} \right)$. This results in the following expression: 

```math
\begin{split}
& \underbrace{\frac{\sum\limits_{m=1}^{M}{{{w}_{m}}{{x}_{om}}}-C\left( \textbf{y}_o,{{\textbf{w}}} \right)}{NF_{EM(I)}^{GDA}\left( \mathbf{x}_{o}^{{}},\mathbf{y}_{o}^{{}},\mathbf{p} \right)}}_{\text{Norm}\text{. Cost Inefficiency}}= \\ 
& =\underbrace{T{{I}_{EM(I)}}\left( \mathbf{x}_{o}^{{}},\mathbf{y}_{o}^{{}} \right)}_{\text{Input Technical Inefficiency}}+\ \,\underbrace{A{{I}_{GDA(I)}}\left( {{\mathbf{x}}_{o}},{{\mathbf{y}}_{o}},\mathbf{\tilde{w}}\right)}_{\text{Norm}\text{. Allocative Inefficiency}} \ge 0.  
\end{split}
```
where the last term represents normalized allocative inefficiency: $A{{I}_{GDA(I)}}\left( {{\mathbf{x}}_{o}},{{\mathbf{y}}_{o}},\mathbf{\tilde{w}} \right) = A{{I}_{GDA(I)}}\left( {{\mathbf{x}}_{o}},{{\mathbf{y}}_{o}},\mathbf{w}\right) / NF_{EM(G)}^{GDA}\left(\mathbf{x}_{o}^{{}},\mathbf{y}_{o}^{{}},\mathbf{w} \right)$.

**Benchmarking Economic Efficiency** with *Julia* implements the cost inefficiency decomposition associated with the general direct approach considering the [Russell input-oriented model](https://javierbarbero.github.io/DataEnvelopmentAnalysis.jl/stable/technical/russell/#Russell-Input-Model). The decomposition can be calculated both in normalized terms and monetary terms. For the latter one needs to add `monetary=true` to the syntax--see the documentation below accompanying this function.  

**Reference**

Chapter 13 in Pastor, J.T., Aparicio, J. and Zofío, J.L. (2022) Benchmarking Economic Efficiency: Technical and Allocative Fundamentals, International Series in Operations Research and Management Science, Vol. 315,  Springer, Cham. 

**Example**

In this example we compute the cost efficiency General Direct Approach measure for the Russell input measure--the input-oriented enhanced Russell graph measure coincides with the original input Russell measure:
```@example costgda
using BenchmarkingEconomicEfficiency

X = [2 2; 1 4; 4 1; 4 3; 5 5; 6 1; 2 5; 1.6 8];

Y = [1; 1; 1; 1; 1; 1; 1; 1];

W = [1 1; 1 1; 1 1; 1 1; 1 1; 1 1; 1 1; 1 1];

costgda = deacostgda(X, Y, W, :ERG)
```

Estimated economic, technical and allocative efficiency scores are returned with the `efficiency` function:
```@example costgda
efficiency(costgda, :Economic)
```

```@example costgda
efficiency(costgda, :Technical)
```

```@example costgda
efficiency(costgda, :Allocative)
```

### deacostgda Function Documentation

```@docs
deacostgda
```

