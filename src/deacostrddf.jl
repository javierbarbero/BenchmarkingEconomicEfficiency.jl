# This file contains functions for the Cost Efficiency Reverse DDF DEA model
"""
CostReverseDDFDEAModel
An data structure representing a cost RDDF DEA model.
"""
struct CostReverseDDFDEAModel <: AbstractCostDEAModel
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
    Gxrddf::Union{Vector,Matrix}
    Gyrddf::Union{Vector,Matrix}
end


"""
    deacostrddf(X, Y, W, measure)
Compute profit efficiency using data envelopment analysis Reverse DDF model for
inputs `X`, outputs `Y`, price of inputs `W`, and efficiency `measure`.

# Measure specification:
- `:ERG`: Enhanced Russell Graph Slack Based Measure.

# Optional Arguments
- `rts=:VRS`: choose between constant returns to scale `:CRS` or variable returns to scale `:VRS`.
- `atol=1e-6`: tolerance for DMU to be considered efficient.
- `names`: a vector of strings with the names of the decision making units.

# Examples
```jldoctest
julia> X = [2 2; 1 4; 4 1; 4 3; 5 5; 6 1; 2 5; 1.6 8];

julia> Y = [1; 1; 1; 1; 1; 1; 1; 1];

julia> W = [1 1; 1 1; 1 1; 1 1; 1 1; 1 1; 1 1; 1 1];

julia> deacostrddf(X, Y, W, :ERG)
Cost Reverse DDF DEA Model 
DMUs = 8; Inputs = 2; Outputs = 1
Returns to Scale: VRS
Associated efficiency measure = ERG
──────────────────────────────────
       Cost  Technical  Allocative
──────────────────────────────────
1  0.0        0.0        0.0
2  0.5        0.0        0.5
3  0.5        0.0        0.5
4  0.416667   0.416667   0.0
5  0.6        0.6        0.0
6  0.25       0.166667   0.0833333
7  0.525      0.35       0.175
8  0.532609   0.4375     0.0951087
──────────────────────────────────
```
"""
function deacostrddf(X::Union{Matrix,Vector}, Y::Union{Matrix,Vector},
    W::Union{Matrix,Vector},
    measure::Symbol; 
    rts::Symbol = :VRS, atol::Float64 = 1e-6, monetary::Bool = false,
    names::Union{Vector{String},Nothing} = nothing,
    optimizer::Union{DEAOptimizer,Nothing} = nothing)::CostReverseDDFDEAModel

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

    # Get directions based on efficiency measure
    Gxrddf, Gyrddf = DataEnvelopmentAnalysis.dearddfdirections(X, Y, measure, orient = :Input, rts = rts, optimizer = optimizer)

    # Get normalization of efficiency measure model
    if measure == :ERG
        measurecostmodel = deacostrussell(X, Y, W, rts = rts, optimizer = optimizer)
    end

    normmeasurecost = normfactor(measurecostmodel)

    # Cost model using calculated directions
    rddfcostmodel = deacostddf(X, Y, W, Gx = Gxrddf, rts = rts, optimizer = optimizer)

    cefficiency = efficiency(rddfcostmodel)
    clambdaeff = peersmatrix(rddfcostmodel)
    techefficiency = efficiency(rddfcostmodel, :Technical)
    allocefficiency = efficiency(rddfcostmodel, :Allocative)
    normalization = normfactor(rddfcostmodel)
    Xtarget = targets(rddfcostmodel, :X)
    Ytarget = targets(rddfcostmodel, :Y)

    # Change normalization factor of efficient DMUs
    for i=1:n
        if abs(techefficiency[i] ) <= atol
            cefficiency[i] = cefficiency[i] ./ normmeasurecost[i] .* normalization[i]
            normalization[i] = normmeasurecost[i] 
        end
    end

    if monetary
        cefficiency = cefficiency .* normalization
        techefficiency = techefficiency .* normalization
    end

    allocefficiency = cefficiency - techefficiency

    return CostReverseDDFDEAModel(n, m, s, measure, rts, monetary, names, cefficiency, clambdaeff, techefficiency, allocefficiency, normalization, Xtarget, Ytarget, Gxrddf, Gyrddf)

end

function Base.show(io::IO, x::CostReverseDDFDEAModel)
    compact = get(io, :compact, false)

    n = nobs(x)
    m = ninputs(x)
    s = noutputs(x)
    dmunames = names(x)

    eff = efficiency(x)
    techeff = efficiency(x, :Technical)
    alloceff = efficiency(x, :Allocative)

    if !compact
        print(io, "Cost Reverse DDF DEA Model \n")
        print(io, "DMUs = ", n)
        print(io, "; Inputs = ", m)
        print(io, "; Outputs = ", s)
        print(io, "\n")
        print(io, "Returns to Scale: ", string(x.rts))
        print(io, "\n")
        print(io, "Associated efficiency measure = ", string(x.measure))
        print(io, "\n")
        show(io, CoefTable(hcat(eff, techeff, alloceff), ["Cost", "Technical", "Allocative"], dmunames))
    end

end
