# This file contains functions for the Cost Efficiency Hölder DEA model
"""
    CostHolderDEAModel
An data structure representing a cost Hölder DEA model.
"""
struct CostHolderDEAModel <: AbstractCostDEAModel
    n::Int64
    m::Int64
    s::Int64
    l::Union{Int64,Float64}
    isweighted::Bool
    monetary::Bool
    dmunames::Union{Vector{String},Nothing}
    rts::Symbol
    eff::Vector
    lambda::SparseMatrixCSC{Float64, Int64}
    techeff::Vector
    alloceff::Vector
    normalization::Vector
    Xtarget::Matrix
    Ytarget::Matrix
end


"""
    deacostholder(X, Y, W; l)
Compute cost efficiency using data envelopment analysis for
inputs `X`, outputs `Y` and price of inputs `W`.

# Hölder norm `l` specification
- `1`.
- `2`.
- `Inf`.

# Optional Arguments
- `weigt=false`:  set to `true` for weighted (weakly) Hölder distance function.
- `rts=:VRS`: chooses variable returns to scale. For constant returns to scale choose `:CRS`.
- `monetary=false`: decomposition in normalized terms. Monetary terms if `true`.
- `names`: a vector of strings with the names of the decision making units.
"""
function deacostholder(X::Union{Matrix,Vector}, Y::Union{Matrix,Vector},
    W::Union{Matrix,Vector};
    l::Union{Int64,Float64}, weight::Bool = false,
    rts::Symbol = :VRS, monetary::Bool = false,
    names::Union{Vector{<: AbstractString},Nothing} = nothing,
    optimizer::Union{DEAOptimizer,Nothing} = nothing)::CostHolderDEAModel

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

    if l != 1 && l != 2 && l != Inf
        throw(ArgumentError("l must by :1, :2, or :Inf"));
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
    cefficiency  = vec(sum(W .* X, dims = 2) .- sum(W .* Xtarget, dims = 2))

    if weight
        if l == 1
            normalization = maximum(W .* X, dims = 2)
        elseif l == 2
            normalization = sqrt.(sum((W .* X).^2, dims = 2))
        elseif l == Inf
            normalization = sum(W .* X, dims = 2)
        end
    else
        if l == 1
            normalization = maximum(W, dims = 2)
        elseif l == 2
            normalization = sqrt.(sum((W ).^2, dims = 2))
        elseif l == Inf
            normalization = sum(W, dims = 2)
        end
    end        
    normalization = vec(normalization)

    techefficiency = efficiency(deaholder(X, Y, l = l, weight = weight, orient = :Input, rts = rts, slack = false, optimizer = optimizer))

    if monetary
        techefficiency = techefficiency .* normalization
    else
        cefficiency = cefficiency ./ normalization
    end

    allocefficiency = cefficiency - techefficiency

    return CostHolderDEAModel(n, m, s, l, weight, monetary, names, rts, cefficiency, clambdaeff, techefficiency, allocefficiency, normalization, Xtarget, Ytarget)
end

function Base.show(io::IO, x::CostHolderDEAModel)
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
        print(io, "Cost Hölder L", string(x.l), " DEA Model \n")
        print(io, "DMUs = ", n)
        print(io, "; Inputs = ", m)
        print(io, "; Outputs = ", s)
        print(io, "\n")
        print(io, "Orientation = Input")
        print(io, "; Returns to Scale = ", string(x.rts))
        print(io, "\n")
        if isweighted
            print(io, "Weighted (weakly) Hölder distance function \n")
        end
        show(io, CoefTable(hcat(eff, techeff, alloceff), ["Cost", "Technical", "Allocative"], dmunames))
    end

end
