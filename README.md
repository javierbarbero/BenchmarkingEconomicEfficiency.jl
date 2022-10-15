# BenchmarkingEconomicEfficiency.jl

A Julia package for economic efficiency measurement using Data Envelopment Analysis (DEA). 

| Documentation | Build Status      | Coverage    |
|:-------------:|:-----------------:|:-----------:|
| [![][docs-stable-img]][docs-stable-url] [![][docs-dev-img]][docs-dev-url] |  [![][githubci-img]][githubci-url] | [![][codecov-img]][codecov-url] |

[docs-stable-img]: https://img.shields.io/badge/docs-stable-blue.svg
[docs-stable-url]: https://javierbarbero.github.io/BenchmarkingEconomicEfficiency.jl/stable

[docs-dev-img]: https://img.shields.io/badge/docs-dev-blue.svg
[docs-dev-url]: https://javierbarbero.github.io/BenchmarkingEconomicEfficiency.jl/dev

[githubci-img]: https://github.com/javierbarbero/BenchmarkingEconomicEfficiency.jl/workflows/CI/badge.svg
[githubci-url]: https://github.com/javierbarbero/BenchmarkingEconomicEfficiency.jl/actions

[codecov-img]: https://codecov.io/gh/javierbarbero/BenchmarkingEconomicEfficiency.jl/branch/main/graph/badge.svg
[codecov-url]: https://codecov.io/gh/javierbarbero/BenchmarkingEconomicEfficiency.jl


BenchmarkingEconomicEfficiency.jl is a Julia package that provides functions for economic efficiency measurement using Data Envelopment Analysis (DEA). The package is an extension of the [DataEnvelopmentAnalysis.jl](https://github.com/javierbarbero/DataEnvelopmentAnalysis.jl) package. The package is being developed for Julia `1.0` and above on Linux, macOS, and Windows. 

For the methodological understanding and empirical interpretation of the different models we refer the reader to the accompanying book: Pastor, Jesús T., Aparicio, Juan, & Zofío, José L. (2022), Benchmarking Economic Efficiency: Technical and Allocative Fundamentals, International Series in Operations Research & Management Science (ISOR, Vol. 346). Springer, Cham. https://doi.org/10.1007/978-3-030-84397-7.

The package uses internally the [JuMP](https://github.com/JuliaOpt/JuMP.jl) modelling language for mathematicall optimization with solvers [GLPK](http://www.gnu.org/software/glpk/) and [Ipopt](https://coin-or.github.io/Ipopt/).

## Installation

The package can be installed with the Julia package manager:
```julia
julia> using Pkg; Pkg.add("BenchmarkingEconomicEfficiency")
```

## Available models

**Profit DEA models**

* Profit Russell model.
* Profit Additive model.
* Profit Enhanced Russell Graph (or Slack Based) model.
* Profit Directional Distance Function model.
* Profit Hölder model.
* Profit Modified Directional Distance Function model.
* Profit Reverse Directional Distance Function model.
* Profit General Direct Approach model.

**Profitability DEA models**

* Profitability Efficiency measurement.

**Cost DEA models**

* Cost Radial model
* Cost Russell model.
* Cost Additive model.
* Cost Directional Distance Function model.
* Cost Hölder model.
* Cost Reverse Directional Distance Function model.
* Cost General Direct Approach model.

**Revenue DEA models**

* Revenue Radial model
* Revenue Russell model.
* Revenue Additive model.
* Revenue Directional Distance Function model.
* Revenue Hölder model.
* Revenue Reverse Directional Distance Function model.
* Revenue General Direct Approach model.

## Authors

BenchmarkingEconomicEfficiency.jl is being developed by [Javier Barbero](http://www.javierbarbero.net) and [José Luís Zofío](http://www.joselzofio.net).

