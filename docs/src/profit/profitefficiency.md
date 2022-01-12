```@meta
CurrentModule = BenchmarkingEconomicEfficiency
```

# Profit Efficiency measurement

*Profit inefficiency* allows studying the economic performance of
firms as profit maximizers. Firms are profit efficient
if they can maximize the difference between revenue and cost given market
prices. The profit function defines as follows:

$\Pi \left(\mathbf{w},\mathbf{p}\right)=\underset{\mathbf{x},\mathbf{y}}{\mathop{\text{max}}}\,\Big\{\mathbf{p}\cdot \mathbf{y}-\mathbf{w}\cdot \mathbf{x}
\,| \, {\mathbf{x}} \ge X\mathbf{\lambda},\;{\mathbf{y}} \leqslant
Y{\mathbf{\lambda },\;{\mathbf{\mathbf{e\lambda=1}, \lambda }}
	\ge {\mathbf{0}}} \Big\}, \mathbf{w}\in \mathbb{R}_{++}^{M},\ \mathbf{p}\in \mathbb{R}_{++}^{N}.$ 

Calculating maximum profit along with the optimal output and input quantities through DEA requires solving:

```math
\begin{split}
	& \Pi \left( \mathbf{w},\mathbf{p} \right)=\underset{\textbf{x},\textbf{y},\pmb{\lambda}}{\mathop{\max }}\,\ \ \sum\limits_{n=1}^{N}{{{p}_{n}}{{y}_{n}}}-\sum\limits_{m=1}^{M}{{{w}_{m}}{{x}_{m}}}\quad  \\ 
	& s.t. \quad \,\sum\limits_{j=1}^{J}{\lambda _{j}^{{}}x_{jm}^{{}}}\le {{x}_{m}},\ m=1,...,M\text{,}\  \\ 
	& \quad \quad \sum\limits_{j=1}^{J}{\lambda _{j}^{{}}y_{jn}^{{}}}\ge y_{n}^{{}},\ n=1,...,N\text{, } \\ 
	& \quad \quad \sum\limits_{j=1}^{J}{\lambda _{j}^{{}}=1,} \\ 
	& \quad \quad \lambda \ge 0.\quad   
\end{split}
```

For a specific firm  $\left( \textbf{x}_{o}^{{}},\textbf{y}_{o}^{{}} \right)\in \mathbb{R}_{+}^{M+N}, \textbf{x}_{o}^{{}}\ne {{0}_{M}},\textbf{y}_{o}^{{}}\ne {{0}_{N}}$, Profit inefficiency defines as the difference between maximum profit and observed profit; i.e., $\mathit{PI(\textbf{x}_o,\textbf{y}_o,\textbf{w}, \textbf{p})}= \Pi\left(\mathbf{w},\mathbf{p}\right)-
\Pi_o= \Pi\left(\mathbf{w},\mathbf{p}\right)- (\mathbf{p\cdot y}_{o}-\mathbf{w\cdot x}_{o})= \Pi \left( \mathbf{w},\mathbf{p} \right)-\left( \sum\limits_{n=1}^{N}{{{p}_{n}}{{y}_{on}}}-\sum\limits_{m=1}^{M}{{{w}_{m}}{{x}_{om}}} \right) \ge 0$. 

The standard approach decomposing profit inefficiency into a technical inefficiency measure, generally denoted by $TI_{EM(G)}(\textbf{x}_o, \textbf{y}_o)$--where the subscript $EM(G)$ represents a specific measure, and an allocative term, follows the same methodology regardless the technical measure (e.g., Russell, weighted additive, directional distance function, etc.). 

First, concerning technical inefficiency measurement, it measures the distance between the firm and the production frontier. If a firm is technically efficient, its value is null, i.e, $TI_{EM(G)}(\textbf{x}_o, \textbf{y}_o)=0$. Otherwise, if the firm is technically inefficient: $TI_{EM(G)}(\textbf{x}_o, \textbf{y}_o)>0$. After calculating technical inefficiency, and based on the duality between the profit function and each technical inefficiency measure, we can establish a Fenchel-Mahler inequality by which *normalized* profit inefficiency: $PI(\textbf{x}_o,\textbf{y}_o, \tilde{\textbf{w}}, \tilde{\textbf{p}}) =\mathit{PI(\textbf{x}_o,\textbf{y}_o,\textbf{w}, \textbf{p})}/NF_{EM(G)}$, is greater or equal in value to the technical inefficiency measure, i.e. $\mathit{ PI(\textbf{x}_o,\textbf{y}_o,\textbf{w}, \textbf{p})}/NF_{EM(G)} \ge TI_{EM(G)}(\textbf{x}_o, \textbf{y}_o)$, where the divisor $NF_{EM(G)}$ is a normalizing scalar derived from the duality relationship. The tilde `~' over prices denotes the normalization of profit inefficiency and its accompanying allocative term. Note that the normalizing factor in the denominator, $NF_{EM(G)}$ can be applied as divisor to the input and output prices:  ($\tilde{\textbf{w}},\tilde{\textbf{p}}$) = ($\textbf{w}/NF_{EM(G)},\textbf{p}/NF_{EM(G)}$).} 

Afterwards, a scalar representing normalized allocative inefficiency is obtained as the residual by closing the inequality.  Allocative inefficiency measures the profit loss that can be attributed to the fact that the technically projected benchmark of the firm--through the technical inefficiency measure--does not demand the optimal input quantities or supply the optimal output quantities that jointly maximize profit. 

```math
\begin{split}
& \underbrace{\frac{\Pi \left( \mathbf{w},\mathbf{p} \right)-\left( \sum\limits_{n=1}^{N}{{{p}_{n}}{{y}_{on}}}-\sum\limits_{m=1}^{M}{{{w}_{m}}{{x}_{om}}} \right)}{NF_{EM(G)}}}_{\text{Norm}\text{. Profit Inefficiency}} =\\ 
& \quad =\underbrace{TI_{EM(G)}(\textbf{x}_o, \textbf{y}_o)}_{\text{Graph Technical Inefficiency}}+\ \,\underbrace{A{{I}_{EM(G)}}\left( {{\mathbf{x}}_{o}},{{\mathbf{y}}_{o}},\mathbf{\tilde{w}},\mathbf{\tilde{p}} \right)}_{\text{Norm}\text{. Allocative Inefficiency}} \ge 0
\end{split}
```

The following functions available in **Benchmarking Economic Efficiency** with *Julia* present alternative decompositions of profit inefficiency based on the most relevant technical inefficiency measures proposed in the literature. As for the decompositions, being normalized, they all satisfy the property of commensurability (or units' invariance), and therefore they are independent of the units of measurement of quantities and prices. Additionally, each of these measures results in a particular decomposition whose pros and cons in terms of a series of properties are inherited from those of the underlying technical inefficiency measure: $TI_{EM(G)}(\textbf{x}_o, \textbf{y}_o)$. Pastor, Aparicio and Zofío (2022, Chap. 14) discuss the properties of the different decompositions proposed in the literature. 

**Reference**

Chapters 2 and 14 in Pastor, J.T., Aparicio, J. and Zofío, J.L. (2022) Benchmarking Economic Efficiency: Technical and Allocative Fundamentals, International Series in Operations Research and Management Science, Vol. 315,  Springer, Cham. 
