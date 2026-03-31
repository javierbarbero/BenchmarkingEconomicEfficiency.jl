# This file contains functions for the Revenue Efficiency Change DEA model
"""
    RevenueChangeDEAModel
An data structure representing a revenue change DEA model.
"""
struct RevenueChangeDEAModel <: AbstractRevenueDEAModel
    n::Int64
    m::Int64
    s::Int64
    dmunames::Union{Vector{String},Nothing}
    revenuechange::Vector
    techchange::Vector
    allocchange::Vector
    revenuemodelbase::AbstractRevenueDEAModel
    revenuemodelcomp::AbstractRevenueDEAModel
end

"""
    dearevenuechange(X, Y, P, model)
Compute revenue efficiency change using data envelopment analysis radial model for
inputs `X`, outputs `Y`, and price of outputs `P`.

# Optional Arguments
- `names`: a vector of strings with the names of the decision making units.
"""
function dearevenuechange(X::Array{Float64,3}, Y::Array{Float64,3}, 
    P::Array{Float64,3}, 
    names::Union{Vector{<: AbstractString},Nothing} = nothing,
    optimizer::Union{DEAOptimizer,Nothing} = nothing)::RevenueChangeDEAModel

    # Check parameters
    n = size(X, 1)
    m = size(X, 2)
    s = size(Y, 2)
    Tx = size(X, 3)
    Ty = size(Y, 3)
    Tp = size(P, 3)

    Tx == Ty || throw(DimensionMismatch("number of time periods in X and Y ($Tx, $Ty) are not equal"));
    Ty == Tp || throw(DimensionMismatch("number of time periods in Y and P ($Ty, $Tp) are not equal"));

    T = Tx
    Tx == 2 || throw(DimensionMismatch("number of time periods should be 2. Now $T"));

    # Run revenue models and compute change
    revenuemodelbase = dearevenue(X[:,:,1], Y[:,:,1], P[:,:,1],
        names = names, optimizer = optimizer)
    revenuemodelcomp = dearevenue(X[:,:,2], Y[:,:,2], P[:,:,2],
        names = names, optimizer = optimizer)

    revenuechange = efficiency(revenuemodelcomp, :Economic) ./ efficiency(revenuemodelbase, :Economic)
    techchange = efficiency(revenuemodelcomp, :Technical) ./ efficiency(revenuemodelbase, :Technical) # No nee dto (1 ./ efficiency) as dearevenue already returns the inverse
    allocchange = efficiency(revenuemodelcomp, :Allocative) ./ efficiency(revenuemodelbase, :Allocative)

    return RevenueChangeDEAModel(n, m, s, names, revenuechange, techchange, allocchange, revenuemodelbase, revenuemodelcomp)
end

dearevenuechangemodelname(::RevenueDEAModel) = "Revenue Efficiency Change Radial DEA Model"

function deadisplayinfo(io::IO, x::RevenueDEAModel)
    print(io, "; Returns to Scale = VRS")
    print(io, "\n")
end

"""
    dearevenuechangeadd(X, Y, P, model)
Compute revenue efficiency change using data envelopment analysis weighted additive model for
inputs `X`, outputs `Y`, and price of outputs `P`.

Model specification:
- `:Ones`: standard additive DEA model.
- `:MIP`: Measure of Inefficiency Proportions. (Charnes et al., 1987; Cooper et al., 1999)
- `:Normalized`: Normalized weighted additive DEA model. (Lovell and Pastor, 1995)
- `:RAM`: Range Adjusted Measure. (Cooper et al., 1999)
- `:BAM`: Bounded Adjusted Measure. (Cooper et al, 2011)
- `:Custom`: User supplied weights.

# Optional Arguments
- `rhoY`: matrix of weights of outputs. Only if `model=:Custom`.
- `monetary=false`: decomposition in normalized terms. Monetary terms if `true`.
- `names`: a vector of strings with the names of the decision making units.
"""
function dearevenuechangeadd(X::Array{Float64,3}, Y::Array{Float64,3}, 
    P::Array{Float64,3}, 
    model::Symbol = :Default;
    rhoY::Union{Matrix,Vector,Nothing} = nothing,
    monetary::Bool = false, 
    names::Union{Vector{<: AbstractString},Nothing} = nothing,
    optimizer::Union{DEAOptimizer,Nothing} = nothing)::RevenueChangeDEAModel

    # Check parameters
    n = size(X, 1)
    m = size(X, 2)
    s = size(Y, 2)
    Tx = size(X, 3)
    Ty = size(Y, 3)
    Tp = size(P, 3)

    Tx == Ty || throw(DimensionMismatch("number of time periods in X and Y ($Tx, $Ty) are not equal"));
    Ty == Tp || throw(DimensionMismatch("number of time periods in X and P ($Ty, $Tp) are not equal"));

    T = Tx
    Tx == 2 || throw(DimensionMismatch("number of time periods should be 2. Now $T"));

    # Run revenue models and compute change
    revenuemodelbase = dearevenueadd(X[:,:,1], Y[:,:,1], P[:,:,1],
        model, rhoY = rhoY, monetary = monetary, names = names, optimizer = optimizer)
    revenuemodelcomp = dearevenueadd(X[:,:,2], Y[:,:,2], P[:,:,2],
        model, rhoY = rhoY, monetary = monetary, names = names, optimizer = optimizer)

    revenuechange = efficiency(revenuemodelbase, :Economic) - efficiency(revenuemodelcomp, :Economic)
    techchange = efficiency(revenuemodelbase, :Technical) - efficiency(revenuemodelcomp, :Technical)
    allocchange = efficiency(revenuemodelbase, :Allocative) - efficiency(revenuemodelcomp, :Allocative)

    return RevenueChangeDEAModel(n, m, s, names, revenuechange, techchange, allocchange, revenuemodelbase, revenuemodelcomp)
