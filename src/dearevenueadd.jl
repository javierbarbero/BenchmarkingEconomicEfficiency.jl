# This file contains functions for the Revenue Efficiency Additive DEA model
"""
    RevenueDEAModel
An data structure representing a revenue additive DEA model.
"""
struct RevenueAdditiveDEAModel <: AbstractRevenueDEAModel
    n::Int64
    m::Int64
    s::Int64
    weights::Symbol
    monetary::Bool
    rts::Symbol
    disposX::Symbol
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
    dearevenueadd(X, Y, P, model)
Compute revenue efficiency using additive data envelopment analysis for
inputs `X`, outputs `Y` and price of outputs `P`.

Model specification:
- `:Ones`: standard additive DEA model.
- `:MIP`: Measure of Inefficiency Proportions. (Charnes et al., 1987; Cooper et al., 1999)
- `:Normalized`: Normalized weighted additive DEA model. (Lovell and Pastor, 1995)
- `:RAM`: Range Adjusted Measure. (Cooper et al., 1999)
- `:BAM`: Bounded Adjusted Measure. (Cooper et al, 2011)
- `:Custom`: User supplied weights.

# Optional Arguments
- `rts=:VRS`: chooses variable returns to scale. For constant returns to scale choose `:CRS`.
- `rhoY`: matrix of weights of outputs. Only if `model=:Custom`.
- `disposal=:Strong`: chooses strong disposal of inputs. For weak disposal choose `:Weak`.
- `names`: a vector of strings with the names of the decision making units.

# Examples
```jldoctest
julia> X = [1; 1; 1; 1; 1; 1; 1; 1];

julia> Y = [7 7; 4 8; 8 4; 3 5; 3 3; 8 2; 6 4; 1.5 5];

julia> P = [1 1; 1 1; 1 1; 1 1; 1 1; 1 1; 1 1; 1 1];

julia> dearevenueadd(X, Y, P, :Ones)
Revenue Additive DEA Model 
DMUs = 8; Inputs = 1; Outputs = 2
Orientation = Output; Returns to Scale = VRS
Weights = Ones
───────────────────────────────────
   Revenue  Technical    Allocative
───────────────────────────────────
1      0.0        0.0   0.0
2      2.0        0.0   2.0
3      2.0        0.0   2.0
4      6.0        6.0   0.0
5      8.0        8.0   0.0
6      4.0        2.0   2.0
7      4.0        4.0  -8.88178e-16
8      7.5        7.5   0.0
───────────────────────────────────

```
"""
function dearevenueadd(X::Union{Matrix,Vector}, Y::Union{Matrix,Vector}, 
    P::Union{Matrix,Vector}, model::Symbol = :Default;
    rts::Symbol = :VRS, 
    rhoY::Union{Matrix,Vector,Nothing} = nothing,
    dispos::Symbol = :Strong, monetary::Bool = false,
    names::Union{Vector{String},Nothing} = nothing,
    optimizer::Union{DEAOptimizer,Nothing} = nothing)::RevenueAdditiveDEAModel

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

    if dispos != :Strong && dispos != :Weak
        throw(ArgumentError("`dispos` must be :Strong or :Weak"));
    end

    # Default behaviour
    if model == :Default
        # If no weights are specified use :Ones
        if rhoY === nothing
            model = :Ones
        else
            model = :Custom
        end
    end

    # Get weights based on the selected model
    if model != :Custom
        # Display error if both model and weights are specified
        if rhoY !== nothing
            throw(ArgumentError("`rhoY` not allowed if model != :Custom"));
        end

        # Get weights for selected model
        rhoX, rhoY = deaaddweights(X, Y, model, orient = :Output)
    end

    if size(rhoY) != size(Y)
        throw(DimensionMismatch("size of rhoY and Y ($(size(rhoY)), $(size(Y))) are not equal"));
    end

    # Default optimizer
    if optimizer === nothing 
        optimizer = DEAOptimizer(GLPK.Optimizer)
    end

    # Get maximum revenue targets and lambdas
    n = nx

    Xtarget = X[:,:]
    Ytarget, rlambdaeff = deamaxrevenue(X, Y, P, rts = rts, dispos = dispos, optimizer = optimizer)

    # Revenue, technical and allocative efficiency
    refficiency  = vec(sum(P .* Ytarget, dims = 2)  .- sum(P .* Y, dims = 2))
    normalization = vec(minimum(P ./ rhoY, dims = 2) )
    
    if model == :Custom
        rhoX = ones(size(X))
        techefficiency = efficiency(deaadd(X, Y, model, orient = :Output, rts = rts, rhoX = rhoX, rhoY = rhoY, disposX = dispos, optimizer = optimizer))
    else
        techefficiency = efficiency(deaadd(X, Y, model, orient = :Output, rts = rts, disposX = dispos, optimizer = optimizer))
    end
    
    if monetary
        techefficiency = techefficiency .* normalization
    else
        refficiency = refficiency ./ normalization
    end

    allocefficiency = refficiency - techefficiency

    return RevenueAdditiveDEAModel(n, m, s, model, monetary, rts, dispos, names, refficiency, rlambdaeff, techefficiency, allocefficiency, normalization, Xtarget, Ytarget)

end

function Base.show(io::IO, x::RevenueAdditiveDEAModel)
    compact = get(io, :compact, false)

    n = nobs(x)
    m = ninputs(x)
    s = noutputs(x)
    disposX = x.disposX
    dmunames = names(x)

    eff = efficiency(x)
    techeff = efficiency(x, :Technical)
    alloceff = efficiency(x, :Allocative)

    if !compact
        print(io, "Revenue Additive DEA Model \n")
        print(io, "DMUs = ", n)
        print(io, "; Inputs = ", m)
        print(io, "; Outputs = ", s)
        print(io, "\n")
        print(io, "Orientation = Output")
        print(io, "; Returns to Scale = ", string(x.rts))
        print(io, "\n")
        print(io, "Weights = ", string(x.weights))
        print(io, "\n")

        if disposX == :Weak println(io, "Weak disposability of inputs") end

        show(io, CoefTable(hcat(eff, techeff, alloceff), ["Revenue", "Technical", "Allocative"], dmunames))
    end

end
