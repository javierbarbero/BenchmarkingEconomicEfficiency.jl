```@meta
CurrentModule = BenchmarkingEconomicEfficiency
DocTestSetup = quote
    using BenchmarkingEconomicEfficiency
end
```

# Revenue General Direct Approach model

In this example we compute the revenue efficiency General Direct Approach measure for the Enhanced Russell Graph associated efficiency measure under variable returns to scale:
```jldoctest 1
julia> X = [1; 1; 1; 1; 1; 1; 1; 1];

julia> Y = [7 7; 4 8; 8 4; 3 5; 3 3; 8 2; 6 4; 1.5 5];

julia> P = [1 1; 1 1; 1 1; 1 1; 1 1; 1 1; 1 1; 1 1];

julia> revenuerddf = dearevenuegda(X, Y, P, :ERG)
General Direct Approach Revenue DEA Model 
DMUs = 8; Inputs = 1; Outputs = 2
Returns to Scale = VRS
Associated efficiency measure = ERG
───────────────────────────────────
    Revenue  Technical   Allocative
───────────────────────────────────
1  0.0        0.0       0.0
2  0.25       0.0       0.25
3  0.25       0.0       0.25
4  0.866667   0.866667  0.0
5  1.33333    1.33333   2.96059e-16
6  1.0        0.5       0.5
7  0.458333   0.458333  0.0
8  2.5        2.05556   0.444444
───────────────────────────────────
```

Estimated economic, technical and allocative efficiency scores are returned with the `efficiency` function:
```jldoctest 1
julia> efficiency(revenuerddf, :Economic)
8-element Vector{Float64}:
 0.0
 0.25
 0.25
 0.8666666666666666
 1.3333333333333333
 1.0
 0.4583333333333335
 2.5
```
```jldoctest 1
julia> efficiency(revenuerddf, :Technical)
8-element Vector{Float64}:
 0.0
 0.0
 0.0
 0.8666666666666665
 1.333333333333333
 0.5
 0.4583333333333335
 2.0555555555555554
```
```jldoctest 1
julia> efficiency(revenuerddf, :Allocative)
8-element Vector{Float64}:
 0.0
 0.25
 0.25
 0.0
 2.9605947323337506e-16
 0.5
 0.0
 0.44444444444444464
```

### dearevenuegda Function Documentation

```@docs
dearevenuegda
```

