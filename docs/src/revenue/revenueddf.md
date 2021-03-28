```@meta
CurrentModule = BenchmarkingEconomicEfficiency
DocTestSetup = quote
    using BenchmarkingEconomicEfficiency
end
```

# Revenue Directional Distance Function model

The revenue directional distance function model is computed by solving a [directional distance function DEA model](https://javierbarbero.github.io/DataEnvelopmentAnalysis.jl/stable/technical/directional/) for the technical efficiency.

In this example we compute the revenue efficiency directional distance function measure under variable returns to scale:
```jldoctest 1
julia> X = [1; 1; 1; 1; 1; 1; 1; 1];

julia> Y = [7 7; 4 8; 8 4; 3 5; 3 3; 8 2; 6 4; 1.5 5];

julia> P = [1 1; 1 1; 1 1; 1 1; 1 1; 1 1; 1 1; 1 1];

julia> revenueddf = dearevenueddf(X, Y, P, Gy = :Monetary)
Revenue DDF DEA Model 
DMUs = 8; Inputs = 1; Outputs = 2
Orientation = Output; Returns to Scale = VRS
Gy = Monetary
─────────────────────────────────
   Revenue  Technical  Allocative
─────────────────────────────────
1      0.0       0.0         0.0
2      2.0       0.0         2.0
3      2.0       0.0         2.0
4      6.0       5.0         1.0
5      8.0       8.0         0.0
6      4.0       0.0         4.0
7      4.0       3.0         1.0
8      7.5       5.75        1.75
─────────────────────────────────
```

Estimated economic, technical and allocative efficiency scores are returned with the `efficiency` function:
```jldoctest 1
julia> efficiency(revenueddf, :Economic)
8-element Vector{Float64}:
 0.0
 2.0
 2.0
 6.0
 8.0
 4.0
 4.0
 7.5

julia> efficiency(revenueddf, :Technical)
8-element Vector{Float64}:
 0.0
 0.0
 0.0
 5.0
 8.0
 0.0
 3.0000000000000004
 5.749999999999999

julia> efficiency(revenueddf, :Allocative)
8-element Vector{Float64}:
 0.0
 2.0
 2.0
 1.0
 0.0
 4.0
 0.9999999999999996
 1.7500000000000009
```

### dearevenueddf Function Documentation

```@docs
dearevenueddf
```

