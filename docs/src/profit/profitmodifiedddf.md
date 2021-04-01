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
1  4.0         7.62306e-7   4.0
2  0.5         8.2947e-8    0.5
3  5.68126e-8  4.71577e-8   9.6549e-9
4  0.166667    1.08317e-7   0.166667
5  1.33333     1.16667      0.166667
6  0.571429    0.571429     3.2471e-9
7  0.285714    0.142857     0.142857
8  2.69996     2.54994      0.150021
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

julia> efficiency(profitmddf, :Technical)
8-element Vector{Float64}:
 7.623057957088545e-7
 8.294696288324726e-8
 4.7157742273940495e-8
 1.0831700031028941e-7
 1.166666753081978
 0.5714286006458398
 0.14285723362224062
 2.549936340615896

julia> efficiency(profitmddf, :Allocative)
8-element Vector{Float64}:
 3.9999994649447905
 0.5000000306783303
 9.654904313249379e-9
 0.16666659622476407
 0.16666665600155062
 3.247101143522002e-9
 0.14285708455641455
 0.15002125702566182
```

### deaprofitmddf Function Documentation

```@docs
deaprofitmddf
```

