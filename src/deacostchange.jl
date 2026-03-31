# This file contains functions for the Cost Efficiency Change DEA model
"""
    CostChangeDEAModel
An data structure representing a cost change DEA model.
"""
struct CostChangeDEAModel <: AbstractCostDEAModel
    n::Int64
    m::Int64
    s::Int64
    dmunames::Union{Vector{String},Nothing}
    costchange::Vector
    techchange::Vector
    allocchange::Vector
    costmodelbase::AbstractCostDEAModel
    costmodelcomp::AbstractCostDEAModel
end

"""
    deacostchange(X, Y, W, model)
Compute cost efficiency change using data envelopment analysis radial model for
inputs `X`, outputs `Y`, and price of inputs `W`.

# Optional Arguments
- `names`: a vector of strings with the names of the decision making units.
"""
function deacostchange(X::Array{Float64,3}, Y::Array{Float64,3}, 
    W::Array{Float64,3}, 
    names::Union{Vector{<: AbstractString},Nothing} = nothing,
    optimizer::Union{DEAOptimizer,Nothing} = nothing)::CostChangeDEAModel

    # Check parameters
    n = size(X, 1)
    m = size(X, 2)
    s = size(Y, 2)
    Tx = size(X, 3)
    Ty = size(Y, 3)
    Tw = size(W, 3)

    Tx == Ty || throw(DimensionMismatch("number of time periods in X and Y ($Tx, $Ty) are not equal"));
    Tx == Tw || throw(DimensionMismatch("number of time periods in X and W ($Tx, $Tw) are not equal"));

    T = Tx
    Tx == 2 || throw(DimensionMismatch("number of time periods should be 2. Now $T"));

    # Run cost models and compute change
    costmodelbase = deacost(X[:,:,1], Y[:,:,1], W[:,:,1],
        names = names, optimizer = optimizer)
    costmodelcomp = deacost(X[:,:,2], Y[:,:,2], W[:,:,2],
        names = names, optimizer = optimizer)

    costchange = efficiency(costmodelcomp, :Economic) ./ efficiency(costmodelbase, :Economic)
    techchange = efficiency(costmodelcomp, :Technical) ./ efficiency(costmodelbase, :Technical)
    allocchange = efficiency(costmodelcomp, :Allocative) ./ efficiency(costmodelbase, :Allocative)

    return CostChangeDEAModel(n, m, s, names, costchange, techchange, allocchange, costmodelbase, costmodelcomp)
end

deacostchangemodelname(::CostDEAModel) = "Cost Efficiency Change Radial DEA Model"

function deadisplayinfo(io::IO, x::CostDEAModel)
    print(io, "; Returns to Scale = VRS")
    print(io, "\n")
end

"""
    deacostchangeadd(X, Y, W, P, model)
Compute cost efficiency change using data envelopment analysis weighted additive model for
inputs `X`, outputs `Y`, and price of inputs `W`.

Model specification:
- `:Ones`: standard additive DEA model.
- `:MIP`: Measure of Inefficiency Proportions. (Charnes et al., 1987; Cooper et al., 1999)
- `:Normalized`: Normalized weighted additive DEA model. (Lovell and Pastor, 1995)
- `:RAM`: Range Adjusted Measure. (Cooper et al., 1999)
- `:BAM`: Bounded Adjusted Measure. (Cooper et al, 2011)
- `:Custom`: User supplied weights.

# Optional Arguments
- `rhoX`: matrix of weights of inputs. Only if `model=:Custom`.
- `monetary=false`: decomposition in normalized terms. Monetary terms if `true`.
- `names`: a vector of strings with the names of the decision making units.
"""
function deacostchangeadd(X::Array{Float64,3}, Y::Array{Float64,3}, 
    W::Array{Float64,3}, 
    model::Symbol = :Default;
    rhoX::Union{Matrix,Vector,Nothing} = nothing,
    monetary::Bool = false, 
    names::Union{Vector{<: AbstractString},Nothing} = nothing,
    optimizer::Union{DEAOptimizer,Nothing} = nothing)::CostChangeDEAModel

    # Check parameters
    n = size(X, 1)
    m = size(X, 2)
    s = size(Y, 2)
    Tx = size(X, 3)
    Ty = size(Y, 3)
    Tw = size(W, 3)

    Tx == Ty || throw(DimensionMismatch("number of time periods in X and Y ($Tx, $Ty) are not equal"));
    Tx == Tw || throw(DimensionMismatch("number of time periods in X and W ($Tx, $Tw) are not equal"));

    T = Tx
    Tx == 2 || throw(DimensionMismatch("number of time periods should be 2. Now $T"));

    # Run cost models and compute change
    costmodelbase = deacostadd(X[:,:,1], Y[:,:,1], W[:,:,1],
        model, rhoX = rhoX, monetary = monetary, names = names, optimizer = optimizer)
    costmodelcomp = deacostadd(X[:,:,2], Y[:,:,2], W[:,:,2],
        model, rhoX = rhoX, monetary = monetary, names = names, optimizer = optimizer)

    costchange = efficiency(costmodelbase, :Economic) - efficiency(costmodelcomp, :Economic)
    techchange = efficiency(costmodelbase, :Technical) - efficiency(costmodelcomp, :Technical)
    allocchange = efficiency(costmodelbase, :Allocative) - efficiency(costmodelcomp, :Allocative)

    return CostChangeDEAModel(n, m, s, names, costchange, techchange, allocchange, costmodelbase, costmodelcomp)
