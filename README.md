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


BenchmarkingEconomicEfficiency.jl is a Julia package that provides functions for economic efficiency measurement using Data Envelopment Analysis (DEA). The package is an extension of the [DataEnvelopmentAnalysis.jl](https://github.com/javierbarbero/DataEnvelopmentAnalysis.jl) package.

The package is being developed for Julia `1.0` and above on Linux, macOS, and Windows.

The packes uses internally the [JuMP](https://github.com/JuliaOpt/JuMP.jl) modelling language for mathematicall optimization with solvers [GLPK](http://www.gnu.org/software/glpk/) and [Ipopt](https://coin-or.github.io/Ipopt/).

## Installation

The package can be installed with the Julia package manager:
```julia
julia> using Pkg; Pkg.add("BenchmarkingEconomicEfficiency")
```

## Available models

**Cost DEA models**

* Cost Directional Distance Function model.
* Cost Additive model.
* Cost Russell model.
* Cost Hölder model.
* Cost Reverse Directional Distance Function model.
* Cost General Direct Approach model.

**Revenue DEA models**

* Revenue Directional Distance Function model.
* Revenue Additive model.
* Revenue Russell model.
* Revenue Hölder model.
* Revenue Reverse Directional Distance Function model.
* Revenue General Direct Approach model.

**Profit DEA models**

* Profit Additive model.
* Profit Russell model.
* Profit Enhanced Russell Graph Slack Based Measure
* Profit Modified Directional Distance Function model.
* Profit Hölder model.
* Profit Reverse Directional Distance Function model.
* Profit General Direct Approach model.

## Authors

BenchmarkingEconomicEfficiency.jl is being developed by [Javier Barbero](http://www.javierbarbero.net) and [José Luís Zofío](http://www.joselzofio.net).

