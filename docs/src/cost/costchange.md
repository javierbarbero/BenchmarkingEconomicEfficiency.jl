```@meta
CurrentModule = BenchmarkingEconomicEfficiency
```
# Cost Efficiency Change

**Example**

In this example we compute the cost efficiency change measure considering a choice of directional vector that returns cost inefficiency in monetary terms:
```@example costeffchddf
using BenchmarkingEconomicEfficiency

X1 = [5 3; 2 4; 4 2; 4 8; 7 9]
Y1 = [7 4; 10 8; 8 10; 5 4; 3 6] 
W1 = [2 1; 2 1; 2 1; 2 1; 2 1]

X2 = [14 12; 8 10; 10 8; 16 20; 14 17]
Y2 = [18 10; 36 28; 28 36; 18 14; 12 20]
W2 = [3 4; 3 4; 3 4; 3 4; 3 4]

X = Array{Float64,3}(undef, 5, 2, 2);
X[:, :, 1] = X1;
X[:, :, 2] = X2;

Y = Array{Float64,3}(undef, 5, 2, 2);
Y[:, :, 1] = Y1;
Y[:, :, 2] = Y2;

W = Array{Float64,3}(undef, 5, 2, 2);
W[:, :, 1] = W1;
W[:, :, 2] = W2;

costeffchddf = deacostchangeddf(X, Y, W, Gx = :Monetary)
```

Estimated economic, technical and allocative efficiency change scores are returned with the `effchange` function:
```@example costeffchddf
effchange(costeffchddf, :Economic)
```

```@example costeffchddf
effchange(costeffchddf, :Technical)
```

```@example costeffchddf
effchange(costeffchddf, :Allocative)
```

### DEA Cost Efficiency Change Functions Documentation

```@docs
deacostchange
deacostchangeadd
deacostchangerussell
deacostchangeddf
deacostchangeholder
deacostchangerddf
deacostchangegda
effchange(::CostChangeDEAModel, ::Symbol)
```
