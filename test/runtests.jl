using BenchmarkingEconomicEfficiency
using Test

@testset "BenchmarkingEconomicEfficiency.jl" begin
    
    include("deacostddf.jl")
    include("dearevenueddf.jl")

end
