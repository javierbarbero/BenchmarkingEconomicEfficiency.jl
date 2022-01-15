```@meta
CurrentModule = BenchmarkingEconomicEfficiency
```

# Cost (In)Efficiency measurement

*Cost efficiency* allows studying the economic performance of firms as cost minimizers; i.e. their ability to minimize the cost of producing a given level of output given input prices. Cost efficiency (inefficency) can be measured and decomposed multiplicatively (additively), depending on the (in)efficiency measure that is employed. The multiplicative approach is most well-known as it corresponds to Farrell's original proposal. For this reason we present the models available starting with this approach, and then follow with the many additive decompositions that have been proposed in the literature, based on the different input-oriented inefficiency measures, denoted by $EM(I)$, that can be also found in the profit and revenue approaches. 
 
As before, measuring economic efficiency requires the definition of the optimal economic goal to be achieved by the firms. In this case, the minimum cost of producing an output level $\textbf{y}$, represented by the input set $L(\textbf{y}_o)$. The cost function is defined as follows: 

$C(\mathbf{y},\mathbf{w})=\underset{\mathbf{x}}{\mathop{\text{min}}}\,\left\{ \mathbf{w}\cdot \mathbf{x} \,| \, {\mathbf{x}} \ge X\mathbf{\lambda},\;{\mathbf{y}_o} \leqslant
Y{\mathbf{\lambda },\;{\mathbf{\mathbf{e\lambda=1}, \lambda }} \ge {\mathbf{0}}} \right\},\ \mathbf{w}\in \mathbb{R}_{++}^{M},\mathbf{y}_o\ge {{0}_{N}}.$

Minimum cost along with the optimal input quantities can be calculated through DEA by solving the following model:  

```math
\begin{split}
& C\left( {{\mathbf{y}}_{o}},\mathbf{w} \right)=\underset{\mathbf{x},\pmb{\lambda }}{\mathop{\min }}\,\ \sum\nolimits_{m=1}^{M}{{{w}_{m}}{{x}_{m}}} \\ 
& \text{s}\text{.t}\text{.}\quad \sum\limits_{j=1}^{J}{\lambda _{j}^{{}}x_{jm}^{{}}}\le \ {{x}_{m}},\ m=1,...,M\text{,}\  \\ 
& \quad \quad \sum\nolimits_{j=1}^{J}{\lambda _{j}^{{}}y_{jn}^{{}}}\ge y_{on}^{{}},\ n=1,...,N\text{, } \\ 
& \quad \quad \sum\nolimits_{j=1}^{J}{\lambda _{j}^{{}}}=1, \\ 
& \quad \quad \lambda \ge 0,\  \\ 
\end{split}
```

**Multiplicative decomposition cost efficiency**

For firm $\left( \textbf{x}_{o}^{{}},\textbf{y}_{o}^{{}} \right)$, *cost efficiency* defines multiplicatively as the ratio of minimum cost to observed cost, i.e., 

$\mathit{CE(\textbf{x}_o,\textbf{y}_o,\textbf{w})}= C\left(\mathbf{y}_o,\mathbf{w}\right)/C_o=C\left(\mathbf{y}_o,\mathbf{w}\right)/\mathbf{w}\cdot \mathbf{x}_o=C\left(\mathbf{y}_o,\mathbf{w}\right)/\sum\limits_{m=1}^{M}{{w}_{m}}{{x}_{om}} \le 1.$


Therefore if $\mathit{CE(\textbf{x}_o,\textbf{y}_o,\textbf{w})} = 1$ the firm minimizes cost, and the smaller the value of the cost efficiency, the greater the cost excess of the firm with respect to the economic benchmark. 

Based on the duality between the cost function and the radial input measure, it is possible  to decompose cost efficiency multiplicatively into a measure of technical efficiency and a residual measure of allocative inefficiency. This method is presented in the following section [Cost Radial model](@ref).  


**Additive decompositions of cost inefficiency**

*Cost inefficiency* is defined additively as the difference between observed cost and minimum cost: 