end

dearevenuechangemodelname(::RevenueAdditiveDEAModel) = "Revenue Efficiency Change Additive DEA Model"

function deadisplayinfo(io::IO, x::RevenueAdditiveDEAModel)
    print(io, "Weights = ", string(x.weights))
    print(io, "; Returns to Scale = VRS")
    print(io, "\n")
end

"""
    dearevenuechangerussell(X, Y, W, P)
Compute revenue efficiency change using Russell data envelopment analysis for
inputs `X`, outputs `Y`, and price of outputs `P`.

# Optional Arguments
- `monetary=false`: decomposition in normalized terms. Monetary terms if `true`.
- `names`: a vector of strings with the names of the decision making units.
"""
function dearevenuechangerussell(X::Array{Float64,3}, Y::Array{Float64,3}, 
    P::Array{Float64,3};
    monetary::Bool = false,
    names::Union{Vector{<: AbstractString},Nothing} = nothing,
    optimizer::Union{DEAOptimizer,Nothing} = nothing)::RevenueChangeDEAModel

    # Check parameters
    n = size(X, 1)
    m = size(X, 2)
    s = size(Y, 2)
    Tx = size(X, 3)
    Ty = size(Y, 3)
    Tp = size(P, 3)

    Tx == Ty || throw(DimensionMismatch("number of time periods in X and Y ($Tx, $Ty) are not equal"));
    Ty == Tp || throw(DimensionMismatch("number of time periods in X and P ($Tx, $Tp) are not equal"));

    T = Tx
    Tx == 2 || throw(DimensionMismatch("number of time periods should be 2. Now $T"));

    # Run revenue models and compute change
    revenuemodelbase = dearevenuerussell(X[:,:,1], Y[:,:,1], P[:,:,1],
        monetary = monetary, names = names, optimizer = optimizer)
    revenuemodelcomp = dearevenuerussell(X[:,:,2], Y[:,:,2], P[:,:,2],
        monetary = monetary, names = names, optimizer = optimizer)

    revenuechange = efficiency(revenuemodelbase, :Economic) - efficiency(revenuemodelcomp, :Economic)
    techchange = efficiency(revenuemodelbase, :Technical) - efficiency(revenuemodelcomp, :Technical)
    allocchange = efficiency(revenuemodelbase, :Allocative) - efficiency(revenuemodelcomp, :Allocative)

    return RevenueChangeDEAModel(n, m, s, names, revenuechange, techchange, allocchange, revenuemodelbase, revenuemodelcomp)
end

dearevenuechangemodelname(::RevenueRussellDEAModel) = "Revenue Efficiency Change Russell DEA Model"

function deadisplayinfo(io::IO, x::RevenueRussellDEAModel)
    print(io, "Orientation = Output")
    print(io, "; Returns to Scale = VRS")
    print(io, "\n")
end

