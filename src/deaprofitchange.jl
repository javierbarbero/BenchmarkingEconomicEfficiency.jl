# This file contains functions for the Profit Efficiency Change DEA model
"""
    ProfitChangeDEAModel
An data structure representing a profit change DEA model.
"""
struct ProfitChangeDEAModel <: AbstractProfitDEAModel
    n::Int64
    m::Int64
    s::Int64
    dmunames::Union{Vector{String},Nothing}
    profchange::Vector
    techchange::Vector
    allocchange::Vector
    profitmodelbase::AbstractProfitDEAModel
    profitmodelcomp::AbstractProfitDEAModel
end


"""
    deaprofitchangeadd(X, Y, W, P, model)
Compute profit efficiency change using data envelopment analysis weighted additive model for
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
- `monetary=false`: decomposition in normalized terms. Monetary terms if `true`.
- `names`: a vector of strings with the names of the decision making units.
"""
function deaprofitchangeadd(X::Array{Float64,3}, Y::Array{Float64,3}, 
    W::Array{Float64,3}, P::Array{Float64,3}, 
    model::Symbol = :Default;
    rhoX::Union{Matrix,Vector,Nothing} = nothing, rhoY::Union{Matrix,Vector,Nothing} = nothing,
    monetary::Bool = false, 
    names::Union{Vector{<: AbstractString},Nothing} = nothing,
    optimizer::Union{DEAOptimizer,Nothing} = nothing)::ProfitChangeDEAModel

    # Check parameters
    n = size(X, 1)
    m = size(X, 2)
    s = size(Y, 2)
    Tx = size(X, 3)
    Ty = size(Y, 3)
    Tw = size(W, 3)
    Tp = size(P, 3)

    Tx == Ty || throw(DimensionMismatch("number of time periods in X and Y ($Tx, $Ty) are not equal"));
    Tx == Tw || throw(DimensionMismatch("number of time periods in X and W ($Tx, $Tw) are not equal"));
    Ty == Tp || throw(DimensionMismatch("number of time periods in X and P ($Tx, $Tp) are not equal"));

    T = Tx
    Tx == 2 || throw(DimensionMismatch("number of time periods should be 2. Now $T"));

    # Run profit models and compute change
    profitmodelbase = deaprofitadd(X[:,:,1], Y[:,:,1], W[:,:,1], P[:,:,1],
        model, rhoX = rhoX, rhoY = rhoY, monetary = monetary, names = names, optimizer = optimizer)
    profitmodelcomp = deaprofitadd(X[:,:,2], Y[:,:,2], W[:,:,2], P[:,:,2],
        model, rhoX = rhoX, rhoY = rhoY, monetary = monetary, names = names, optimizer = optimizer)

    profchange = efficiency(profitmodelbase, :Economic) - efficiency(profitmodelcomp, :Economic)
    techchange = efficiency(profitmodelbase, :Technical) - efficiency(profitmodelcomp, :Technical)
    allocchange = efficiency(profitmodelbase, :Allocative) - efficiency(profitmodelcomp, :Allocative)

    return ProfitChangeDEAModel(n, m, s, names, profchange, techchange, allocchange, profitmodelbase, profitmodelcomp)
end

deaprofitchangemodelname(::ProfitAdditiveDEAModel) = "Profit Efficiency Change Additive DEA Model"

function deadisplayinfo(io::IO, x::ProfitAdditiveDEAModel)
    print(io, "Weights = ", string(x.weights))
    print(io, "; Returns to Scale = VRS")
    print(io, "\n")
end

