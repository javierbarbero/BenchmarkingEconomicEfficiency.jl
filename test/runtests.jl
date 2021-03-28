using BenchmarkingEconomicEfficiency
using Test

@testset "BenchmarkingEconomicEfficiency.jl" begin
    
    include("deacostddf.jl")
    include("dearevenueddf.jl")
    include("deacostadd.jl")
    include("dearevenueadd.jl")
    include("deaprofitadd.jl")
    include("deacostrussell.jl")
    
end
