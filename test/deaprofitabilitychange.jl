# Tests for Profitability EfficiencyChange DEA Models
@testset "ProfitabilityEfficiencyChangeDEAModel" begin

    # Test using 
    X1 = [5 3; 2 4; 4 2; 4 8; 7 9]
    Y1 = [7 4; 10 8; 8 10; 5 4; 3 6] 
    W1 = [2 1; 2 1; 2 1; 2 1; 2 1]
    P1 = [3 2; 3 2; 3 2; 3 2; 3 2]

    X2 = [14 12; 8 10; 10 8; 16 20; 14 17]
    Y2 = [18 10; 36 28; 28 36; 18 14; 12 20]
    W2 = [3 4; 3 4; 3 4; 3 4; 3 4]
    P2 = [3 5; 3 5; 3 5; 3 5; 3 5]

    X = Array{Float64,3}(undef, 5, 2, 2);
    X[:, :, 1] = X1;
    X[:, :, 2] = X2;

    Y = Array{Float64,3}(undef, 5, 2, 2);
    Y[:, :, 1] = Y1;
    Y[:, :, 2] = Y2;

    W = Array{Float64,3}(undef, 5, 2, 2);
    W[:, :, 1] = W1;
    W[:, :, 2] = W2;

    P = Array{Float64,3}(undef, 5, 2, 2);
    P[:, :, 1] = P1;
    P[:, :, 2] = P2;

    # Profitability Efficiency Change DEA Model
    profitaeffch = deaprofitabilitychange(X, Y, W, P)

    @test effchange(profitaeffch) == effchange(profitaeffch, :Economic)
    @test effchange(profitaeffch, :Economic) ≈ [0.6995065787165716; 0.9100378939024053; 1.306818198185957; 0.9100378970578911; 1.8285648452062437] atol = 1e-4
    @test effchange(profitaeffch, :CRS) ≈ [0.6547619150417504; 1.0; 1.0; 1.0; 1.5211639859155095] atol = 1e-4
    @test effchange(profitaeffch, :VRS) ≈ [0.7029261773466667; 1.0; 1.0; 1.0; 1.117935475411068] atol = 1e-4
    @test effchange(profitaeffch, :Scale) ≈ [0.9314803405291834; 1.0; 1.0; 1.0; 1.3606903254914362] atol = 1e-4
    @test effchange(profitaeffch, :Allocative) ≈ [1.0683373034486408; 0.9100378870216137; 1.306818185769918; 0.9100378731462934; 1.2020826565294507] atol = 1e-4
    show(IOBuffer(), profitaeffch)

    @test_throws ArgumentError effchange(profitaeffch, :Error)

end
