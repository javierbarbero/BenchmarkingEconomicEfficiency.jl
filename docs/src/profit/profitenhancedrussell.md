```@meta
CurrentModule = BenchmarkingEconomicEfficiency
DocTestSetup = quote
    using BenchmarkingEconomicEfficiency
end
```

# Profit Enhanced Russell Graph Slack Based Measure

The profit Enhanced Russell Graph Slack Based Measure is computed by solving an [Enhanced Russell Graph Slack Based Measure model](https://javierbarbero.github.io/DataEnvelopmentAnalysis.jl/stable/technical/enhancedrussell/) for the technical efficiency.

In this example we compute the profit efficiency Enhanced Russell Graph Slack Based measure under variable returns to scale:
```jldoctest 1
julia> X = [2; 4; 8; 12; 6; 14; 14; 9.412];

julia> Y = [1; 5; 8; 9; 3; 7; 9; 2.353];

julia> W = [1; 1; 1; 1; 1; 1; 1; 1];

julia> P = [2; 2; 2; 2; 2; 2; 2; 2];

julia> profiterg = deaprofiterg(X, Y, W, P)
Enhanced Russell Graph Slack Based Measure DEA Model 
DMUs = 8; Inputs = 1; Outputs = 1
Returns to Scale = VRS
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
8  1.2706     0.8         0.4706
──────────────────────────────────
```

Estimated economic, technical and allocative efficiency scores are returned with the `efficiency` function:
```jldoctest 1
julia> efficiency(profiterg, :Economic)
8-element Vector{Float64}:
 4.0
 0.5
 0.0
 0.16666666666666666
 0.8
 0.5714285714285714
 0.2857142857142857
 1.2705999999999997

julia> efficiency(profiterg, :Technical)
8-element Vector{Float64}:
 0.0
 0.0
 0.0
 0.0
 0.6000000000000001
 0.5238095238095238
 0.14285714285714257
 0.8

julia> efficiency(profiterg, :Allocative)
8-element Vector{Float64}:
 4.0
 0.5
 0.0
 0.16666666666666666
 0.19999999999999996
 0.04761904761904756
 0.14285714285714313
 0.4705999999999997
```

### deaprofiterg Function Documentation

```@docs
deaprofiterg
```