$CI(\textbf{x}_o,\textbf{y}_o,\textbf{w}) = C_o-C\left(\mathbf{y}_o,\mathbf{w}\right) = \mathbf{w \cdot x}_o-C\left(\mathbf{y}_o,\mathbf{w}\right) = \sum\nolimits_{m=1}^{M}{{w}_{m}}{{x}_{om}} -C\left(\mathbf{y}_o,\mathbf{w}\right) \ge 0.$ 


Therefore if $\mathit{CI(\textbf{x}_o,\textbf{y}_o,\textbf{w})} = 0$ the firm minimizes cost, and the greater the value of the cost inefficiency, the greater the cost excess of the firm with respect to the economic benchmark. 

Following the literature the decomposition of cost inefficiency can be performed based on different input-oriented technical inefficiency measures. Regardless the particular ineffiency measure, $EM(I)$, cost inefficiency is decomposed into an input technical inefficiency measure, generally denoted by $TI_{EM(I)}(\textbf{x}_o, \textbf{y}_o)$, and an allocative term. Regarding efficiency measurement, if a firm is technically efficient, the efficiency score is null, i.e, $EM(I) = 0$. On the contrary, if the inefficiency score is positive, the firm is technically inefficient.  After calculating the input-oriented technical inefficiency, and based on the duality between the cost and each technical inefficiency measure, we can establish two Fenchel-Mahler inequalities by which *normalized* cost inefficiency: $CI(\textbf{x}_o,\textbf{y}_o, \tilde{\textbf{w}}) =\mathit{CI(\textbf{x}_o,\textbf{y}_o,\textbf{w})}/NF_{EM(I)}$, is greater or equal in value to the technical efficiency measure, i.e., $\mathit{CI(\textbf{x}_o,\textbf{y}_o,\textbf{w})}/NF_{EM(I)} \ge TI_{EM(I)}(\textbf{x}_o, \textbf{y}_o)$, $CI(\textbf{x}_o,\textbf{y}_o, \tilde{\textbf{w}})$.
 
 The divisor $NF_{EM(I)}$ is a normalizing scalar derived from the duality relationship. Afterwards, a scalar representing normalized allocative inefficiency is obtained as a residual by closing the inequality. Cost allocative inefficiency measures the cost excess that can be attributed to the fact that firm (or its technically projected benchmark) does not demand the optimal input quantities. 

Normalized cost inefficiency can be decomposed then as follows: 

```math
\underbrace{\frac{ \sum\limits_{m=1}^{M}{{{w}_{m}}{{x}_{om}}} - C \left( \mathbf{y}_o,\mathbf{w} \right)}{NF_{EM(I)}}}_{\text{Norm}\text{. Cost Inefficiency}}= \quad =\underbrace{TI_{EM(I)}(\textbf{x}_o, \textbf{y}_o)}_{\text{Input Technical Inefficiency}}+\ \,\underbrace{A{{I}_{EM(I)}}\left( {{\mathbf{x}}_{o}},{{\mathbf{y}}_{o}},\mathbf{\tilde{w}}\right)}_{\text{Norm}\text{. Allocative Inefficiency}} \ge 0,    
```  
The following functions available in **BenchmarkingEconomicEfficiency.jl** present alternative decompositions of cost inefficiency based on the most relevant technical inefficiency measures proposed in the literature. As for the decompositions, being normalized, they all satisfy the property of commensurability (or units' invariance), and therefore they are independent of the units of measurement of quantities and prices. Additionally, each of these measures results in a particular decomposition whose pros and cons in terms of a series of properties are inherited from those of the underlying technical inefficiency measure: $TI_{EM(I)}(\textbf{x}_o, \textbf{y}_o)$. Pastor, Aparicio and Zofío (2022, Chap. 14) discuss the properties of the different decompositions. 

**Reference**

Chapter 2 and 14 in Pastor, J.T., Aparicio, J. and Zofío, J.L. (2022) Benchmarking Economic Efficiency: Technical and Allocative Fundamentals, International Series in Operations Research and Management Science, Vol. 315,  Springer, Cham. 
