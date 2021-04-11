# Tests for General Direct Approach Cost DEA Models
@testset "CostGDADEAModel" begin

    # Test using Book data
    X = [2 2; 1 4; 4 1; 4 3; 5 5; 6 1; 2 5; 1.6 8];
    Y = [1; 1; 1; 1; 1; 1; 1; 1];
    W = [1 1; 1 1; 1 1; 1 1; 1 1; 1 1; 1 1; 1 1];

    # Cost GDA
    costgda = deacostgda(X, Y, W, :ERG)

    @test typeof(costgda) == CostGDADEAModel

    @test nobs(costgda) == 8
    @test ninputs(costgda) == 2
    @test noutputs(costgda) == 1
    @test ismonetary(costgda) == false

    @test efficiency(costgda) == efficiency(costgda, :Economic)
    @test efficiency(costgda, :Economic)   ≈ [0.0; 0.5; 0.5; 5/12; 0.6; 0.25; 0.525; 0.532609] atol = 1e-5
    @test efficiency(costgda, :Technical)  ≈ [0.0; 0.0; 0.0; 5/12; 0.6; 1/6; 0.35; 7/16] 
    @test efficiency(costgda, :Allocative) ≈ [0.0; 0.5; 0.5; 0.0; 0.0; 1/12; 0.175; 0.095109] atol = 1e-5
    @test normfactor(costgda) ≈ [4.0; 2.0; 2.0; 7.2; 10.0; 12.0; 40/7; 368/35]
    
    # With monetary = true
    costgdamon = deacostrddf(X, Y, W, :ERG, monetary = true)

    @test ismonetary(costgdamon) == true

    @test efficiency(costgdamon) ≈ efficiency(costgda) .* normfactor(costgda)
    @test efficiency(costgdamon, :Technical) ≈ efficiency(costgda, :Technical) .* normfactor(costgda)
    @test efficiency(costgdamon, :Allocative) ≈ efficiency(costgda, :Allocative) .* normfactor(costgda)

    # With CRS (Same result in this example)
    costgdacrs = deacostrddf(X, Y, W, :ERG, rts = :CRS)

    @test efficiency(costgdacrs, :Economic)   ≈ [0.0; 0.5; 0.5; 5/12; 0.6; 0.25; 0.525; 0.532609] atol = 1e-5
    @test efficiency(costgdacrs, :Technical)  ≈ [0.0; 0.0; 0.0; 5/12; 0.6; 1/6; 0.35; 7/16] 
    @test efficiency(costgdacrs, :Allocative) ≈ [0.0; 0.5; 0.5; 0.0; 0.0; 1/12; 0.175; 0.095109] atol = 1e-5

    # Print
    show(IOBuffer(), costgda)

    # Test errors
    @test_throws DimensionMismatch deacostgda([1; 2 ; 3], [4 ; 5], [1; 1; 1], :ERG) #  Different number of observations
    @test_throws DimensionMismatch deacostgda([1; 2; 3], [4; 5; 6], [1; 2; 3; 4], :ERG) # Different number of observation in prices
    @test_throws DimensionMismatch deacostgda([1 1; 2 2; 3 3 ], [4; 5; 6], [1 1 1; 2 2 2; 3 3 3], :ERG) # Different number of input prices and inputs
    @test_throws ArgumentError deacostgda([1; 2; 3], [4; 5; 6], [1; 2; 3], :Error) # Invalid associated efficiency measure
    @test_throws ArgumentError deacostgda([1; 2; 3], [4; 5; 6], [1; 2; 3], :ERG, rts = :Error) # Invalid returns to scale

end