end

deacostchangemodelname(::CostAdditiveDEAModel) = "Cost Efficiency Change Additive DEA Model"

function deadisplayinfo(io::IO, x::CostAdditiveDEAModel)
    print(io, "Weights = ", string(x.weights))
    print(io, "; Returns to Scale = VRS")
    print(io, "\n")
end

"""
    deacostchangerussell(X, Y, W, P)
Compute cost efficiency change using Russell data envelopment analysis for
inputs `X`, outputs `Y`, and price of inputs `W`.

# Optional Arguments
- `monetary=false`: decomposition in normalized terms. Monetary terms if `true`.
- `names`: a vector of strings with the names of the decision making units.
"""
function deacostchangerussell(X::Array{Float64,3}, Y::Array{Float64,3}, 
    W::Array{Float64,3};
    monetary::Bool = false,
    names::Union{Vector{<: AbstractString},Nothing} = nothing,
    optimizer::Union{DEAOptimizer,Nothing} = nothing)::CostChangeDEAModel

    # Check parameters
    n = size(X, 1)
    m = size(X, 2)
    s = size(Y, 2)
    Tx = size(X, 3)
    Ty = size(Y, 3)
    Tw = size(W, 3)

    Tx == Ty || throw(DimensionMismatch("number of time periods in X and Y ($Tx, $Ty) are not equal"));
    Tx == Tw || throw(DimensionMismatch("number of time periods in X and W ($Tx, $Tw) are not equal"));

    T = Tx
    Tx == 2 || throw(DimensionMismatch("number of time periods should be 2. Now $T"));

    # Run cost models and compute change
    costmodelbase = deacostrussell(X[:,:,1], Y[:,:,1], W[:,:,1],
        monetary = monetary, names = names, optimizer = optimizer)
    costmodelcomp = deacostrussell(X[:,:,2], Y[:,:,2], W[:,:,2],
        monetary = monetary, names = names, optimizer = optimizer)

    costchange = efficiency(costmodelbase, :Economic) - efficiency(costmodelcomp, :Economic)
    techchange = efficiency(costmodelbase, :Technical) - efficiency(costmodelcomp, :Technical)
    allocchange = efficiency(costmodelbase, :Allocative) - efficiency(costmodelcomp, :Allocative)

    return CostChangeDEAModel(n, m, s, names, costchange, techchange, allocchange, costmodelbase, costmodelcomp)
end

deacostchangemodelname(::CostRussellDEAModel) = "Cost Efficiency Change Russell DEA Model"

function deadisplayinfo(io::IO, x::CostRussellDEAModel)
    print(io, "Orientation = Input")
    print(io, "; Returns to Scale = VRS")
    print(io, "\n")
end

