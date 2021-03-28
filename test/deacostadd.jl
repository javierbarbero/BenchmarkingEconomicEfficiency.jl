# Tests for Cost Additive DEA Models
@testset "CostAdditiveDEAModel" begin

    # Test using Book data
    X = [2 2; 1 4; 4 1; 4 3; 5 5; 6 1; 2 5; 1.6 8];
    Y = [1; 1; 1; 1; 1; 1; 1; 1];
    W = [1 1; 1 1; 1 1; 1 1; 1 1; 1 1; 1 1; 1 1];

    # With :Ones 
    deacostaddones = deacostadd(X, Y, W, :Ones)

    @test typeof(deacostaddones) == CostAdditiveDEAModel

    @test nobs(deacostaddones) == 8
    @test ninputs(deacostaddones) == 2
    @test noutputs(deacostaddones) == 1
    @test ismonetary(deacostaddones) == false

    @test efficiency(deacostaddones) == efficiency(deacostaddones, :Economic)
    @test efficiency(deacostaddones, :Economic)   ≈ [0.0; 1.0; 1.0; 3.0; 6.0; 3.0; 3.0; 5.6]
    @test efficiency(deacostaddones, :Technical)  ≈ [0.0; 0.0; 0.0; 3.0; 6.0; 2.0; 3.0; 5.2]
    @test efficiency(deacostaddones, :Allocative) ≈ [0.0; 1.0; 1.0; 0.0; 0.0; 1.0; 0.0; 0.4]
    @test normfactor(deacostaddones) ≈ [1.0; 1.0; 1.0; 1.0; 1.0; 1.0; 1.0; 1.0]
    
    # With :Ones and CRS (Same result in this example)
    deacostaddonescrs = deacostadd(X, Y, W, :Ones, rts = :CRS)

    @test efficiency(deacostaddonescrs, :Economic)   ≈ [0.0; 1.0; 1.0; 3.0; 6.0; 3.0; 3.0; 5.6]
    @test efficiency(deacostaddonescrs, :Technical)  ≈ [0.0; 0.0; 0.0; 3.0; 6.0; 2.0; 3.0; 5.2]
    @test efficiency(deacostaddonescrs, :Allocative) ≈ [0.0; 1.0; 1.0; 0.0; 0.0; 1.0; 0.0; 0.4]

    # With :MIP
    deacostaddmip = deacostadd(X, Y, W, :MIP)

    @test efficiency(deacostaddmip, :Economic)   ≈ [0.0; 1.0; 1.0; 1.0; 1.2; 3.0; 1.5; 3.5] atol = 1e-5
    @test efficiency(deacostaddmip, :Technical)  ≈ [0.0; 0.0; 0.0; 5/6; 1.2; 1/3; 7/10; 0.875] atol = 1e-5
    @test efficiency(deacostaddmip, :Allocative) ≈ [0.0; 1.0; 1.0; 1/6; 0.0; 8/3; 4/5; 21/8] atol = 1e-5
    @test normfactor(deacostaddmip) ≈ [2.0; 1.0; 1.0; 3.0; 5.0; 1.0; 2.0; 1.6]
    
    # With :MIP and monetary = true     
    deacostaddmipmon = deacostadd(X, Y, W, :MIP, monetary = true)

    @test ismonetary(deacostaddmipmon) == true

    @test efficiency(deacostaddmipmon) ≈ efficiency(deacostaddmip) .* normfactor(deacostaddmip)
    @test efficiency(deacostaddmipmon, :Technical) ≈ efficiency(deacostaddmip, :Technical) .* normfactor(deacostaddmip)
    @test efficiency(deacostaddmipmon, :Allocative) ≈ efficiency(deacostaddmip, :Allocative) .* normfactor(deacostaddmip)

    # With custom weights
    deacostaddcustom = deacostadd(X, Y, W, rhoX = 1 ./ X)

    @test efficiency(deacostaddcustom) ≈ efficiency(deacostaddmip)

    # Print
    show(IOBuffer(), deacostaddones)
    show(IOBuffer(), deacostadd(X, Y, W, :Ones, dispos = :Weak))

    # Test errors
    @test_throws DimensionMismatch deacostadd([1; 2 ; 3], [4 ; 5], [1; 1; 1] , :Ones) #  Different number of observations
    @test_throws DimensionMismatch deacostadd([1; 2; 3], [4; 5; 6], [1; 2; 3; 4], :Ones) # Different number of observation in prices
    @test_throws DimensionMismatch deacostadd([1 1; 2 2; 3 3 ], [4; 5; 6], [1 1 1; 2 2 2; 3 3 3], :Ones) # Different number of input prices and inputs
    @test_throws DimensionMismatch deacostadd([1; 2; 3] , [4; 5; 6], [1; 1; 1], rhoX = [1 1; 2 2; 3 3]) # Different size of inputs direction
    @test_throws ArgumentError deacostadd([1; 2; 3], [4; 5; 6], [1; 2; 3],:Ones, rts = :Error) # Invalid returns to scale
    @test_throws ArgumentError deacostadd([1; 2; 3], [1; 2; 3], [1; 1; 1], :Error) # Invalid inuts direction
    @test_throws ArgumentError deacostadd([1; 2; 3], [1; 2; 3], [1; 1; 1], :Ones, dispos = :Error) # Invalid inputs disposability
    @test_throws ArgumentError deacostadd([1; 2; 3], [1; 2; 3], [1; 1; 1], :Ones, rhoX= [1; 1; 1]) # Weights not allowed if model != :Custom

end
