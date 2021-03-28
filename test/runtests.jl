using BenchmarkingEconomicEfficiency
using Test

@testset "BenchmarkingEconomicEfficiency.jl" begin
    
    include("deacostddf.jl")
    include("dearevenueddf.jl")
    include("deacostadd.jl")

end