"""
    deacostchangeddf(X, Y, W, P; Gx, Gy)
Compute cost efficiency change using DDF data envelopment analysis model for
inputs `X`, outputs `Y`, and price of inputs `W`.

# Direction specification:

The direction `Gx` can be one of the following symbols.
- `:Zeros`: use zeros.
- `:Ones`: use ones.
- `:Observed`: use observed values.
- `:Mean`: use column means.
- `:Monetary`: use direction so that cost inefficiency is expressed in monetary values.

Alternatively, a vector or matrix with the desired directions can be supplied.

# Optional Arguments
- `monetary=false`: decomposition in normalized terms. Monetary terms if `true`.
- `names`: a vector of strings with the names of the decision making units.
"""
function deacostchangeddf(X::Array{Float64,3}, Y::Array{Float64,3},
    W::Array{Float64,3};
    Gx::Union{Symbol,Matrix,Vector},
    rts::Symbol = :VRS, monetary::Bool = false,
    names::Union{Vector{<: AbstractString},Nothing} = nothing,
    optimizer::Union{DEAOptimizer,Nothing} = nothing)::CostChangeDEAModel

    # Check parameters
    n = size(X, 1)
    m = size(X, 2)
    s = size(Y, 2)
    Tx = size(X, 3)
    Ty = size(Y, 3)
    Tw = size(W, 3)

    Tx == Ty || throw(DimensionMismatch("number of time periods in X and Y ($Tx, $Ty) are not equal"));
    Tx == Tw || throw(DimensionMismatch("number of time periods in X and W ($Tx, $Tw) are not equal"));

    T = Tx
    Tx == 2 || throw(DimensionMismatch("number of time periods should be 2. Now $T"));

    # Run cost models and compute change
    costmodelbase = deacostddf(X[:,:,1], Y[:,:,1], W[:,:,1], 
        Gx = Gx, rts = rts, monetary = monetary, names = names, optimizer = optimizer)
    costmodelcomp = deacostddf(X[:,:,2], Y[:,:,2], W[:,:,2], 
        Gx = Gx, rts = rts, monetary = monetary, names = names, optimizer = optimizer)

    costchange = efficiency(costmodelbase, :Economic) - efficiency(costmodelcomp, :Economic)
    techchange = efficiency(costmodelbase, :Technical) - efficiency(costmodelcomp, :Technical)
    allocchange = efficiency(costmodelbase, :Allocative) - efficiency(costmodelcomp, :Allocative)

    return CostChangeDEAModel(n, m, s, names, costchange, techchange, allocchange, costmodelbase, costmodelcomp)
end

deacostchangemodelname(::CostDDFDEAModel) = "Cost Efficiency Change DEA Model"

function deadisplayinfo(io::IO, x::CostDDFDEAModel)
    print(io, "Returns to Scale = VRS")
    print(io, "\n")
    print(io, "Gx = ", string(x.Gx),)
    print(io, "\n")
end

"""
    deacostchangeholder(X, Y, W, P; l)
Compute cost efficiency change using data envelopment analysis Hölder model for
inputs `X`, outputs `Y`, and price of inputs `W`.

# Hölder norm `l` specification
- `1`.
- `2`.
- `Inf`.

# Optional Arguments
- `weigt=false`:  set to `true` for weighted (weakly) Hölder distance function.
- `monetary=false`: decomposition in normalized terms. Monetary terms if `true`.
- `names`: a vector of strings with the names of the decision making units.
"""
function deacostchangeholder(X::Array{Float64,3}, Y::Array{Float64,3},
    W::Array{Float64,3};
    l::Union{Int64,Float64}, weight::Bool = false, monetary::Bool = false,
    names::Union{Vector{<: AbstractString},Nothing} = nothing,
    optimizer::Union{DEAOptimizer,Nothing} = nothing)::CostChangeDEAModel

    # Check parameters
    n = size(X, 1)
    m = size(X, 2)
    s = size(Y, 2)
    Tx = size(X, 3)
    Ty = size(Y, 3)
    Tw = size(W, 3)

    Tx == Ty || throw(DimensionMismatch("number of time periods in X and Y ($Tx, $Ty) are not equal"));
    Tx == Tw || throw(DimensionMismatch("number of time periods in X and W ($Tx, $Tw) are not equal"));

    T = Tx
    Tx == 2 || throw(DimensionMismatch("number of time periods should be 2. Now $T"));

    # Run cost models and compute change
    costmodelbase = deacostholder(X[:,:,1], Y[:,:,1], W[:,:,1],
        l = l, weight = weight, monetary = monetary, names = names, optimizer = optimizer)
    costmodelcomp = deacostholder(X[:,:,2], Y[:,:,2], W[:,:,2],
        l = l, weight = weight, monetary = monetary, names = names, optimizer = optimizer)

    costchange = efficiency(costmodelbase, :Economic) - efficiency(costmodelcomp, :Economic)
    techchange = efficiency(costmodelbase, :Technical) - efficiency(costmodelcomp, :Technical)
    allocchange = efficiency(costmodelbase, :Allocative) - efficiency(costmodelcomp, :Allocative)

    return CostChangeDEAModel(n, m, s, names, costchange, techchange, allocchange, costmodelbase, costmodelcomp)
