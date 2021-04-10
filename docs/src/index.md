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

Cost DEA models:
```@contents
Pages = ["cost/costddf.md", "cost/costadditive.md", "cost/costrussell.md", "cost/costholder.md"]
Depth = 2
```

Revenue DEA models:
```@contents
Pages = ["revenue/revenueddf.md", "revenue/revenueadditive.md", "revenue/revenuerussell.md", "revenue/revenueholder.md"]
Depth = 2
```

Profit DEA models:
```@contents
Pages = ["profit/profitadditive.md", "profit/profitrussell.md", "profit/profitenhancedrussell.md", "profit/profitmodifiedddf.md", "profit/profitholder.md"]
Depth = 2
```

## Authors

DataEnvelopmentAnalysis.jl is being developed by [Javier Barbero](http://www.javierbarbero.net) and [José Luís Zofío](http://www.joselzofio.net).
