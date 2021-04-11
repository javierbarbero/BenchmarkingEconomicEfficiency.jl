# Tests for Profit General Direct Approach DEA Models
@testset "ProfitGDADEAAModel" begin

    # Test using Book data
    X = [2; 4; 8; 12; 6; 14; 14; 9.412];
    Y = [1; 5; 8; 9; 3; 7; 9; 2.353];
    W = [1; 1; 1; 1; 1; 1; 1; 1];
    P = [2; 2; 2; 2; 2; 2; 2; 2];

    # Profit GDA
    profitgda = deaprofitgda(X, Y, W, P, :ERG)

    @test typeof(profitgda) == ProfitGDADEAModel
    
    @test nobs(profitgda) == 8
    @test ninputs(profitgda) == 1
    @test noutputs(profitgda) == 1
    @test ismonetary(profitgda) == false

    @test profitgda.measure == :ERG
    @test efficiency(profitgda) == efficiency(profitgda, :Economic)
    @test efficiency(profitgda, :Economic)   ≈ [4.0; 0.5; 0.0; 1/6; 0.8; 4/7; 2/7; 0.949449] atol = 1e-5
    @test efficiency(profitgda, :Technical)  ≈ [0.0; 0.0; 0.0; 0.0; 0.6; 11/21; 1/7; 0.8] atol = 1e-5
    @test efficiency(profitgda, :Allocative) ≈ [4.0; 0.5; 0.0; 1/6; 0.2; 1/21; 1/7; 0.149449] atol = 1e-5
    @test normfactor(profitgda) ≈ [2.0; 4.0; 8.0; 12.0; 10.0; 14.0; 14.0; 13.3825]
    
    # With monetary = true
    profitgdamon = deaprofitgda(X, Y, W, P, :ERG, monetary = true)

    @test ismonetary(profitgdamon) == true

    @test efficiency(profitgdamon) ≈ efficiency(profitgda) .* normfactor(profitgda)
    @test efficiency(profitgdamon, :Technical) ≈ efficiency(profitgda, :Technical) .* normfactor(profitgda)
    @test efficiency(profitgdamon, :Allocative) ≈ efficiency(profitgda, :Allocative) .* normfactor(profitgda)

    # Print
    show(IOBuffer(), profitgda)

    # Test errors
    @test_throws DimensionMismatch deaprofitgda([1; 2 ; 3], [4; 5], [1; 1; 1], [1; 1], :ERG) #  Different number of observations
    @test_throws DimensionMismatch deaprofitgda([1; 2; 3], [4; 5; 6], [1; 2; 3; 4], [1; 1; 1], :ERG) # Different number of observation in input prices
    @test_throws DimensionMismatch deaprofitgda([1; 2; 3], [4; 5; 6], [1; 1; 1], [1; 2; 3; 4], :ERG) # Different number of observation in output prices
    @test_throws DimensionMismatch deaprofitgda([1 1; 2 2; 3 3 ], [4; 5; 6], [1 1 1; 2 2 2; 3 3 3], [1; 1; 1], :ERG) # Different number of input prices and inputs
    @test_throws DimensionMismatch deaprofitgda([1; 2; 3 ], [4; 5; 6], [1; 1; 1], [1 1 1; 2 2 2; 3 3 3], :ERG) # Different number of output prices and outputs
    @test_throws ArgumentError deaprofitgda([1; 2; 3], [4; 5; 6], [1; 2; 3], [4; 5; 6], :Error) # Invalid associated efficiency measure

end
