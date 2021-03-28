# Tests for Cost DDF DEA Models
@testset "CostDDFDEAModel" begin

    # Test using Book data
    X = [2 2; 1 4; 4 1; 4 3; 5 5; 6 1; 2 5; 1.6 8];
    Y = [1; 1; 1; 1; 1; 1; 1; 1];
    W = [1 1; 1 1; 1 1; 1 1; 1 1; 1 1; 1 1; 1 1];

    # With Gx = :Ones 
    deacostddfones = deacostddf(X, Y, W, Gx = :Ones)

    @test typeof(deacostddfones) == CostDDFDEAModel

    @test nobs(deacostddfones) == 8
    @test ninputs(deacostddfones) == 2
    @test noutputs(deacostddfones) == 1
    @test ismonetary(deacostddfones) == false

    @test efficiency(deacostddfones) == efficiency(deacostddfones, :Economic)
    @test efficiency(deacostddfones, :Economic)   ≈ [0.0; 0.5; 0.5; 1.5; 3.0; 1.5; 1.5; 2.8]
    @test efficiency(deacostddfones, :Technical)  ≈ [0.0; 0.0; 0.0; 4/3; 3; 0.0; 1.0; 0.6]
    @test efficiency(deacostddfones, :Allocative) ≈ [0.0; 0.5; 0.5; 1/6; 0.0; 1.5; 0.5; 2.2]
    @test normfactor(deacostddfones) ≈ [2.0; 2.0; 2.0; 2.0; 2.0; 2.0; 2.0; 2.0]
    
    deacostddfonesmon = deacostddf(X, Y, W, Gx = :Ones, monetary = true)

    @test ismonetary(deacostddfonesmon) == true

    @test efficiency(deacostddfonesmon) ≈ efficiency(deacostddfones) .* normfactor(deacostddfones)
    @test efficiency(deacostddfonesmon, :Technical) ≈ efficiency(deacostddfones, :Technical) .* normfactor(deacostddfones)
    @test efficiency(deacostddfonesmon, :Allocative) ≈ efficiency(deacostddfones, :Allocative) .* normfactor(deacostddfones)

    # With Gx = :Ones and CRS (Same result in this example)
    deacostddfonescrs = deacostddf(X, Y, W, Gx = :Ones, rts = :CRS)

    @test efficiency(deacostddfonescrs, :Economic)   ≈ [0.0; 0.5; 0.5; 1.5; 3.0; 1.5; 1.5; 2.8]
    @test efficiency(deacostddfonescrs, :Technical)  ≈ [0.0; 0.0; 0.0; 4/3; 3; 0.0; 1.0; 0.6]
    @test efficiency(deacostddfonescrs, :Allocative) ≈ [0.0; 0.5; 0.5; 1/6; 0.0; 1.5; 0.5; 2.2]

    # With Gx = :Observed
    deacostddfobs = deacostddf(X, Y, W, Gx = :Observed)

    @test efficiency(deacostddfobs, :Economic)   ≈ [0.0; 0.2; 0.2; 0.428571; 0.6; 0.428571; 0.428571; 0.583333] atol = 1e-5
    @test efficiency(deacostddfobs, :Technical)  ≈ [0.0; 0.0; 0.0; 0.4; 0.6; 0.0; 1/3; 6/16] atol = 1e-5
    @test efficiency(deacostddfobs, :Allocative) ≈ [0.0; 0.2; 0.2; 0.028571; 0.0; 0.428571; 0.095238; 0.208333] atol = 1e-5

    # With Gx = :Mean
    deacostddfmean = deacostddf(X, Y, W, Gx = :Mean)

    @test efficiency(deacostddfmean, :Economic)   ≈ [0.0; 0.146520; 0.146520; 0.439560; 0.879121; 0.439560; 0.439560; 0.820513] atol = 1e-5
    @test efficiency(deacostddfmean, :Technical)  ≈ [0.0; 0.0; 0.0; 0.382775; 0.861244; 0.0; 0.299252; 0.1875] atol = 1e-5
    @test efficiency(deacostddfmean, :Allocative) ≈ [0.0; 0.146520; 0.146520; 0.056785; 0.017877; 0.439560; 0.140309; 0.633013] atol = 1e-5

    # With Gx = :Monetary
    deacostddfmon = deacostddf(X, Y, W, Gx = :Monetary)

    @test efficiency(deacostddfmon, :Economic)   ≈ [0.0; 1.0; 1.0; 3.0; 6.0; 3.0; 3.0; 5.6] 
    @test efficiency(deacostddfmon, :Technical)  ≈ [0.0; 0.0; 0.0; 16/6; 6.0; 0.0; 2.0; 1.2] 
    @test efficiency(deacostddfmon, :Allocative) ≈ [0.0; 1.0; 1.0; 1/3; 0.0; 3.0; 1.0; 4.4] 

    # With custom direction
    deacostddfcustom = deacostddf(X, Y, W, Gx = ones(size(X)))
    @test efficiency(deacostddfcustom) ≈ efficiency(deacostddfones)

    # Print
    show(IOBuffer(), deacostddfones)

    # Test errors
    @test_throws DimensionMismatch deacostddf([1; 2 ; 3], [4 ; 5], [1; 1; 1] , Gx = :Ones) #  Different number of observations
    @test_throws DimensionMismatch deacostddf([1; 2; 3], [4; 5; 6], [1; 2; 3; 4], Gx = :Ones) # Different number of observation in prices
    @test_throws DimensionMismatch deacostddf([1 1; 2 2; 3 3 ], [4; 5; 6], [1 1 1; 2 2 2; 3 3 3], Gx = :Ones) # Different number of input prices and inputs
    @test_throws DimensionMismatch deacostddf([1; 2; 3] , [4; 5; 6], [1; 1; 1], Gx = [1 1; 2 2; 3 3]) # Different size of inputs direction
    @test_throws ArgumentError deacostddf([1; 2; 3], [4; 5; 6], [1; 2; 3], Gx = :Ones, rts = :Error) # Invalid returns to scale
    @test_throws ArgumentError deacostddf([1; 2; 3], [1; 2; 3], [1; 1; 1], Gx = :Error) # Invalid inuts direction

end
