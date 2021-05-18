# Tests for Revenue Hölder DEA Models
@testset "RevenueHölderDEAModel" begin

    # Test using Book data
    X = [1; 1; 1; 1; 1; 1; 1; 1];
    Y = [7 7; 4 8; 8 4; 3 5; 3 3; 8 2; 6 4; 1.5 5];
    P = [1 1; 1 1; 1 1; 1 1; 1 1; 1 1; 1 1; 1 1];

    # Revenue Hölder L1
    revenueholderl1 = dearevenueholder(X, Y, P, l = 1)

    @test typeof(revenueholderl1) == RevenueHolderDEAModel

    @test nobs(revenueholderl1) == 8
    @test ninputs(revenueholderl1) == 1
    @test noutputs(revenueholderl1) == 2
    @test ismonetary(revenueholderl1) == false

    @test efficiency(revenueholderl1) == efficiency(revenueholderl1, :Economic)
    @test efficiency(revenueholderl1, :Economic)   ≈ [0.0; 2.0; 2.0; 6.0; 8.0; 4.0; 4.0; 7.5]
    @test efficiency(revenueholderl1, :Technical)  ≈ [0.0; 0.0; 0.0; 3.0; 5.0; 0.0; 2.0; 3.0]
    @test efficiency(revenueholderl1, :Allocative) ≈ [0.0; 2.0; 2.0; 3.0; 3.0; 4.0; 2.0; 4.5]
    @test normfactor(revenueholderl1) ≈ [1.0; 1.0; 1.0; 1.0; 1.0; 1.0; 1.0; 1.0]
    
    # With monetary = true
    revenueholderl1mom = dearevenueholder(X, Y, P, l = 1, monetary = true)

    @test ismonetary(revenueholderl1mom) == true

    @test efficiency(revenueholderl1mom) ≈ efficiency(revenueholderl1) .* normfactor(revenueholderl1)
    @test efficiency(revenueholderl1mom, :Technical) ≈ efficiency(revenueholderl1, :Technical) .* normfactor(revenueholderl1)
    @test efficiency(revenueholderl1mom, :Allocative) ≈ efficiency(revenueholderl1, :Allocative) .* normfactor(revenueholderl1)

    # With CRS (Same result in this example)
    revenueholderl1crs = dearevenueholder(X, Y, P, l = 1, rts = :CRS)

    @test efficiency(revenueholderl1crs, :Economic)   ≈ [0.0; 2.0; 2.0; 6.0; 8.0; 4.0; 4.0; 7.5]
    @test efficiency(revenueholderl1crs, :Technical)  ≈ [0.0; 0.0; 0.0; 3.0; 5.0; 0.0; 2.0; 3.0]
    @test efficiency(revenueholderl1crs, :Allocative) ≈ [0.0; 2.0; 2.0; 3.0; 3.0; 4.0; 2.0; 4.5]

    # Revenue Hölder L1 Weighted (weakly)
    revenueholderl1weight = dearevenueholder(X, Y, P, l = 1, weight = true)

    @test efficiency(revenueholderl1weight, :Economic)   ≈ [0.0; 0.25; 0.25; 1.2; 8/3; 0.5; 2/3; 1.5]
    @test efficiency(revenueholderl1weight, :Technical)  ≈ [0.0; 0.0; 0.0; 0.6; 5/3; 0.0; 1/3; 0.6]
    @test efficiency(revenueholderl1weight, :Allocative) ≈ [0.0; 0.25; 0.25; 0.6; 1.0; 0.5; 1/3; 0.9]
  
    # Revenue Hölder L2
    logs, value = Test.collect_test_logs() do
        revenueholderl2 = dearevenueholder(X, Y, P, l = 2, optimizer = DEAOptimizer(:NLP))

        @test normfactor(revenueholderl2) ≈ sqrt(2) .* ones(8)
        show(IOBuffer(), revenueholderl2)
    end
     
    # Revenue Hölder L2 Weighted (weakly)
    logs, value = Test.collect_test_logs() do
        revenueholderl2weight = dearevenueholder(X, Y, P, l = 2, weight = true, optimizer = DEAOptimizer(:NLP))

        @test normfactor(revenueholderl2weight) ≈ sqrt.(sum((P .* Y).^2, dims = 2))
        show(IOBuffer(), revenueholderl2weight)
    end

    # Revenue Hölder LInf
    revenueholderlInf = dearevenueholder(X, Y, P, l = Inf)

    @test efficiency(revenueholderlInf, :Economic)   ≈ [0.0; 1.0; 1.0; 3.0; 4.0; 2.0; 2.0; 3.75]
    @test efficiency(revenueholderlInf, :Technical)  ≈ [0.0; 0.0; 0.0; 2.5; 4.0; 0.0; 1.5; 2.875]
    @test efficiency(revenueholderlInf, :Allocative) ≈ [0.0; 1.0; 1.0; 0.5; 0.0; 2.0; 0.5; 0.875]
    @test normfactor(revenueholderlInf) ≈ [2.0; 2.0; 2.0; 2.0; 2.0; 2.0; 2.0; 2.0]

    # Revenue Hölder LInf Weighted (weakly)
    revenueholderlInfweight = dearevenueholder(X, Y, P, l = Inf, weight = true)

    @test efficiency(revenueholderlInfweight, :Economic)   ≈ [0.0; 1/6; 1/6; 0.75; 4/3; 0.4; 0.4; 15/13] 
    @test efficiency(revenueholderlInfweight, :Technical)  ≈ [0.0; 0.0; 0.0; 5/9; 4/3; 0.0; 3/11; 0.6]
    @test efficiency(revenueholderlInfweight, :Allocative) ≈ [0.0; 1/6; 1/6; 7/36; 0.0; 0.4; 7/55; 36/65]
    @test normfactor(revenueholderlInfweight) ≈ [14.0; 12.0; 12.0; 8.0; 6.0; 10.0; 10.0; 6.5]

    # Print
    show(IOBuffer(), revenueholderl1)
    show(IOBuffer(), revenueholderl1weight)
    show(IOBuffer(), revenueholderlInf)
    show(IOBuffer(), revenueholderlInfweight)

    # Test errors
    @test_throws DimensionMismatch dearevenueholder([1; 2 ; 3], [4 ; 5], [1; 1; 1], l = 1) #  Different number of observations
    @test_throws DimensionMismatch dearevenueholder([1; 2; 3], [4; 5; 6], [1; 2; 3; 4], l = 1) # Different number of observation in prices
    @test_throws DimensionMismatch dearevenueholder([1 1; 2 2; 3 3 ], [4; 5; 6], [1 1 1; 2 2 2; 3 3 3], l = 1) # Different number of input prices and inputs
    @test_throws ArgumentError dearevenueholder([1; 2; 3], [4; 5; 6], [1; 2; 3], l = 5) # Invalid l
    @test_throws ArgumentError dearevenueholder([1; 2; 3], [4; 5; 6], [1; 2; 3], l = 1, rts = :Error) # Invalid returns to scale

end
