```@meta
CurrentModule = BenchmarkingEconomicEfficiency
DocTestSetup = quote
    using BenchmarkingEconomicEfficiency
end
```

# Revenue Reverse Directional Distance Function model

In this example we compute the revenue efficiency Reverse directional distance function measure for the Enhanced Russell Graph associated efficiency measure under variable returns to scale:
```jldoctest 1
julia> X = [1; 1; 1; 1; 1; 1; 1; 1];

julia> Y = [7 7; 4 8; 8 4; 3 5; 3 3; 8 2; 6 4; 1.5 5];

julia> P = [1 1; 1 1; 1 1; 1 1; 1 1; 1 1; 1 1; 1 1];

julia> revenuerddf = dearevenuerddf(X, Y, P, :ERG)
Revenue Reverse DDF DEA Model 
DMUs = 8; Inputs = 1; Outputs = 2
Returns to Scale: VRS
Associated efficiency measure = ERG
────────────────────────────────────
    Revenue  Technical    Allocative
────────────────────────────────────
1  0.0        0.0        0.0
2  0.25       0.0        0.25
3  0.25       0.0        0.25
4  0.464286   0.464286   0.0
5  0.571429   0.571429   0.0
6  0.666667   0.333333   0.333333
7  0.314286   0.314286  -5.55112e-17
8  0.818182   0.672727   0.145455
────────────────────────────────────
```

Estimated economic, technical and allocative efficiency scores are returned with the `efficiency` function:
```jldoctest 1
julia> efficiency(revenuerddf, :Economic)
8-element Vector{Float64}:
 0.0
 0.25
 0.25
 0.4642857142857143
 0.5714285714285715
 0.6666666666666667
 0.3142857142857144
 0.8181818181818182
```
```jldoctest 1
julia> efficiency(revenuerddf, :Technical)
8-element Vector{Float64}:
 0.0
 0.0
 0.0
 0.4642857142857143
 0.5714285714285715
 0.33333333333333337
 0.31428571428571445
 0.6727272727272727
```
```jldoctest 1
julia> efficiency(revenuerddf, :Allocative)
8-element Vector{Float64}:
  0.0
  0.25
  0.25
  0.0
  0.0
  0.33333333333333337
 -5.551115123125783e-17
  0.1454545454545455
```

### dearevenuerddf Function Documentation

```@docs
dearevenuerddf
```