"""
    deaprofitchangerussell(X, Y, W, P)
Compute profit efficiency change using Russell data envelopment analysis for
inputs `X`, outputs `Y`, price of inputs `W`, and price of outputs `P`.

# Optional Arguments
- `monetary=false`: decomposition in normalized terms. Monetary terms if `true`.
- `names`: a vector of strings with the names of the decision making units.
"""
function deaprofitchangerussell(X::Array{Float64,3}, Y::Array{Float64,3}, 
    W::Array{Float64,3}, P::Array{Float64,3};
    monetary::Bool = false,
    names::Union{Vector{<: AbstractString},Nothing} = nothing,
    optimizer::Union{DEAOptimizer,Nothing} = nothing)::ProfitChangeDEAModel

    # Check parameters
    n = size(X, 1)
    m = size(X, 2)
    s = size(Y, 2)
    Tx = size(X, 3)
    Ty = size(Y, 3)
    Tw = size(W, 3)
    Tp = size(P, 3)

    Tx == Ty || throw(DimensionMismatch("number of time periods in X and Y ($Tx, $Ty) are not equal"));
    Tx == Tw || throw(DimensionMismatch("number of time periods in X and W ($Tx, $Tw) are not equal"));
    Ty == Tp || throw(DimensionMismatch("number of time periods in X and P ($Tx, $Tp) are not equal"));

    T = Tx
    Tx == 2 || throw(DimensionMismatch("number of time periods should be 2. Now $T"));

    # Run profit models and compute change
    profitmodelbase = deaprofitrussell(X[:,:,1], Y[:,:,1], W[:,:,1], P[:,:,1],
        monetary = monetary, names = names, optimizer = optimizer)
    profitmodelcomp = deaprofitrussell(X[:,:,2], Y[:,:,2], W[:,:,2], P[:,:,2],
        monetary = monetary, names = names, optimizer = optimizer)

    profchange = efficiency(profitmodelbase, :Economic) - efficiency(profitmodelcomp, :Economic)
    techchange = efficiency(profitmodelbase, :Technical) - efficiency(profitmodelcomp, :Technical)
    allocchange = efficiency(profitmodelbase, :Allocative) - efficiency(profitmodelcomp, :Allocative)

    return ProfitChangeDEAModel(n, m, s, names, profchange, techchange, allocchange, profitmodelbase, profitmodelcomp)
end

deaprofitchangemodelname(::ProfitRussellDEAModel) = "Profit Efficiency Change Russell DEA Model"

function deadisplayinfo(io::IO, x::ProfitRussellDEAModel)
    print(io, "Orientation = Graph")
    print(io, "; Returns to Scale = VRS")
    print(io, "\n")
end

"""
    deaprofitchangeerg(X, Y, W, P)
Compute profit efficiency change using data envelopment analysis Enhanced Russell Graph Slack Based Measure
model for inputs `X`, outputs `Y`, price of inputs `W`, and price of outputs `P`.

# Optional Arguments
- `monetary=false`: decomposition in normalized terms. Monetary terms if `true`.
- `names`: a vector of strings with the names of the decision making units.
"""
function deaprofitchangeerg(X::Array{Float64,3}, Y::Array{Float64,3}, 
    W::Array{Float64,3}, P::Array{Float64,3};
    monetary::Bool = false,
    names::Union{Vector{<: AbstractString},Nothing} = nothing,
    optimizer::Union{DEAOptimizer,Nothing} = nothing)::ProfitChangeDEAModel

    # Check parameters
    n = size(X, 1)
    m = size(X, 2)
    s = size(Y, 2)
    Tx = size(X, 3)
    Ty = size(Y, 3)
    Tw = size(W, 3)
    Tp = size(P, 3)

    Tx == Ty || throw(DimensionMismatch("number of time periods in X and Y ($Tx, $Ty) are not equal"));
    Tx == Tw || throw(DimensionMismatch("number of time periods in X and W ($Tx, $Tw) are not equal"));
    Ty == Tp || throw(DimensionMismatch("number of time periods in X and P ($Tx, $Tp) are not equal"));

    T = Tx
    Tx == 2 || throw(DimensionMismatch("number of time periods should be 2. Now $T"));

    # Run profit models and compute change
    profitmodelbase = deaprofiterg(X[:,:,1], Y[:,:,1], W[:,:,1], P[:,:,1], 
       monetary = monetary, names = names, optimizer = optimizer)
    profitmodelcomp = deaprofiterg(X[:,:,2], Y[:,:,2], W[:,:,2], P[:,:,2], 
       monetary = monetary, names = names, optimizer = optimizer)

    profchange = efficiency(profitmodelbase, :Economic) - efficiency(profitmodelcomp, :Economic)
    techchange = efficiency(profitmodelbase, :Technical) - efficiency(profitmodelcomp, :Technical)
    allocchange = efficiency(profitmodelbase, :Allocative) - efficiency(profitmodelcomp, :Allocative)

    return ProfitChangeDEAModel(n, m, s, names, profchange, techchange, allocchange, profitmodelbase, profitmodelcomp)
end

deaprofitchangemodelname(::ProfitERGDEAModel) = "Profit Efficiency Change Enhanced Russell Graph Slack Based Measure DEA Model"

function deadisplayinfo(io::IO, x::ProfitERGDEAModel)
    print(io, "Returns to Scale = VRS")
    print(io, "\n")
end

