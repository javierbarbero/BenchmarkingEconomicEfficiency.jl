# Tests for Profit Russell DEA Models
@testset "ProfitRussellDEAModel" begin

    # Test using Book data
    X = [2; 4; 8; 12; 6; 14; 14; 9.412];
    Y = [1; 5; 8; 9; 3; 7; 9; 2.353];
    W = [1; 1; 1; 1; 1; 1; 1; 1];
    P = [2; 2; 2; 2; 2; 2; 2; 2];

    # Profit Russell
    deaprofitrus = deaprofitrussell(X, Y, W, P)

    @test typeof(deaprofitrus) == ProfitRussellDEAModel

    @test nobs(deaprofitrus) == 8
    @test ninputs(deaprofitrus) == 1
    @test noutputs(deaprofitrus) == 1
    @test ismonetary(deaprofitrus) == false

    @test efficiency(deaprofitrus) == efficiency(deaprofitrus, :Economic)
    @test efficiency(deaprofitrus, :Economic)   ≈ [2; 0.25; 0.0; 1/12; 2/3; 0.285714; 0.142857; 1.349979] atol = 1e-5
    @test efficiency(deaprofitrus, :Technical)  ≈ [0.0; 0.0; 0.0; 0.0; 11/30; 0.276786; 0.071429; 0.552205] atol = 1e-5
    @test efficiency(deaprofitrus, :Allocative) ≈ [2.0; 0.25; 0.0; 1/12; 0.3; 0.008929; 0.071429; 0.797773] atol = 1e-5
    @test normfactor(deaprofitrus) ≈ [4.0; 8.0; 16.0; 24.0; 12.0; 28.0; 28.0; 9.412]
    
    # With monetary = true
    deaprofitrusmon = deaprofitrussell(X, Y, W, P, monetary = true)

    @test ismonetary(deaprofitrusmon) == true

    @test efficiency(deaprofitrusmon) ≈ efficiency(deaprofitrus) .* normfactor(deaprofitrus)
    @test efficiency(deaprofitrusmon, :Technical) ≈ efficiency(deaprofitrus, :Technical) .* normfactor(deaprofitrus)
    @test efficiency(deaprofitrusmon, :Allocative) ≈ efficiency(deaprofitrus, :Allocative) .* normfactor(deaprofitrus)

    # Print
    show(IOBuffer(), deaprofitrus)

    # Test errors
    @test_throws DimensionMismatch deaprofitrussell([1; 2 ; 3], [4; 5], [1; 1; 1], [1; 1]) #  Different number of observations
    @test_throws DimensionMismatch deaprofitrussell([1; 2; 3], [4; 5; 6], [1; 2; 3; 4], [1; 1; 1]) # Different number of observation in input prices
    @test_throws DimensionMismatch deaprofitrussell([1; 2; 3], [4; 5; 6], [1; 1; 1], [1; 2; 3; 4]) # Different number of observation in output prices
    @test_throws DimensionMismatch deaprofitrussell([1 1; 2 2; 3 3 ], [4; 5; 6], [1 1 1; 2 2 2; 3 3 3], [1; 1; 1]) # Different number of input prices and inputs
    @test_throws DimensionMismatch deaprofitrussell([1; 2; 3 ], [4; 5; 6], [1; 1; 1], [1 1 1; 2 2 2; 3 3 3]) # Different number of output prices and outputs

end
