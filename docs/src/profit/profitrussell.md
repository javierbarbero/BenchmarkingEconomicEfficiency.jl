```@meta
CurrentModule = BenchmarkingEconomicEfficiency
DocTestSetup = quote
    using BenchmarkingEconomicEfficiency
    deaprofitrussell([1; 2; 3], [1; 1; 2], [1; 1; 1], [1; 1;1])
end
```

# Profit Russell model

The cost Russell model is computed by solving a graph [Russell DEA model](https://javierbarbero.github.io/DataEnvelopmentAnalysis.jl/stable/technical/russell/) for the technical efficiency.

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
1  2.0         3.50176e-7  2.0
2  0.25        2.36616e-8  0.25
3  2.84063e-8  1.05742e-8  1.78321e-8
4  0.0833334   2.93062e-8  0.0833333
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

julia> efficiency(profitrussell, :Technical)
8-element Vector{Float64}:
 3.5017596855535515e-7
 2.3661629988680488e-8
 1.0574210618230495e-8
 2.9306198690015606e-8
 0.36666667736489766
 0.2767857062834501
 0.07142859511533883
 0.5522053118262116

julia> efficiency(profitrussell, :Allocative)
8-element Vector{Float64}:
 1.9999997634493245
 0.2500000331510166
 1.7832112675364442e-8
 0.0833333229646835
 0.3000000271768667
 0.008928595663020344
 0.07142856397398875
 0.7977734869945674
```

### deaprofitrussell Function Documentation

```@docs
deaprofitrussell
```

