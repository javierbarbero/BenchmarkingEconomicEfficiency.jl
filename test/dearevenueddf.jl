# Tests for Revenue DDF DEA Models
@testset "RevenueDDFDEAModel" begin

    # Test using Book data
    X = [1; 1; 1; 1; 1; 1; 1; 1];
    Y = [7 7; 4 8; 8 4; 3 5; 3 3; 8 2; 6 4; 1.5 5];
    P = [1 1; 1 1; 1 1; 1 1; 1 1; 1 1; 1 1; 1 1];

    # With Gy = :Ones 
    dearevenueddfones = dearevenueddf(X, Y, P, Gy = :Ones)

    @test typeof(dearevenueddfones) == RevenueDDFDEAModel

    @test nobs(dearevenueddfones) == 8
    @test ninputs(dearevenueddfones) == 1
    @test noutputs(dearevenueddfones) == 2
    @test ismonetary(dearevenueddfones) == false

    @test efficiency(dearevenueddfones) == efficiency(dearevenueddfones, :Economic)
    @test efficiency(dearevenueddfones, :Economic)   ≈ [0.0; 1.0; 1.0; 3.0; 4.0; 2.0; 2.0; 3.75]
    @test efficiency(dearevenueddfones, :Technical)  ≈ [0.0; 0.0; 0.0; 2.5; 4.0; 0.0; 1.5; 2.875]
    @test efficiency(dearevenueddfones, :Allocative) ≈ [0.0; 1.0; 1.0; 0.5; 0.0; 2.0; 0.5; 0.875]
    @test normfactor(dearevenueddfones) ≈ [2.0; 2.0; 2.0; 2.0; 2.0; 2.0; 2.0; 2.0]
    
    dearevenueddfonesmon = dearevenueddf(X, Y, P, Gy = :Ones, monetary = true)

    @test ismonetary(dearevenueddfonesmon) == true

    @test efficiency(dearevenueddfonesmon) ≈ efficiency(dearevenueddfones) .* normfactor(dearevenueddfones)
    @test efficiency(dearevenueddfonesmon, :Technical) ≈ efficiency(dearevenueddfones, :Technical) .* normfactor(dearevenueddfones)
    @test efficiency(dearevenueddfonesmon, :Allocative) ≈ efficiency(dearevenueddfones, :Allocative) .* normfactor(dearevenueddfones)

    # With Gy = :Ones and CRS (Same result in this example)
    dearevenueddfonescrs = dearevenueddf(X, Y, P, Gy = :Ones, rts = :CRS)

    @test efficiency(dearevenueddfonescrs, :Economic)   ≈ [0.0; 1.0; 1.0; 3.0; 4.0; 2.0; 2.0; 3.75]
    @test efficiency(dearevenueddfonescrs, :Technical)  ≈ [0.0; 0.0; 0.0; 2.5; 4.0; 0.0; 1.5; 2.875]
    @test efficiency(dearevenueddfonescrs, :Allocative) ≈ [0.0; 1.0; 1.0; 0.5; 0.0; 2.0; 0.5; 0.875]

    # With Gx = :Observed
    dearevenueddfobs = dearevenueddf(X, Y, P, Gy = :Observed)

    @test efficiency(dearevenueddfobs, :Economic)   ≈ [0.0; 6/36; 6/36; 0.75; 4/3; 0.4; 0.4; 1.153846] atol = 1e-5
    @test efficiency(dearevenueddfobs, :Technical)  ≈ [0.0; 0.0; 0.0; 5/9; 4/3; 0.0; 3/11; 3/5] atol = 1e-5
    @test efficiency(dearevenueddfobs, :Allocative) ≈ [0.0; 1/6; 1/6; 7/36; 0.0; 0.4; 7/55; 0.553846] atol = 1e-5

    # With Gx = :Mean
    dearevenueddfmean = dearevenueddf(X, Y, P, Gy = :Mean)

    @test efficiency(dearevenueddfmean, :Economic)   ≈ [0.0; 0.203821; 0.203822; 0.611465; 0.815287; 0.407643; 0.407643; 0.764331] atol = 1e-5
    @test efficiency(dearevenueddfmean, :Technical)  ≈ [0.0; 0.0; 0.0; 0.517799; 0.802508; 0.0; 0.300940; 0.595469] atol = 1e-5
    @test efficiency(dearevenueddfmean, :Allocative) ≈ [0.0; 0.203822; 0.203822; 0.093666; 0.012779; 0.407643; 0.106703; 0.168862] atol = 1e-5

    # With Gx = :Monetary
    dearevenueddfmon = dearevenueddf(X, Y, P, Gy = :Monetary)

    @test efficiency(dearevenueddfmon, :Economic)   ≈ [0.0; 2.0; 2.0; 6.0; 8.0; 4.0; 4.0; 7.5] 
    @test efficiency(dearevenueddfmon, :Technical)  ≈ [0.0; 0.0; 0.0; 5.0; 8.0; 0.0; 3.0; 5.75] 
    @test efficiency(dearevenueddfmon, :Allocative) ≈ [0.0; 2.0; 2.0; 1.0; 0.0; 4.0; 1.0; 1.75] 

    # With custom direction
    dearevenueddfcustom = dearevenueddf(X, Y, P, Gy = ones(size(Y)))
    @test efficiency(dearevenueddfcustom) ≈ efficiency(dearevenueddfones)

    # Print
    show(IOBuffer(), dearevenueddfones)

    # Test errors
    @test_throws DimensionMismatch dearevenueddf([1; 2 ; 3], [4 ; 5], [1; 1; 1] , Gy = :Ones) #  Different number of observations
    @test_throws DimensionMismatch dearevenueddf([1; 2; 3], [4; 5; 6], [1; 2; 3; 4], Gy = :Ones) # Different number of observation in prices
    @test_throws DimensionMismatch dearevenueddf([1 1; 2 2; 3 3 ], [4; 5; 6], [1 1 1; 2 2 2; 3 3 3], Gy = :Ones) # Different number of input prices and inputs
    @test_throws DimensionMismatch dearevenueddf([1; 2; 3] , [4; 5; 6], [1; 1; 1], Gy = [1 1; 2 2; 3 3]) # Different size of inputs direction
    @test_throws ArgumentError dearevenueddf([1; 2; 3], [4; 5; 6], [1; 2; 3], Gy = :Ones, rts = :Error) # Invalid returns to scale
    @test_throws ArgumentError dearevenueddf([1; 2; 3], [1; 2; 3], [1; 1; 1], Gy = :Error) # Invalid inuts direction

end
