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
─────────────────────────────────────
       Profit   Technical  Allocative
─────────────────────────────────────
1  4.0         7.623e-7    4.0
2  0.5         8.28765e-8  0.5
3  5.68126e-8  4.78858e-8  8.92688e-9
4  0.166667    1.08205e-7  0.166667
5  1.33333     1.16667     0.166667
6  0.571429    0.571429    3.2471e-9
7  0.285714    0.142857    0.142857
8  2.69996     2.54994     0.150021
─────────────────────────────────────
```

Estimated economic, technical and allocative efficiency scores are returned with the `efficiency` function:
```jldoctest 1
julia> efficiency(profitmddf, :Economic)
8-element Vector{Float64}:
 4.000000227250586
 0.5000001136252932
 5.6812646587189874e-8
 0.16666670454176438
 1.3333334090835287
 0.5714286038929409
 0.28571431817865517
 2.699957597641558
```
```jldoctest 1
julia> efficiency(profitmddf, :Technical)
8-element Vector{Float64}:
 7.62299821585534e-7
 8.287654900253467e-8
 4.7885770009027296e-8
 1.0820468712138814e-7
 1.1666667530819783
 0.5714286006458399
 0.14285723362224123
 2.549936340615896
```
```jldoctest 1
julia> efficiency(profitmddf, :Allocative)
8-element Vector{Float64}:
 3.999999464950765
 0.5000000307487442
 8.926876578162579e-9
 0.16666659633707726
 0.1666666560015504
 3.2471010324996996e-9
 0.14285708455641394
 0.15002125702566182
```

### deaprofitmddf Function Documentation

```@docs
deaprofitmddf
```

