```@meta
CurrentModule = BenchmarkingEconomicEfficiency
```
# Profit Efficiency Change

**Example**

In this example we compute the profit efficiency change measure considering a choice of directional vector that returns profit inefficiency in monetary terms:
```@example profitchddf
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

profteffchddf = deaprofitchange(X, Y, W, P, Gx = :Monetary, Gy = :Monetary)
```

Estimated economic, technical and allocative efficiency change scores are returned with the `effchange` function:
```@example profitchddf
effchange(profteffchddf, :Economic)
```

```@example profitchddf
effchange(profteffchddf, :Technical)
```

```@example profitchddf
effchange(profteffchddf, :Allocative)
```

### DEA Profit Efficiency Change Functions Documentation

```@docs
deaprofitchangeadd
deaprofitchangerussell
deaprofitchangeerg
deaprofitchange
deaprofitchangeholder
deaprofitchangemddf
deaprofitchangerddf
deaprofitchangegda
effchange(::ProfitChangeDEAModel, ::Symbol)
```
