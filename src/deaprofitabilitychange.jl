# This file contains functions for the Profitability Efficiency Change DEA model
"""
    ProfitabilityChangeDEAModel
An data structure representing a profitability change DEA model.
"""
struct ProfitabilityChangeDEAModel <: AbstractProfitabilityDEAModel
    n::Int64
    m::Int64
    s::Int64
    dmunames::Union{Vector{String},Nothing}
    profchange::Vector
    #techchange::Vector
    crseffchange::Vector
    vrseffchange::Vector
    scaleffchange::Vector
    allocchange::Vector
    profitamodelbase::ProfitabilityDEAModel
    profitamodelcomp::ProfitabilityDEAModel
end

"""
    deaprofitabilitychange(X, Y, W, P)
Compute profitability efficiency change using data envelopment analysis for
inputs `X`, outputs `Y`, price of inputs `W`, and price of outputs `P`.

# Optional Arguments
- `alpha=0.5`: alpha to use for the generalized distance function.
- `names`: a vector of strings with the names of the decision making units.
"""
function deaprofitabilitychange(X::Array{Float64,3}, Y::Array{Float64,3},
    W::Array{Float64,3}, P::Array{Float64,3};
    alpha::Float64 = 0.5,
    names::Union{Vector{<: AbstractString},Nothing} = nothing,
    optimizer::Union{DEAOptimizer,Nothing} = nothing)::ProfitabilityChangeDEAModel

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
    profitmodelbase = deaprofitability(X[:,:,1], Y[:,:,1], W[:,:,1], P[:,:,1],
        alpha = alpha, names = names, optimizer = optimizer)
    profitmodelcomp = deaprofitability(X[:,:,2], Y[:,:,2], W[:,:,2], P[:,:,2],
        alpha = alpha, names = names, optimizer = optimizer)

    profchange = efficiency(profitmodelcomp, :Economic) ./ efficiency(profitmodelbase, :Economic)
    crseffchange =  efficiency(profitmodelcomp, :CRS) ./ efficiency(profitmodelbase, :CRS)
    vrseffchange =  efficiency(profitmodelcomp, :VRS) ./ efficiency(profitmodelbase, :VRS)
    scalefftechchange =  efficiency(profitmodelcomp, :Scale) ./ efficiency(profitmodelbase, :Scale)
    allocchange = efficiency(profitmodelcomp, :Allocative) ./ efficiency(profitmodelbase, :Allocative)

    return ProfitabilityChangeDEAModel(n, m, s, names, profchange, crseffchange, vrseffchange, scalefftechchange, allocchange, profitmodelbase, profitmodelcomp)
end

# Show function common for all Profitability Change Models
function Base.show(io::IO, x::ProfitabilityChangeDEAModel)
    compact = get(io, :compact, false)

    n = nobs(x)
    m = ninputs(x)
    s = noutputs(x)
    dmunames = names(x)

    profchange = x.profchange
    crseffchange = x.crseffchange
    vrseffchange = x.vrseffchange
    scaleffchange = x.scaleffchange
    allocchange = x.allocchange

    if !compact
        print(io, "Profitability Change DEA Model \n")
        print(io, "DMUs = ", n)
        print(io, "; Inputs = ", m)
        print(io, "; Outputs = ", s)
        print(io, "\n")
        print(io, "alpha = ", x.profitamodelbase.alpha)
        print(io, "; Returns to Scale = VRS")
        print(io, "\n")
        show(io, CoefTable(hcat(profchange, crseffchange, vrseffchange, scaleffchange, allocchange), ["Prof.Change", "CRS.Change", "VRS.Change", "Scale.Change", "Alloc.Change"], dmunames))
    end

end

"""
    effchange(model::ProfitabilityChangeDEAModel)
Return efficiency change of a profitability change DEA model.

# Optional Arguments
- `type=Economic`: type of efficiency change scores to return.

Type specification:
- `:Economic`: returns economic efficiency change of the model.
- `:CRS`: returns technical efficiency change under constant returns to scale.
- `:VRS`: returns technical efficiency change under variable returns to scale.
- `:Scale`: returns scale efficiency change.
- `:Allocative`: returns allocative efficiency change.
"""
function effchange(model::ProfitabilityChangeDEAModel, type::Symbol = :Economic)::Vector

    if type == :Economic
        return model.profchange
    end
    if type == :CRS
        return model.crseffchange
    end
    if type == :VRS
        return model.vrseffchange
    end
    if type == :Scale
        return model.scaleffchange
    end
    if type == :Allocative
        return model.allocchange
    end

    throw(ArgumentError("$(typeof(model)) has no efficiency change $(type)"));

end
