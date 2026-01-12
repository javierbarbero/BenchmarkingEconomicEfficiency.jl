```@meta
CurrentModule = BenchmarkingEconomicEfficiency
```
# Profitability Efficiency Change

**Example**

In this example we compute the profitability efficiency change:
```@example profitabilitych
using BenchmarkingEconomicEfficiency

X1 = [5 3; 2 4; 4 2; 4 8; 7 9]
Y1 = [7 4; 10 8; 8 10; 5 4; 3 6] 
W1 = [2 1; 2 1; 2 1; 2 1; 2 1]
P1 = [3 2; 3 2; 3 2; 3 2; 3 2]

X2 = [14 12; 8 10; 10 8; 16 20; 14 17]
Y2 = [18 10; 36 28; 28 36; 18 14; 12 20]
W2 = [3 4; 3 4; 3 4; 3 4; 3 4]
P2 = [3 5; 3 5; 3 5; 3 5; 3 5]

X = Array{Float64,3}(undef, 5, 2, 2);
X[:, :, 1] = X1;
X[:, :, 2] = X2;

Y = Array{Float64,3}(undef, 5, 2, 2);
Y[:, :, 1] = Y1;
Y[:, :, 2] = Y2;

W = Array{Float64,3}(undef, 5, 2, 2);
W[:, :, 1] = W1;
W[:, :, 2] = W2;

P = Array{Float64,3}(undef, 5, 2, 2);
P[:, :, 1] = P1;
P[:, :, 2] = P2;

profitabilityeffch = deaprofitabilitychange(X, Y, W, P)
```

Estimated economic, technical CRS and VRS, scale, and allocative efficiency change scores are returned with the `effchange` function:
```@example profitabilitych
effchange(profitabilityeffch, :Economic)
```

```@example profitabilitych
effchange(profitabilityeffch, :CRS)
```

```@example profitabilitych
effchange(profitabilityeffch, :VRS)
```

```@example profitabilitych
effchange(profitabilityeffch, :Scale)
```
```@example profitabilitych
effchange(profitabilityeffch, :Allocative)
```

### DEA Profitability Efficiency Change Function Documentation

```@docs
deaprofitabilitychange
effchange(::ProfitabilityChangeDEAModel, ::Symbol)
```
