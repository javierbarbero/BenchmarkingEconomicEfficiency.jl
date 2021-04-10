```@meta
CurrentModule = BenchmarkingEconomicEfficiency
DocTestSetup = quote
    using BenchmarkingEconomicEfficiency
    deaprofitrussell([1; 2; 3], [1; 1; 2], [1; 1; 1], [1; 1;1])
end
```

# Profit Russell model

The profit Russell model is computed by solving a graph [Russell DEA model](https://javierbarbero.github.io/DataEnvelopmentAnalysis.jl/stable/technical/russell/) for the technical efficiency.

In this example we compute the profit efficiency Russell measure under variable returns to scale:
```jldoctest 1
julia> X = [2; 4; 8; 12; 6; 14; 14; 9.412];

julia> Y = [1; 5; 8; 9; 3; 7; 9; 2.353];

julia> W = [1; 1; 1; 1; 1; 1; 1; 1];

julia> P = [2; 2; 2; 2; 2; 2; 2; 2];

julia> profitrussell = deaprofitrussell(X, Y, W, P)
Russell Profit DEA Model 
DMUs = 8; Inputs = 1; Outputs = 1
Orientation = Graph; Returns to Scale = VRS
─────────────────────────────────────
       Profit   Technical  Allocative
─────────────────────────────────────
1  2.0         3.50173e-7  2.0
2  0.25        2.49141e-8  0.25
3  2.84063e-8  8.48991e-9  1.99164e-8
4  0.0833334   2.9862e-8   0.0833333
5  0.666667    0.366667    0.3
6  0.285714    0.276786    0.0089286
7  0.142857    0.0714286   0.0714286
8  1.34998     0.552205    0.797773
─────────────────────────────────────
```

Estimated economic, technical and allocative efficiency scores are returned with the `efficiency` function:
```jldoctest 1
julia> efficiency(profitrussell, :Economic)
8-element Vector{Float64}:
 2.000000113625293
 0.2500000568126466
 2.8406323293594937e-8
 0.08333335227088219
 0.6666667045417644
 0.28571430194647046
 0.14285715908932758
 1.349978798820779
```
```jldoctest 1
julia> efficiency(profitrussell, :Technical)
8-element Vector{Float64}:
 3.5017295285655337e-7
 2.4914090124283916e-8
 8.48991321689141e-9
 2.9861977113299076e-8
 0.36666667736489755
 0.2767857062834501
 0.07142859511479327
 0.5522053118262116
```
```jldoctest 1
julia> efficiency(profitrussell, :Allocative)
8-element Vector{Float64}:
 1.9999997634523403
 0.25000003189855646
 1.9916410076703528e-8
 0.08333332240890508
 0.3000000271768668
 0.008928595663020344
 0.07142856397453431
 0.7977734869945674
```

### deaprofitrussell Function Documentation

```@docs
deaprofitrussell
```