"""
    dearevenuechangeddf(X, Y, W, P; Gx, Gy)
Compute revenue efficiency change using data envelopment analysis model for
inputs `X`, outputs `Y`, and price of outputs `P`.

# Direction specification:

The direction `Gy` can be one of the following symbols.
- `:Zeros`: use zeros.
- `:Ones`: use ones.
- `:Observed`: use observed values.
- `:Mean`: use column means.
- `:Monetary`: use direction so that revenue inefficiency is expressed in monetary values.

Alternatively, a vector or matrix with the desired directions can be supplied.

# Optional Arguments
- `monetary=false`: decomposition in normalized terms. Monetary terms if `true`.
- `names`: a vector of strings with the names of the decision making units.
"""
function dearevenuechangeddf(X::Array{Float64,3}, Y::Array{Float64,3},
    P::Array{Float64,3};
    Gy::Union{Symbol,Matrix,Vector},
    rts::Symbol = :VRS, monetary::Bool = false,
    names::Union{Vector{<: AbstractString},Nothing} = nothing,
    optimizer::Union{DEAOptimizer,Nothing} = nothing)::RevenueChangeDEAModel

    # Check parameters
    n = size(X, 1)
    m = size(X, 2)
    s = size(Y, 2)
    Tx = size(X, 3)
    Ty = size(Y, 3)
    Tp = size(P, 3)

    Tx == Ty || throw(DimensionMismatch("number of time periods in X and Y ($Tx, $Ty) are not equal"));
    Ty == Tp || throw(DimensionMismatch("number of time periods in X and P ($Tx, $Tp) are not equal"));

    T = Tx
    Tx == 2 || throw(DimensionMismatch("number of time periods should be 2. Now $T"));

    # Run revenue models and compute change
    revenuemodelbase = dearevenueddf(X[:,:,1], Y[:,:,1], P[:,:,1], 
        Gy = Gy, rts = rts, monetary = monetary, names = names, optimizer = optimizer)
    revenuemodelcomp = dearevenueddf(X[:,:,2], Y[:,:,2], P[:,:,2], 
        Gy = Gy, rts = rts, monetary = monetary, names = names, optimizer = optimizer)

    revenuechange = efficiency(revenuemodelbase, :Economic) - efficiency(revenuemodelcomp, :Economic)
    techchange = efficiency(revenuemodelbase, :Technical) - efficiency(revenuemodelcomp, :Technical)
    allocchange = efficiency(revenuemodelbase, :Allocative) - efficiency(revenuemodelcomp, :Allocative)

    return RevenueChangeDEAModel(n, m, s, names, revenuechange, techchange, allocchange, revenuemodelbase, revenuemodelcomp)
end

dearevenuechangemodelname(::RevenueDDFDEAModel) = "Revenue Efficiency Change DEA Model"

function deadisplayinfo(io::IO, x::RevenueDDFDEAModel)
    print(io, "Returns to Scale = VRS")
    print(io, "\n")
    print(io, "Gy = ", string(x.Gy))
    print(io, "\n")
end

"""
    derevenuechangetholder(X, Y, W, P; l)
Compute revenue efficiency change using data envelopment analysis Hölder model for
inputs `X`, outputs `Y`, and price of outputs `P`.

# Hölder norm `l` specification
- `1`.
- `2`.
- `Inf`.

# Optional Arguments
- `weigt=false`:  set to `true` for weighted (weakly) Hölder distance function.
- `monetary=false`: decomposition in normalized terms. Monetary terms if `true`.
- `names`: a vector of strings with the names of the decision making units.
"""
function dearevenuechangeholder(X::Array{Float64,3}, Y::Array{Float64,3},
    P::Array{Float64,3};
    l::Union{Int64,Float64}, weight::Bool = false, monetary::Bool = false,
    names::Union{Vector{<: AbstractString},Nothing} = nothing,
    optimizer::Union{DEAOptimizer,Nothing} = nothing)::RevenueChangeDEAModel

    # Check parameters
    n = size(X, 1)
    m = size(X, 2)
    s = size(Y, 2)
    Tx = size(X, 3)
    Ty = size(Y, 3)
    Tp = size(P, 3)

    Tx == Ty || throw(DimensionMismatch("number of time periods in X and Y ($Tx, $Ty) are not equal"));
    Ty == Tp || throw(DimensionMismatch("number of time periods in X and P ($Tx, $Tp) are not equal"));

    T = Tx
    Tx == 2 || throw(DimensionMismatch("number of time periods should be 2. Now $T"));

    # Run revenue models and compute change
    revenuemodelbase = dearevenueholder(X[:,:,1], Y[:,:,1], P[:,:,1],
        l = l, weight = weight, monetary = monetary, names = names, optimizer = optimizer)
    revenuemodelcomp = dearevenueholder(X[:,:,2], Y[:,:,2], P[:,:,2],
        l = l, weight = weight, monetary = monetary, names = names, optimizer = optimizer)

    revenuechange = efficiency(revenuemodelbase, :Economic) - efficiency(revenuemodelcomp, :Economic)
    techchange = efficiency(revenuemodelbase, :Technical) - efficiency(revenuemodelcomp, :Technical)
    allocchange = efficiency(revenuemodelbase, :Allocative) - efficiency(revenuemodelcomp, :Allocative)

    return RevenueChangeDEAModel(n, m, s, names, revenuechange, techchange, allocchange, revenuemodelbase, revenuemodelcomp)
