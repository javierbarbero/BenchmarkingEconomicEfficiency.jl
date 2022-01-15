# This file contains functions for the Revenue Efficiency Hölder DEA model
"""
    RevenueHolderDEAModel
An data structure representing a revenue Hölder DEA model.
"""
struct RevenueHolderDEAModel <: AbstractRevenueDEAModel
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
    dearevenueholder(X, Y, W; l)
Compute revenue efficiency using data envelopment analysis for
inputs `X`, outputs `Y` and price of outputs `P`.

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
function dearevenueholder(X::Union{Matrix,Vector}, Y::Union{Matrix,Vector},
    P::Union{Matrix,Vector};
    l::Union{Int64,Float64}, weight::Bool = false,
    rts::Symbol = :VRS, monetary::Bool = false,
    names::Union{Vector{<: AbstractString},Nothing} = nothing,
    optimizer::Union{DEAOptimizer,Nothing} = nothing)::RevenueHolderDEAModel

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

    if l != 1 && l != 2 && l != Inf
        throw(ArgumentError("l must by :1, :2, or :Inf"));
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
    refficiency  = vec(sum(P .* Ytarget, dims = 2)  .- sum(P .* Y, dims = 2))

    if weight
        if l == 1
            normalization = maximum(P .* Y, dims = 2)
        elseif l == 2
            normalization = sqrt.(sum((P .* Y ).^2, dims = 2))
        elseif l == Inf
            normalization = sum(P .* Y, dims = 2)
        end
    else
        if l == 1
            normalization = maximum(P, dims = 2)
        elseif l == 2
            normalization = sqrt.(sum((P ).^2, dims = 2))
        elseif l == Inf
            normalization = sum(P, dims = 2)
        end
    end
    normalization = vec(normalization)

    techefficiency = efficiency(deaholder(X, Y, l = l, weight = weight, orient = :Output, rts = rts, slack = false, optimizer = optimizer))

    if monetary
        techefficiency = techefficiency .* normalization
    else
        refficiency = refficiency ./ normalization
    end

    allocefficiency = refficiency - techefficiency

    return RevenueHolderDEAModel(n, m, s, l, weight, monetary, names, rts, refficiency, rlambdaeff, techefficiency, allocefficiency, normalization, Xtarget, Ytarget)
end

function Base.show(io::IO, x::RevenueHolderDEAModel)
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
        print(io, "Revenue Hölder L", string(l), " DEA Model \n")
        print(io, "DMUs = ", n)
        print(io, "; Inputs = ", m)
        print(io, "; Outputs = ", s)
        print(io, "\n")
        print(io, "Orientation = Output")
        print(io, "; Returns to Scale = ", string(x.rts))
        print(io, "\n")
        if isweighted
            print(io, "Weighted (weakly) Hölder distance function \n")
        end
        show(io, CoefTable(hcat(eff, techeff, alloceff), ["Revenue", "Technical", "Allocative"], dmunames))
    end

end
