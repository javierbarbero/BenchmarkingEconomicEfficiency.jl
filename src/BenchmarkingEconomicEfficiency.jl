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

    using Reexport
    @reexport using DataEnvelopmentAnalysis

end