end

deacostchangemodelname(::CostHolderDEAModel) = "Cost Efficiency Change Hölder DEA Model"

function deadisplayinfo(io::IO, x::CostHolderDEAModel)
    print(io, "l = ", string(x.l))
    print(io, "; Returns to Scale = VRS")
    print(io, "\n")
end

"""
    deacostchangerddf(X, Y, W, P, measure)
Compute cost change efficiency using data envelopment analysis Reverse DDF model for
inputs `X`, outputs `Y`, price of inputs `W`, price of outputs `P`, and efficiency `measure`.

# Measure specification:
- `:ERG`: Enhanced Russell Graph Slack Based Measure.

# Direction specification:
For the Modified Directional Distance Function, the directions `Gx` and `Gy` can be one of the following symbols.
- `:Observed`: use observed values.

Alternatively, a vector or matrix with the desired directions can be supplied.

# Optional Arguments
- `monetary=false`: decomposition in normalized terms. Monetary terms if `true`.
- `atol=1e-6`: tolerance for DMU to be considered efficient.
- `names`: a vector of strings with the names of the decision making units.
"""
function deacostchangerddf(X::Array{Float64,3}, Y::Array{Float64,3},
    W::Array{Float64,3},
    measure::Symbol;
    monetary::Bool = false, atol::Float64 = 1e-6,
    names::Union{Vector{<: AbstractString},Nothing} = nothing,
    optimizer::Union{DEAOptimizer,Nothing} = nothing)::CostChangeDEAModel

    # Check parameters
    n = size(X, 1)
    m = size(X, 2)
    s = size(Y, 2)
    Tx = size(X, 3)
    Ty = size(Y, 3)
    Tw = size(W, 3)

    Tx == Ty || throw(DimensionMismatch("number of time periods in X and Y ($Tx, $Ty) are not equal"));
    Tx == Tw || throw(DimensionMismatch("number of time periods in X and W ($Tx, $Tw) are not equal"));

    T = Tx
    Tx == 2 || throw(DimensionMismatch("number of time periods should be 2. Now $T"));

    # Run cost models and compute change
    costmodelbase = deacostrddf(X[:,:,1], Y[:,:,1], W[:,:,1],
        measure, monetary = monetary, atol = atol, names = names, optimizer = optimizer)
    costmodelcomp = deacostrddf(X[:,:,2], Y[:,:,2], W[:,:,2],
        measure, monetary = monetary, atol = atol, names = names, optimizer = optimizer)

    costchange = efficiency(costmodelbase, :Economic) - efficiency(costmodelcomp, :Economic)
    techchange = efficiency(costmodelbase, :Technical) - efficiency(costmodelcomp, :Technical)
    allocchange = efficiency(costmodelbase, :Allocative) - efficiency(costmodelcomp, :Allocative)

    return CostChangeDEAModel(n, m, s, names, costchange, techchange, allocchange, costmodelbase, costmodelcomp)
end

deacostchangemodelname(::CostReverseDDFDEAModel) = "Cost Efficiency Change Reverse DDF DEA Model"

function deadisplayinfo(io::IO, x::CostReverseDDFDEAModel)
    print(io, "Returns to Scale = VRS")
    print(io, "\n")
    print(io, "Associated efficiency measure = ", string(x.measure))
    print(io, "\n")
end