"""
    deaprofitchange(X, Y, W, P; Gx, Gy)
Compute profit efficiency change using data envelopment analysis model for
inputs `X`, outputs `Y`, price of inputs `W`, and price of outputs `P`.

# Direction specification:

The directions `Gx` and `Gy` can be one of the following symbols.
- `:Zeros`: use zeros.
- `:Ones`: use ones.
- `:Observed`: use observed values.
- `:Mean`: use column means.
- `:Monetary`: use direction so that profit inefficiency is expressed in monetary values.
- `:Euclidean`: use prices normalized by the Euclidean norm of all input and output prices so profit inefficiency is the Euclidean distance between profit hyperplanes.

Alternatively, a vector or matrix with the desired directions can be supplied.

# Optional Arguments
- `monetary=false`: decomposition in normalized terms. Monetary terms if `true`.
- `names`: a vector of strings with the names of the decision making units.
"""
function deaprofitchange(X::Array{Float64,3}, Y::Array{Float64,3},
    W::Array{Float64,3}, P::Array{Float64,3};
    Gx::Union{Symbol,Matrix,Vector}, Gy::Union{Symbol,Matrix,Vector},
    rts::Symbol = :VRS, monetary::Bool = false,
    names::Union{Vector{<: AbstractString},Nothing} = nothing,
    optimizer::Union{DEAOptimizer,Nothing} = nothing)::ProfitChangeDEAModel

    # Check parameters
    n = size(X, 1)
    m = size(X, 2)
    s = size(Y, 2)
    Tx = size(X, 3)
    Ty = size(Y, 3)
    Tw = size(W, 3)
    Tp = size(P, 3)

    Tx == Ty || throw(DimensionMismatch("number of time periods in X and Y ($Tx, $Ty) are not equal"));
    Tx == Tw || throw(DimensionMismatch("number of time periods in X and W ($Tx, $Tw) are not equal"));
    Ty == Tp || throw(DimensionMismatch("number of time periods in X and P ($Tx, $Tp) are not equal"));

    T = Tx
    Tx == 2 || throw(DimensionMismatch("number of time periods should be 2. Now $T"));

    # Run profit models and compute change
    profitmodelbase = deaprofit(X[:,:,1], Y[:,:,1], W[:,:,1], P[:,:,1], 
        Gx = Gx, Gy = Gy, rts = rts, monetary = monetary, names = names, optimizer = optimizer)
    profitmodelcomp = deaprofit(X[:,:,2], Y[:,:,2], W[:,:,2], P[:,:,2], 
        Gx = Gx, Gy = Gy, rts = rts, monetary = monetary, names = names, optimizer = optimizer)

    profchange = efficiency(profitmodelbase, :Economic) - efficiency(profitmodelcomp, :Economic)
    techchange = efficiency(profitmodelbase, :Technical) - efficiency(profitmodelcomp, :Technical)
    allocchange = efficiency(profitmodelbase, :Allocative) - efficiency(profitmodelcomp, :Allocative)

    return ProfitChangeDEAModel(n, m, s, names, profchange, techchange, allocchange, profitmodelbase, profitmodelcomp)
end

deaprofitchangemodelname(::ProfitDEAModel) = "Profit Efficiency Change DEA Model"

function deadisplayinfo(io::IO, x::ProfitDEAModel)
    print(io, "Returns to Scale = VRS")
    print(io, "\n")
    print(io, "Gx = ", string(x.Gx), "; Gy = ", string(x.Gy))
    print(io, "\n")
end

