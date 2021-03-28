```@meta
CurrentModule = BenchmarkingEconomicEfficiency
DocTestSetup = quote
    using BenchmarkingEconomicEfficiency
end
```

# Revenue Russell model

The revenue Russell model is computed by solving am output [Russell DEA model](https://javierbarbero.github.io/DataEnvelopmentAnalysis.jl/stable/technical/russell/) for the technical efficiency.

In this example we compute the revenue efficiency Russell measure under variable returns to scale:
```jldoctest 1
julia> X = [1; 1; 1; 1; 1; 1; 1; 1];

julia> Y = [7 7; 4 8; 8 4; 3 5; 3 3; 8 2; 6 4; 1.5 5];

julia> P = [1 1; 1 1; 1 1; 1 1; 1 1; 1 1; 1 1; 1 1];

julia> revenuerussell = dearevenuerussell(X, Y, P)
Russell Revenue DEA Model 
DMUs = 8; Inputs = 1; Outputs = 2
Orientation = Output; Returns to Scale = VRS
──────────────────────────────────
   Revenue  Technical   Allocative
──────────────────────────────────
1  0.0       0.0       0.0
2  0.25      0.0       0.25
3  0.25      0.0       0.25
4  1.0       0.866667  0.133333
5  1.33333   1.33333   2.22045e-16
6  1.0       0.5       0.5
7  0.5       0.458333  0.0416667
8  2.5       2.05556   0.444444
──────────────────────────────────
```

Estimated economic, technical and allocative efficiency scores are returned with the `efficiency` function:
```jldoctest 1
julia> efficiency(revenuerussell, :Economic)
8-element Vector{Float64}:
 0.0
 0.25
 0.25
 1.0
 1.3333333333333333
 1.0
 0.5
 2.5

julia> efficiency(revenuerussell, :Technical)
8-element Vector{Float64}:
 0.0
 0.0
 0.0
 0.8666666666666665
 1.333333333333333
 0.5
 0.4583333333333335
 2.0555555555555554

julia> efficiency(revenuerussell, :Allocative)
8-element Vector{Float64}:
 0.0
 0.25
 0.25
 0.13333333333333353
 2.220446049250313e-16
 0.5
 0.04166666666666652
 0.44444444444444464
```

### dearevenuerussell Function Documentation

```@docs
dearevenuerussell
```

