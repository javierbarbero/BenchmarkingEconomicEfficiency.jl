# Tests for Revenue Russell DEA Models
@testset "RevenueRussellDEAModel" begin

    # Test using Book data
    X = [1; 1; 1; 1; 1; 1; 1; 1];
    Y = [7 7; 4 8; 8 4; 3 5; 3 3; 8 2; 6 4; 1.5 5];
    P = [1 1; 1 1; 1 1; 1 1; 1 1; 1 1; 1 1; 1 1];

    # Revenue Russell
    dearevenuerus = dearevenuerussell(X, Y, P)

    @test typeof(dearevenuerus) == RevenueRussellDEAModel

    @test nobs(dearevenuerus) == 8
    @test ninputs(dearevenuerus) == 1
    @test noutputs(dearevenuerus) == 2
    @test ismonetary(dearevenuerus) == false

    @test efficiency(dearevenuerus) == efficiency(dearevenuerus, :Economic)
    @test efficiency(dearevenuerus, :Economic)   ≈ [0.0; 0.25; 0.25; 1.0; 4/3; 1.0; 0.5; 2.5]
    @test efficiency(dearevenuerus, :Technical)  ≈ [0.0; 0.0; 0.0; 13/15; 4/3; 0.5; 11/24; 37/18]
    @test efficiency(dearevenuerus, :Allocative) ≈ [0.0; 0.25; 0.25; 2/15; 0.0; 0.5; 1/24; 4/9]
    @test normfactor(dearevenuerus) ≈ [14.0; 8.0; 8.0; 6.0; 6.0; 4.0; 8.0; 3.0]
    
    # With monetary = true
    dearevenuerusmon = dearevenuerussell(X, Y, P, monetary = true)

    @test ismonetary(dearevenuerusmon) == true

    @test efficiency(dearevenuerusmon) ≈ efficiency(dearevenuerus) .* normfactor(dearevenuerus)
    @test efficiency(dearevenuerusmon, :Technical) ≈ efficiency(dearevenuerus, :Technical) .* normfactor(dearevenuerus)
    @test efficiency(dearevenuerusmon, :Allocative) ≈ efficiency(dearevenuerus, :Allocative) .* normfactor(dearevenuerus)

    # With CRS (Same result in this example)
    dearevenueruscrs = dearevenuerussell(X, Y, P, rts = :CRS)

    @test efficiency(dearevenueruscrs, :Economic)   ≈ [0.0; 0.25; 0.25; 1.0; 4/3; 1.0; 0.5; 2.5]
    @test efficiency(dearevenueruscrs, :Technical)  ≈ [0.0; 0.0; 0.0; 13/15; 4/3; 0.5; 11/24; 37/18]
    @test efficiency(dearevenueruscrs, :Allocative) ≈ [0.0; 0.25; 0.25; 2/15; 0.0; 0.5; 1/24; 4/9]

    # Print
    show(IOBuffer(), dearevenuerus)

    # Test errors
    @test_throws DimensionMismatch dearevenuerussell([1; 2 ; 3], [4 ; 5], [1; 1; 1]) #  Different number of observations
    @test_throws DimensionMismatch dearevenuerussell([1; 2; 3], [4; 5; 6], [1; 2; 3; 4]) # Different number of observation in prices
    @test_throws DimensionMismatch dearevenuerussell([1 1; 2 2; 3 3 ], [4; 5; 6], [1 1 1; 2 2 2; 3 3 3]) # Different number of output prices and outputs
    @test_throws ArgumentError dearevenuerussell([1; 2; 3], [4; 5; 6], [1; 2; 3], rts = :Error) # Invalid returns to scale

end
