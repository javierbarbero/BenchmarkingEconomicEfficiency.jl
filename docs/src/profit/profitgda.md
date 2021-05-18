```@meta
CurrentModule = BenchmarkingEconomicEfficiency
DocTestSetup = quote
    using BenchmarkingEconomicEfficiency
end
```

# Profit General Direct Approach model

In this example we compute the profit efficiency General Direct Approach measure for the Enhanced Russell Graph associated efficiency measure under variable returns to scale:
```jldoctest 1
julia> X = [2; 4; 8; 12; 6; 14; 14; 9.412];

julia> Y = [1; 5; 8; 9; 3; 7; 9; 2.353];

julia> W = [1; 1; 1; 1; 1; 1; 1; 1];

julia> P = [2; 2; 2; 2; 2; 2; 2; 2];

julia> profitgda = deaprofitgda(X, Y, W, P, :ERG)
General Direct Approach Profit DEA Model 
DMUs = 8; Inputs = 1; Outputs = 1
Returns to Scale = VRS
Associated efficiency measure = ERG
──────────────────────────────────
     Profit  Technical  Allocative
──────────────────────────────────
1  4.0        0.0         4.0
2  0.5        0.0         0.5
3  0.0        0.0         0.0
4  0.166667   0.0         0.166667
5  0.8        0.6         0.2
6  0.571429   0.52381     0.047619
7  0.285714   0.142857    0.142857
8  0.949449   0.8         0.149449
──────────────────────────────────
```

Estimated economic, technical and allocative efficiency scores are returned with the `efficiency` function:
```jldoctest 1
julia> efficiency(profitgda, :Economic)
8-element Vector{Float64}:
 4.0
 0.5
 0.0
 0.16666666666666666
 0.8000000000000002
 0.5714285714285715
 0.2857142857142859
 0.9494489071548665
```
```jldoctest 1
julia> efficiency(profitgda, :Technical)
8-element Vector{Float64}:
 0.0
 0.0
 0.0
 0.0
 0.6000000000000001
 0.5238095238095238
 0.14285714285714257
 0.8
```
```jldoctest 1
julia> efficiency(profitgda, :Allocative)
8-element Vector{Float64}:
 4.0
 0.5
 0.0
 0.16666666666666666
 0.20000000000000004
 0.047619047619047644
 0.14285714285714332
 0.14944890715486644
```

### deaprofitgda Function Documentation

```@docs
deaprofitgda
```

