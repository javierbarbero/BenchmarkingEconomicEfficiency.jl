# This file contains functions for the Profit Efficiency Hölder DEA model
"""
    ProfitHolderDEAModel
An data structure representing a profit SBM DEA model.
"""
struct ProfitHolderDEAModel <: AbstractProfitDEAModel
    n::Int64
    m::Int64
    s::Int64
    l::Union{Int64,Float64}
    isweighted::Bool
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
    deaprofitholder(X, Y, W, P; l)
Compute profit efficiency using data envelopment analysis Hölder model for
inputs `X`, outputs `Y`, price of inputs `W`, and price of outputs `P`.

# Hölder norm `l` specification
- `1`.
- `2`.
- `Inf`.

# Optional Arguments
- `names`: a vector of strings with the names of the decision making units.

# Examples
```jldoctest
julia> X = [1 1; 1 1; 0.75 1.5; 0.5 2; 0.5 2; 2 2; 2.75 3.5; 1.375 1.75];

julia> Y = [1 11; 5 3; 5 5; 2 9; 4 5; 4 2; 3 3; 4.5 3.5];

julia> P = [2 1; 2 1; 2 1; 2 1; 2 1; 2 1; 2 1; 2 1];

julia> W = [2 1; 2 1; 2 1; 2 1; 2 1; 2 1; 2 1; 2 1];

julia> deaprofitholder(X, Y, W, P, l = 1)
Profit Hölder L1 DEA Model 
DMUs = 8; Inputs = 2; Outputs = 2
Returns to Scale = VRS
───────────────────────────────────
   Profit     Technical  Allocative
───────────────────────────────────
1     1.0   0.0                 1.0
2     1.0  -1.44329e-15         1.0
3     0.0   0.0                 0.0
4     1.0   0.0                 1.0
5     1.0   0.0                 1.0
6     4.0   1.0                 3.0
7     6.0   2.0                 4.0
8     2.0   0.5                 1.5
───────────────────────────────────
```
"""
function deaprofitholder(X::Union{Matrix,Vector}, Y::Union{Matrix,Vector},
    W::Union{Matrix,Vector}, P::Union{Matrix,Vector};
    l::Union{Int64,Float64}, weight::Bool = false, monetary::Bool = false,
    names::Union{Vector{String},Nothing} = nothing,
    optimizer::Union{DEAOptimizer,Nothing} = nothing)::ProfitHolderDEAModel

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

    if l != 1 && l != 2 && l != Inf
        throw(ArgumentError("l must by :1, :2, or :Inf"));
    end

    # Default optimizer
    if optimizer === nothing 
        optimizer = DEAOptimizer(:LP)
    end   

    # Get maximum profit targets and lambdas
    n = nx

    Xtarget, Ytarget, plambdaeff = deamaxprofit(X, Y, W, P, optimizer = optimizer)

    # Profit, technical and allocative efficiency
    maxprofit = sum(P .* Ytarget, dims = 2) .- sum(W .* Xtarget, dims = 2)

    pefficiency  = vec(maxprofit .- ( sum(P .* Y, dims = 2) .- sum(W .* X, dims = 2)))
    
    if weight
        if l == 1
            normalization = maximum([(P .* Y) (W .* X)], dims = 2)
        elseif l == 2
            normalization = sqrt.(sum((P .* Y).^2, dims = 2) .+ sum((W .* X).^2, dims = 2))
        elseif l == Inf
            normalization = sum(P .* Y, dims = 2) .+ sum(W .* X, dims = 2)
        end
    else
        if l == 1
            normalization = maximum([P W], dims = 2)
        elseif l == 2
            normalization = sqrt.(sum(P.^2, dims = 2) .+ sum(W.^2, dims = 2))
        elseif l == Inf
            normalization = sum(P, dims = 2) .+ sum(W, dims = 2)
        end
    end
    normalization = vec(normalization)
    
    techefficiency = efficiency(deaholder(X, Y, l = l, weight = weight, orient = :Graph, rts = :VRS, slack = false, optimizer = optimizer))

    if monetary
        techefficiency = techefficiency .* normalization
    else
        pefficiency = pefficiency ./ normalization
    end

    allocefficiency = pefficiency - techefficiency

    return ProfitHolderDEAModel(n, m, s, l, weight, monetary, names, pefficiency, plambdaeff, techefficiency, allocefficiency, normalization, Xtarget, Ytarget)

end

function Base.show(io::IO, x::ProfitHolderDEAModel)
    compact = get(io, :compact, false)

    n = nobs(x)
    m = ninputs(x)
    s = noutputs(x)
    l = x.l
    isweighted = x.isweighted
    dmunames = names(x)

    eff = efficiency(x)
    techeff = efficiency(x, :Technical)
    alloceff = efficiency(x, :Allocative)

    if !compact
        print(io, "Profit Hölder L", string(l), " DEA Model \n")
        print(io, "DMUs = ", n)
        print(io, "; Inputs = ", m)
        print(io, "; Outputs = ", s)
        print(io, "\n")
        print(io, "Returns to Scale = VRS")
        print(io, "\n")
        if isweighted
            print(io, "Weighted (weakly) Hölder distance function \n")
        end
        show(io, CoefTable(hcat(eff, techeff, alloceff), ["Profit", "Technical", "Allocative"], dmunames))
    end
end
