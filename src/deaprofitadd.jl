# This file contains functions for the Profit Efficiency Additive DEA model
"""
    ProfitAdditiveDEAModel
An data structure representing a profit additive DEA model.
"""
struct ProfitAdditiveDEAModel <: AbstractProfitDEAModel
    n::Int64
    m::Int64
    s::Int64
    weights::Symbol
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
    deaprofitadd(X, Y, W, P, model)
Compute profit efficiency using data envelopment analysis weighted additive model for
inputs `X`, outputs `Y`, price of inputs `W`, and price of outputs `P`.

Model specification:
- `:Ones`: standard additive DEA model.
- `:MIP`: Measure of Inefficiency Proportions. (Charnes et al., 1987; Cooper et al., 1999)
- `:Normalized`: Normalized weighted additive DEA model. (Lovell and Pastor, 1995)
- `:RAM`: Range Adjusted Measure. (Cooper et al., 1999)
- `:BAM`: Bounded Adjusted Measure. (Cooper et al, 2011)
- `:Custom`: User supplied weights.

# Optional Arguments
- `rhoX`: matrix of weights of inputs. Only if `model=:Custom`.
- `rhoY`: matrix of weights of outputs. Only if `model=:Custom`.
- `names`: a vector of strings with the names of the decision making units.

# Examples
```jldoctest
julia> X = [2; 4; 8; 12; 6; 14; 14; 9.412];

julia> Y = [1; 5; 8; 9; 3; 7; 9; 2.353];

julia> W = [1; 1; 1; 1; 1; 1; 1; 1];

julia> P = [1; 1; 1; 1; 1; 1; 1; 1];

julia> deaprofitadd(X, Y, W, P, :Ones)
Profit Additive DEA Model 
DMUs = 8; Inputs = 1; Outputs = 1
Weights = Ones; Returns to Scale = VRS
─────────────────────────────────
   Profit  Technical   Allocative
─────────────────────────────────
1   2.0      0.0      2.0
2   0.0      0.0      0.0
3   1.0      0.0      1.0
4   4.0      0.0      4.0
5   4.0      4.0      8.88178e-16
6   8.0      7.33333  0.666667
7   6.0      2.0      4.0
8   8.059    8.059    0.0
─────────────────────────────────
```
"""
function deaprofitadd(X::Union{Matrix,Vector}, Y::Union{Matrix,Vector}, 
    W::Union{Matrix,Vector}, P::Union{Matrix,Vector}, 
    model::Symbol = :Default;
    rhoX::Union{Matrix,Vector,Nothing} = nothing, rhoY::Union{Matrix,Vector,Nothing} = nothing,
    monetary::Bool = false, 
    names::Union{Vector{String},Nothing} = nothing,
    optimizer::Union{DEAOptimizer,Nothing} = nothing)::ProfitAdditiveDEAModel

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

    # Default behaviour
    if model == :Default
        # If no weights are specified use :Ones
        if rhoX === nothing && rhoY === nothing
            model = :Ones
        else
            model = :Custom
        end
    end

    # Get weights based on the selected model
    if model != :Custom
        # Display error if both model and weights are specified
        if rhoX !== nothing || rhoY !== nothing
            throw(ArgumentError("`rhoX` and `rhoY` not allowed if model != :Custom"));
        end

        # Get weights for selected model
        rhoX, rhoY = deaaddweights(X, Y, model, orient = :Graph)
    end

    if size(rhoX) != size(X)
        throw(DimensionMismatch("size of rhoX and X ($(size(rhoX)), $(size(X))) are not equal"));
    end
    if size(rhoY) != size(Y)
        throw(DimensionMismatch("size of rhoY and Y ($(size(rhoY)), $(size(Y))) are not equal"));
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
    normalization = vec(minimum(hcat(W ./ rhoX, P ./ rhoY), dims = 2))
    techefficiency = efficiency(deaadd(X, Y, :Custom, rts = :VRS, rhoX = rhoX, rhoY = rhoY, optimizer = optimizer))

    if monetary
        techefficiency = techefficiency .* normalization
    else
        pefficiency = pefficiency ./ normalization 
    end

    allocefficiency = pefficiency - techefficiency

    return ProfitAdditiveDEAModel(n, m, s, model, monetary, names, pefficiency, plambdaeff, techefficiency, allocefficiency, normalization, Xtarget, Ytarget)

end

function Base.show(io::IO, x::ProfitAdditiveDEAModel)
    compact = get(io, :compact, false)

    n = nobs(x)
    m = ninputs(x)
    s = noutputs(x)
    dmunames = names(x)

    eff = efficiency(x)
    techeff = efficiency(x, :Technical)
    alloceff = efficiency(x, :Allocative)

    if !compact
        print(io, "Profit Additive DEA Model \n")
        print(io, "DMUs = ", n)
        print(io, "; Inputs = ", m)
        print(io, "; Outputs = ", s)
        print(io, "\n")
        print(io, "Weights = ", string(x.weights))
        print(io, "; Returns to Scale = VRS")
        print(io, "\n")
        show(io, CoefTable(hcat(eff, techeff, alloceff), ["Profit", "Technical", "Allocative"], dmunames))
    end

end