end

dearevenuechangemodelname(::RevenueHolderDEAModel) = "Revenue Efficiency Change Hölder DEA Model"

function deadisplayinfo(io::IO, x::RevenueHolderDEAModel)
    print(io, "l = ", string(x.l))
    print(io, "; Returns to Scale = VRS")
    print(io, "\n")
end

"""
    dearevenuechangerddf(X, Y, W, P, measure)
Compute revenue change efficiency using data envelopment analysis Reverse DDF model for
inputs `X`, outputs `Y`, price of outputs `P`, and efficiency `measure`.

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
function dearevenuechangerddf(X::Array{Float64,3}, Y::Array{Float64,3},
    P::Array{Float64,3},
    measure::Symbol;
    Gy::Union{Symbol,Matrix,Vector,Nothing} = nothing,
    monetary::Bool = false, atol::Float64 = 1e-6,
    names::Union{Vector{<: AbstractString},Nothing} = nothing,
    optimizer::Union{DEAOptimizer,Nothing} = nothing)::RevenueChangeDEAModel

    # Check parameters
    n = size(X, 1)
    m = size(X, 2)
    s = size(Y, 2)
    Tx = size(X, 3)
    Ty = size(Y, 3)
    Tp = size(P, 3)

    Tx == Ty || throw(DimensionMismatch("number of time periods in X and Y ($Tx, $Ty) are not equal"));
    Ty == Tp || throw(DimensionMismatch("number of time periods in X and P ($Tx, $Tp) are not equal"));

    T = Tx
    Tx == 2 || throw(DimensionMismatch("number of time periods should be 2. Now $T"));

    # Run revenue models and compute change
    revenuemodelbase = dearevenuerddf(X[:,:,1], Y[:,:,1], P[:,:,1],
        measure, monetary = monetary, atol = atol, names = names, optimizer = optimizer)
    revenuemodelcomp = dearevenuerddf(X[:,:,2], Y[:,:,2], P[:,:,2],
        measure, monetary = monetary, atol = atol, names = names, optimizer = optimizer)

    revenuechange = efficiency(revenuemodelbase, :Economic) - efficiency(revenuemodelcomp, :Economic)
    techchange = efficiency(revenuemodelbase, :Technical) - efficiency(revenuemodelcomp, :Technical)
    allocchange = efficiency(revenuemodelbase, :Allocative) - efficiency(revenuemodelcomp, :Allocative)

    return RevenueChangeDEAModel(n, m, s, names, revenuechange, techchange, allocchange, revenuemodelbase, revenuemodelcomp)
end

dearevenuechangemodelname(::RevenueReverseDDFDEAModel) = "Revenue Efficiency Change Reverse DDF DEA Model"

function deadisplayinfo(io::IO, x::RevenueReverseDDFDEAModel)
    print(io, "Returns to Scale = VRS")
    print(io, "\n")
    print(io, "Associated efficiency measure = ", string(x.measure))
    print(io, "\n")
end

"""
    dearevenuechangegda(X, Y, W, P, measure)
Compute revenue efficiency change using data envelopment analysis General Direct Approach model for
inputs `X`, outputs `Y`, price of outputs `P`, and efficiency `measure`.

# Measure specification:
- `:ERG`: Enhanced Russell Graph (or Slack Based Measure (SBM)).

