```@meta
CurrentModule = BenchmarkingEconomicEfficiency
```

# Revenue (In)Efficiency measurement

*Revenue efficiency* allows studying the economic performance of firms as revenue maximizers; i.e. their ability to maximize the revevenue of producing with a given level of inputs given output prices. Revenue efficiency (inefficency) can be measured and decomposed multiplicatively (additively), depending on the (in)efficiency measure that is employed. The multiplicative approach is most well-known as it corresponds to Farrell's radial dproposal. For this reason we initiate the presentation of the revenue models with this approach and then follow with the many additive decompositions that have been proposed in the literature, based on the different output-oriented inefficiency measures, denoted by $EM(O)$, that can be also found in the profit and cost approaches. 
 
In this case, measuring economic efficiency requires the definition of the optimal economic goal of the firm, which corresponds to the maximum revenue that can be obtainable from input level \textbf{x}, represented by the output set $P(\textbf{x}_o)$. The revenue function is expressed as: 

$R(\mathbf{x},\mathbf{p})=\underset{\mathbf{y}}{\mathop{\text{max}}}\,\left\{ \mathbf{p}\cdot \mathbf{y}\,| \, {\mathbf{x}_o} \ge
Y{\mathbf{\lambda },\;{\mathbf{\mathbf{e\lambda=1}, \lambda }} 	\ge {\mathbf{0}}} \right\},\ \ \mathbf{p}\in \mathbb{R}_{++}^{N},\mathbf{x}_o\ge {{0}_{N}}$. 

Maximum revenue along with the optimal output  quantities can be calculated through DEA by solving the following model  

```math
\begin{split}
& R\left( {{\mathbf{x}}_{o}},\mathbf{p} \right)=\underset{\textbf{y},\pmb{\lambda} }{\mathop{\max }}\,\ \sum\nolimits_{n=1}^{N}{{{p}_{n}}{{y}_{n}}} \\ 
& \text{s}\text{.t}\text{.}\quad \sum\nolimits_{j=1}^{J}{\lambda _{j}^{{}}x_{jm}^{{}}}\le \ {{x}_{om}},\ m=1,...,M\text{,}\  \\ 
& \quad \quad \sum\nolimits_{j=1}^{J}{\lambda _{j}^{{}}y_{jn}^{{}}}\ge y_{n}^{{}},\ n=1,...,N\text{, } \\ 
& \quad \quad \sum\nolimits_{j=1}^{J}{\lambda _{j}^{{}}}=1, \\ 
& \quad \quad \lambda \ge 0. \\ 
\end{split}
```

**Multiplicative decomposition revenue efficiency**

For firm $\left( \textbf{x}_{o}^{{}},\textbf{y}_{o}^{{}} \right)$, *revenue efficiency* defines as the ratio of observed revenue to maximum revenue; i.e, 

$\mathit{RE(\textbf{x}_o,\textbf{y}_o, \textbf{p})}= R_o/R\left(\mathbf{x}_o,\mathbf{p}\right)=\mathbf{p}\cdot \mathbf{y}_o/R\left(\mathbf{x}_o,\mathbf{p}\right)= 
\sum\limits_{n=1}^{N}{{p}_{n}}{{y}_{on}}/R\left(\mathbf{x}_o,\mathbf{p}\right) \le 1.$

Therefore if $\mathit{RE(\textbf{x}_o,\textbf{y}_o,\textbf{p})} = 1$ the firm maximizes revenue, and the smaller the value of the revenue efficiency, the greater the revenue loss.    

