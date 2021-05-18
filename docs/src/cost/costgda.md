```@meta
CurrentModule = BenchmarkingEconomicEfficiency
DocTestSetup = quote
    using BenchmarkingEconomicEfficiency
end
```

# Cost General Direct Approach model

In this example we compute the cost efficiency General Direct Approach measure for the Enhanced Russell Graph associated efficiency measure under variable returns to scale:
```jldoctest 1
julia> X = [2 2; 1 4; 4 1; 4 3; 5 5; 6 1; 2 5; 1.6 8];

julia> Y = [1; 1; 1; 1; 1; 1; 1; 1];

julia> W = [1 1; 1 1; 1 1; 1 1; 1 1; 1 1; 1 1; 1 1];

julia> costgda = deacostgda(X, Y, W, :ERG)
General Direct Approach Cost DEA Model 
DMUs = 8; Inputs = 2; Outputs = 1
Returns to Scale = VRS
Associated efficiency measure = ERG
──────────────────────────────────
       Cost  Technical  Allocative
──────────────────────────────────
1  0.0        0.0        0.0
2  0.5        0.0        0.5
3  0.5        0.0        0.5
4  0.416667   0.416667   0.0
5  0.6        0.6        0.0
6  0.25       0.166667   0.0833333
7  0.525      0.35       0.175
8  0.532609   0.4375     0.0951087
──────────────────────────────────
```

Estimated economic, technical and allocative efficiency scores are returned with the `efficiency` function:
```jldoctest 1
julia> efficiency(costgda, :Economic)
8-element Vector{Float64}:
 0.0
 0.5
 0.5
 0.41666666666666663
 0.6
 0.24999999999999992
 0.525
 0.5326086956521738
```
```jldoctest 1
julia> efficiency(costgda, :Technical)
8-element Vector{Float64}:
 0.0
 0.0
 0.0
 0.41666666666666663
 0.6
 0.16666666666666663
 0.35
 0.4375
```
```jldoctest 1
julia> efficiency(costgda, :Allocative)
8-element Vector{Float64}:
 0.0
 0.5
 0.5
 0.0
 0.0
 0.08333333333333331
 0.175
 0.09510869565217392
```

### deacostgda Function Documentation

```@docs
deacostgda
```

