```@meta
CurrentModule = BenchmarkingEconomicEfficiency
DocTestSetup = quote
    using BenchmarkingEconomicEfficiency
end
```

# Cost Hölder model

The cost Hölder model is computed by solving am input [Hölder distance function DEA model](https://javierbarbero.github.io/DataEnvelopmentAnalysis.jl/stable/technical/russell/) for the technical efficiency.

In this example we compute the Hölder L1 efficiency measure under variable returns to scale:
```jldoctest 1
julia> X = [2 2; 1 4; 4 1; 4 3; 5 5; 6 1; 2 5; 1.6 8];

julia> Y = [1; 1; 1; 1; 1; 1; 1; 1];

julia> W = [1 1; 1 1; 1 1; 1 1; 1 1; 1 1; 1 1; 1 1];

julia> costholderl1 = deacostholder(X, Y, W, l = 1)
Cost Hölder L1 DEA Model 
DMUs = 8; Inputs = 2; Outputs = 1
Orientation = Input; Returns to Scale = VRS
──────────────────────────────
   Cost  Technical  Allocative
──────────────────────────────
1   0.0        0.0         0.0
2   1.0        0.0         1.0
3   1.0        0.0         1.0
4   3.0        2.0         1.0
5   6.0        4.0         2.0
6   3.0        0.0         3.0
7   3.0        1.0         2.0
8   5.6        0.6         5.0
──────────────────────────────
```

Estimated economic, technical and allocative efficiency scores are returned with the `efficiency` function:
```jldoctest 1
julia> efficiency(costholderl1, :Economic)
8-element Vector{Float64}:
 0.0
 1.0
 1.0
 3.0
 6.0
 3.0
 3.0
 5.6
```
```jldoctest 1
julia> efficiency(costholderl1, :Technical)
8-element Vector{Float64}:
 0.0
 0.0
 0.0
 2.0
 4.0
 0.0
 1.0
 0.6000000000000001
```
```jldoctest 1
julia> efficiency(costholderl1, :Allocative)
8-element Vector{Float64}:
 0.0
 1.0
 1.0
 1.0
 2.0
 3.0
 2.0
 5.0
```

### deacostholder Function Documentation

```@docs
deacostholder
```

