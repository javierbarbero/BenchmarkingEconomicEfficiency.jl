```@meta
CurrentModule = BenchmarkingEconomicEfficiency
DocTestSetup = quote
    using BenchmarkingEconomicEfficiency
end
```

# Revenue Hölder model

The revenue Hölder model is computed by solving am output [Hölder DEA model](https://javierbarbero.github.io/DataEnvelopmentAnalysis.jl/stable/technical/russell/) for the technical efficiency.

In this example we compute the revenue efficiency Hölder L1 measure under variable returns to scale:
```jldoctest 1
julia> X = [1; 1; 1; 1; 1; 1; 1; 1];

julia> Y = [7 7; 4 8; 8 4; 3 5; 3 3; 8 2; 6 4; 1.5 5];

julia> P = [1 1; 1 1; 1 1; 1 1; 1 1; 1 1; 1 1; 1 1];

julia> revenueholder = dearevenueholder(X, Y, P, l = 1)
Revenue Hölder L1 DEA Model 
DMUs = 8; Inputs = 1; Outputs = 2
Orientation = Output; Returns to Scale = VRS
─────────────────────────────────
   Revenue  Technical  Allocative
─────────────────────────────────
1      0.0        0.0         0.0
2      2.0        0.0         2.0
3      2.0        0.0         2.0
4      6.0        3.0         3.0
5      8.0        5.0         3.0
6      4.0        0.0         4.0
7      4.0        2.0         2.0
8      7.5        3.0         4.5
─────────────────────────────────
```

Estimated economic, technical and allocative efficiency scores are returned with the `efficiency` function:
```jldoctest 1
julia> efficiency(revenueholder, :Economic)
8-element Vector{Float64}:
 0.0
 2.0
 2.0
 6.0
 8.0
 4.0
 4.0
 7.5
```
```jldoctest 1
julia> efficiency(revenueholder, :Technical)
8-element Vector{Float64}:
 0.0
 0.0
 0.0
 2.9999999999999996
 5.0
 0.0
 2.0
 2.9999999999999996
```
```jldoctest 1
julia> efficiency(revenueholder, :Allocative)
8-element Vector{Float64}:
 0.0
 2.0
 2.0
 3.0000000000000004
 3.0
 4.0
 2.0
 4.5
```

### dearevenueholder Function Documentation

```@docs
dearevenueholder
```

