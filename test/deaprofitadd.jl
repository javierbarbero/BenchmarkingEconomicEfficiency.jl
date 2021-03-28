# Tests for Profit Additive DEA Models
@testset "ProfitAdditiveDEAModel" begin

    # Test using Book data
    X = [2; 4; 8; 12; 6; 14; 14; 9.412];
    Y = [1; 5; 8; 9; 3; 7; 9; 2.353];
    W = [1; 1; 1; 1; 1; 1; 1; 1];
    P = [2; 2; 2; 2; 2; 2; 2; 2];

    # With :Ones 
    deaprofitaddones = deaprofitadd(X, Y, W, P, :Ones)

    @test typeof(deaprofitaddones) == ProfitAdditiveDEAModel

    @test nobs(deaprofitaddones) == 8
    @test ninputs(deaprofitaddones) == 1
    @test noutputs(deaprofitaddones) == 1
    @test ismonetary(deaprofitaddones) == false

    @test efficiency(deaprofitaddones) == efficiency(deaprofitaddones, :Economic)
    @test efficiency(deaprofitaddones, :Economic)   ≈ [8.0; 2.0; 0.0; 2.0; 8.0; 8.0; 4.0; 12.706]
    @test efficiency(deaprofitaddones, :Technical)  ≈ [0.0; 0.0; 0.0; 0.0; 4.0; 22/3; 2.0; 8059/1000]
    @test efficiency(deaprofitaddones, :Allocative) ≈ [8.0; 2.0; 0.0; 2.0; 4.0; 2/3; 2.0; 4647/1000] 
    @test normfactor(deaprofitaddones) ≈ [1.0; 1.0; 1.0; 1.0; 1.0; 1.0; 1.0; 1.0]
    
    # Default is :Ones
    @test efficiency(deaprofitadd(X, Y, W, P)) == efficiency(deaprofitaddones)

    # With :MIP
    deaprofitaddmip = deaprofitadd(X, Y, W, P, :MIP)

    @test efficiency(deaprofitaddmip, :Economic)   ≈ [4.0; 0.5; 0.0; 1/6; 4/3; 4/7; 2/7; 2.699958] atol = 1e-5
    @test efficiency(deaprofitaddmip, :Technical)  ≈ [0.0; 0.0; 0.0; 0.0; 7/6; 4/7; 1/7; 2.549936] atol = 1e-5
    @test efficiency(deaprofitaddmip, :Allocative) ≈ [4.0; 0.5; 0.0; 1/6; 1/6; 0.0; 1/7; 0.150021] atol = 1e-5
    @test normfactor(deaprofitaddmip) ≈ [2.0; 4.0; 8.0; 12.0; 6.0; 14.0; 14.0; 4.706]
    
    # With :MIP and monetary = true     
    deaprofitaddmipmon = deaprofitadd(X, Y, W, P, :MIP, monetary = true)

    @test ismonetary(deaprofitaddmipmon) == true

    @test efficiency(deaprofitaddmipmon) ≈ efficiency(deaprofitaddmip) .* normfactor(deaprofitaddmip)
    @test efficiency(deaprofitaddmipmon, :Technical) ≈ efficiency(deaprofitaddmip, :Technical) .* normfactor(deaprofitaddmip)
    @test efficiency(deaprofitaddmipmon, :Allocative) ≈ efficiency(deaprofitaddmip, :Allocative) .* normfactor(deaprofitaddmip)

    # With custom weights
    deaprofitaddcustom = deaprofitadd(X, Y, W, P, rhoX = 1 ./ X, rhoY = 1 ./ Y)

    @test efficiency(deaprofitaddcustom) ≈ efficiency(deaprofitaddmip)

    # Print
    show(IOBuffer(), deaprofitaddones)

    # Test errors
    @test_throws DimensionMismatch deaprofitadd([1; 2 ; 3], [4; 5], [1; 1; 1], [1; 1], :Ones) #  Different number of observations
    @test_throws DimensionMismatch deaprofitadd([1; 2; 3], [4; 5; 6], [1; 2; 3; 4], [1; 1; 1], :Ones) # Different number of observation in input prices
    @test_throws DimensionMismatch deaprofitadd([1; 2; 3], [4; 5; 6], [1; 1; 1], [1; 2; 3; 4], :Ones) # Different number of observation in output prices
    @test_throws DimensionMismatch deaprofitadd([1 1; 2 2; 3 3 ], [4; 5; 6], [1 1 1; 2 2 2; 3 3 3], [1; 1; 1], :Ones) # Different number of input prices and inputs
    @test_throws DimensionMismatch deaprofitadd([1; 2; 3 ], [4; 5; 6], [1; 1; 1], [1 1 1; 2 2 2; 3 3 3], :Ones) # Different number of output prices and outputs
    @test_throws DimensionMismatch deaprofitadd([1; 2; 3] , [4; 5; 6], [1; 1; 1], [1; 1; 1], rhoX = [1 1; 2 2; 3 3], rhoY = [1; 1; 1]) # Different size of inputs weights
    @test_throws DimensionMismatch deaprofitadd([1; 2; 3] , [4; 5; 6], [1; 1; 1], [1; 1; 1], rhoX = [1; 1; 1], rhoY = [1 1; 2 2; 3 3]) # Different size of output weights
    @test_throws ArgumentError deaprofitadd([1; 2; 3], [1; 2; 3], [1; 1; 1], [1; 1; 1], :Error) # Invalid inuts weights
    @test_throws ArgumentError deaprofitadd([1; 2; 3], [1; 2; 3], [1; 1; 1], [1; 1; 1], :Ones, rhoX= [1; 1; 1], rhoY = [1; 1; 1]) # Weights not allowed if model != :Custom

end
