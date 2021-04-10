# Configuring the optimizer

BenchmarkingEconomicEfficiency.jl will use a default optimizer/solver for each DEA model, as shown in the next table.

| Function            | Specific Options | Problem type | Default Optimizer |
| --------------------|-----------------:|-------------:|------------------:|
| `deacostadd`        |                  | LP           | GLPK              | 
| `deacostddf`        |                  | LP           | GLPK              |
| `deacostrussell`    |                  | LP           | GLPK              |
| `deacostholder `    |                  | LP           | GLPK              |
| `dearevenueddf`     |                  | LP           | GLPK              |
| `dearevenueadd`     |                  | LP           | GLPK              |
| `dearevenuerussell` |                  | LP           | GLPK              |
| `dearevenueholder`  |                  | LP           | GLPK              |
| `deaprofitadd `     |                  | LP           | GLPK              |
| `deaprofitrussell`  |                  | NLP          | Ipopt             |
| `deaprofiterg`      |                  | LP           | GLPK              |
| `deaprofitmddf`     |                  | NLP          | Ipopt             |
| `deaprofitholder`   |                  | LP           | GLPK              |

Where:
- LP = Linear programming.
- NLP = Nonlinear programming.

Models can be solved using a different optimizer by passing a `DEAOptimizer` object to the `optimizer` optional argument. For instruction, see the documentation on the [DataEnvelopmentAnalysis](https://javierbarbero.github.io/DataEnvelopmentAnalysis.jl/stable/optimizer/) package.

