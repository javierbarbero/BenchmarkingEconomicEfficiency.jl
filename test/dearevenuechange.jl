# Tests for Revenue Efficiency Change DEA Models
@testset "RevenueEfficiencyChangeDEAModel" begin

    # Test using 
    X1 = [5 3; 2 4; 4 2; 4 8; 7 9]
    Y1 = [7 4; 10 8; 8 10; 5 4; 3 6] 
    P1 = [3 2; 3 2; 3 2; 3 2; 3 2]

    X2 = [14 12; 8 10; 10 8; 16 20; 14 17]
    Y2 = [18 10; 36 28; 28 36; 18 14; 12 20]
    P2 = [3 5; 3 5; 3 5; 3 5; 3 5]
  
    X = Array{Float64,3}(undef, 5, 2, 2);
    X[:, :, 1] = X1;
    X[:, :, 2] = X2;

    Y = Array{Float64,3}(undef, 5, 2, 2);
    Y[:, :, 1] = Y1;
    Y[:, :, 2] = Y2;

    P = Array{Float64,3}(undef, 5, 2, 2);
    P[:, :, 1] = P1;
    P[:, :, 2] = P2;

    # Revenue Efficiency Change Radial DEA Model
    revenueeffchradial = dearevenuechange(X, Y, P)

    @test effchange(revenueeffchradial) == effchange(revenueeffchradial, :Economic)
    @test effchange(revenueeffchradial, :Economic) ≈ [0.6112852664576802; 1.0; 1.0; 0.9393939393939394; 1.1284271284271286]
    @test effchange(revenueeffchradial, :Technical) ≈ [0.6428571428571429; 1.0; 1.0000000000000002; 1.0; 0.925925925925926]
    @test effchange(revenueeffchradial, :Allocative) ≈ [0.9508881922675024; 1.0; 1.0; 0.9393939393939394; 1.2187012987012988]
    show(IOBuffer(), revenueeffchradial)

    # Revenue Efficiency Change Additive DEA Model
    revenueeffchadd = dearevenuechangeadd(X, Y, P, monetary = true)

    @test effchange(revenueeffchadd) == effchange(revenueeffchadd, :Economic)
    @test effchange(revenueeffchadd, :Economic) ≈ [-144.0; 0.0; 0.0; -117.0; -103.0]
    @test effchange(revenueeffchadd, :Technical) ≈ [-94.0; 0.0; 0.0; -78.0; -78.0]
    @test effchange(revenueeffchadd, :Allocative) ≈ [-50.0; 0.0; 0.0; -39.0; -25.0]
    @test revenueeffchadd.revenuemodelbase.normalization ≈ [2.0; 2.0; 2.0; 2.0; 2.0]
    @test revenueeffchadd.revenuemodelcomp.normalization ≈ [3.0; 3.0; 3.0; 3.0; 3.0]
    show(IOBuffer(), revenueeffchadd)

    @test_throws ArgumentError effchange(revenueeffchadd, :Error)

    # Revenue Efficiency Change Russell DEA Model
    revenueeffchruss = dearevenuechangerussell(X, Y, P, monetary = true)

    @test effchange(revenueeffchruss, :Economic) ≈ [-144.0; 0.0; 0.0; -117.0; -103.0]
    @test effchange(revenueeffchruss, :Technical) ≈ [ -144.6349206349207; 0.0; 0.0; -98.05714285714284; -62.40000000000001]
    @test effchange(revenueeffchruss, :Allocative) ≈ [0.634920634920686; 0.0; 0.0; -18.942857142857164; -40.59999999999999]
    @test revenueeffchruss.revenuemodelbase.normalization ≈ [16.0; 32.0; 40.0; 16.0; 18.0]
    @test revenueeffchruss.revenuemodelcomp.normalization ≈ [100.0; 216.0; 168.0; 108.0; 72.0]
    show(IOBuffer(), revenueeffchruss)

    # Revenue Efficiency Change DEA DDF Model
    revenueeffchddf = dearevenuechangeddf(X, Y, P, Gy = :Monetary)

    @test effchange(revenueeffchddf, :Economic) ≈ [-144.0; 0.0; 0.0; -117.0; -103.0]
    @test effchange(revenueeffchddf, :Technical) ≈ [-134.0; 0.0; 0.0; -105.5; -108.0]
    @test effchange(revenueeffchddf, :Allocative) ≈ [-10.0; 0.0; 0.0; -11.5; 5.0]
    @test revenueeffchddf.revenuemodelbase.normalization ≈ [1.0; 1.0; 1.0; 1.0; 1.0]
    @test revenueeffchddf.revenuemodelcomp.normalization ≈ [1.0; 1.0; 1.0; 1.0; 1.0]
    show(IOBuffer(), revenueeffchddf)

    # Revenue Efficiency Change Hölder DEA Model
    revenueeffchholder = dearevenuechangeholder(X, Y, P; l = 1, monetary = true)

    @test effchange(revenueeffchholder, :Economic) ≈ [-144.0; 0.0; 0.0; -117.0; -103.0]
    @test effchange(revenueeffchholder, :Technical) ≈ [-84.0; 0.0; 0.0; -75.0; -68.0]
    @test effchange(revenueeffchholder, :Allocative) ≈ [-60.0; 0.0; 0.0; -42.0; -35.0]
    @test revenueeffchholder.revenuemodelbase.normalization ≈ [3.0; 3.0; 3.0; 3.0; 3.0]
    @test revenueeffchholder.revenuemodelcomp.normalization ≈ [5.0; 5.0; 5.0; 5.0; 5.0]
    show(IOBuffer(), revenueeffchholder)

    # Revenue Efficiency Change Reverse DDF DEA Model
    revenueeffchrddf = dearevenuechangerddf(X, Y, P, :ERG, monetary = true)

    @test effchange(revenueeffchrddf, :Economic) ≈ [-144.0; 0.0; 0.0; -117.0; -103.0]
    @test effchange(revenueeffchrddf, :Technical) ≈ [-145.0; 0.0; 0.0; -119.0; -87.0]
    @test effchange(revenueeffchrddf, :Allocative) ≈ [1.0; 0.0; 0.0; 2.0; -16.0]
    @test revenueeffchrddf.revenuemodelbase.normalization ≈ [33.2608695652174; 32.0; 40.0; 41.0; 43.75]
    @test revenueeffchrddf.revenuemodelcomp.normalization ≈ [261.40845070422534; 216.0; 168.0; 271.64179104477614; 205.33333333333343]
    show(IOBuffer(), revenueeffchrddf)

    # General Direct Approach Revenue Efficiency Change DEA Model
    revenueeffchgda = dearevenuechangegda(X, Y, P, :ERG, monetary = true)

    @test effchange(revenueeffchgda, :Economic) ≈ [-144.0; 0.0; 0.0; -117.0; -103.0]
    @test effchange(revenueeffchgda, :Technical) ≈ [-145.0; 0.0; 0.0; -119.0; -87.0]
    @test effchange(revenueeffchgda, :Allocative) ≈ [1.0; 0.0; 0.0; 2.0; -16.0]
    @test revenueeffchgda.revenuemodelbase.normalization ≈ [18.26086956521739; 32.0; 40.0; 20.000000000000004; 18.750000000000004]
    @test revenueeffchgda.revenuemodelcomp.normalization ≈ [101.40845070422533; 216.0; 168.0; 131.64179104477614; 93.33333333333336]
    show(IOBuffer(), revenueeffchgda)

end
