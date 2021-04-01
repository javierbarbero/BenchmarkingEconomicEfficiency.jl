# Tests for Profit Profit Efficiency Enhanced Russell Graph Slack Based Measure DEA Models
@testset "ProfitERGDEAModel" begin

    # Test using Book data
    X = [2; 4; 8; 12; 6; 14; 14; 9.412];
    Y = [1; 5; 8; 9; 3; 7; 9; 2.353];
    W = [1; 1; 1; 1; 1; 1; 1; 1];
    P = [2; 2; 2; 2; 2; 2; 2; 2];

    # Profit Russell
    profiterg = deaprofiterg(X, Y, W, P)

    @test typeof(profiterg) == ProfitERGDEAModel

    @test nobs(profiterg) == 8
    @test ninputs(profiterg) == 1
    @test noutputs(profiterg) == 1
    @test ismonetary(profiterg) == false

    @test efficiency(profiterg) == efficiency(profiterg, :Economic)
    @test efficiency(profiterg, :Economic)   ≈ [4.0; 0.5; 0.0; 1/6; 0.8; 4/7; 2/7; 1.2706] atol = 1e-5
    @test efficiency(profiterg, :Technical)  ≈ [0.0; 0.0; 0.0; 0.0; 0.6; 11/21; 1/7; 0.8] atol = 1e-5
    @test efficiency(profiterg, :Allocative) ≈ [4.0; 0.5; 0.0; 1/6; 0.2; 1/21; 1/7; 0.4706] atol = 1e-5
    @test normfactor(profiterg) ≈ [2.0; 4.0; 8.0; 12.0; 10.0; 14.0; 14.0; 10.0]
    
    # With monetary = true
    profitergmon = deaprofiterg(X, Y, W, P, monetary = true)

    @test ismonetary(profitergmon) == true

    @test efficiency(profitergmon) ≈ efficiency(profiterg) .* normfactor(profiterg)
    @test efficiency(profitergmon, :Technical) ≈ efficiency(profiterg, :Technical) .* normfactor(profiterg)
    @test efficiency(profitergmon, :Allocative) ≈ efficiency(profiterg, :Allocative) .* normfactor(profiterg)

    # Print
    show(IOBuffer(), profiterg)

    # Test errors
    @test_throws DimensionMismatch deaprofiterg([1; 2 ; 3], [4; 5], [1; 1; 1], [1; 1]) #  Different number of observations
    @test_throws DimensionMismatch deaprofiterg([1; 2; 3], [4; 5; 6], [1; 2; 3; 4], [1; 1; 1]) # Different number of observation in input prices
    @test_throws DimensionMismatch deaprofiterg([1; 2; 3], [4; 5; 6], [1; 1; 1], [1; 2; 3; 4]) # Different number of observation in output prices
    @test_throws DimensionMismatch deaprofiterg([1 1; 2 2; 3 3 ], [4; 5; 6], [1 1 1; 2 2 2; 3 3 3], [1; 1; 1]) # Different number of input prices and inputs
    @test_throws DimensionMismatch deaprofiterg([1; 2; 3 ], [4; 5; 6], [1; 1; 1], [1 1 1; 2 2 2; 3 3 3]) # Different number of output prices and outputs

end