"""
    deacostchangegda(X, Y, W, P, measure)
Compute cost efficiency change using data envelopment analysis General Direct Approach model for
inputs `X`, outputs `Y`, price of inputs `W`, price of outputs `P`, and efficiency `measure`.

# Measure specification:
- `:ERG`: Enhanced Russell Graph (or Slack Based Measure (SBM)).

# Optional Arguments
- `monetary=false`: decomposition in normalized terms. Monetary terms if `true`.
- `atol=1e-6`: tolerance for DMU to be considered efficient.
- `names`: a vector of strings with the names of the decision making units.
"""
function deacostchangegda(X::Array{Float64,3}, Y::Array{Float64,3},
    W::Array{Float64,3},
    measure::Symbol;
    monetary::Bool = false, atol::Float64 = 1e-6,
    names::Union{Vector{<: AbstractString},Nothing} = nothing,
    optimizer::Union{DEAOptimizer,Nothing} = nothing)::CostChangeDEAModel

    # Check parameters
    n = size(X, 1)
    m = size(X, 2)
    s = size(Y, 2)
    Tx = size(X, 3)
    Ty = size(Y, 3)
    Tw = size(W, 3)

    Tx == Ty || throw(DimensionMismatch("number of time periods in X and Y ($Tx, $Ty) are not equal"));
    Tx == Tw || throw(DimensionMismatch("number of time periods in X and W ($Tx, $Tw) are not equal"));

    T = Tx
    Tx == 2 || throw(DimensionMismatch("number of time periods should be 2. Now $T"));

    # Run cost models and compute change
    costmodelbase = deacostgda(X[:,:,1], Y[:,:,1], W[:,:,1],
        measure, monetary = monetary, atol = atol, names = names, optimizer = optimizer)
    costmodelcomp = deacostgda(X[:,:,2], Y[:,:,2], W[:,:,2],
        measure, monetary = monetary, atol = atol, names = names, optimizer = optimizer)

    costchange = efficiency(costmodelbase, :Economic) - efficiency(costmodelcomp, :Economic)
    techchange = efficiency(costmodelbase, :Technical) - efficiency(costmodelcomp, :Technical)
    allocchange = efficiency(costmodelbase, :Allocative) - efficiency(costmodelcomp, :Allocative)

    return CostChangeDEAModel(n, m, s, names, costchange, techchange, allocchange, costmodelbase, costmodelcomp)
end

deacostchangemodelname(::CostGDADEAModel) = "General Direct Approach Cost Efficiency Change DEA Model"

function deadisplayinfo(io::IO, x::CostGDADEAModel)
    print(io, "Returns to Scale = VRS")
    print(io, "\n")
    print(io, "Associated efficiency measure = ", string(x.measure))
    print(io, "\n")
end


# Show function common for all Cost Change Models
function Base.show(io::IO, x::CostChangeDEAModel)
    compact = get(io, :compact, false)

    n = nobs(x)
    m = ninputs(x)
    s = noutputs(x)
    dmunames = names(x)

    costchange = x.costchange
    techchange = x.techchange
    allocchange = x.allocchange

    if typeof(x.costmodelbase) == CostDEAModel
        normbase = zeros(n)
        normcomp = zeros(n)
    else
        normbase = x.costmodelbase.normalization
        normcomp = x.costmodelcomp.normalization
    end

    if !compact
        print(io, deacostchangemodelname(x.costmodelbase) * " \n")
        print(io, "DMUs = ", n)
        print(io, "; Inputs = ", m)
        print(io, "; Outputs = ", s)
        print(io, "; Time periods = 2")
        print(io, "\n")
        deadisplayinfo(io, x.costmodelbase)
        
        if typeof(x.costmodelbase) == CostDEAModel
            show(io, MIME"text/plain"(), CoefTable(hcat(costchange, techchange, allocchange), ["Cost.Change", "Tech.Change", "Alloc.Change"], dmunames))
        else
            show(io, MIME"text/plain"(), CoefTable(hcat(costchange, techchange, allocchange, normbase, normcomp), ["Cost.Change", "Tech.Change", "Alloc.Change", "NF.Base", "NF.Comp"], dmunames))
        end
    end

end

"""
    effchange(model::CostChangeDEAModel)
Return efficiency change of a cost change DEA model.

# Optional Arguments
- `type=Economic`: type of efficiency change scores to return.

Type specification:
- `:Economic`: returns economic efficiency change of the model.
- `:Technical`: returns technical efficiency change.
- `:Allocative`: returns allocative efficiency change.
"""
function effchange(model::CostChangeDEAModel, type::Symbol = :Economic)::Vector

    if type == :Economic
        return model.costchange
    end
    if type == :Technical
        return model.techchange
    end
    if type == :Allocative
        return model.allocchange
    end

    throw(ArgumentError("$(typeof(model)) has no efficiency change $(type)"));

end
