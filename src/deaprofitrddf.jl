# This file contains functions for the Profit Efficiency Reverse DDF DEA model
"""
    ProfitReverseDDFDEAModel
An data structure representing a profit DEA model.
"""
struct ProfitReverseDDFDEAModel <: AbstractProfitDEAModel
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
    Gxrddf::Union{Vector,Matrix}
    Gyrddf::Union{Vector,Matrix}
end

"""
    deaprofitrddf(X, Y, W, P, measure)
Compute profit efficiency using data envelopment analysis Reverse DDF model for
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
function deaprofitrddf(X::Union{Matrix,Vector}, Y::Union{Matrix,Vector},
    W::Union{Matrix,Vector}, P::Union{Matrix,Vector},
    measure::Symbol;
    Gx::Union{Symbol,Matrix,Vector,Nothing} = nothing, Gy::Union{Symbol,Matrix,Vector,Nothing} = nothing,
    monetary::Bool = false, atol::Float64 = 1e-6,
    names::Union{Vector{String},Nothing} = nothing,
    optimizer::Union{DEAOptimizer,Nothing} = nothing)::ProfitReverseDDFDEAModel

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

    # Get directions based on efficiency measure
    Gxrddf, Gyrddf = DataEnvelopmentAnalysis.dearddfdirections(X, Y, measure, Gx = Gx, Gy = Gy, orient = :Graph, rts = :VRS, optimizer = optimizer)

    # Get normalization of efficiency measure model
    if measure == :ERG
        measureprofitmodel = deaprofiterg(X, Y, W, P, optimizer = optimizer)
    elseif measure == :MDDF
        measureprofitmodel = deaprofitmddf(X, Y, W, P, Gx = Gx, Gy = Gy, optimizer = optimizer)
    end

    normmeasureprof = normfactor(measureprofitmodel)
    pefficiencymeasure = efficiency(measureprofitmodel)

    # Profit model using calculated directions
    rddfprofitmodel = deaprofit(X, Y, W, P, Gx = Gxrddf, Gy = Gyrddf, optimizer = optimizer)

    pefficiency = efficiency(rddfprofitmodel)
    plambdaeff = peersmatrix(rddfprofitmodel)
    techefficiency = efficiency(rddfprofitmodel, :Technical)
    allocefficiency = efficiency(rddfprofitmodel, :Allocative)
    normalization = normfactor(rddfprofitmodel)
    Xtarget = targets(rddfprofitmodel, :X)
    Ytarget = targets(rddfprofitmodel, :Y)

    # Change normalization factor of efficient DMUs
    for i=1:n
        if abs(techefficiency[i] ) <= atol
            pefficiency[i] = pefficiencymeasure[i]
            normalization[i] = normmeasureprof[i]
        end
    end

    if monetary
        pefficiency = pefficiency .* normalization
        techefficiency = techefficiency .* normalization
    end

    allocefficiency = pefficiency - techefficiency

    return ProfitReverseDDFDEAModel(n, m, s, measure, monetary, names, pefficiency, plambdaeff, techefficiency, allocefficiency, normalization, Xtarget, Ytarget, Gxrddf, Gyrddf)
end

function Base.show(io::IO, x::ProfitReverseDDFDEAModel)
    compact = get(io, :compact, false)

    n = nobs(x)
    m = ninputs(x)
    s = noutputs(x)
    dmunames = names(x)

    eff = efficiency(x)
    techeff = efficiency(x, :Technical)
    alloceff = efficiency(x, :Allocative)

    if !compact
        print(io, "Profit Reverse DDF DEA Model \n")
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
