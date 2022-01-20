# Configuring the optimizer

BenchmarkingEconomicEfficiency.jl will use a default optimizer/solver for each DEA model, as shown in the next table.

| Model               | Function            | Specific Options | Problem type | Default Optimizer |
|:--------------------|:--------------------|:-----------------|-------------:|------------------:|
| Profit Russell      | `deaprofitrussell`  |                  | NLP          | Ipopt             |
| Profit Additive     | `deaprofitadd `     |                  | LP           | GLPK              |
| Profit ERG=SBM      | `deaprofiterg`      |                  | LP           | GLPK              |
| Profit DDF          | `deaprofit`         |                  | LP           | GLPK              |
| Profit Hölder       | `deaprofitholder`   |                  | LP           | GLPK              |
| Profit MDDF         | `deaprofitmddf`     |                  | LP           | GLPK              |
| Profit Reverse DDF  | `deaprofitrddf`     | `:ERG`           | LP           | GLPK              |
| Profit Reverse DDF  | `deaprofitrddf`     | `:MDDF`          | LP           | GLPK              |
| Profit GDA          | `deaprofitgda`      |                  | LP           | GLPK              |
| Profitability GDF   | `deaprofitability`  |                  | NLP          | Ipopt             |
| Cost Radial         | `deacost`           |                  | LP           | GLPK              |
| Cost Russell        | `deacostrussell`    |                  | LP           | GLPK              |
| Cost Additive       | `deacostadd`        |                  | LP           | GLPK              | 
| Cost DDF            | `deacostddf`        |                  | LP           | GLPK              |
| Cost Hölder         | `deacostholder `    |                  | LP           | GLPK              |
| Cost Reverse DDF    | `deacostrddf`       |                  | LP           | GLPK              |
| Cost GDA            | `deacostgda`        |                  | LP           | GLPK              |
| Revenue Radial      | `dearevenue`        |                  | LP           | GLPK              |
| Revenue Russell     | `dearevenuerussell` |                  | LP           | GLPK              |
| Revenue Additive    | `dearevenueadd`     |                  | LP           | GLPK              |
| Revenue DDF         | `dearevenueddf`     |                  | LP           | GLPK              |
| Revenue Hölder      | `dearevenueholder`  |                  | LP           | GLPK              |
| Revenue Reverse DDF | `dearevenuerddf`    |                  | LP           | GLPK              |
| Revenue GDA         | `dearevenuegda`     |                  | LP           | GLPK              |

Where:
- LP = Linear programming.
- NLP = Nonlinear programming.

Models can be solved using a different optimizer by passing a `DEAOptimizer` object to the `optimizer` optional argument. For instruction, see the documentation on the [DataEnvelopmentAnalysis](https://javierbarbero.github.io/DataEnvelopmentAnalysis.jl/stable/optimizer/) package.

