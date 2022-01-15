```@meta
CurrentModule = BenchmarkingEconomicEfficiency
```
# Revenue General Direct Approach model

The generalized direct approach, *GDA*, is introduced by Pastor, Aparicio and Zofío (2022, Ch. 13). Contrary to the standard approach that relies on duality theory to obtain a suitable Fenchel-Mahler inequality from which allocative efficiency is recovered as a residual--see [Revenue (In)Efficiency measurement](@ref), the *GDA* establishes an economic efficiency decomposition valid for any technical efficiency measure, $EM(I)$, by considering the same single equality each time. For any firm $\left( \textbf{x}_o,\textbf{y}_o\right)$ and for an already selected $EM(O)$ we just need to know two pieces of information, its technical inefficiency $T{{I}_{EM (O)}}\left( \textbf{x}_o,\textbf{y}_o \right)$ and its associated frontier projection $\left( {{{\hat{\textbf{x}}}}},{{{\hat{\textbf{y}}}}_{oEM(O)}} \right)$. The $GDA$, providing a unifying framework for decomposing economic inefficiency, follows similar steps as the traditional approach but is easier to develop and implement since it does not rely on duality theory. It is *general*, because it can be applied to any efficiency measure; *easier* to implement, because it does not require to search for Fenchel-Mahler inequalities (although the underlying duality holds); and more *reliable*, because working with equalities instead of inequalities (and their associated normalization factors) avoids the possibility of overestimating allocative inefficiency as several traditional approaches do when failing to satisfy the essential property.

The *GDA* approach breaks up revenue inefficiency of firm $\left( \textbf{x}_{o}^{{}},\textbf{y}_{o}^{{}} \right)$ into the sum of two components. The first one corresponds to a technological term which is the interior product of the optimal output slack vector $\textbf{s}_{oEM(O)}^{+*} = ({{{\hat{\textbf{y}}}}_{oEM(O)}}-{{\textbf{y}}_{o}})$---the $L_1$-path between the firm under evaluation and its projection on the frontier of the output production possibility set $P(\textbf{x}_o)$, and the output price vector $\textbf{p}$, and a second term measuring the revenue inefficiency of the projected benchmark $(\textbf{x}_o,{\hat{\textbf{y}}_{oEM(O)}})$. This results in the following decomposition:

