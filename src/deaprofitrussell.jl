# This file contains functions for the Profit Efficiency Russell DEA model
"""
    ProfitRussellDEAModel
An data structure representing a profit Russell DEA model.
"""
struct ProfitRussellDEAModel <: AbstractProfitDEAModel
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
    deaprofitrussell(X, Y, W, P)
Compute profit efficiency using Russell data envelopment analysis for
inputs `X`, outputs `Y`, price of inputs `W`, and price of outputs `P`.

# Optional Arguments
- `monetary=false`: decomposition in normalized terms. Monetary terms if `true`.
- `names`: a vector of strings with the names of the decision making units.
"""
function deaprofitrussell(X::Union{Matrix,Vector}, Y::Union{Matrix,Vector}, 
    W::Union{Matrix,Vector}, P::Union{Matrix,Vector};
    monetary::Bool = false,
    names::Union{Vector{String},Nothing} = nothing,
    optimizer::Union{DEAOptimizer,Nothing} = nothing)::ProfitRussellDEAModel

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
        optimizer = DEAOptimizer(:NLP)
    end

    # Get maximum profit targets and lambdas
    n = nx

    Xtarget, Ytarget, plambdaeff = deamaxprofit(X, Y, W, P, optimizer = optimizer)

    # Profit, technical and allocative efficiency
    mno0 = sum(X .!= 0, dims = 2)
    sno0 = sum(Y .!= 0, dims = 2)

    maxprofit = sum(P .* Ytarget, dims = 2) .- sum(W .* Xtarget, dims = 2)

    pefficiency  = vec(maxprofit .- ( sum(P .* Y, dims = 2) .- sum(W .* X, dims = 2)))
    normalization = vec((m + s) * minimum([W .* X P .* Y], dims = 2))
    techefficiency =  1 .- efficiency(dearussell(X, Y, orient = :Graph, rts = :VRS, slack = false, optimizer = optimizer))

    if monetary
        techefficiency = techefficiency .* normalization
    else
        pefficiency = pefficiency ./ normalization 
    end

    allocefficiency = pefficiency - techefficiency

    return ProfitRussellDEAModel(n, m, s, monetary, names, pefficiency, plambdaeff, techefficiency, allocefficiency, normalization, Xtarget, Ytarget)

end

function Base.show(io::IO, x::ProfitRussellDEAModel)
    compact = get(io, :compact, false)

    n = nobs(x)
    m = ninputs(x)
    s = noutputs(x)
    dmunames = names(x)

    eff = efficiency(x)
    techeff = efficiency(x, :Technical)
    alloceff = efficiency(x, :Allocative)

    if !compact
        print(io, "Russell Profit DEA Model \n")
        print(io, "DMUs = ", n)
        print(io, "; Inputs = ", m)
        print(io, "; Outputs = ", s)
        print(io, "\n")
        print(io, "Orientation = Graph")
        print(io, "; Returns to Scale = VRS")
        print(io, "\n")
 
        show(io, CoefTable(hcat(eff, techeff, alloceff), ["Profit", "Technical", "Allocative"], dmunames))
    end

end
