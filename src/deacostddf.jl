# This file contains functions for the Cost Efficiency DDF DEA model
"""
    CostDDFDEAModel
An data structure representing a cost DDF DEA model.
"""
struct CostDDFDEAModel <: AbstractCostDEAModel
    n::Int64
    m::Int64
    s::Int64
    Gx::Symbol
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
    deacostddf(X, Y, W; Gx)
Compute cost efficiency using directional distance function DEA model for
inputs `X`, outputs `Y` and price of inputs `W`.

# Direction specification:

The direction `Gx` can be one of the following symbols.
- `:Ones`: use ones.
- `:Observed`: use observed values.
- `:Mean`: use column means.
- `:Monetary`: use direction so that profit inefficiency is expressed in monetary values.

Alternatively, a vector or matrix with the desired directions can be supplied.

# Optional Arguments
- `rts=:VRS`: chooses variable returns to scale. For constant returns to scale choose `:CRS`.

# Examples
```jldoctest
julia> X = [2 2; 1 4; 4 1; 4 3; 5 5; 6 1; 2 5; 1.6 8];

julia> Y = [1; 1; 1; 1; 1; 1; 1; 1];

julia> W = [1 1; 1 1; 1 1; 1 1; 1 1; 1 1; 1 1; 1 1];

julia> deacostddf(X, Y, W, Gx = :Monetary)
Cost DDF DEA Model 
DMUs = 8; Inputs = 2; Outputs = 1
Orientation = Input; Returns to Scale = VRS
Gx = Monetary
──────────────────────────────
   Cost  Technical  Allocative
──────────────────────────────
1   0.0    0.0        0.0
2   1.0    0.0        1.0
3   1.0    0.0        1.0
4   3.0    2.66667    0.333333
5   6.0    6.0        0.0
6   3.0    0.0        3.0
7   3.0    2.0        1.0
8   5.6    1.2        4.4
──────────────────────────────
```
"""
function deacostddf(X::Union{Matrix,Vector}, Y::Union{Matrix,Vector},
    W::Union{Matrix,Vector};
    Gx::Union{Symbol,Matrix,Vector},
    rts::Symbol = :VRS, monetary::Bool = false,
    names::Union{Vector{String},Nothing} = nothing,
    optimizer::Union{DEAOptimizer,Nothing} = nothing)::CostDDFDEAModel

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

    # Build or get user directions
    if typeof(Gx) == Symbol
        Gxsym = Gx

        if Gx == :Ones
            Gx = ones(size(X))
        elseif Gx == :Observed
            Gx = X
        elseif Gx == :Mean
            Gx = repeat(mean(X, dims = 1), size(X, 1))
        elseif Gx == :Monetary
            GxGydollar = 1 ./ (sum(W, dims = 2));
            Gx = repeat(GxGydollar, 1, m);
        else
            throw(ArgumentError("Invalid `Gx`"));
        end

    else
        Gxsym = :Custom
    end

    if (size(Gx, 1) != size(X, 1)) | (size(Gx, 2) != size(X, 2))
        throw(DimensionMismatch("size of Gx and X ($(size(Gx)), $(size(X))) are not equal"));
    end

    # Set output direction to zeros
    Gy = zeros(size(Y))

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
    normalization = vec(sum(W .* Gx, dims = 2))
    techefficiency = efficiency(deaddf(X, Y, Gx = Gx, Gy = Gy, rts = rts, slack = false, optimizer = optimizer))
    
    if monetary
        techefficiency = techefficiency .* normalization
    else
        cefficiency = cefficiency ./ normalization
    end
    
    allocefficiency = cefficiency - techefficiency

    return CostDDFDEAModel(n, m, s, Gxsym, monetary, names, rts, cefficiency, clambdaeff, techefficiency, allocefficiency, normalization, Xtarget, Ytarget)
end

function Base.show(io::IO, x::CostDDFDEAModel)
    compact = get(io, :compact, false)

    n = nobs(x)
    m = ninputs(x)
    s = noutputs(x)    
    dmunames = names(x)

    eff = efficiency(x)
    techeff = efficiency(x, :Technical)
    alloceff = efficiency(x, :Allocative)

    if !compact
        print(io, "Cost DDF DEA Model \n")
        print(io, "DMUs = ", n)
        print(io, "; Inputs = ", m)
        print(io, "; Outputs = ", s)
        print(io, "\n")
        print(io, "Orientation = Input")
        print(io, "; Returns to Scale = ", string(x.rts))
        print(io, "\n")
        print(io, "Gx = ", string(x.Gx))
        print(io, "\n")
        show(io, CoefTable(hcat(eff, techeff, alloceff), ["Cost", "Technical", "Allocative"], dmunames))
    end

end