```math
\begin{split}
& RI\left( {{\mathbf{x}}_{o}},{{\mathbf{y}}_{o}},\mathbf{p} \right)= R\left(\mathbf{x}_o,\mathbf{p} \right)- {{R}_{o}}= R\left(\mathbf{x}_o,\mathbf{p} \right) - \mathbf{p}\cdot \mathbf{y}_{o}^{{}} =    \\ 
& \mathbf{p}\cdot \mathbf{s}_{oEM(O)}^{+*} + (R\left(\mathbf{x}_o,\mathbf{p} \right) - \mathbf{p}\cdot \mathbf{\hat{y}}_{oEM(O)}^{{}}) = \\ 
& \underbrace{\mathbf{p}\cdot \mathbf{s}_{oEM(O)}^{+*} }_{\text{Revenue}\ \text{Technological}\ \text{Gap }}+\underbrace{RI\left({{{\mathbf{x}}}_{o}}, {{{\mathbf{\hat{y}}}}_{oEM(O)}},\mathbf{p}\right)}_{\text{Revenue Allocative Inefficiency}}. 
\end{split}
```
Last equality shows that revenue inefficiency, measured in monetary values, can be decomposed into the revenue loss due to the technological gap between the firm and its projection, which we term *revenue technological gap*, plus the revenue inefficiency of the projected benchmark under the given efficiency measures $EM(O)$, representing *revenue allocative inefficiency*.  Subsequently we can relate the revenue technological gap, $\mathbf{p}\cdot \mathbf{s}_{oEM(O}^{+*}$, with the technical inefficiency measurse $T{{I}_{EM(O)}}\left( {{\textbf{x}}_{o}},{{\textbf{y}}_{o}} \right)$ of the firm under evaluation, which has been already calculated. The following expression shows this relationship:  

```math
RI\left( {{\mathbf{x}}_{o}},{{\mathbf{y}}_{o}},\mathbf{p} \right)=  
 \left( \frac{\mathbf{p}\cdot \mathbf{s}_{oEM}^{+*}}{T{{I}_{EM(O)}}\left( \mathbf{x}_{o}^{{}},\mathbf{y}_{o}^{{}} \right)} \right)\times T{{I}_{EM(O)}}\left( \mathbf{x}_{o}^{{}},\mathbf{y}_{o}^{{}} \right)+RI\left( {{{\mathbf{x}}}_{o}},{{{\mathbf{\hat{y}}}}_{oEM(G)}}, \mathbf{p} \right).  
```

Therefore, the revenue loss associated with the revenue technological gap can be decomposed into the technical inefficiency of the firm itself, $\left( \mathbf{x}_{o}^{{}},\mathbf{y}_{o}^{{}} \right)$, times a normalizing factor $N{{F}_{EM(O)}}\left( {{\textbf{x}}_{o}},{{\textbf{y}}_{o}},\mathbf{\tilde{p}} \right)$ that captures the revenue loss per unit of technical inefficiency--the normalizing factor being equal to the revenue technological gap divided by the technical inefficiency measure. This corresponds to the technical revenue inefficiency of the firm and, consequently, the remaining cost inefficiency captured in the second term, which is the difference between overall revenue inefficiency and technical revenue inefficiency, effectively corresponds to the allocativerevenue inefficiency of the firm under evaluation $\left( \mathbf{x}_{o}^{{}},\mathbf{y}_{o}^{{}} \right)$. As already shown, this last inefficiency is equivalent to the cost inefficiency at its projection $\left( {{{\mathbf{x}_o}}},{{{\mathbf{y}}}_{oEM(O)}} \right)$. 

The final step consists in characterizing the normalizing factor for the revenue decompositions:$N{{F}_{EM(O)}^{GDA}}\left( {{\textbf{x}}_{o}},{{\textbf{y}}_{o}},\mathbf{\tilde{p}} \right)$, which allow us to define a measure of normalized economic inefficiency that is, as the previous ones, units' invariant. For this purpose we differentiate if the firm under evaluation is technically inefficient or not. That is, if $T{{I}_{EM(O)}}\left( {{\textbf{x}}_{o}},{{\textbf{y}}_{o}} \right)>0$, with $\left( {{\mathbf{x}}_{o}},{{\mathbf{y}}_{o}} \right)\ne \left( \mathbf{x}_{o}^{{}},\mathbf{\hat{y}}_{oEM(O)}^{{}} \right)$, or $T{{I}_{EM(O)}}\left( {{\textbf{x}}_{o}},{{\textbf{y}}_{o}} \right) = 0$, with $\left( {{\mathbf{x}}_{o}},{{\mathbf{y}}_{o}} \right) = \left( \mathbf{x}_{o}^{{}},\mathbf{\hat{y}}_{oEM(O)}^{{}} \right)$. Hence, we define:

```math
NF_{EM(O)}^{GDA}\left( \mathbf{x}_{o}^{{}},\mathbf{y}_{o}^{{}},\mathbf{p} \right)=\left\{ 
\begin{split}
& \frac{\mathbf{p}\cdot \mathbf{s}_{EM(O)}^{+*}}{T{{I}_{EM(O)}}\left( \mathbf{x}_{o}^{{}},\mathbf{y}_{o}^{{}} \right)},\,\,\left( {{\mathbf{x}}_{o}},{{\mathbf{y}}_{o}} \right)\ne \left( \mathbf{x}_{o}^{{}},\mathbf{\hat{y}}_{oEM(O)}^{{}} \right) \\ 
& \,\,\,\,\,\,\,\,{{k}_{o\$}}\,,\,\,{{k}_{o}}>0\,,\,\,\,\,\,\,\,\,\left({{\mathbf{x}}_{o}},{{\mathbf{y}}_{o}}\right)=\left(\mathbf{x}_{o}^{{}},\mathbf{\hat{y}}_{oEM(O)}^{{}}\right)\\
\end{split}
\right\}
```
where the dollar-valued $k_{o}$ is a normalization factor for technically efficient firms that, being expressed in the same monetary units, simply translates a null technical efficiency score into the same currency values. We can introduce the normalized version of the general direct approach and its associated revenue decomposition: $R{{I}_{GDA\left( O \right)}}\left( {{\textbf{x}}_{o}},{{\textbf{y}}_{o}}, \tilde{{\textbf{p}}} \right)$ = $T{{I}_{GDA\left( O \right)}}\left( {{\textbf{x}}_{o}},{{\textbf{y}}_{o}} \right)$ +  $A{{I}_{GDA\left( O \right)}}\left( {{\textbf{x}}_{o}},{{\textbf{y}}_{o}}, \tilde{{\textbf{p}}} \right)$. This results in the following expression: 

```math
\begin{split}
& \underbrace{\frac{R \left( \mathbf{x}_o,\mathbf{p} \right) - \sum\limits_{n=1}^{N}{{{p}_{n}}{{y}_{om}}}}{NF_{EM(O)}^{GDA}\left( \mathbf{x}_{o}^{{}},\mathbf{y}_{o}^{{}},\mathbf{p} \right)}}_{\text{Norm}\text{. Revenue Inefficiency}}= \\ 
& =\underbrace{T{{I}_{EM(O)}}\left( \mathbf{x}_{o}^{{}},\mathbf{y}_{o}^{{}} \right)}_{\text{Output Technical Inefficiency}}+\ \,\underbrace{A{{I}_{GDA(O)}}\left( {{\mathbf{x}}_{o}},{{\mathbf{y}}_{o}},\mathbf{\tilde{p}} \right)}_{\text{Norm}\text{. Allocative Inefficiency}} \ge 0.  
\end{split}
```

where the last term represents normalized allocative inefficiency: $A{{I}_{GDA(O)}}\left( {{\mathbf{x}}_{o}},{{\mathbf{y}}_{o}},\mathbf{\tilde{p}} \right) = A{{I}_{GDA(O)}}\left( {{\mathbf{x}}_{o}},{{\mathbf{y}}_{o}},\mathbf{p}\right) / NF_{EM(O)}^{GDA}\left(\mathbf{x}_{o}^{{}},\mathbf{y}_{o}^{{}},\mathbf{p} \right)$.

**BenchmarkingEconomicEfficiency.jl** implements the revenue inefficiency decomposition associated with the general direct approach considering the [Russell output-oriented model](https://javierbarbero.github.io/DataEnvelopmentAnalysis.jl/stable/technical/russell/#Russell-Output-Model). The decomposition can be calculated both in normalized terms and monetary terms. For the latter one needs to add `monetary=true` to the syntax--see the documentation below accompanying this function.  

**Reference**

Chapter 13 in Pastor, J.T., Aparicio, J. and Zofío, J.L. (2022) Benchmarking Economic Efficiency: Technical and Allocative Fundamentals, International Series in Operations Research and Management Science, Vol. 315,  Springer, Cham. 

**Example**

In this example we compute the cost efficiency General Direct Approach measure for the Russell output measure--the output-oriented enhanced Russell graph measure coincides with the original output Russell measure:

```@example revenuegda
using BenchmarkingEconomicEfficiency

X = [1; 1; 1; 1; 1; 1; 1; 1];

Y = [7 7; 4 8; 8 4; 3 5; 3 3; 8 2; 6 4; 1.5 5];

P = [1 1; 1 1; 1 1; 1 1; 1 1; 1 1; 1 1; 1 1];

revenuerddf = dearevenuegda(X, Y, P, :ERG)
```

Estimated economic, technical and allocative efficiency scores are returned with the `efficiency` function:
```@example revenuegda
efficiency(revenuerddf, :Economic)
```

```@example revenuegda
efficiency(revenuerddf, :Technical)
```

```@example revenuegda
efficiency(revenuerddf, :Allocative)
```

### dearevenuegda Function Documentation

```@docs
dearevenuegda
```

