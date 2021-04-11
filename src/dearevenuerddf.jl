# This file contains functions for the Revenue Efficiency Reverse DDF DEA model
"""
    RevenueReverseDDFDEAModel
An data structure representing a cost RDDF DEA model.
"""
struct RevenueReverseDDFDEAModel <: AbstractRevenueDEAModel
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
    dearevenuerddf(X, Y, P, measure)
Compute profit efficiency using data envelopment analysis Reverse DDF model for
inputs `X`, outputs `Y`, price of outputs `P`, and efficiency `measure`.

# Measure specification:
- `:ERG`: Enhanced Russell Graph Slack Based Measure.

# Optional Arguments
- `rts=:VRS`: choose between constant returns to scale `:CRS` or variable returns to scale `:VRS`.
- `atol=1e-6`: tolerance for DMU to be considered efficient.
- `names`: a vector of strings with the names of the decision making units.

# Examples
```jldoctest
julia> X = [1; 1; 1; 1; 1; 1; 1; 1];

julia> Y = [7 7; 4 8; 8 4; 3 5; 3 3; 8 2; 6 4; 1.5 5];

julia> P = [1 1; 1 1; 1 1; 1 1; 1 1; 1 1; 1 1; 1 1];

julia> dearevenuerddf(X, Y, P, :ERG)
Revenue Reverse DDF DEA Model 
DMUs = 8; Inputs = 1; Outputs = 2
Returns to Scale: VRS
Associated efficiency measure = ERG
────────────────────────────────────
    Revenue  Technical    Allocative
────────────────────────────────────
1  0.0        0.0        0.0
2  0.25       0.0        0.25
3  0.25       0.0        0.25
4  0.464286   0.464286   0.0
5  0.571429   0.571429   0.0
6  0.666667   0.333333   0.333333
7  0.314286   0.314286  -5.55112e-17
8  0.818182   0.672727   0.145455
────────────────────────────────────
```
"""
function dearevenuerddf(X::Union{Matrix,Vector}, Y::Union{Matrix,Vector},
    P::Union{Matrix,Vector},
    measure::Symbol; 
    rts::Symbol = :VRS, atol::Float64 = 1e-6, monetary::Bool = false,
    names::Union{Vector{String},Nothing} = nothing,
    optimizer::Union{DEAOptimizer,Nothing} = nothing)::RevenueReverseDDFDEAModel

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

    # Get directions based on efficiency measure
    Gxrddf, Gyrddf = DataEnvelopmentAnalysis.dearddfdirections(X, Y, measure, orient = :Output, rts = rts, optimizer = optimizer)

    # Get normalization of efficiency measure model
    if measure == :ERG
        measurerevenuemodel = dearevenuerussell(X, Y, P, rts = rts, optimizer = optimizer)
    end

    normmeasurerev = normfactor(measurerevenuemodel)

    # Cost model using calculated directions
    rddfrevenuemodel = dearevenueddf(X, Y, P, Gy = Gyrddf, rts = rts, optimizer = optimizer)

    refficiency = efficiency(rddfrevenuemodel)
    rlambdaeff = peersmatrix(rddfrevenuemodel)
    techefficiency = efficiency(rddfrevenuemodel, :Technical)
    allocefficiency = efficiency(rddfrevenuemodel, :Allocative)
    normalization = normfactor(rddfrevenuemodel)
    Xtarget = targets(rddfrevenuemodel, :X)
    Ytarget = targets(rddfrevenuemodel, :Y)

    # Change normalization factor of efficient DMUs
    for i=1:n
        if abs(techefficiency[i] ) <= atol           
            refficiency[i] = refficiency[i] ./ normmeasurerev[i] .* normalization[i]
            normalization[i] = normmeasurerev[i] 
        end
    end

    if monetary
        refficiency = refficiency .* normalization
        techefficiency = techefficiency .* normalization
    end

    allocefficiency = refficiency - techefficiency

    return RevenueReverseDDFDEAModel(n, m, s, measure, rts, monetary, names, refficiency, rlambdaeff, techefficiency, allocefficiency, normalization, Xtarget, Ytarget, Gxrddf, Gyrddf)

end

function Base.show(io::IO, x::RevenueReverseDDFDEAModel)
    compact = get(io, :compact, false)

    n = nobs(x)
    m = ninputs(x)
    s = noutputs(x)
    dmunames = names(x)

    eff = efficiency(x)
    techeff = efficiency(x, :Technical)
    alloceff = efficiency(x, :Allocative)

    if !compact
        print(io, "Revenue Reverse DDF DEA Model \n")
        print(io, "DMUs = ", n)
        print(io, "; Inputs = ", m)
        print(io, "; Outputs = ", s)
        print(io, "\n")
        print(io, "Returns to Scale: ", string(x.rts))
        print(io, "\n")
        print(io, "Associated efficiency measure = ", string(x.measure))
        print(io, "\n")
        show(io, CoefTable(hcat(eff, techeff, alloceff), ["Revenue", "Technical", "Allocative"], dmunames))
    end

end
