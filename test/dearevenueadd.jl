# Tests for Revenue Additive DEA Models
@testset "RevenueAdditiveDEAModel" begin

    # Test using Book data
    X = [1; 1; 1; 1; 1; 1; 1; 1];
    Y = [7 7; 4 8; 8 4; 3 5; 3 3; 8 2; 6 4; 1.5 5];
    P = [1 1; 1 1; 1 1; 1 1; 1 1; 1 1; 1 1; 1 1];

    # With :Ones 
    dearevenueaddones = dearevenueadd(X, Y, P, :Ones)

    @test typeof(dearevenueaddones) == RevenueAdditiveDEAModel

    @test nobs(dearevenueaddones) == 8
    @test ninputs(dearevenueaddones) == 1
    @test noutputs(dearevenueaddones) == 2
    @test ismonetary(dearevenueaddones) == false

    @test efficiency(dearevenueaddones) == efficiency(dearevenueaddones, :Economic)
    @test efficiency(dearevenueaddones, :Economic)   ≈ [0.0; 2.0; 2.0; 6.0; 8.0; 4.0; 4.0; 7.5]
    @test efficiency(dearevenueaddones, :Technical)  ≈ [0.0; 0.0; 0.0; 6.0; 8.0; 2.0; 4.0; 7.5]
    @test efficiency(dearevenueaddones, :Allocative) ≈ [0.0; 2.0; 2.0; 0.0; 0.0; 2.0; 0.0; 0.0]
    @test normfactor(dearevenueaddones) ≈ [1.0; 1.0; 1.0; 1.0; 1.0; 1.0; 1.0; 1.0]
    
    # With :Ones and CRS (Same result in this example)
    dearevenueaddonescrs = dearevenueadd(X, Y, P, :Ones, rts = :CRS)

    @test efficiency(dearevenueaddonescrs, :Economic)   ≈ [0.0; 2.0; 2.0; 6.0; 8.0; 4.0; 4.0; 7.5]
    @test efficiency(dearevenueaddonescrs, :Technical)  ≈ [0.0; 0.0; 0.0; 6.0; 8.0; 2.0; 4.0; 7.5]
    @test efficiency(dearevenueaddonescrs, :Allocative) ≈ [0.0; 2.0; 2.0; 0.0; 0.0; 2.0; 0.0; 0.0]

    # Default is :Ones
    @test efficiency(dearevenueadd(X, Y, P)) == efficiency(dearevenueaddones)

    # With :MIP
    dearevenueaddmip = dearevenueadd(X, Y, P, :MIP)

    @test efficiency(dearevenueaddmip, :Economic)   ≈ [0.0; 0.5; 0.5; 2.0; 8/3; 2.0; 1.0; 5.0] atol = 1e-5
    @test efficiency(dearevenueaddmip, :Technical)  ≈ [0.0; 0.0; 0.0; 26/15; 8/3; 1.0; 11/12; 37/9] atol = 1e-5
    @test efficiency(dearevenueaddmip, :Allocative) ≈ [0.0; 0.5; 0.5; 4/15; 0.0; 1.0; 1/12; 8/9] atol = 1e-5
    @test normfactor(dearevenueaddmip) ≈ [7.0; 4.0; 4.0; 3.0; 3.0; 2.0; 4.0; 1.5]
    
    # With :MIP and monetary = true     
    dearevenueaddmipmon = dearevenueadd(X, Y, P, :MIP, monetary = true)

    @test ismonetary(dearevenueaddmipmon) == true

    @test efficiency(dearevenueaddmipmon) ≈ efficiency(dearevenueaddmip) .* normfactor(dearevenueaddmip)
    @test efficiency(dearevenueaddmipmon, :Technical) ≈ efficiency(dearevenueaddmip, :Technical) .* normfactor(dearevenueaddmip)
    @test efficiency(dearevenueaddmipmon, :Allocative) ≈ efficiency(dearevenueaddmip, :Allocative) .* normfactor(dearevenueaddmip)
    
    # With custom weights
    dearevenueaddcustom = dearevenueadd(X, Y, P, rhoY = 1 ./ Y)

    @test efficiency(dearevenueaddcustom) ≈ efficiency(dearevenueaddmip)

    # Print
    show(IOBuffer(), dearevenueaddones)
    show(IOBuffer(), dearevenueadd(X, Y, P, :Ones, dispos = :Weak))

    # Test errors
    @test_throws DimensionMismatch dearevenueadd([1; 2 ; 3], [4 ; 5], [1; 1; 1] , :Ones) #  Different number of observations
    @test_throws DimensionMismatch dearevenueadd([1; 2; 3], [4; 5; 6], [1; 2; 3; 4], :Ones) # Different number of observation in prices
    @test_throws DimensionMismatch dearevenueadd([1 1; 2 2; 3 3 ], [4; 5; 6], [1 1 1; 2 2 2; 3 3 3], :Ones) # Different number of output prices and Outputs
    @test_throws DimensionMismatch dearevenueadd([1; 2; 3] , [4; 5; 6], [1; 1; 1], rhoY = [1 1; 2 2; 3 3]) # Different size of output weights 
    @test_throws ArgumentError dearevenueadd([1; 2; 3], [4; 5; 6], [1; 2; 3], :Ones, rts = :Error) # Invalid returns to scale
    @test_throws ArgumentError dearevenueadd([1; 2; 3], [1; 2; 3], [1; 1; 1], :Error) # Invalid inuts direction
    @test_throws ArgumentError dearevenueadd([1; 2; 3], [1; 2; 3], [1; 1; 1], :Ones, dispos = :Error) # Invalid inputs disposal
    @test_throws ArgumentError dearevenueadd([1; 2; 3], [1; 2; 3], [1; 1; 1], :Ones, rhoY= [1; 1; 1]) # Weights not allowed if model != :Custom

end
