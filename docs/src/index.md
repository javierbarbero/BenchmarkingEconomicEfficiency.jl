# BenchmarkingEconomicEfficiency.jl

BenchmarkingEconomicEfficiency.jl is a Julia package that provides functions for economic efficiency using Data Envelopment Analysis (DEA). The package is an extension of the [DataEnvelopmentAnalysis.jl](https://github.com/javierbarbero/DataEnvelopmentAnalysis.jl) package.

The package is being developed for Julia `1.0` and above on Linux, macOS, and Windows.

The packes uses internally the [JuMP](https://github.com/JuliaOpt/JuMP.jl) modelling language for mathematicall optimization with solvers [GLPK](https://github.com/jump-dev/GLPK.jl) and [Ipopt](https://github.com/jump-dev/Ipopt.jl).

## Installation

The package can be installed with the Julia package manager:
```julia
julia> using Pkg; Pkg.add("BenchmarkingEconomicEfficiency")
```

## Tutorial

For a tutorial on how to use the package, check the documentation on the [Cost Directional Distance Function model](@ref).

## Available models

Profit DEA models:
```@contents
Pages = ["profit/profitefficiency.md", "profit/profitrussell.md", "profit/profitadditive.md", "profit/profitenhancedrussell.md", "profit/profitddf.md", "profit/profitholder.md",  "profit/profitmddf.md", "profit/profitrddf.md", "profit/profitgda.md"]
Depth = 2
```

Profitability DEA models:
```@contents
Pages = ["profitability/profitability.md"]
Depth = 2
```

Cost DEA models:
```@contents
Pages = ["cost/costefficiency.md", "cost/cost.md", "cost/costrussell.md", "cost/costadditive.md", "cost/costddf.md", "cost/costholder.md", "cost/costrddf.md", "cost/costgda.md"]
Depth = 2
```

Revenue DEA models:
```@contents
Pages = ["revenue/revenueefficiency.md", "revenue/revenue.md",  "revenue/revenuerussell.md", "revenue/revenueadditive.md", "revenue/revenueddf.md", "revenue/revenueholder.md", "revenue/revenuerddf.md", "revenue/revenuegda.md"]
Depth = 2
```

## Authors

BenchmarkingEconomicEfficiency.jl is being developed by [Javier Barbero](http://www.javierbarbero.net) and [José Luís Zofío](http://www.joselzofio.net).
