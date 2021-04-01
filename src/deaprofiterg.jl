# This file contains functions for the Profit Efficiency Enhanced Russell Graph Slack Based Measure DEA model
"""
    ProfitERGDEAModel
An data structure representing a profit Enhanced Russell Graph Slack Based Measure DEA model.
"""
struct ProfitERGDEAModel <: AbstractProfitDEAModel
    n::Int64
    m::Int64
    s::Int64
    monetary::Bool
    dmunames::Union{Vector{String},Nothing}
    eff::Vector
    lambda::SparseMatrixCSC{Float64, Int64}
    techeff::Vector
    alloceff::Vector
    normalization::Vector
    Xtarget::Matrix
    Ytarget::Matrix
end


"""
    deaprofiterg(X, Y, W, P)
Compute profit efficiency using data envelopment analysis Enhanced Russell Graph Slack Based Measure
model for inputs `X`, outputs `Y`, price of inputs `W`, and price of outputs `P`.

# Optional Arguments
- `names`: a vector of strings with the names of the decision making units.

# Examples
```jldoctest
julia> X = [2; 4; 8; 12; 6; 14; 14; 9.412];

julia> Y = [1; 5; 8; 9; 3; 7; 9; 2.353];

julia> W = [1; 1; 1; 1; 1; 1; 1; 1];

julia> P = [2; 2; 2; 2; 2; 2; 2; 2];

julia> deaprofiterg(X, Y, W, P)
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
"""
function deaprofiterg(X::Union{Matrix,Vector}, Y::Union{Matrix,Vector}, 
    W::Union{Matrix,Vector}, P::Union{Matrix,Vector};
    monetary::Bool = false,
    names::Union{Vector{String},Nothing} = nothing,
    optimizer::Union{DEAOptimizer,Nothing} = nothing)::ProfitERGDEAModel

    # Check parameters
    nx, m = size(X, 1), size(X, 2)
    ny, s = size(Y, 1), size(Y, 2)

    nw, mw = size(W, 1), size(W, 2)
    np, sp = size(P, 1), size(P, 2)

    if nx != ny
        throw(DimensionMismatch("number of rows in X and Y ($nx, $ny) are not equal"));
    end
    if nw != nx
        throw(DimensionMismatch("number of rows in W and X ($nw, $nx) are not equal"));
    end
    if np != ny
        throw(DimensionMismatch("number of rows in P and Y ($np, $ny) are not equal"));
    end
    if mw != m
        throw(DimensionMismatch("number of columns in W and X ($mw, $m) are not equal"));
    end
    if sp != s
        throw(DimensionMismatch("number of columns in P and Y ($sp, $s) are not equal"));
    end

    # Default optimizer
    if optimizer === nothing 
        optimizer = DEAOptimizer(GLPK.Optimizer)
    end

    # Get maximum profit targets and lambdas
    n = nx

    Xtarget, Ytarget, plambdaeff = deamaxprofit(X, Y, W, P, optimizer = optimizer)

    # Profit, technical and allocative efficiency
    maxprofit = sum(P .* Ytarget, dims = 2) .- sum(W .* Xtarget, dims = 2)
    pefficiency  = vec(maxprofit .- ( sum(P .* Y, dims = 2) .- sum(W .* X, dims = 2)))
    techergmodel = deaerg(X, Y, rts = :VRS, optimizer = optimizer)
    normalization = vec( minimum(hcat(m .* W .* X, s .* P .* Y), dims = 2) .* (1 .+ 1 ./ s .* sum(slacks(techergmodel, :Y) ./ Y, dims = 2)) )
    techefficiency = 1 .- efficiency(techergmodel)

    if monetary
        techefficiency = techefficiency .* normalization
    else
        pefficiency =  pefficiency ./ normalization 
    end

    allocefficiency = pefficiency - techefficiency

    return ProfitERGDEAModel(n, m, s, monetary, names, pefficiency, plambdaeff, techefficiency, allocefficiency, normalization, Xtarget, Ytarget)

end

function Base.show(io::IO, x::ProfitERGDEAModel)
    compact = get(io, :compact, false)

    n = nobs(x)
    m = ninputs(x)
    s = noutputs(x)
    dmunames = names(x)

    eff = efficiency(x)
    techeff = efficiency(x, :Technical)
    alloceff = efficiency(x, :Allocative)

    if !compact
        print(io, "Enhanced Russell Graph Slack Based Measure DEA Model \n")
        print(io, "DMUs = ", n)
        print(io, "; Inputs = ", m)
        print(io, "; Outputs = ", s)
        print(io, "\n")
        print(io, "Returns to Scale = VRS")
        print(io, "\n")
        show(io, CoefTable(hcat(eff, techeff, alloceff), ["Profit", "Technical", "Allocative"], dmunames))
    end
end
