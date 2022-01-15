# This file contains functions for the Cost Efficiency Russell DEA model
"""
    CostRussellDEAModel
An data structure representing a cost Russell DEA model.
"""
struct CostRussellDEAModel <: AbstractCostDEAModel
    n::Int64
    m::Int64
    s::Int64
    rts::Symbol
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
    deacostrussell(X, Y, W)
Compute cost efficiency using Russell data envelopment analysis for
inputs `X`, outputs `Y` and price of inputs `W`.

# Optional Arguments
- `rts=:VRS`: chooses variable returns to scale. For constant returns to scale choose `:CRS`.
- `monetary=false`: decomposition in normalized terms. Monetary terms if `true`.
- `names`: a vector of strings with the names of the decision making units.
"""
function deacostrussell(X::Union{Matrix,Vector}, Y::Union{Matrix,Vector}, 
    W::Union{Matrix,Vector}; rts::Symbol = :VRS,
    monetary::Bool = false,
    names::Union{Vector{<: AbstractString},Nothing} = nothing,
    optimizer::Union{DEAOptimizer,Nothing} = nothing)::CostRussellDEAModel

    # Check parameters
    nx, m = size(X, 1), size(X, 2)
    ny, s = size(Y, 1), size(Y, 2)

    nw, mw = size(W, 1), size(W, 2)

    if nx != ny
        throw(DimensionMismatch("number of rows in X and Y ($nx, $ny) are not equal"));
    end
    if nw != nx
        throw(DimensionMismatch("number of rows in W and X ($nw, $nx) are not equal"));
    end
    if mw != m
        throw(DimensionMismatch("number of columns in W and X ($mw, $m) are not equal"));
    end

    # Default optimizer
    if optimizer === nothing 
        optimizer = DEAOptimizer(:LP)
    end

    # Get minimum cost targets and lambdas
    n = nx

    Xtarget, clambdaeff = deamincost(X, Y, W, rts = rts, dispos = :Strong, optimizer = optimizer)
    Ytarget = Y[:,:]

    # Cost, technical and allocative efficiency
    WX = W .* X
    WX[WX .== 0] .= WX[WX .== 0] .+ Inf
    mno0 = sum(X .!= 0, dims = 2)

    cefficiency  = vec( sum(W .* X, dims = 2) - sum(W .* Xtarget, dims = 2)  ) 
    normalization = vec(mno0 .* minimum(WX, dims = 2) )
    techefficiency = 1 .- efficiency(dearussell(X, Y, orient = :Input, rts = rts, slack = false, optimizer = optimizer)) 

    if monetary
        techefficiency = techefficiency .* normalization
    else
        cefficiency = cefficiency ./ normalization
    end

    allocefficiency = cefficiency .- techefficiency

    return CostRussellDEAModel(n, m, s, rts, monetary, names, cefficiency, clambdaeff, techefficiency, allocefficiency, normalization, Xtarget, Ytarget)
end

function Base.show(io::IO, x::CostRussellDEAModel)
    compact = get(io, :compact, false)

    n = nobs(x)
    m = ninputs(x)
    s = noutputs(x)
    dmunames = names(x)

    eff = efficiency(x)
    techeff = efficiency(x, :Technical)
    alloceff = efficiency(x, :Allocative)

    if !compact
        print(io, "Russell Cost DEA Model \n")
        print(io, "DMUs = ", n)
        print(io, "; Inputs = ", m)
        print(io, "; Outputs = ", s)
        print(io, "\n")
        print(io, "Orientation = Input")
        print(io, "; Returns to Scale = ", string(x.rts))
        print(io, "\n")

        show(io, CoefTable(hcat(eff, techeff, alloceff), ["Cost", "Technical", "Allocative"], dmunames))

    end
    
end