"""
    deaprofichangetholder(X, Y, W, P; l)
Compute profit efficiency change using data envelopment analysis Hölder model for
inputs `X`, outputs `Y`, price of inputs `W`, and price of outputs `P`.

# Hölder norm `l` specification
- `1`.
- `2`.
- `Inf`.

# Optional Arguments
- `weigt=false`:  set to `true` for weighted (weakly) Hölder distance function.
- `monetary=false`: decomposition in normalized terms. Monetary terms if `true`.
- `names`: a vector of strings with the names of the decision making units.
"""
function deaprofitchangeholder(X::Array{Float64,3}, Y::Array{Float64,3},
    W::Array{Float64,3}, P::Array{Float64,3};
    l::Union{Int64,Float64}, weight::Bool = false, monetary::Bool = false,
    names::Union{Vector{<: AbstractString},Nothing} = nothing,
    optimizer::Union{DEAOptimizer,Nothing} = nothing)::ProfitChangeDEAModel

    # Check parameters
    n = size(X, 1)
    m = size(X, 2)
    s = size(Y, 2)
    Tx = size(X, 3)
    Ty = size(Y, 3)
    Tw = size(W, 3)
    Tp = size(P, 3)

    Tx == Ty || throw(DimensionMismatch("number of time periods in X and Y ($Tx, $Ty) are not equal"));
    Tx == Tw || throw(DimensionMismatch("number of time periods in X and W ($Tx, $Tw) are not equal"));
    Ty == Tp || throw(DimensionMismatch("number of time periods in X and P ($Tx, $Tp) are not equal"));

    T = Tx
    Tx == 2 || throw(DimensionMismatch("number of time periods should be 2. Now $T"));

    # Run profit models and compute change
    profitmodelbase = deaprofitholder(X[:,:,1], Y[:,:,1], W[:,:,1], P[:,:,1],
        l = l, weight = weight, monetary = monetary, names = names, optimizer = optimizer)
    profitmodelcomp = deaprofitholder(X[:,:,2], Y[:,:,2], W[:,:,2], P[:,:,2],
        l = l, weight = weight, monetary = monetary, names = names, optimizer = optimizer)

    profchange = efficiency(profitmodelbase, :Economic) - efficiency(profitmodelcomp, :Economic)
    techchange = efficiency(profitmodelbase, :Technical) - efficiency(profitmodelcomp, :Technical)
    allocchange = efficiency(profitmodelbase, :Allocative) - efficiency(profitmodelcomp, :Allocative)

    return ProfitChangeDEAModel(n, m, s, names, profchange, techchange, allocchange, profitmodelbase, profitmodelcomp)
end

deaprofitchangemodelname(::ProfitHolderDEAModel) = "Profit Efficiency Change Hölder DEA Model"

function deadisplayinfo(io::IO, x::ProfitHolderDEAModel)
    print(io, "l = ", string(x.l))
    print(io, "; Returns to Scale = VRS")
    print(io, "\n")
end

"""
    deaprofitchangemddf(X, Y, W, P; Gx, Gy)
Compute profit efficiency change using Modified DDF data envelopment analysis model for
inputs `X`, outputs `Y`, price of inputs `W`, and price of outputs `P`.

# Direction specification:

The directions `Gx` and `Gy` can be one of the following symbols.
- `:Observed`: use observed values.

Alternatively, a vector or matrix with the desired directions can be supplied.

# Optional Arguments
- `monetary=false`: decomposition in normalized terms. Monetary terms if `true`.
- `names`: a vector of strings with the names of the decision making units.
"""
function deaprofitchangemddf(X::Array{Float64,3}, Y::Array{Float64,3},
    W::Array{Float64,3}, P::Array{Float64,3};
    Gx::Union{Symbol,Matrix,Vector}, Gy::Union{Symbol,Matrix,Vector},
    monetary::Bool = false,
    names::Union{Vector{<: AbstractString},Nothing} = nothing,
    optimizer::Union{DEAOptimizer,Nothing} = nothing)::ProfitChangeDEAModel

    # Check parameters
    n = size(X, 1)
    m = size(X, 2)
    s = size(Y, 2)
    Tx = size(X, 3)
    Ty = size(Y, 3)
    Tw = size(W, 3)
    Tp = size(P, 3)

    Tx == Ty || throw(DimensionMismatch("number of time periods in X and Y ($Tx, $Ty) are not equal"));
    Tx == Tw || throw(DimensionMismatch("number of time periods in X and W ($Tx, $Tw) are not equal"));
    Ty == Tp || throw(DimensionMismatch("number of time periods in X and P ($Tx, $Tp) are not equal"));

    T = Tx
    Tx == 2 || throw(DimensionMismatch("number of time periods should be 2. Now $T"));

    # Run profit models and compute change
    profitmodelbase = deaprofitmddf(X[:,:,1], Y[:,:,1], W[:,:,1], P[:,:,1],
        Gx = Gx, Gy = Gy, monetary = monetary, names = names, optimizer = optimizer)
    profitmodelcomp = deaprofitmddf(X[:,:,2], Y[:,:,2], W[:,:,2], P[:,:,2],
        Gx = Gx, Gy = Gy, monetary = monetary, names = names, optimizer = optimizer)

    profchange = efficiency(profitmodelbase, :Economic) - efficiency(profitmodelcomp, :Economic)
    techchange = efficiency(profitmodelbase, :Technical) - efficiency(profitmodelcomp, :Technical)
    allocchange = efficiency(profitmodelbase, :Allocative) - efficiency(profitmodelcomp, :Allocative)

    return ProfitChangeDEAModel(n, m, s, names, profchange, techchange, allocchange, profitmodelbase, profitmodelcomp)