Based on the duality between the rvenue function and the radial output measure, it is possible  to decompose revenue efficiency multiplicatively into a measure of technical efficiency and a residual measure of allocative inefficiency. This methoid is presented in the following section [Revenue Radial model](file:///C:/Users/NLHome/Dropbox%20(Personal)/DEA%20Julia/BEEdocs/build/revenue/revenue.html).  


**Additive decompositions of revenue inefficiency**

*Revenue inefficiency* can be defined as the difference between maximum revenue and observed revenue: 


 $\mathit{RI(\textbf{x}_o,\textbf{y}_o, \textbf{p})}= R\left(\mathbf{x}_o,\mathbf{p}\right) - R_o = R\left(\mathbf{x}_o,\mathbf{p}\right) - \mathbf{p}\cdot \mathbf{y}_o= R\left(\mathbf{x}_o,\mathbf{p}\right)-\sum\limits_{n=1}^{N}{{p}_{n}}{{y}_{on}} \ge 0.$

 Therefore if $\mathit{RI(\textbf{x}_o,\textbf{y}_o,\textbf{p})} = 0$ the firm maximizes revenue, and the greater the value of the revenue inefficiency, the greater the revenue loss.    

Following the literature the decomposition of revenue inefficiency can be performed based on different output-oriented technical inefficiency measures. Regardless the particular ineffiency measure, $EM(O)$, revenue inefficiency is decomposed into an output technical inefficiency measure, generally denoted by $TI_{EM(O)}(\textbf{x}_o, \textbf{y}_o)$, and an allocative term. Regarding efficiency measurement,  if a firm is technically efficient, the efficiency score is null, i.e, $EM(O) = 0$. On the contrary, if the inefficiency score is positive, the firm is technically inefficient.  After calculating the output-oriented technical inefficiency, and based on the duality between the revenue function and each technical inefficiency measure, we can establish two Fenchel-Mahler inequalities by which *normalized* revenue inefficiency:  $\mathit{RI(\textbf{x}_o,\textbf{y}_o,\tilde{\textbf{p}})}=  \mathit{RI(\textbf{x}_o,\textbf{y}_o,\textbf{p})}/NF_{EM(O)}$, is greater or equal in value to the output-oriented technical efficiency measure, i.e., $\mathit{RI(\textbf{x}_o,\textbf{y}_o,\textbf{p})}/NF_{EM(O)} \ge TI_{EM(O)}(\textbf{x}_o, \textbf{y}_o)$.

 The divisor $NF_{EM(O)}$ is a normalizing scalar derived from the duality relationship. Afterwards, a scalar representing normalized allocative inefficiency is obtained as a residual by closing the inequality. Revenue allocative inefficiency measures the revenue loss that can be attributed to the fact that firm (or its technically projected benchmark) does not supply the optimal output quantities.

Normalized revenue inefficiency can be decomposed then as follows: 

```math
\underbrace{     \frac{ \sum\limits_{m=1}^{M}{{{w}_{m}}{{x}_{om}}} - C \left( \mathbf{y}_o,\mathbf{w} \right)}{NF_{EM(I)}}}_{\text{Norm}\text{. Cost Inefficiency}} 
\quad =\underbrace{TI_{EM(I)}(\textbf{x}_o, \textbf{y}_o)}_{\text{Input Technical Inefficiency}}+\ \,\underbrace{A{{I}_{EM(I)}}\left( {{\mathbf{x}}_{o}},{{\mathbf{y}}_{o}},\mathbf{\tilde{w}}\right)}_{\text{Norm}\text{. Allocative Inefficiency}} \ge 0,    
```  
The following functions available in **BenchmarkingEconomicEfficiency.jl** present alternative decompositions of revenue inefficiency based on the most relevant technical inefficiency measures proposed in the literature. As for the decompositions, being normalized, they all satisfy the property of commensurability (or units' invariance), and therefore they are independent of the units of measurement of quantities and prices. Additionally, each of these measures results in a particular decomposition whose pros and cons in terms of a series of properties are inherited from those of the underlying technical inefficiency measure: $TI_{EM(O)}(\textbf{x}_o, \textbf{y}_o)$. Pastor, Aparicio and Zofío (2022, Chap. 14) discuss the properties of the different decompositions. 

**Reference**

Chapter 2 and 14 in Pastor, J.T., Aparicio, J. and Zofío, J.L. (2022) Benchmarking Economic Efficiency: Technical and Allocative Fundamentals, International Series in Operations Research and Management Science, Vol. 315,  Springer, Cham. 
