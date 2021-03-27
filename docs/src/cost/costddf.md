```@meta
CurrentModule = BenchmarkingEconomicEfficiency
DocTestSetup = quote
    using BenchmarkingEconomicEfficiency
end
```

# Cost Directional Distance Function model

The cost directional distance function model is computed by solving a [directional distance function DEA model](https://javierbarbero.github.io/DataEnvelopmentAnalysis.jl/stable/technical/directional/) for the technical efficiency.

In this example we compute the cost efficiency directional distance function measure under variable returns to scale:
```jldoctest 1
julia> X = [2 2; 1 4; 4 1; 4 3; 5 5; 6 1; 2 5; 1.6 8];

julia> Y = [1; 1; 1; 1; 1; 1; 1; 1];

julia> W = [1 1; 1 1; 1 1; 1 1; 1 1; 1 1; 1 1; 1 1];

julia> costddf = deacostddf(X, Y, W, Gx = :Monetary)
Cost DDF DEA Model 
DMUs = 8; Inputs = 2; Outputs = 1
Orientation = Input; Returns to Scale = VRS
Gx = Monetary
──────────────────────────────
   Cost  Technical  Allocative
──────────────────────────────
1   0.0    0.0        0.0
2   1.0    0.0        1.0
3   1.0    0.0        1.0
4   3.0    2.66667    0.333333
5   6.0    6.0        0.0
6   3.0    0.0        3.0
7   3.0    2.0        1.0
8   5.6    1.2        4.4
──────────────────────────────
```

Estimated economic, technical and allocative efficiency scores are returned with the `efficiency` function:
```jldoctest 1
julia> efficiency(costddf, :Economic)
8-element Vector{Float64}:
 0.0
 1.0
 1.0
 3.0
 6.0
 3.0
 3.0
 5.6

julia> efficiency(costddf, :Technical)
8-element Vector{Float64}:
 0.0
 0.0
 0.0
 2.666666666666666
 6.0
 0.0
 2.0
 1.2000000000000002

julia> efficiency(costddf, :Allocative)
8-element Vector{Float64}:
 0.0
 1.0
 1.0
 0.3333333333333339
 0.0
 3.0
 1.0
 4.3999999999999995
```

### deacostddf Function Documentation

```@docs
deacostddf
```

