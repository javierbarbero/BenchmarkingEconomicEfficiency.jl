```@meta
CurrentModule = BenchmarkingEconomicEfficiency
DocTestSetup = quote
    using BenchmarkingEconomicEfficiency
end
```

# Cost Additive model

The cost additive model is computed by solving an [additive DEA model](https://javierbarbero.github.io/DataEnvelopmentAnalysis.jl/stable/technical/additive/) for the technical efficiency.

In this example we compute the cost efficiency additive measure under variable returns to scale:
```jldoctest 1
julia> X = [2 2; 1 4; 4 1; 4 3; 5 5; 6 1; 2 5; 1.6 8];

julia> Y = [1; 1; 1; 1; 1; 1; 1; 1];

julia> W = [1 1; 1 1; 1 1; 1 1; 1 1; 1 1; 1 1; 1 1];

julia> costadd = deacostadd(X, Y, W, :Ones)
Cost Additive DEA Model 
DMUs = 8; Inputs = 2; Outputs = 1
Orientation = Input; Returns to Scale = VRS
Weights = Ones
──────────────────────────────
   Cost  Technical  Allocative
──────────────────────────────
1   0.0        0.0         0.0
2   1.0        0.0         1.0
3   1.0        0.0         1.0
4   3.0        3.0         0.0
5   6.0        6.0         0.0
6   3.0        2.0         1.0
7   3.0        3.0         0.0
8   5.6        5.2         0.4
──────────────────────────────
```

Estimated economic, technical and allocative efficiency scores are returned with the `efficiency` function:
```jldoctest 1
julia> efficiency(costadd, :Economic)
8-element Vector{Float64}:
 0.0
 1.0
 1.0
 3.0
 6.0
 3.0
 3.0
 5.6

julia> efficiency(costadd, :Technical)
8-element Vector{Float64}:
 0.0
 0.0
 0.0
 3.0
 6.0
 2.0000000000000004
 3.0
 5.200000000000001

julia> efficiency(costadd, :Allocative)
8-element Vector{Float64}:
 0.0
 1.0
 1.0
 0.0
 0.0
 0.9999999999999996
 0.0
 0.3999999999999986
```

### deacostadd Function Documentation

```@docs
deacostadd
```

