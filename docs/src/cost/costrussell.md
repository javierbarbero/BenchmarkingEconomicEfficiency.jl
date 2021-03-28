```@meta
CurrentModule = BenchmarkingEconomicEfficiency
DocTestSetup = quote
    using BenchmarkingEconomicEfficiency
end
```

# Cost Russell model

The cost Russell model is computed by solving am input [Russell DEA model](https://javierbarbero.github.io/DataEnvelopmentAnalysis.jl/stable/technical/russell/) for the technical efficiency.

In this example we compute the cost efficiency Russell measure under variable returns to scale:
```jldoctest 1
julia> X = [2 2; 1 4; 4 1; 4 3; 5 5; 6 1; 2 5; 1.6 8];

julia> Y = [1; 1; 1; 1; 1; 1; 1; 1];

julia> W = [1 1; 1 1; 1 1; 1 1; 1 1; 1 1; 1 1; 1 1];

julia> costrussell = deacostrussell(X, Y, W)
Russell Cost DEA Model 
DMUs = 8; Inputs = 2; Outputs = 1
Orientation = Input; Returns to Scale = VRS
──────────────────────────────
   Cost  Technical  Allocative
──────────────────────────────
1  0.0    0.0        0.0
2  0.5    0.0        0.5
3  0.5    0.0        0.5
4  0.5    0.416667   0.0833333
5  0.6    0.6        0.0
6  1.5    0.166667   1.33333
7  0.75   0.35       0.4
8  1.75   0.4375     1.3125
──────────────────────────────
```

Estimated economic, technical and allocative efficiency scores are returned with the `efficiency` function:
```jldoctest 1
julia> efficiency(costrussell, :Economic)
8-element Vector{Float64}:
 0.0
 0.5
 0.5
 0.5
 0.6
 1.5
 0.75
 1.7499999999999998

julia> efficiency(costrussell, :Technical)
8-element Vector{Float64}:
 0.0
 0.0
 0.0
 0.41666666666666663
 0.6
 0.16666666666666663
 0.35
 0.4375

julia> efficiency(costrussell, :Allocative)
8-element Vector{Float64}:
 0.0
 0.5
 0.5
 0.08333333333333337
 0.0
 1.3333333333333335
 0.4
 1.3124999999999998
```

### deacostrussell Function Documentation

```@docs
deacostrussell
```

