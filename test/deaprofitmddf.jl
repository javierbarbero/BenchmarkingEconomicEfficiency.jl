# Tests for Profit Modified Directional Distance Function DEA Models
@testset "ProfitModifiedDDFDEAModel" begin

    # Test using Book data
    X = [2; 4; 8; 12; 6; 14; 14; 9.412];
    Y = [1; 5; 8; 9; 3; 7; 9; 2.353];
    W = [1; 1; 1; 1; 1; 1; 1; 1];
    P = [2; 2; 2; 2; 2; 2; 2; 2];

    # Profit MDDF wtih :Observed
    profitmddfobserved = deaprofitmddf(X, Y, W, P, Gx = :Observed, Gy = :Observed)

    @test typeof(profitmddfobserved) == ProfitModifiedDDFDEAModel

    @test nobs(profitmddfobserved) == 8
    @test ninputs(profitmddfobserved) == 1
    @test noutputs(profitmddfobserved) == 1
    @test ismonetary(profitmddfobserved) == false

    @test efficiency(profitmddfobserved) == efficiency(profitmddfobserved, :Economic)
    @test efficiency(profitmddfobserved, :Economic)   ≈ [4.0; 0.5; 0.0; 1/6; 4/3; 0.571429; 0.285714; 2.699958] atol = 1e-5
    @test efficiency(profitmddfobserved, :Technical)  ≈ [0.0; 0.0; 0.0; 0.0; 7/6; 0.571429; 0.142857; 2.549936] atol = 1e-5
    @test efficiency(profitmddfobserved, :Allocative) ≈ [4.0; 0.5; 0.0; 1/6; 1/6; 0.0; 0.142857; 0.150021] atol = 1e-5
    @test normfactor(profitmddfobserved) ≈ [2.0; 4.0; 8.0; 12.0; 6.0; 14.0; 14.0; 4.706]
    
    # With :Observed and monetary = true
    profitmddfobservedmon = deaprofitmddf(X, Y, W, P, Gx = :Observed, Gy = :Observed, monetary = true)

    @test ismonetary(profitmddfobservedmon) == true

    @test efficiency(profitmddfobservedmon) ≈ efficiency(profitmddfobserved) .* normfactor(profitmddfobserved)
    @test efficiency(profitmddfobservedmon, :Technical) ≈ efficiency(profitmddfobserved, :Technical) .* normfactor(profitmddfobserved)
    @test efficiency(profitmddfobservedmon, :Allocative) ≈ efficiency(profitmddfobserved, :Allocative) .* normfactor(profitmddfobserved)

    # Print
    show(IOBuffer(), profitmddfobserved)

    # Test errors
    @test_throws DimensionMismatch deaprofitmddf([1; 2 ; 3], [4 ; 5], [1; 1; 1], [4; 5], Gx = [1; 2 ; 3], Gy = [4 ; 5]) #  Different number of observations
    @test_throws DimensionMismatch deaprofitmddf([1; 2; 3], [4; 5; 6], [1; 2; 3; 4], [4; 5; 6], Gx = [1; 2; 3], Gy = [4; 5; 6]) # Different number of observation in input prices
    @test_throws DimensionMismatch deaprofitmddf([1; 2; 3], [4; 5; 6], [1; 2; 3], [4; 5; 6; 7], Gx = [1; 2; 3], Gy = [4; 5; 6]) # Different number of observation in output prices
    @test_throws DimensionMismatch deaprofitmddf([1 1; 2 2; 3 3], [4; 5; 6], [1 1 1; 2 2 2; 3 3 3], [4; 5; 6], Gx = [1 1; 2 2; 3 3], Gy = [4; 5; 6]) # Different number of input prices and inputs
    @test_throws DimensionMismatch deaprofitmddf([1; 2; 3], [4 4; 5 5; 6 6], [1; 2; 3], [4 4 4; 5 5 5; 6 6 6], Gx = [1; 2; 3], Gy = [4 4; 5 5; 6 6]) # Different number of oputput prices and outputs
    @test_throws DimensionMismatch deaprofitmddf([1 1; 2 2; 3 3], [4; 5; 6], [1 1; 2 2; 3 3], [4; 5; 6], Gx = [1 1 1; 2 2 2; 3 3 3], Gy = [4; 5; 6]) # Different size of inputs direction
    @test_throws DimensionMismatch deaprofitmddf([1; 2; 3], [4 4; 5 5; 6 6], [1; 2; 3], [4 4; 5 5; 6 6], Gx = [1; 2; 3], Gy = [4 4 4; 5 5 5; 6 6 6]) # Different size of outputs direction
    @test_throws ArgumentError deaprofitmddf([1; 2; 3], [1; 2; 3], [1; 1; 1], [1; 1; 1], Gx = :Error, Gy = :Observed) # Invalid inputs direction
    @test_throws ArgumentError deaprofitmddf([1; 2; 3], [1; 2; 3], [1; 1; 1], [1; 1; 1], Gx = :Observed, Gy = :Error) # Invalid outputs direction
 
end
