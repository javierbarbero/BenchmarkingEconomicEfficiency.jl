# Tests for Profit Reverse DDF DEA Models
@testset "ProfitReverseDDFDEAModel" begin

    # Test using Book data
    X = [2; 4; 8; 12; 6; 14; 14; 9.412];
    Y = [1; 5; 8; 9; 3; 7; 9; 2.353];
    W = [1; 1; 1; 1; 1; 1; 1; 1];
    P = [2; 2; 2; 2; 2; 2; 2; 2];

    # Profit Reverse DDF :ERG
    profitrddferg = deaprofitrddf(X, Y, W, P, :ERG)

    @test typeof(profitrddferg) == ProfitReverseDDFDEAModel
    
    @test nobs(profitrddferg) == 8
    @test ninputs(profitrddferg) == 1
    @test noutputs(profitrddferg) == 1
    @test ismonetary(profitrddferg) == false

    @test profitrddferg.measure == :ERG
    @test efficiency(profitrddferg) == efficiency(profitrddferg, :Economic)
    @test efficiency(profitrddferg, :Economic)   ≈ [4.0; 0.5; 0.0; 1/6; 0.8; 4/7; 2/7; 0.949449] atol = 1e-5
    @test efficiency(profitrddferg, :Technical)  ≈ [0.0; 0.0; 0.0; 0.0; 0.6; 11/21; 1/7; 0.8] atol = 1e-5
    @test efficiency(profitrddferg, :Allocative) ≈ [4.0; 0.5; 0.0; 1/6; 0.2; 1/21; 1/7; 0.149449] atol = 1e-5
    @test normfactor(profitrddferg) ≈ [2.0; 4.0; 8.0; 12.0; 10.0; 14.0; 14.0; 13.3825]
    
    # With monetary = true
    profitrddfergmon = deaprofitrddf(X, Y, W, P, :ERG, monetary = true)

    @test ismonetary(profitrddfergmon) == true

    @test efficiency(profitrddfergmon) ≈ efficiency(profitrddferg) .* normfactor(profitrddferg)
    @test efficiency(profitrddfergmon, :Technical) ≈ efficiency(profitrddferg, :Technical) .* normfactor(profitrddferg)
    @test efficiency(profitrddfergmon, :Allocative) ≈ efficiency(profitrddferg, :Allocative) .* normfactor(profitrddferg)

    # Print
    show(IOBuffer(), profitrddferg)

    # Profit Reverse DDF :MDDF
    profitrddfmddf = deaprofitrddf(X, Y, W, P, :MDDF, Gx = :Observed, Gy = :Observed)

    @test typeof(profitrddfmddf) == ProfitReverseDDFDEAModel

    @test profitrddfmddf.measure == :MDDF
    @test efficiency(profitrddfmddf) == efficiency(profitrddfmddf, :Economic)
    @test efficiency(profitrddfmddf, :Economic)   ≈ [4.0; 0.5; 0.0; 1/6; 4/3; 4/7; 2/7; 2.589507] atol = 1e-5
    @test efficiency(profitrddfmddf, :Technical)  ≈ [0.0; 0.0; 0.0; 0.0; 7/6; 4/7; 1/7; 2.549936] atol = 1e-5
    @test efficiency(profitrddfmddf, :Allocative) ≈ [4.0; 0.5; 0.0; 1/6; 1/6; 0.0; 1/7; 0.039571] atol = 1e-5
    @test normfactor(profitrddfmddf) ≈ [2.0; 4.0; 8.0; 12.0; 6.0; 14.0; 14.0; 4.906725] atol = 1e-5

    # Profit Reverse DDF :MDDF with Custom Direction
    profitrddfmddfcurstom = deaprofitrddf(X, Y, W, P, :MDDF, Gx = X, Gy = Y)
    @test efficiency(profitrddfmddfcurstom) == efficiency(profitrddfmddf)

    # Test errors
    @test_throws DimensionMismatch deaprofitrddf([1; 2 ; 3], [4; 5], [1; 1; 1], [1; 1], :ERG) #  Different number of observations
    @test_throws DimensionMismatch deaprofitrddf([1; 2; 3], [4; 5; 6], [1; 2; 3; 4], [1; 1; 1], :ERG) # Different number of observation in input prices
    @test_throws DimensionMismatch deaprofitrddf([1; 2; 3], [4; 5; 6], [1; 1; 1], [1; 2; 3; 4], :ERG) # Different number of observation in output prices
    @test_throws DimensionMismatch deaprofitrddf([1 1; 2 2; 3 3 ], [4; 5; 6], [1 1 1; 2 2 2; 3 3 3], [1; 1; 1], :ERG) # Different number of input prices and inputs
    @test_throws DimensionMismatch deaprofitrddf([1; 2; 3 ], [4; 5; 6], [1; 1; 1], [1 1 1; 2 2 2; 3 3 3], :ERG) # Different number of output prices and outputs
    @test_throws ArgumentError deaprofitrddf([1; 2; 3], [4; 5; 6], [1; 2; 3], [4; 5; 6], :Error) # Invalid associated efficiency measure
    @test_throws ArgumentError deaprofitrddf([1; 2; 3], [4; 5; 6], [1; 2; 3], [4; 5; 6], :MDDF, Gx = :Error, Gy = :Observed) # Invalid Gx direction
    @test_throws ArgumentError deaprofitrddf([1; 2; 3], [4; 5; 6], [1; 2; 3], [4; 5; 6], :MDDF, Gx = :Observed, Gy = :Error) # Invalid Gx direction

end
