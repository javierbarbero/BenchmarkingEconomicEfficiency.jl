# This file contains functions for the Revenue Efficiency Russell DEA model
"""
    RevenueRussellDEAModel
An data structure representing a revenue Russell DEA model.
"""
struct RevenueRussellDEAModel <: AbstractRevenueDEAModel
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
    dearevenuerussell(X, Y, P)
Compute revenue efficiency using Russell data envelopment analysis for
inputs `X`, outputs `Y` and price of outputs `P`.

# Optional Arguments
- `rts=:VRS`: chooses variable returns to scale. For constant returns to scale choose `:CRS`.
- `monetary=false`: decomposition in normalized terms. Monetary terms if `true`.
- `names`: a vector of strings with the names of the decision making units.
"""
function dearevenuerussell(X::Union{Matrix,Vector}, Y::Union{Matrix,Vector}, 
    P::Union{Matrix,Vector}; rts::Symbol = :VRS,
    monetary::Bool = false,
    names::Union{Vector{<: AbstractString},Nothing} = nothing,
    optimizer::Union{DEAOptimizer,Nothing} = nothing)::RevenueRussellDEAModel

    # Check parameters
    nx, m = size(X, 1), size(X, 2)
    ny, s = size(Y, 1), size(Y, 2)

    np, sp = size(P, 1), size(P, 2)

    if nx != ny
        throw(DimensionMismatch("number of rows in X and Y ($nx, $ny) are not equal"));
    end
    if np != ny
        throw(DimensionMismatch("number of rows in P and Y ($np, $ny) are not equal"));
    end
    if sp != s
        throw(DimensionMismatch("number of columns in P and Y ($sp, $s) are not equal"));
    end

    # Default optimizer
    if optimizer === nothing 
        optimizer = DEAOptimizer(:LP)
    end

    # Get maximum revenue targets and lambdas
    n = nx

    Xtarget = X[:,:]
    Ytarget, rlambdaeff = deamaxrevenue(X, Y, P, rts = rts, dispos = :Strong, optimizer = optimizer)

    # Revenue, technical and allocative efficiency
    PY = P .* Y
    PY[PY .== 0] .= PY[PY .== 0] .+ Inf
    sno0 = sum(Y .!= 0, dims = 2)

    refficiency  = vec( sum(P .* Ytarget, dims = 2)  .- sum(P .* Y, dims = 2) )
    normalization = vec(sno0 .* minimum(PY, dims = 2) )
    techefficiency = efficiency(dearussell(X, Y, orient = :Output, rts = rts, slack = false, optimizer = optimizer)) .- 1

    if monetary
        techefficiency = techefficiency .* normalization
    else
        refficiency = refficiency ./ normalization
    end
    
    allocefficiency = refficiency .- techefficiency

    return RevenueRussellDEAModel(n, m, s, rts, monetary, names, refficiency, rlambdaeff, techefficiency, allocefficiency, normalization, Xtarget, Ytarget)
end

function Base.show(io::IO, x::RevenueRussellDEAModel)
    compact = get(io, :compact, false)

    n = nobs(x)
    m = ninputs(x)
    s = noutputs(x)
    dmunames = names(x)

    eff = efficiency(x)
    techeff = efficiency(x, :Technical)
    alloceff = efficiency(x, :Allocative)

    if !compact
        print(io, "Russell Revenue DEA Model \n")
        print(io, "DMUs = ", n)
        print(io, "; Inputs = ", m)
        print(io, "; Outputs = ", s)
        print(io, "\n")
        print(io, "Orientation = Output")
        print(io, "; Returns to Scale = ", string(x.rts))
        print(io, "\n")

        show(io, CoefTable(hcat(eff, techeff, alloceff), ["Revenue", "Technical", "Allocative"], dmunames))
    end
    
end