end

deaprofitchangemodelname(::ProfitModifiedDDFDEAModel) = "Profit Efficiency Change Modified DDF DEA Model"

function deadisplayinfo(io::IO, x::ProfitModifiedDDFDEAModel)
    print(io, "Returns to Scale = VRS")
    print(io, "\n")
    print(io, "Gx = ", string(x.Gx), "; Gy = ", string(x.Gy))
    print(io, "\n")
end

"""
    deaprofitchangerddf(X, Y, W, P, measure)
Compute profit change efficiency using data envelopment analysis Reverse DDF model for
inputs `X`, outputs `Y`, price of inputs `W`, price of outputs `P`, and efficiency `measure`.

# Measure specification:
- `:ERG`: Enhanced Russell Graph Slack Based Measure.
- `:MDDF`: Modified Directional Distance Function.

# Direction specification:
For the Modified Directional Distance Function, the directions `Gx` and `Gy` can be one of the following symbols.
- `:Observed`: use observed values.

Alternatively, a vector or matrix with the desired directions can be supplied.

# Optional Arguments
- `monetary=false`: decomposition in normalized terms. Monetary terms if `true`.
- `atol=1e-6`: tolerance for DMU to be considered efficient.
- `names`: a vector of strings with the names of the decision making units.
"""
function deaprofitchangerddf(X::Array{Float64,3}, Y::Array{Float64,3},
    W::Array{Float64,3}, P::Array{Float64,3},
    measure::Symbol;
    Gx::Union{Symbol,Matrix,Vector,Nothing} = nothing, Gy::Union{Symbol,Matrix,Vector,Nothing} = nothing,
    monetary::Bool = false, atol::Float64 = 1e-6,
    names::Union{Vector{<: AbstractString},Nothing} = nothing,
    optimizer::Union{DEAOptimizer,Nothing} = nothing)::ProfitChangeDEAModel

    # Check parameters
    n = size(X, 1)
    m = size(X, 2)
    s = size(Y, 2)
    Tx = size(X, 3)
    Ty = size(Y, 3)
    Tw = size(W, 3)
    Tp = size(P, 3)

    Tx == Ty || throw(DimensionMismatch("number of time periods in X and Y ($Tx, $Ty) are not equal"));
    Tx == Tw || throw(DimensionMismatch("number of time periods in X and W ($Tx, $Tw) are not equal"));
    Ty == Tp || throw(DimensionMismatch("number of time periods in X and P ($Tx, $Tp) are not equal"));

    T = Tx
    Tx == 2 || throw(DimensionMismatch("number of time periods should be 2. Now $T"));

    # Run profit models and compute change
    profitmodelbase = deaprofitrddf(X[:,:,1], Y[:,:,1], W[:,:,1], P[:,:,1],
        measure, Gx = Gx, Gy = Gy, monetary = monetary, atol = atol, names = names, optimizer = optimizer)
    profitmodelcomp = deaprofitrddf(X[:,:,2], Y[:,:,2], W[:,:,2], P[:,:,2],
        measure, Gx = Gx, Gy = Gy, monetary = monetary, atol = atol, names = names, optimizer = optimizer)

    profchange = efficiency(profitmodelbase, :Economic) - efficiency(profitmodelcomp, :Economic)
    techchange = efficiency(profitmodelbase, :Technical) - efficiency(profitmodelcomp, :Technical)
    allocchange = efficiency(profitmodelbase, :Allocative) - efficiency(profitmodelcomp, :Allocative)

    return ProfitChangeDEAModel(n, m, s, names, profchange, techchange, allocchange, profitmodelbase, profitmodelcomp)
end

deaprofitchangemodelname(::ProfitReverseDDFDEAModel) = "Profit Efficiency Change Reverse DDF DEA Model"

function deadisplayinfo(io::IO, x::ProfitReverseDDFDEAModel)
    print(io, "Returns to Scale = VRS")
    print(io, "\n")
    print(io, "Associated efficiency measure = ", string(x.measure))
    print(io, "\n")
end

