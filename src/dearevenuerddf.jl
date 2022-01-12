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
- `monetary=false`: decomposition in normalized terms. Monetary terms if `true`.
- `names`: a vector of strings with the names of the decision making units.
"""
function dearevenuerddf(X::Union{Matrix,Vector}, Y::Union{Matrix,Vector},
    P::Union{Matrix,Vector},
    measure::Symbol; 
    rts::Symbol = :VRS, monetary::Bool = false, atol::Float64 = 1e-6,
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
