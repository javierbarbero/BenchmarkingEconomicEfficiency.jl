module BenchmarkingEconomicEfficiency

    """
    BenchmarkingEconomicEfficiency
    A Julia package for economic efficiency measurement using Data Envelopment Analysis (DEA).
    [BenchmarkingEconomicEfficiency repository](https://github.com/javierbarbero/BenchmarkingEconomicEfficiency.jl).
    """

    using JuMP
    using GLPK
    using Ipopt
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
    CostAdditiveDEAModel,

    # Economic models
    deacostddf, dearevenueddf,
    deacostadd

    # Include code of functions
    include("deacostddf.jl")
    include("dearevenueddf.jl")    
    include("deacostadd.jl")

end
