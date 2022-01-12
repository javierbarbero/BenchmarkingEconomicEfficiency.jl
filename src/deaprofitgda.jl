# This file contains functions for the Profit General Direct Approach DEA model
"""
    ProfitGDADEAModel
An data structure representing a profit General Direct Approach DEA model.
"""
struct ProfitGDADEAModel <: AbstractProfitDEAModel
    n::Int64
    m::Int64
    s::Int64
    measure::Symbol
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
    deaprofitgda(X, Y, W, P, measure)
Compute profit efficiency using data envelopment analysis General Direct Approach model for
inputs `X`, outputs `Y`, price of inputs `W`, price of outputs `P`, and efficiency `measure`.

# Measure specification:
- `:ERG`: Enhanced Russell Graph (or Slack Based Measure (SBM)).

# Optional Arguments
- `monetary=false`: decomposition in normalized terms. Monetary terms if `true`.
- `atol=1e-6`: tolerance for DMU to be considered efficient.
- `names`: a vector of strings with the names of the decision making units.
"""
function deaprofitgda(X::Union{Matrix,Vector}, Y::Union{Matrix,Vector},
    W::Union{Matrix,Vector}, P::Union{Matrix,Vector},
    measure::Symbol;
    monetary::Bool = false, atol::Float64 = 1e-6,
    names::Union{Vector{String},Nothing} = nothing,
    optimizer::Union{DEAOptimizer,Nothing} = nothing)::ProfitGDADEAModel

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

    n = nx

    # Get efficiency measure model
    if measure == :ERG
        measuremodel = deaprofiterg(X, Y, W, P, optimizer = optimizer)
        measuretechnicalmodel = deaerg(X, Y, rts = :VRS, optimizer = optimizer)
    else
        throw(ArgumentError("Invalid efficiency `measure`"));
    end

    normmeasure = normfactor(measuremodel)
    pimeasure = efficiency(measuremodel)  .* normmeasure   
    timeasure = efficiency(measuremodel, :Technical) 
    plambdaeff = peersmatrix(measuremodel)
    Xtarget = targets(measuremodel, :X)
    Ytarget = targets(measuremodel, :Y)
    slackXmeasure = slacks(measuretechnicalmodel, :X)
    slackYmeasure = slacks(measuretechnicalmodel, :Y)
    Xtargetti = targets(measuretechnicalmodel, :X)
    Ytargetti = targets(measuretechnicalmodel, :Y)

    # Calculate slack as the difference between target and observed
    slackXmeasure = X .- Xtargetti
    slackYmeasure = Ytargetti .- Y

    # Get profit inefficiency of projection (target)
    if measure == :ERG
        targetmodel = deaprofiterg(Xtargetti, Ytargetti, W, P, optimizer = optimizer)
    end

    pitarget = efficiency(targetmodel) .* normfactor(targetmodel)
    
    monetaryti = sum(P .* slackYmeasure, dims=2).+ sum(W .* slackXmeasure, dims = 2)

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
        pefficiency = pimeasure 
        techefficiency = timeasure .* normalization
        allocefficiency = pitarget
    else
        pefficiency = pimeasure ./ normalization
        techefficiency = timeasure
        allocefficiency = pitarget ./ normalization
    end

    return ProfitGDADEAModel(n, m, s, measure, monetary, names, pefficiency, plambdaeff, techefficiency, allocefficiency, normalization, Xtarget, Ytarget)
end

function Base.show(io::IO, x::ProfitGDADEAModel)
    compact = get(io, :compact, false)

    n = nobs(x)
    m = ninputs(x)
    s = noutputs(x)
    dmunames = names(x)

    eff = efficiency(x)
    techeff = efficiency(x, :Technical)
    alloceff = efficiency(x, :Allocative)

    if !compact
        print(io, "General Direct Approach Profit DEA Model \n")
        print(io, "DMUs = ", n)
        print(io, "; Inputs = ", m)
        print(io, "; Outputs = ", s)
        print(io, "\n")
        print(io, "Returns to Scale = VRS")
        print(io, "\n")
        print(io, "Associated efficiency measure = ", string(x.measure))
        print(io, "\n")
        show(io, CoefTable(hcat(eff, techeff, alloceff), ["Profit", "Technical", "Allocative"], dmunames))
    end

end
