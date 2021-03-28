```@meta
CurrentModule = BenchmarkingEconomicEfficiency
DocTestSetup = quote
    using BenchmarkingEconomicEfficiency
end
```

# Revenue Additive model

The revenue additive model is computed by solving an [additive DEA model](https://javierbarbero.github.io/DataEnvelopmentAnalysis.jl/stable/technical/additive/) for the technical efficiency.

In this example we compute the revenue efficiency additive measure under variable returns to scale:
```jldoctest 1
julia> X = [1; 1; 1; 1; 1; 1; 1; 1];

julia> Y = [7 7; 4 8; 8 4; 3 5; 3 3; 8 2; 6 4; 1.5 5];

julia> P = [1 1; 1 1; 1 1; 1 1; 1 1; 1 1; 1 1; 1 1];

julia> revenueadd = dearevenueadd(X, Y, P, :Ones)
Revenue Additive DEA Model 
DMUs = 8; Inputs = 1; Outputs = 2
Orientation = Output; Returns to Scale = VRS
Weights = Ones
───────────────────────────────────
   Revenue  Technical    Allocative
───────────────────────────────────
1      0.0        0.0   0.0
2      2.0        0.0   2.0
3      2.0        0.0   2.0
4      6.0        6.0   0.0
5      8.0        8.0   0.0
6      4.0        2.0   2.0
7      4.0        4.0  -8.88178e-16
8      7.5        7.5   0.0
───────────────────────────────────
```

Estimated economic, technical and allocative efficiency scores are returned with the `efficiency` function:
```jldoctest 1
julia> efficiency(revenueadd, :Economic)
8-element Vector{Float64}:
 0.0
 2.0
 2.0
 6.0
 8.0
 4.0
 4.0
 7.5

julia> efficiency(revenueadd, :Technical)
8-element Vector{Float64}:
 0.0
 0.0
 0.0
 6.0
 8.0
 2.0000000000000004
 4.000000000000001
 7.5

julia> efficiency(revenueadd, :Allocative)
8-element Vector{Float64}:
  0.0
  2.0
  2.0
  0.0
  0.0
  1.9999999999999996
 -8.881784197001252e-16
  0.0
```

### dearevenueadd Function Documentation

```@docs
dearevenueadd
```

