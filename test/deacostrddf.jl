# Tests for Cost RDDF DEA Models
@testset "CostRDDFDEAModel" begin

    # Test using Book data
    X = [2 2; 1 4; 4 1; 4 3; 5 5; 6 1; 2 5; 1.6 8];
    Y = [1; 1; 1; 1; 1; 1; 1; 1];
    W = [1 1; 1 1; 1 1; 1 1; 1 1; 1 1; 1 1; 1 1];

    # Cost RDDF
    costrddf = deacostrddf(X, Y, W, :ERG)

    @test typeof(costrddf) == CostRDDFDEAModel

    @test nobs(costrddf) == 8
    @test ninputs(costrddf) == 2
    @test noutputs(costrddf) == 1
    @test ismonetary(costrddf) == false

    @test efficiency(costrddf) == efficiency(costrddf, :Economic)
    @test efficiency(costrddf, :Economic)   ≈ [0.0; 0.5; 0.5; 5/12; 0.6; 0.25; 0.525; 0.532609] atol = 1e-5
    @test efficiency(costrddf, :Technical)  ≈ [0.0; 0.0; 0.0; 5/12; 0.6; 1/6; 0.35; 7/16] 
    @test efficiency(costrddf, :Allocative) ≈ [0.0; 0.5; 0.5; 0.0; 0.0; 1/12; 0.175; 0.095109] atol = 1e-5
    @test normfactor(costrddf) ≈ [4.0; 2.0; 2.0; 7.2; 10.0; 12.0; 40/7; 368/35]
    
    # With monetary = true
    costrddfmon = deacostrddf(X, Y, W, :ERG, monetary = true)

    @test ismonetary(costrddfmon) == true

    @test efficiency(costrddfmon) ≈ efficiency(costrddf) .* normfactor(costrddf)
    @test efficiency(costrddfmon, :Technical) ≈ efficiency(costrddf, :Technical) .* normfactor(costrddf)
    @test efficiency(costrddfmon, :Allocative) ≈ efficiency(costrddf, :Allocative) .* normfactor(costrddf)

    # With CRS (Same result in this example)
    costrddfcrs = deacostrddf(X, Y, W, :ERG, rts = :CRS)

    @test efficiency(costrddfcrs, :Economic)   ≈ [0.0; 0.5; 0.5; 5/12; 0.6; 0.25; 0.525; 0.532609] atol = 1e-5
    @test efficiency(costrddfcrs, :Technical)  ≈ [0.0; 0.0; 0.0; 5/12; 0.6; 1/6; 0.35; 7/16] 
    @test efficiency(costrddfcrs, :Allocative) ≈ [0.0; 0.5; 0.5; 0.0; 0.0; 1/12; 0.175; 0.095109] atol = 1e-5

    # Print
    show(IOBuffer(), costrddf)

    # Test errors
    @test_throws DimensionMismatch deacostrddf([1; 2 ; 3], [4 ; 5], [1; 1; 1], :ERG) #  Different number of observations
    @test_throws DimensionMismatch deacostrddf([1; 2; 3], [4; 5; 6], [1; 2; 3; 4], :ERG) # Different number of observation in prices
    @test_throws DimensionMismatch deacostrddf([1 1; 2 2; 3 3 ], [4; 5; 6], [1 1 1; 2 2 2; 3 3 3], :ERG) # Different number of input prices and inputs
    @test_throws ArgumentError deacostrddf([1; 2; 3], [4; 5; 6], [1; 2; 3], :Error) # Invalid associated efficiency measure
    @test_throws ArgumentError deacostrddf([1; 2; 3], [4; 5; 6], [1; 2; 3], :ERG, rts = :Error) # Invalid returns to scale

end
