# Tests for Profit Hölder DEA Models
@testset "ProfitHölderDEAModel" begin

    # Test using Book data
    X = [2; 4; 8; 12; 6; 14; 14; 9.412];
    Y = [1; 5; 8; 9; 3; 7; 9; 2.353];
    W = [1; 1; 1; 1; 1; 1; 1; 1];
    P = [2; 2; 2; 2; 2; 2; 2; 2];

    # Profit Hölder L1
    profitholderl1 = deaprofitholder(X, Y, W, P, l = 1)

    @test typeof(profitholderl1) == ProfitHolderDEAModel

    @test nobs(profitholderl1) == 8
    @test ninputs(profitholderl1) == 1
    @test noutputs(profitholderl1) == 1
    @test ismonetary(profitholderl1) == false

    @test efficiency(profitholderl1) == efficiency(profitholderl1, :Economic)
    @test efficiency(profitholderl1, :Economic)   ≈ [4.0; 1.0; 0.0; 1.0; 4.0; 4.0; 2.0; 6.353]
    @test efficiency(profitholderl1, :Technical)  ≈ [0.0; 0.0; 0.0; 0.0; 3.0; 2.0; 0.0; 6.0]
    @test efficiency(profitholderl1, :Allocative) ≈ [4.0; 1.0; 0.0; 1.0; 1.0; 2.0; 2.0; 0.353]
    @test normfactor(profitholderl1) ≈ [2.0; 2.0; 2.0; 2.0; 2.0; 2.0; 2.0; 2.0]
    
    # With monetary = true
    profitholderl1mom = deaprofitholder(X, Y, W, P, l = 1, monetary = true)

    @test ismonetary(profitholderl1mom) == true

    @test efficiency(profitholderl1mom) ≈ efficiency(profitholderl1) .* normfactor(profitholderl1)
    @test efficiency(profitholderl1mom, :Technical) ≈ efficiency(profitholderl1, :Technical) .* normfactor(profitholderl1)
    @test efficiency(profitholderl1mom, :Allocative) ≈ efficiency(profitholderl1, :Allocative) .* normfactor(profitholderl1)

    # Profit Hölder L1 Weighted (weakly)
    profitholderl1weight= deaprofitholder(X, Y, W, P, l = 1, weight = true)

    @test efficiency(profitholderl1weight, :Economic)   ≈ [4.0; 0.2; 0.0; 1/9; 4/3; 4/7; 2/9; 1.349979] atol = 1e-5
    @test efficiency(profitholderl1weight, :Technical)  ≈ [0.0; 0.0; 0.0; 0.0; 0.5; 2/7; 0.0; 0.715629] atol = 1e-5
    @test efficiency(profitholderl1weight, :Allocative) ≈ [4.0; 0.2; 0.0; 1/9; 5/6; 2/7; 2/9; 0.634350] atol = 1e-5
  
    # Profit Hölder L2
    logs, value = Test.collect_test_logs() do
        profitholderl2 = deaprofitholder(X, Y, W, P, l = 2, optimizer = DEAOptimizer(:NLP))

        @test normfactor(profitholderl2) ≈ sqrt(5) .* ones(8)
        show(IOBuffer(), profitholderl2)
    end
     
    # Profit Hölder L2 Weighted (weakly)
    logs, value = Test.collect_test_logs() do
        profitholderl2weight = deaprofitholder(X, Y, W, P, l = 2, weight = true, optimizer = DEAOptimizer(:NLP))

        @test normfactor(profitholderl2weight) ≈ sqrt.(sum((P .* Y).^2, dims = 2) .+ sum((W .* X).^2, dims = 2))
        show(IOBuffer(), profitholderl2weight)
    end

    # Profit Hölder LInf
    profitholderlInf = deaprofitholder(X, Y, W, P, l = Inf)

    @test efficiency(profitholderlInf, :Economic)   ≈ [8/3; 2/3; 0.0; 2/3; 8/3; 8/3; 4/3; 6353/1500]
    @test efficiency(profitholderlInf, :Technical)  ≈ [0.0; 0.0; 0.0; 0.0; 2.0; 2.0; 0.0; 3.832]
    @test efficiency(profitholderlInf, :Allocative) ≈ [8/3; 2/3; 0.0; 2/3; 2/3; 2/3; 4/3; 121/300]
    @test normfactor(profitholderlInf) ≈ [3.0; 3.0; 3.0; 3.0; 3.0; 3.0; 3.0; 3.0]

    # Profit Hölder LInf Weighted (weakly)
    profitholderlInfweight = deaprofitholder(X, Y, W, P, l = Inf, weight = true)

    @test efficiency(profitholderlInfweight, :Economic)   ≈ [2.0; 1/7; 0.0; 1/15; 2/3; 2/7; 0.125; 0.899986] atol = 1e-5 
    @test efficiency(profitholderlInfweight, :Technical)  ≈ [0.0; 0.0; 0.0; 0.0; 0.4; 5/21; 0.0; 0.636115] atol = 1e-5
    @test efficiency(profitholderlInfweight, :Allocative) ≈ [2.0; 1/7; 0.0; 1/15; 4/15; 1/21; 0.125; 0.263871] atol = 1e-5
    @test normfactor(profitholderlInfweight) ≈ [4.0; 14.0; 24.0; 30.0; 12.0; 28.0; 32.0; 14.118]

    # Print
    show(IOBuffer(), profitholderl1)
    show(IOBuffer(), profitholderl1weight)
    show(IOBuffer(), profitholderlInf)
    show(IOBuffer(), profitholderlInfweight)

    # Test errors
    @test_throws DimensionMismatch deaprofitholder([1; 2 ; 3], [4; 5], [1; 1; 1], [1; 1], l = 1) #  Different number of observations
    @test_throws DimensionMismatch deaprofitholder([1; 2; 3], [4; 5; 6], [1; 2; 3; 4], [1; 1; 1], l = 1) # Different number of observation in input prices
    @test_throws DimensionMismatch deaprofitholder([1; 2; 3], [4; 5; 6], [1; 1; 1], [1; 2; 3; 4], l = 1) # Different number of observation in output prices
    @test_throws DimensionMismatch deaprofitholder([1 1; 2 2; 3 3 ], [4; 5; 6], [1 1 1; 2 2 2; 3 3 3], [1; 1; 1], l = 1) # Different number of input prices and inputs
    @test_throws DimensionMismatch deaprofitholder([1; 2; 3 ], [4; 5; 6], [1; 1; 1], [1 1 1; 2 2 2; 3 3 3], l = 1) # Different number of output prices and outputs
    @test_throws ArgumentError deaprofitholder([1; 2; 3], [4; 5; 6], [1; 2; 3], [4; 5; 6], l = 5) # Invalid l

end
