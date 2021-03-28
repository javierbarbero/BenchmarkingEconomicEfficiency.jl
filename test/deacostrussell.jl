# Tests for Cost Russell DEA Models
@testset "CostRussellDEAModel" begin

    # Test using Book data
    X = [2 2; 1 4; 4 1; 4 3; 5 5; 6 1; 2 5; 1.6 8];
    Y = [1; 1; 1; 1; 1; 1; 1; 1];
    W = [1 1; 1 1; 1 1; 1 1; 1 1; 1 1; 1 1; 1 1];

    # Cost Russell
    deacostrus = deacostrussell(X, Y, W)

    @test typeof(deacostrus) == CostRussellDEAModel

    @test nobs(deacostrus) == 8
    @test ninputs(deacostrus) == 2
    @test noutputs(deacostrus) == 1
    @test ismonetary(deacostrus) == false

    @test efficiency(deacostrus) == efficiency(deacostrus, :Economic)
    @test efficiency(deacostrus, :Economic)   ≈ [0.0; 0.5; 0.5; 0.5; 0.6; 1.5; 0.75; 1.75]
    @test efficiency(deacostrus, :Technical)  ≈ [0.0; 0.0; 0.0; 5/12; 0.6; 1/6; 0.35; 7/16]
    @test efficiency(deacostrus, :Allocative) ≈ [0.0; 0.5; 0.5; 1/12; 0.0; 4/3; 0.4; 21/16]
    @test normfactor(deacostrus) ≈ [4.0; 2.0; 2.0; 6.0; 10.0; 2.0; 4.0; 3.2]
    
    # With monetary = true
    deacostrusmon = deacostrussell(X, Y, W, monetary = true)

    @test ismonetary(deacostrusmon) == true

    @test efficiency(deacostrusmon) ≈ efficiency(deacostrus) .* normfactor(deacostrus)
    @test efficiency(deacostrusmon, :Technical) ≈ efficiency(deacostrus, :Technical) .* normfactor(deacostrus)
    @test efficiency(deacostrusmon, :Allocative) ≈ efficiency(deacostrus, :Allocative) .* normfactor(deacostrus)

    # With CRS (Same result in this example)
    deacostruscrs = deacostrussell(X, Y, W, rts = :CRS)

    @test efficiency(deacostruscrs, :Economic)   ≈ [0.0; 0.5; 0.5; 0.5; 0.6; 1.5; 0.75; 1.75]
    @test efficiency(deacostruscrs, :Technical)  ≈ [0.0; 0.0; 0.0; 5/12; 0.6; 1/6; 0.35; 7/16]
    @test efficiency(deacostruscrs, :Allocative) ≈ [0.0; 0.5; 0.5; 1/12; 0.0; 4/3; 0.4; 21/16]

    # Print
    show(IOBuffer(), deacostrus)

    # Test errors
    @test_throws DimensionMismatch deacostrussell([1; 2 ; 3], [4 ; 5], [1; 1; 1]) #  Different number of observations
    @test_throws DimensionMismatch deacostrussell([1; 2; 3], [4; 5; 6], [1; 2; 3; 4]) # Different number of observation in prices
    @test_throws DimensionMismatch deacostrussell([1 1; 2 2; 3 3 ], [4; 5; 6], [1 1 1; 2 2 2; 3 3 3]) # Different number of input prices and inputs
    @test_throws ArgumentError deacostadd([1; 2; 3], [4; 5; 6], [1; 2; 3], rts = :Error) # Invalid returns to scale

end
