# This file contains functions for the Cost Efficiency Additive DEA model
"""
    CostAdditiveDEAModel
An data structure representing a cost additive DEA model.
"""
struct CostAdditiveDEAModel <: AbstractCostDEAModel
    n::Int64
    m::Int64
    s::Int64
    weights::Symbol
    monetary::Bool
    rts::Symbol
    disposY::Symbol
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
    deacostadditive(X, Y, W, model)
Compute cost efficiency using additive data envelopment analysis for
inputs `X`, outputs `Y` and price of inputs `W`.

Model specification:
- `:Ones`: standard additive DEA model.
- `:MIP`: Measure of Inefficiency Proportions. (Charnes et al., 1987; Cooper et al., 1999)
- `:Normalized`: Normalized weighted additive DEA model. (Lovell and Pastor, 1995)
- `:RAM`: Range Adjusted Measure. (Cooper et al., 1999)
- `:BAM`: Bounded Adjusted Measure. (Cooper et al, 2011)
- `:Custom`: User supplied weights.

# Optional Arguments
- `rts=:VRS`: chooses variable returns to scale. For constant returns to scale choose `:CRS`.
- `rhoX`: matrix of weights of inputs. Only if `model=:Custom`.
- `disposal=:Strong`: chooses strong disposal of outputs. For weak disposal choose `:Weak`.
- `names`: a vector of strings with the names of the decision making units.

# Examples
```jldoctest
julia> X = [2 2; 1 4; 4 1; 4 3; 5 5; 6 1; 2 5; 1.6 8];

julia> Y = [1; 1; 1; 1; 1; 1; 1; 1];

julia> W = [1 1; 1 1; 1 1; 1 1; 1 1; 1 1; 1 1; 1 1];

julia> deacostadd(X, Y, W, :Ones)
Cost Additive DEA Model 
DMUs = 8; Inputs = 2; Outputs = 1
Orientation = Input; Returns to Scale = VRS
Weights = Ones
──────────────────────────────
   Cost  Technical  Allocative
──────────────────────────────
1   0.0        0.0         0.0
2   1.0        0.0         1.0
3   1.0        0.0         1.0
4   3.0        3.0         0.0
5   6.0        6.0         0.0
6   3.0        2.0         1.0
7   3.0        3.0         0.0
8   5.6        5.2         0.4
──────────────────────────────
```
"""
function deacostadd(X::Union{Matrix,Vector}, Y::Union{Matrix,Vector},
    W::Union{Matrix,Vector}, model::Symbol = :Default;
    rts::Symbol = :VRS, 
    rhoX::Union{Matrix,Vector,Nothing} = nothing,
    dispos::Symbol = :Strong, monetary::Bool = false, 
    names::Union{Vector{String},Nothing} = nothing,
    optimizer::Union{DEAOptimizer,Nothing} = nothing)::CostAdditiveDEAModel

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

    if dispos != :Strong && dispos != :Weak
        throw(ArgumentError("`disposX` must be :Strong or :Weak"));
    end

    # Default behaviour
    if model == :Default
        # If no weights are specified use :Ones
        if rhoX === nothing
            model = :Ones
        else
            model = :Custom
        end
    end

    # Get weights based on the selected model
    if model != :Custom
        # Display error if both model and weights are specified
        if rhoX !== nothing 
            throw(ArgumentError("`rhoX` not allowed if model != :Custom"));
        end

        # Get weights for selected model
        rhoX, rhoY = deaaddweights(X, Y, model, orient = :Input)
    end

    if size(rhoX) != size(X)
        throw(DimensionMismatch("size of rhoX and X ($(size(rhoX)), $(size(X))) are not equal"));
    end

    # Default optimizer
    if optimizer === nothing 
        optimizer = DEAOptimizer(GLPK.Optimizer)
    end

    # Get minimum cost targets and lambdas
    n = nx

    Xtarget, clambdaeff = deamincost(X, Y, W, rts = rts, dispos = dispos, optimizer = optimizer)
    Ytarget = Y[:,:]

    # Cost, technical and allocative efficiency
    cefficiency  = vec(sum(W .* X, dims = 2) .- sum(W .* Xtarget, dims = 2))
    normalization = vec(minimum(W ./ rhoX, dims = 2))
    
    if model == :Custom
        rhoY = ones(size(Y))
        techefficiency = efficiency(deaadd(X, Y, model, orient = :Input, rts = rts, rhoX = rhoX, rhoY = rhoY, disposY = dispos, optimizer = optimizer))
    else
        techefficiency = efficiency(deaadd(X, Y, model, orient = :Input, rts = rts, disposY = dispos, optimizer = optimizer))
    end

    if monetary
        techefficiency = techefficiency .* normalization
    else
        cefficiency = cefficiency ./ normalization
    end

    allocefficiency = cefficiency - techefficiency

    return CostAdditiveDEAModel(n, m, s, model, monetary, rts, dispos, names, cefficiency, clambdaeff, techefficiency, allocefficiency, normalization, Xtarget, Ytarget)

end

function Base.show(io::IO, x::CostAdditiveDEAModel)
    compact = get(io, :compact, false)

    n = nobs(x)
    m = ninputs(x)
    s = noutputs(x)
    eff = efficiency(x)
    disposY = x.disposY
    dmunames = names(x)

    techeff = efficiency(x, :Technical)
    alloceff = efficiency(x, :Allocative)

    if !compact
        print(io, "Cost Additive DEA Model \n")
        print(io, "DMUs = ", n)
        print(io, "; Inputs = ", m)
        print(io, "; Outputs = ", s)
        print(io, "\n")
        print(io, "Orientation = Input")
        print(io, "; Returns to Scale = ", string(x.rts))
        print(io, "\n")
        print(io, "Weights = ", string(x.weights))
        print(io, "\n")

        if disposY == :Weak println(io, "Weak disposability of outputs") end

        show(io, CoefTable(hcat(eff, techeff, alloceff), ["Cost", "Technical", "Allocative"], dmunames))
    end

end
