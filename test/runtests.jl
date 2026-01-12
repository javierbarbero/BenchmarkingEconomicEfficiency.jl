using BenchmarkingEconomicEfficiency
using Test

@testset "BenchmarkingEconomicEfficiency.jl" begin
    
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
    include("dearevenuerddf.jl")
    include("deaprofitrddf.jl")
    include("deacostgda.jl")
    include("dearevenuegda.jl")
    include("deaprofitgda.jl")

    include("deaprofitchange.jl")
    include("deaprofitabilitychange.jl")
    
end
