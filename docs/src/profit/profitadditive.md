```@meta
CurrentModule = BenchmarkingEconomicEfficiency
DocTestSetup = quote
    using BenchmarkingEconomicEfficiency
end
```

# Profit Additive model

The profit additive model is computed by solving an [additive DEA model](https://javierbarbero.github.io/DataEnvelopmentAnalysis.jl/stable/technical/additive/) for the technical efficiency.

In this example we compute the profit efficiency additive measure under variable returns to scale:
```jldoctest 1
julia> X = [2; 4; 8; 12; 6; 14; 14; 9.412];

julia> Y = [1; 5; 8; 9; 3; 7; 9; 2.353];

julia> W = [1; 1; 1; 1; 1; 1; 1; 1];

julia> P = [1; 1; 1; 1; 1; 1; 1; 1];

julia> profitadd = deaprofitadd(X, Y, W, P, :Ones)
Profit Additive DEA Model 
DMUs = 8; Inputs = 1; Outputs = 1
Weights = Ones; Returns to Scale = VRS
─────────────────────────────────
   Profit  Technical   Allocative
─────────────────────────────────
1   2.0      0.0      2.0
2   0.0      0.0      0.0
3   1.0      0.0      1.0
4   4.0      0.0      4.0
5   4.0      4.0      8.88178e-16
6   8.0      7.33333  0.666667
7   6.0      2.0      4.0
8   8.059    8.059    0.0
─────────────────────────────────
```

Estimated economic, technical and allocative efficiency scores are returned with the `efficiency` function:
```jldoctest 1
julia> efficiency(profitadd, :Economic)
8-element Vector{Float64}:
 2.0
 0.0
 1.0
 4.0
 4.0
 8.0
 6.0
 8.059000000000001

julia> efficiency(profitadd, :Technical)
8-element Vector{Float64}:
 0.0
 0.0
 0.0
 0.0
 3.999999999999999
 7.333333333333333
 1.9999999999999944
 8.059000000000001

julia> efficiency(profitadd, :Allocative)
8-element Vector{Float64}:
 2.0
 0.0
 1.0
 4.0
 8.881784197001252e-16
 0.666666666666667
 4.000000000000005
 0.0
```

### deaprofitadd Function Documentation

```@docs
deaprofitadd
```

