```@meta
CurrentModule = BenchmarkingEconomicEfficiency
DocTestSetup = quote
    using BenchmarkingEconomicEfficiency
end
```

# Profit Hölder model

The profit Hölder model is computed by solving a graph [Hölder DEA model](https://javierbarbero.github.io/DataEnvelopmentAnalysis.jl/stable/technical/russell/) for the technical efficiency.

In this example we compute the profit efficiency Hölder L1 measure under variable returns to scale:
```jldoctest 1
julia> X = [2; 4; 8; 12; 6; 14; 14; 9.412];

julia> Y = [1; 5; 8; 9; 3; 7; 9; 2.353];

julia> W = [1; 1; 1; 1; 1; 1; 1; 1];

julia> P = [2; 2; 2; 2; 2; 2; 2; 2];

julia> profitholderl1 = deaprofitholder(X, Y, W, P, l = 1)
Profit Hölder L1 DEA Model 
DMUs = 8; Inputs = 1; Outputs = 1
Returns to Scale = VRS
────────────────────────────────
   Profit  Technical  Allocative
────────────────────────────────
1   4.0          0.0       4.0
2   1.0          0.0       1.0
3   0.0          0.0       0.0
4   1.0          0.0       1.0
5   4.0          3.0       1.0
6   4.0          2.0       2.0
7   2.0          0.0       2.0
8   6.353        6.0       0.353
────────────────────────────────
```

Estimated economic, technical and allocative efficiency scores are returned with the `efficiency` function:
```jldoctest 1
julia> efficiency(profitholderl1, :Economic)
8-element Vector{Float64}:
 4.0
 1.0
 0.0
 1.0
 4.0
 4.0
 2.0
 6.353
```
```jldoctest 1
julia> efficiency(profitholderl1, :Technical)
8-element Vector{Float64}:
 0.0
 0.0
 0.0
 0.0
 2.9999999999999996
 2.000000000000001
 0.0
 6.0
```
```jldoctest 1
julia> efficiency(profitholderl1, :Allocative)
8-element Vector{Float64}:
 4.0
 1.0
 0.0
 1.0
 1.0000000000000004
 1.9999999999999991
 2.0
 0.35299999999999976
```

### deaprofitholder Function Documentation

```@docs
deaprofitholder
```