# Optional Arguments
- `monetary=false`: decomposition in normalized terms. Monetary terms if `true`.
- `atol=1e-6`: tolerance for DMU to be considered efficient.
- `names`: a vector of strings with the names of the decision making units.
"""
function dearevenuechangegda(X::Array{Float64,3}, Y::Array{Float64,3},
    P::Array{Float64,3},
    measure::Symbol;
    monetary::Bool = false, atol::Float64 = 1e-6,
    names::Union{Vector{<: AbstractString},Nothing} = nothing,
    optimizer::Union{DEAOptimizer,Nothing} = nothing)::RevenueChangeDEAModel

    # Check parameters
    n = size(X, 1)
    m = size(X, 2)
    s = size(Y, 2)
    Tx = size(X, 3)
    Ty = size(Y, 3)
    Tp = size(P, 3)

    Tx == Ty || throw(DimensionMismatch("number of time periods in X and Y ($Tx, $Ty) are not equal"));
    Ty == Tp || throw(DimensionMismatch("number of time periods in X and P ($Tx, $Tp) are not equal"));

    T = Tx
    Tx == 2 || throw(DimensionMismatch("number of time periods should be 2. Now $T"));

    # Run revenue models and compute change
    revenuemodelbase = dearevenuegda(X[:,:,1], Y[:,:,1], P[:,:,1],
        measure, monetary = monetary, atol = atol, names = names, optimizer = optimizer)
    revenuemodelcomp = dearevenuegda(X[:,:,2], Y[:,:,2], P[:,:,2],
        measure, monetary = monetary, atol = atol, names = names, optimizer = optimizer)

    revenuechange = efficiency(revenuemodelbase, :Economic) - efficiency(revenuemodelcomp, :Economic)
    techchange = efficiency(revenuemodelbase, :Technical) - efficiency(revenuemodelcomp, :Technical)
    allocchange = efficiency(revenuemodelbase, :Allocative) - efficiency(revenuemodelcomp, :Allocative)

    return RevenueChangeDEAModel(n, m, s, names, revenuechange, techchange, allocchange, revenuemodelbase, revenuemodelcomp)
end

dearevenuechangemodelname(::RevenueGDADEAModel) = "General Direct Approach Revenue Efficiency Change DEA Model"

function deadisplayinfo(io::IO, x::RevenueGDADEAModel)
    print(io, "Returns to Scale = VRS")
    print(io, "\n")
    print(io, "Associated efficiency measure = ", string(x.measure))
    print(io, "\n")
end


# Show function common for all revenue Change Models
function Base.show(io::IO, x::RevenueChangeDEAModel)
    compact = get(io, :compact, false)

    n = nobs(x)
    m = ninputs(x)
    s = noutputs(x)
    dmunames = names(x)

    revenuechange = x.revenuechange
    techchange = x.techchange
    allocchange = x.allocchange

    if typeof(x.revenuemodelbase) == RevenueDEAModel
        normbase = zeros(n)
        normcomp = zeros(n)
    else
        normbase = x.revenuemodelbase.normalization
        normcomp = x.revenuemodelcomp.normalization
    end

    if !compact
        print(io, dearevenuechangemodelname(x.revenuemodelbase) * " \n")
        print(io, "DMUs = ", n)
        print(io, "; Inputs = ", m)
        print(io, "; Outputs = ", s)
        print(io, "; Time periods = 2")
        print(io, "\n")
        deadisplayinfo(io, x.revenuemodelbase)
        
        if typeof(x.revenuemodelbase) == RevenueDEAModel
            show(io, MIME"text/plain"(), CoefTable(hcat(revenuechange, techchange, allocchange), ["Rev.Change", "Tech.Change", "Alloc.Change"], dmunames))
        else
            show(io, MIME"text/plain"(), CoefTable(hcat(revenuechange, techchange, allocchange, normbase, normcomp), ["Rev.Change", "Tech.Change", "Alloc.Change", "NF.Base", "NF.Comp"], dmunames))
        end
    end

end

"""
    effchange(model::RevenueChangeDEAModel)
Return efficiency change of a revenue change DEA model.

# Optional Arguments
- `type=Economic`: type of efficiency change scores to return.

Type specification:
- `:Economic`: returns economic efficiency change of the model.
- `:Technical`: returns technical efficiency change.
- `:Allocative`: returns allocative efficiency change.
"""
function effchange(model::RevenueChangeDEAModel, type::Symbol = :Economic)::Vector

    if type == :Economic
        return model.revenuechange
    end
    if type == :Technical
        return model.techchange
    end
    if type == :Allocative
        return model.allocchange
    end

    throw(ArgumentError("$(typeof(model)) has no efficiency change $(type)"));

end
