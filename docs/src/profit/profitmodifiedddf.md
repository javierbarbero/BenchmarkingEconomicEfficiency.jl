```@meta
CurrentModule = BenchmarkingEconomicEfficiency
DocTestSetup = quote
    using BenchmarkingEconomicEfficiency
    deaprofitmddf([1; 2; 3], [1; 1; 2], [1; 1; 1], [1; 1;1], Gx = :Observed, Gy = :Observed)
end
```

# Profit Modified Directional Distance Function model

The profit Modified Directional Distance Function is computed by solving a [Modified Directional Distance Function model](https://javierbarbero.github.io/DataEnvelopmentAnalysis.jl/stable/technical/modifiedddf/) for the technical efficiency.

In this example we compute the profit Modified Directional Distance Function measure under variable returns to scale:
```jldoctest 1
julia> X = [2; 4; 8; 12; 6; 14; 14; 9.412];

julia> Y = [1; 5; 8; 9; 3; 7; 9; 2.353];

julia> W = [1; 1; 1; 1; 1; 1; 1; 1];

julia> P = [2; 2; 2; 2; 2; 2; 2; 2];

julia> profitmddf = deaprofitmddf(X, Y, W, P, Gx = :Observed, Gy = :Observed)
Profit Modified DDF DEA Model 
DMUs = 8; Inputs = 1; Outputs = 1
Returns to Scale = VRS
Gx = Observed; Gy = Observed
──────────────────────────────────
     Profit  Technical  Allocative
──────────────────────────────────
1  4.0        0.0         4.0
2  0.5        0.0         0.5
3  0.0        0.0         0.0
4  0.166667   0.0         0.166667
5  1.33333    1.16667     0.166667
6  0.571429   0.571429    0.0
7  0.285714   0.142857    0.142857
8  2.69996    2.54994     0.150021
──────────────────────────────────
```

Estimated economic, technical and allocative efficiency scores are returned with the `efficiency` function:
```jldoctest 1
julia> efficiency(profitmddf, :Economic)
8-element Vector{Float64}:
 4.0
 0.5
 0.0
 0.16666666666666666
 1.3333333333333333
 0.5714285714285714
 0.2857142857142857
 2.6999575010624732
```
```jldoctest 1
julia> efficiency(profitmddf, :Technical)
8-element Vector{Float64}:
 0.0
 0.0
 0.0
 0.0
 1.1666666666666665
 0.5714285714285714
 0.14285714285714285
 2.54993625159371
```
```jldoctest 1
julia> efficiency(profitmddf, :Allocative)
8-element Vector{Float64}:
 4.0
 0.5
 0.0
 0.16666666666666666
 0.16666666666666674
 0.0
 0.14285714285714285
 0.15002124946876316
```

### deaprofitmddf Function Documentation

```@docs
deaprofitmddf
```

