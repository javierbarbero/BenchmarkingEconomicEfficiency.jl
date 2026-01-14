# This file contains functions for the Revenue Efficiency DDF DEA model
"""
    RevenueDDFDEAModel
An data structure representing a revenue DDF DEA model.
"""
struct RevenueDDFDEAModel <: AbstractRevenueDEAModel
    n::Int64
    m::Int64
    s::Int64
    Gy::Symbol
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
    dearevenueddf(X, Y, P; Gy)
Compute revenue efficiency using directional distance function data envelopment analysis for
inputs `X`, outputs `Y` and price of outputs `P`.

# Direction specification:

The direction `Gy` can be one of the following symbols.
- `:Ones`: use ones.
- `:Observed`: use observed values.
- `:Mean`: use column means.
- `:Monetary`: use direction so that profit inefficiency is expressed in monetary values.

Alternatively, a vector or matrix with the desired directions can be supplied.

# Optional Arguments
- `rts=:VRS`: chooses variable returns to scale. For constant returns to scale choose `:CRS`.
- `monetary=false`: decomposition in normalized terms. Monetary terms if `true`.
- `names`: a vector of strings with the names of the decision making units.
"""
function dearevenueddf(X::Union{Matrix,Vector}, Y::Union{Matrix,Vector},
    P::Union{Matrix,Vector};
    Gy::Union{Symbol,Matrix,Vector},
    rts::Symbol = :VRS, monetary::Bool = false,
    names::Union{Vector{<: AbstractString},Nothing} = nothing,
    optimizer::Union{DEAOptimizer,Nothing} = nothing)::RevenueDDFDEAModel

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

    # Build or get user directions
    if typeof(Gy) == Symbol
        Gysym = Gy

        if Gy == :Ones
            Gy = ones(size(Y))
        elseif Gy == :Observed
            Gy = Y
        elseif Gy == :Mean
            Gy = repeat(mean(Y, dims = 1), size(Y, 1))
        elseif Gy == :Monetary
            GxGydollar = 1 ./ (sum(P, dims = 2));
            Gy = repeat(GxGydollar, 1, s);
        else
            throw(ArgumentError("Invalid `Gy`"));
        end

    else
        Gysym = :Custom
    end

    if (size(Gy, 1) != size(Y, 1)) | (size(Gy, 2) != size(Y, 2))
        throw(DimensionMismatch("size of Gy and Y ($(size(Gy)), $(size(Y))) are not equal"));
    end

    # Set input direction to zeros
    Gx = zeros(size(X))

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
    normalization = vec(sum(P .* Gy, dims = 2))
    techefficiency = efficiency(deaddf(X, Y, Gx = Gx, Gy = Gy, rts = rts, slack = false, optimizer = optimizer))

    if monetary
        techefficiency = techefficiency .* normalization
    else
        refficiency = refficiency ./ normalization
    end
    
    allocefficiency = refficiency .- techefficiency

    return RevenueDDFDEAModel(n, m, s, Gysym, monetary, names, rts, refficiency, rlambdaeff, techefficiency, allocefficiency, normalization, Xtarget, Ytarget)
end

function Base.show(io::IO, x::RevenueDDFDEAModel)
    compact = get(io, :compact, false)

    n = nobs(x)
    m = ninputs(x)
    s = noutputs(x)    
    dmunames = names(x)

    eff = efficiency(x)
    techeff = efficiency(x, :Technical)
    alloceff = efficiency(x, :Allocative)

    if !compact
        print(io, "Revenue DDF DEA Model \n")
        print(io, "DMUs = ", n)
        print(io, "; Inputs = ", m)
        print(io, "; Outputs = ", s)
        print(io, "\n")
        print(io, "Orientation = Output")
        print(io, "; Returns to Scale = ", string(x.rts))
        print(io, "\n")
        print(io, "Gy = ", string(x.Gy))
        print(io, "\n")
        show(io, MIME"text/plain"(), CoefTable(hcat(eff, techeff, alloceff), ["Revenue", "Technical", "Allocative"], dmunames))
    end

end
