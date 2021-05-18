# Tests for Cost Hölder DEA Models
@testset "CostHölderDEAModel" begin

    # Test using Book data
    X = [2 2; 1 4; 4 1; 4 3; 5 5; 6 1; 2 5; 1.6 8];
    Y = [1; 1; 1; 1; 1; 1; 1; 1];
    W = [1 1; 1 1; 1 1; 1 1; 1 1; 1 1; 1 1; 1 1];

    # Cost Hölder L1
    costholderl1 = deacostholder(X, Y, W, l = 1)

    @test typeof(costholderl1) == CostHolderDEAModel

    @test nobs(costholderl1) == 8
    @test ninputs(costholderl1) == 2
    @test noutputs(costholderl1) == 1
    @test ismonetary(costholderl1) == false

    @test efficiency(costholderl1) == efficiency(costholderl1, :Economic)
    @test efficiency(costholderl1, :Economic)   ≈ [0.0; 1.0; 1.0; 3.0; 6.0; 3.0; 3.0; 5.6]
    @test efficiency(costholderl1, :Technical)  ≈ [0.0; 0.0; 0.0; 2.0; 4.0; 0.0; 1.0; 0.6]
    @test efficiency(costholderl1, :Allocative) ≈ [0.0; 1.0; 1.0; 1.0; 2.0; 3.0; 2.0; 5.0]
    @test normfactor(costholderl1) ≈ [1.0; 1.0; 1.0; 1.0; 1.0; 1.0; 1.0; 1.0]
    
    # With monetary = true
    costholderl1mom = deacostholder(X, Y, W, l = 1, monetary = true)

    @test ismonetary(costholderl1mom) == true

    @test efficiency(costholderl1mom) ≈ efficiency(costholderl1) .* normfactor(costholderl1)
    @test efficiency(costholderl1mom, :Technical) ≈ efficiency(costholderl1, :Technical) .* normfactor(costholderl1)
    @test efficiency(costholderl1mom, :Allocative) ≈ efficiency(costholderl1, :Allocative) .* normfactor(costholderl1)

    # With CRS (Same result in this example)
    costholderl1crs = deacostholder(X, Y, W, l = 1, rts = :CRS)

    @test efficiency(costholderl1crs, :Economic)   ≈ [0.0; 1.0; 1.0; 3.0; 6.0; 3.0; 3.0; 5.6]
    @test efficiency(costholderl1crs, :Technical)  ≈ [0.0; 0.0; 0.0; 2.0; 4.0; 0.0; 1.0; 0.6]
    @test efficiency(costholderl1crs, :Allocative) ≈ [0.0; 1.0; 1.0; 1.0; 2.0; 3.0; 2.0; 5.0]

    # Cost Hölder L1 Weighted (weakly)
    costholderl1weight= deacostholder(X, Y, W, l = 1, weight = true)

    @test efficiency(costholderl1weight, :Economic)   ≈ [0.0; 0.25; 0.25; 0.75; 1.2; 0.5; 0.6; 0.7]
    @test efficiency(costholderl1weight, :Technical)  ≈ [0.0; 0.0; 0.0; 0.625; 0.8; 0.0; 0.5; 0.375]
    @test efficiency(costholderl1weight, :Allocative) ≈ [0.0; 0.25; 0.25; 0.125; 0.4; 0.5; 0.1; 0.325]
  
    # Cost Hölder L2
    logs, value = Test.collect_test_logs() do
        costholderl2 = deacostholder(X, Y, W, l = 2, optimizer = DEAOptimizer(:NLP))

        @test normfactor(costholderl2) ≈ sqrt(2) .* ones(8)
        show(IOBuffer(), costholderl2)
    end
     
    # Cost Hölder L2 Weighted (weakly)
    logs, value = Test.collect_test_logs() do
        costholderl2weight = deacostholder(X, Y, W, l = 2, weight = true, optimizer = DEAOptimizer(:NLP))

        @test normfactor(costholderl2weight) ≈ sqrt.(sum((W .* X).^2, dims = 2))
        show(IOBuffer(), costholderl2weight)
    end

    # Cost Hölder LInf
    costholderlInf = deacostholder(X, Y, W, l = Inf)

    @test efficiency(costholderlInf, :Economic)   ≈ [0.0; 0.5; 0.5; 1.5; 3.0; 1.5; 1.5; 2.8]
    @test efficiency(costholderlInf, :Technical)  ≈ [0.0; 0.0; 0.0; 4/3; 3.0; 0.0; 1.0; 0.6]
    @test efficiency(costholderlInf, :Allocative) ≈ [0.0; 0.5; 0.5; 1/6; 0.0; 1.5; 0.5; 2.2]
    @test normfactor(costholderlInf) ≈ [2.0; 2.0; 2.0; 2.0; 2.0; 2.0; 2.0; 2.0]

    # Cost Hölder LInf Weighted (weakly)
    costholderlInfweight = deacostholder(X, Y, W, l = Inf, weight = true)

    @test efficiency(costholderlInfweight, :Economic)   ≈ [0.0; 0.2; 0.2; 3/7; 0.6; 3/7; 3/7; 7/12] 
    @test efficiency(costholderlInfweight, :Technical)  ≈ [0.0; 0.0; 0.0; 0.4; 0.6; 0.0; 1/3; 3/8]
    @test efficiency(costholderlInfweight, :Allocative) ≈ [0.0; 0.2; 0.2; 1/35; 0.0; 3/7; 2/21; 5/24]
    @test normfactor(costholderlInfweight) ≈ [4.0; 5.0; 5.0; 7.0; 10.0; 7.0; 7.0; 9.6]

    # Print
    show(IOBuffer(), costholderl1)
    show(IOBuffer(), costholderl1weight)
    show(IOBuffer(), costholderlInf)
    show(IOBuffer(), costholderlInfweight)

    # Test errors
    @test_throws DimensionMismatch deacostholder([1; 2 ; 3], [4 ; 5], [1; 1; 1], l = 1) #  Different number of observations
    @test_throws DimensionMismatch deacostholder([1; 2; 3], [4; 5; 6], [1; 2; 3; 4], l = 1) # Different number of observation in prices
    @test_throws DimensionMismatch deacostholder([1 1; 2 2; 3 3 ], [4; 5; 6], [1 1 1; 2 2 2; 3 3 3], l = 1) # Different number of input prices and inputs
    @test_throws ArgumentError deacostholder([1; 2; 3], [4; 5; 6], [1; 2; 3], l = 5) # Invalid l
    @test_throws ArgumentError deacostholder([1; 2; 3], [4; 5; 6], [1; 2; 3], l = 1, rts = :Error) # Invalid returns to scale

end
