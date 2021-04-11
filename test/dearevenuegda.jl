# Tests for Revenue General Direct Approach Models
@testset "RevenueRussellDEAModel" begin

    # Test using Book data
    X = [1; 1; 1; 1; 1; 1; 1; 1];
    Y = [7 7; 4 8; 8 4; 3 5; 3 3; 8 2; 6 4; 1.5 5];
    P = [1 1; 1 1; 1 1; 1 1; 1 1; 1 1; 1 1; 1 1];

    # Revenue GDA
    revenuegda = dearevenuegda(X, Y, P, :ERG)

    @test typeof(revenuegda) == RevenueGDADEAModel

    @test nobs(revenuegda) == 8
    @test ninputs(revenuegda) == 1
    @test noutputs(revenuegda) == 2
    @test ismonetary(revenuegda) == false

    @test efficiency(revenuegda) == efficiency(revenuegda, :Economic)
    @test efficiency(revenuegda, :Economic)   ≈ [0.0; 0.25; 0.25; 13/15; 4/3; 1.0; 11/24; 2.5]
    @test efficiency(revenuegda, :Technical)  ≈ [0.0; 0.0; 0.0; 13/15; 4/3; 0.5; 11/24; 37/18]
    @test efficiency(revenuegda, :Allocative) ≈ [0.0; 0.25; 0.25; 0.0; 0.0; 0.5; 0.0; 4/9]
    @test normfactor(revenuegda) ≈ [14.0; 8.0; 8.0; 90/13; 6.0; 4.0; 96/11; 3.0] atol = 1e-5
    
    # With monetary = true
    revenuegdamon = dearevenuegda(X, Y, P, :ERG, monetary = true)

    @test ismonetary(revenuegdamon) == true

    @test efficiency(revenuegdamon) ≈ efficiency(revenuegda) .* normfactor(revenuegda)
    @test efficiency(revenuegdamon, :Technical) ≈ efficiency(revenuegda, :Technical) .* normfactor(revenuegda)
    @test efficiency(revenuegdamon, :Allocative) ≈ efficiency(revenuegda, :Allocative) .* normfactor(revenuegda)

    # With CRS (Same result in this example)
    revenugdacrs = dearevenuegda(X, Y, P, :ERG, rts = :CRS)

    @test efficiency(revenugdacrs, :Economic)   ≈ [0.0; 0.25; 0.25; 13/15; 4/3; 1.0; 11/24; 2.5]
    @test efficiency(revenugdacrs, :Technical)  ≈ [0.0; 0.0; 0.0; 13/15; 4/3; 0.5; 11/24; 37/18]
    @test efficiency(revenugdacrs, :Allocative) ≈ [0.0; 0.25; 0.25; 0.0; 0.0; 0.5; 0.0; 4/9]

    # Print
    show(IOBuffer(), revenuegda)

    # Test errors
    @test_throws DimensionMismatch dearevenuegda([1; 2 ; 3], [4 ; 5], [1; 1; 1], :ERG) #  Different number of observations
    @test_throws DimensionMismatch dearevenuegda([1; 2; 3], [4; 5; 6], [1; 2; 3; 4], :ERG) # Different number of observation in prices
    @test_throws DimensionMismatch dearevenuegda([1 1; 2 2; 3 3 ], [4; 5; 6], [1 1 1; 2 2 2; 3 3 3], :ERG) # Different number of output prices and outputs
    @test_throws ArgumentError dearevenuegda([1; 2; 3], [4; 5; 6], [4; 5; 6], :Error) # Invalid associated efficiency measure
    @test_throws ArgumentError dearevenuegda([1; 2; 3], [4; 5; 6], [1; 2; 3], :ERG, rts = :Error) # Invalid returns to scale

end
