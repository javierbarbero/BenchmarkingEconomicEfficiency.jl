# This file contains functions for the Revenue General Direct Approach DEA model
"""
    RevenueGDADEAModel
An data structure representing a Revenue General Direct Approach DEA model.
"""
struct RevenueGDADEAModel <: AbstractProfitDEAModel
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
    dearevenuegda(X, Y, P, measure)
Compute revenue efficiency using data envelopment analysis General Direct Approach model for
inputs `X`, outputs `Y`, price of outputs `P`, and efficiency `measure`.

# Measure specification:
- `:ERG`: Enhanced Russell Graph (or Slack Based Measure (SBM)).

# Optional Arguments
- `rts=:VRS`: choose between constant returns to scale `:CRS` or variable returns to scale `:VRS`.
- `atol=1e-6`: tolerance for DMU to be considered efficient.
- `names`: a vector of strings with the names of the decision making units.

# Examples
```jldoctest
julia> X = [1; 1; 1; 1; 1; 1; 1; 1];

julia> Y = [7 7; 4 8; 8 4; 3 5; 3 3; 8 2; 6 4; 1.5 5];

julia> P = [1 1; 1 1; 1 1; 1 1; 1 1; 1 1; 1 1; 1 1];

julia> dearevenuegda(X, Y, P, :ERG)
General Direct Approach Revenue DEA Model 
DMUs = 8; Inputs = 1; Outputs = 2
Returns to Scale = VRS
Returns to Scale = VRS
───────────────────────────────────
    Revenue  Technical   Allocative
───────────────────────────────────
1  0.0        0.0       0.0
2  0.25       0.0       0.25
3  0.25       0.0       0.25
4  0.866667   0.866667  0.0
5  1.33333    1.33333   2.96059e-16
6  1.0        0.5       0.5
7  0.458333   0.458333  0.0
8  2.5        2.05556   0.444444
───────────────────────────────────
```
"""
function dearevenuegda(X::Union{Matrix,Vector}, Y::Union{Matrix,Vector},
    P::Union{Matrix,Vector},
    measure::Symbol;
    rts::Symbol = :VRS, monetary::Bool = false, atol::Float64 = 1e-6,
    names::Union{Vector{String},Nothing} = nothing,
    optimizer::Union{DEAOptimizer,Nothing} = nothing)::RevenueGDADEAModel

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

    n = nx

    # Get efficiency measure model
    if measure == :ERG
        measuremodel = dearevenuerussell(X, Y, P, rts = rts, optimizer = optimizer)
        measuretechnicalmodel = dearussell(X, Y, orient = :Output, rts = rts, slack = false, optimizer = optimizer)
    else
        throw(ArgumentError("Invalid efficiency `measure`"));
    end

    normmeasure = normfactor(measuremodel)
    rimeasure = efficiency(measuremodel)  .* normmeasure   
    timeasure = efficiency(measuremodel, :Technical) 
    rlambdaeff = peersmatrix(measuremodel)
    Xtarget = targets(measuremodel, :X)
    Ytarget = targets(measuremodel, :Y)
    Xtargetti = targets(measuretechnicalmodel, :X)
    Ytargetti = targets(measuretechnicalmodel, :Y)

    # Calculate slack as the difference between target and observed
    slackYmeasure = Ytargetti .- Y

    # Get profit inefficiency of projection (target)
    if measure == :ERG
        targetmodel = dearevenuerussell(Xtargetti, Ytargetti, P, rts = rts, optimizer = optimizer)
    end

    ritarget = efficiency(targetmodel) .* normfactor(targetmodel)

    monetaryti = sum(P .* slackYmeasure, dims = 2)

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
        refficiency = rimeasure 
        techefficiency = timeasure .* normalization
        allocefficiency = ritarget
    else
        refficiency = rimeasure ./ normalization
        techefficiency = timeasure
        allocefficiency = ritarget ./ normalization
    end

    return RevenueGDADEAModel(n, m, s, measure, rts, monetary, names, refficiency, rlambdaeff, techefficiency, allocefficiency, normalization, Xtarget, Ytarget)
end

function Base.show(io::IO, x::RevenueGDADEAModel)
    compact = get(io, :compact, false)

    n = nobs(x)
    m = ninputs(x)
    s = noutputs(x)
    dmunames = names(x)

    eff = efficiency(x)
    techeff = efficiency(x, :Technical)
    alloceff = efficiency(x, :Allocative)

    if !compact
        print(io, "General Direct Approach Revenue DEA Model \n")
        print(io, "DMUs = ", n)
        print(io, "; Inputs = ", m)
        print(io, "; Outputs = ", s)
        print(io, "\n")
        print(io, "Returns to Scale = ", string(x.rts))
        print(io, "\n")
        print(io, "Associated efficiency measure = ", string(x.measure))
        print(io, "\n")
        show(io, CoefTable(hcat(eff, techeff, alloceff), ["Revenue", "Technical", "Allocative"], dmunames))
    end

end
