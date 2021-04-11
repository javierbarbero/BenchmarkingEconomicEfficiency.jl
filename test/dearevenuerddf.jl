# Tests for Revenue Russell DEA Models
@testset "RevenueRussellDEAModel" begin

    # Test using Book data
    X = [1; 1; 1; 1; 1; 1; 1; 1];
    Y = [7 7; 4 8; 8 4; 3 5; 3 3; 8 2; 6 4; 1.5 5];
    P = [1 1; 1 1; 1 1; 1 1; 1 1; 1 1; 1 1; 1 1];

    # Revenue Russell
    revenuerddf = dearevenuerddf(X, Y, P, :ERG)

    @test typeof(revenuerddf) == RevenueReverseDDFDEAModel

    @test nobs(revenuerddf) == 8
    @test ninputs(revenuerddf) == 1
    @test noutputs(revenuerddf) == 2
    @test ismonetary(revenuerddf) == false

    @test efficiency(revenuerddf) == efficiency(revenuerddf, :Economic)
    @test efficiency(revenuerddf, :Economic)   ≈ [0.0; 0.25; 0.25; 13/28; 4/7; 2/3; 11/35; 9/11]
    @test efficiency(revenuerddf, :Technical)  ≈ [0.0; 0.0; 0.0; 13/28; 4/7; 1/3; 11/35; 37/55]
    @test efficiency(revenuerddf, :Allocative) ≈ [0.0; 0.25; 0.25; 0.0; 0.0; 1/3; 0.0; 8/55]
    @test normfactor(revenuerddf) ≈ [14.0; 8.0; 8.0; 168/13; 14.0; 6.0; 140/11; 55/6] atol = 1e-5
    
    # With monetary = true
    revenurrddfmon = dearevenuerddf(X, Y, P, :ERG, monetary = true)

    @test ismonetary(revenurrddfmon) == true

    @test efficiency(revenurrddfmon) ≈ efficiency(revenuerddf) .* normfactor(revenuerddf)
    @test efficiency(revenurrddfmon, :Technical) ≈ efficiency(revenuerddf, :Technical) .* normfactor(revenuerddf)
    @test efficiency(revenurrddfmon, :Allocative) ≈ efficiency(revenuerddf, :Allocative) .* normfactor(revenuerddf)

    # With CRS (Same result in this example)
    revenurrddfcrs = dearevenuerddf(X, Y, P, :ERG, rts = :CRS)

    @test efficiency(revenurrddfcrs, :Economic)   ≈ [0.0; 0.25; 0.25; 13/28; 4/7; 2/3; 11/35; 9/11]
    @test efficiency(revenurrddfcrs, :Technical)  ≈ [0.0; 0.0; 0.0; 13/28; 4/7; 1/3; 11/35; 37/55]
    @test efficiency(revenurrddfcrs, :Allocative) ≈ [0.0; 0.25; 0.25; 0.0; 0.0; 1/3; 0.0; 8/55]

    # Print
    show(IOBuffer(), revenuerddf)

    # Test errors
    @test_throws DimensionMismatch dearevenuerddf([1; 2 ; 3], [4 ; 5], [1; 1; 1], :ERG) #  Different number of observations
    @test_throws DimensionMismatch dearevenuerddf([1; 2; 3], [4; 5; 6], [1; 2; 3; 4], :ERG) # Different number of observation in prices
    @test_throws DimensionMismatch dearevenuerddf([1 1; 2 2; 3 3 ], [4; 5; 6], [1 1 1; 2 2 2; 3 3 3], :ERG) # Different number of output prices and outputs
    @test_throws ArgumentError dearevenuerddf([1; 2; 3], [4; 5; 6], [4; 5; 6], :Error) # Invalid associated efficiency measure
    @test_throws ArgumentError dearevenuerddf([1; 2; 3], [4; 5; 6], [1; 2; 3], :ERG, rts = :Error) # Invalid returns to scale

end
