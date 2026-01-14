# This file contains functions for the Cost General Direct Approach DEA model
"""
    CostGDADEAModel
An data structure representing a Cost General Direct Approach  DEA model.
"""
struct CostGDADEAModel <: AbstractCostDEAModel
    n::Int64
    m::Int64
    s::Int64
    measure::Symbol
    rts::Symbol 
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
    deacostgda(X, Y, W, measure)
Compute cost efficiency using data envelopment analysis General Direct Approach model for
inputs `X`, outputs `Y`, price of inputs `W`, and efficiency `measure`.

# Measure specification:
- `:ERG`: Enhanced Russell Graph (or Slack Based Measure (SBM)).

# Optional Arguments
- `rts=:VRS`: choose between constant returns to scale `:CRS` or variable returns to scale `:VRS`.
- `atol=1e-6`: tolerance for DMU to be considered efficient.
- `monetary=false`: decomposition in normalized terms. Monetary terms if `true`.
- `names`: a vector of strings with the names of the decision making units.
"""
function deacostgda(X::Union{Matrix,Vector}, Y::Union{Matrix,Vector},
    W::Union{Matrix,Vector},
    measure::Symbol;    
    rts::Symbol = :VRS, monetary::Bool = false, atol::Float64 = 1e-6,
    names::Union{Vector{<: AbstractString},Nothing} = nothing,
    optimizer::Union{DEAOptimizer,Nothing} = nothing)::CostGDADEAModel

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

    n = nx

    # Get efficiency measure model
    if measure == :ERG
        measuremodel = deacostrussell(X, Y, W, rts = rts, optimizer = optimizer)
        measuretechnicalmodel = dearussell(X, Y, orient = :Input, rts = rts, slack = false, optimizer = optimizer)
    else
        throw(ArgumentError("Invalid efficiency `measure`"));
    end

    normmeasure = normfactor(measuremodel)
    cimeasure = efficiency(measuremodel)  .* normmeasure   
    timeasure = efficiency(measuremodel, :Technical) 
    clambdaeff = peersmatrix(measuremodel)
    Xtarget = targets(measuremodel, :X)
    Ytarget = targets(measuremodel, :Y)
    Xtargetti = targets(measuretechnicalmodel, :X)
    Ytargetti = targets(measuretechnicalmodel, :Y)

    # Calculate slack as the difference between target and observed
    slackXmeasure = X .- Xtargetti

    # Get profit inefficiency of projection (target)
    if measure == :ERG
        targetmodel = deacostrussell(Xtargetti, Ytargetti, W, rts = rts, optimizer = optimizer)
    end

    citarget = efficiency(targetmodel) .* normfactor(targetmodel)

    monetaryti = sum(W .* slackXmeasure, dims = 2)

    # Normalization factor (equation 13.13)
    normalization = zeros(n)
    for i=1:n        
        if abs(timeasure[i] ) <= atol
            # For technical efficient DMU's
            normalization[i] = normmeasure[i]        
        else
            # For inefficient DMU's
            normalization[i] = monetaryti[i] ./ timeasure[i]
        end
    end
    
    if monetary
        cefficiency = cimeasure 
        techefficiency = timeasure .* normalization
        allocefficiency = citarget
    else
        cefficiency = cimeasure ./ normalization
        techefficiency = timeasure
        allocefficiency = citarget ./ normalization
    end

    return CostGDADEAModel(n, m, s, measure, rts, monetary, names, cefficiency, clambdaeff, techefficiency, allocefficiency, normalization, Xtarget, Ytarget)
end

function Base.show(io::IO, x::CostGDADEAModel)
    compact = get(io, :compact, false)

    n = nobs(x)
    m = ninputs(x)
    s = noutputs(x)
    dmunames = names(x)

    eff = efficiency(x)
    techeff = efficiency(x, :Technical)
    alloceff = efficiency(x, :Allocative)

    if !compact
        print(io, "General Direct Approach Cost DEA Model \n")
        print(io, "DMUs = ", n)
        print(io, "; Inputs = ", m)
        print(io, "; Outputs = ", s)
        print(io, "\n")
        print(io, "Returns to Scale = ", string(x.rts))
        print(io, "\n")
        print(io, "Associated efficiency measure = ", string(x.measure))
        print(io, "\n")
        show(io, MIME"text/plain"(), CoefTable(hcat(eff, techeff, alloceff), ["Cost", "Technical", "Allocative"], dmunames))
    end

end