"""
    deaprofitchangegda(X, Y, W, P, measure)
Compute profit efficiency change using data envelopment analysis General Direct Approach model for
inputs `X`, outputs `Y`, price of inputs `W`, price of outputs `P`, and efficiency `measure`.

# Measure specification:
- `:ERG`: Enhanced Russell Graph (or Slack Based Measure (SBM)).

# Optional Arguments
- `monetary=false`: decomposition in normalized terms. Monetary terms if `true`.
- `atol=1e-6`: tolerance for DMU to be considered efficient.
- `names`: a vector of strings with the names of the decision making units.
"""
function deaprofitchangegda(X::Array{Float64,3}, Y::Array{Float64,3},
    W::Array{Float64,3}, P::Array{Float64,3},
    measure::Symbol;
    monetary::Bool = false, atol::Float64 = 1e-6,
    names::Union{Vector{<: AbstractString},Nothing} = nothing,
    optimizer::Union{DEAOptimizer,Nothing} = nothing)::ProfitChangeDEAModel

    # Check parameters
    n = size(X, 1)
    m = size(X, 2)
    s = size(Y, 2)
    Tx = size(X, 3)
    Ty = size(Y, 3)
    Tw = size(W, 3)
    Tp = size(P, 3)

    Tx == Ty || throw(DimensionMismatch("number of time periods in X and Y ($Tx, $Ty) are not equal"));
    Tx == Tw || throw(DimensionMismatch("number of time periods in X and W ($Tx, $Tw) are not equal"));
    Ty == Tp || throw(DimensionMismatch("number of time periods in X and P ($Tx, $Tp) are not equal"));

    T = Tx
    Tx == 2 || throw(DimensionMismatch("number of time periods should be 2. Now $T"));

    # Run profit models and compute change
    profitmodelbase = deaprofitgda(X[:,:,1], Y[:,:,1], W[:,:,1], P[:,:,1],
        measure, monetary = monetary, atol = atol, names = names, optimizer = optimizer)
    profitmodelcomp = deaprofitgda(X[:,:,2], Y[:,:,2], W[:,:,2], P[:,:,2],
        measure, monetary = monetary, atol = atol, names = names, optimizer = optimizer)

    profchange = efficiency(profitmodelbase, :Economic) - efficiency(profitmodelcomp, :Economic)
    techchange = efficiency(profitmodelbase, :Technical) - efficiency(profitmodelcomp, :Technical)
    allocchange = efficiency(profitmodelbase, :Allocative) - efficiency(profitmodelcomp, :Allocative)

    return ProfitChangeDEAModel(n, m, s, names, profchange, techchange, allocchange, profitmodelbase, profitmodelcomp)
end

deaprofitchangemodelname(::ProfitGDADEAModel) = "General Direct Approach Profit Efficiency Change DEA Model"

function deadisplayinfo(io::IO, x::ProfitGDADEAModel)
    print(io, "Returns to Scale = VRS")
    print(io, "\n")
    print(io, "Associated efficiency measure = ", string(x.measure))
    print(io, "\n")
end


# Show function common for all Profit Change Models
function Base.show(io::IO, x::ProfitChangeDEAModel)
    compact = get(io, :compact, false)

    n = nobs(x)
    m = ninputs(x)
    s = noutputs(x)
    dmunames = names(x)

    profchange = x.profchange
    techchange = x.techchange
    allocchange = x.allocchange

    normbase = x.profitmodelbase.normalization
    normcomp = x.profitmodelcomp.normalization

    if !compact
        print(io, deaprofitchangemodelname(x.profitmodelbase) * " \n")
        print(io, "DMUs = ", n)
        print(io, "; Inputs = ", m)
        print(io, "; Outputs = ", s)
        print(io, "; Time periods = 2")
        print(io, "\n")
        deadisplayinfo(io, x.profitmodelbase)
        
        show(io, MIME"text/plain"(), CoefTable(hcat(profchange, techchange, allocchange, normbase, normcomp), ["Prof.Change", "Tech.Change", "Alloc.Change", "NF.Base", "NF.Comp"], dmunames))
    end

end

"""
    effchange(model::ProfitChangeDEAModel)
Return efficiency change of a profit change DEA model.

# Optional Arguments
- `type=Economic`: type of efficiency change scores to return.

Type specification:
- `:Economic`: returns economic efficiency change of the model.
- `:Technical`: returns technical efficiency change.
- `:Allocative`: returns allocative efficiency change.
"""
function effchange(model::ProfitChangeDEAModel, type::Symbol = :Economic)::Vector

    if type == :Economic
        return model.profchange
    end
    if type == :Technical
        return model.techchange
    end
    if type == :Allocative
        return model.allocchange
    end

    throw(ArgumentError("$(typeof(model)) has no efficiency change $(type)"));

end
