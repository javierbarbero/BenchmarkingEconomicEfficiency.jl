module BenchmarkingEconomicEfficiency

    """
    BenchmarkingEconomicEfficiency
    A Julia package for economic efficiency measurement using Data Envelopment Analysis (DEA).
    [BenchmarkingEconomicEfficiency repository](https://github.com/javierbarbero/BenchmarkingEconomicEfficiency.jl).
    """

    using SparseArrays
    using LinearAlgebra

    using Printf: @sprintf
    using Statistics: std
    using StatsBase: CoefTable

    import StatsBase: nobs, mean

    using Reexport
    @reexport using DataEnvelopmentAnalysis

    export
    # Types
    CostDDFDEAModel, RevenueDDFDEAModel,
    CostAdditiveDEAModel, RevenueAdditiveDEAModel, ProfitAdditiveDEAModel,
    CostRussellDEAModel, RevenueRussellDEAModel, ProfitRussellDEAModel,
    ProfitERGDEAModel,
    ProfitModifiedDDFDEAModel,
    CostHolderDEAModel, RevenueHolderDEAModel, ProfitHolderDEAModel,
    CostRDDFDEAModel,

    # Economic models
    deacostddf, dearevenueddf,
    deacostadd, dearevenueadd, deaprofitadd,
    deacostrussell, dearevenuerussell, deaprofitrussell,
    deaprofiterg,
    deaprofitmddf,
    deacostholder, dearevenueholder,deaprofitholder,
    deacostrddf

    # Include code of functions
    include("deacostddf.jl")
    include("dearevenueddf.jl")        
    include("deacostadd.jl")
    include("dearevenueadd.jl")
    include("deaprofitadd.jl")
    include("deacostrussell.jl")
    include("dearevenuerussell.jl")
    include("deaprofitrussell.jl")
    include("deaprofiterg.jl")
    include("deaprofitmddf.jl")
    include("deacostholder.jl")
    include("dearevenueholder.jl")
    include("deaprofitholder.jl")
    include("deacostrddf.jl")

end
