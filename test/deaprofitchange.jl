# Tests for Profit Efficiency Change DEA Models
@testset "ProfitEfficiencyChangeDEAModel" begin

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

    # Profit Efficiency Change Additive DEA Model
    profteffchadd = deaprofitchangeadd(X, Y, W, P, monetary = true)

    @test effchange(profteffchadd) == effchange(profteffchadd, :Economic)
    @test effchange(profteffchadd, :Economic) ≈ [-166.0; -18.0; 4.0; -175.0; -136.0]
    @test effchange(profteffchadd, :Technical) ≈ [-123.0; 0.0; 0.0; -135; -116]
    @test effchange(profteffchadd, :Allocative) ≈ [-43.0; -18.0; 4.0; -40.0; -20.0]
    @test profteffchadd.profitmodelbase.normalization ≈ [1.0; 1.0; 1.0; 1.0; 1.0]
    @test profteffchadd.profitmodelcomp.normalization ≈ [3.0; 3.0; 3.0; 3.0; 3.0]
    show(IOBuffer(), profteffchadd)

    @test_throws ArgumentError effchange(profteffchadd, :Error)

    # Profit Efficiency Change Russell DEA Model
    profteffchruss = deaprofitchangerussell(X, Y, W, P, monetary = true)

    @test effchange(profteffchruss, :Economic) ≈ [-166.0; -18.0; 4.0; -175.0; -136.0] atol = 1e-4
    @test effchange(profteffchruss, :Technical) ≈ [-69.26762028777515; -1.1028274116142711e-6; -1.6859232596644347e-6; -80.00837615586664; -45.85325331717295] atol = 1e-4
    @test effchange(profteffchruss, :Allocative) ≈ [-96.73238469222584; -18.00000387717357; 3.999996705922279; -94.99162882413435; -90.14675166282802] atol = 1e-4
    @test profteffchruss.profitmodelbase.normalization ≈ [12.0; 16.0; 8.0; 32.0; 36.0]
    @test profteffchruss.profitmodelcomp.normalization ≈ [168.0; 96.0; 120.0; 192.0; 144.0]
    show(IOBuffer(), profteffchruss)

    # Profit Efficiency Change Enhanced Russell Graph Slack Based Measure DEA Model
    profteffcherg =  deaprofitchangeerg(X, Y, W, P, monetary = true)

    @test effchange(profteffcherg, :Economic) ≈ [-166.0; -18.0; 4.0; -175.0; -136.0] atol = 1e-4
    @test effchange(profteffcherg, :Technical) ≈ [-152.0047619047619; -5.329070518200751e-15; -6.661338147750939e-15; -124.89523809523811; -81.22352941176482] atol = 1e-4
    @test effchange(profteffcherg, :Allocative) ≈ [-13.995238095237983; -17.99999999999988; 4.000000000000121; -50.104761904761766; -54.77647058823508] atol = 1e-4
    @test profteffcherg.profitmodelbase.normalization ≈ [10.928571428571429; 8.0; 4.0; 32.0; 42.0]
    @test profteffcherg.profitmodelcomp.normalization ≈ [216.5333333333333; 48.0; 60.0; 198.09523809523813; 158.4]
    show(IOBuffer(), profteffcherg)

    # Profit Efficiency Change DEA Model
    profteffchddf = deaprofitchange(X, Y, W, P, Gx = :Monetary, Gy = :Monetary)

    @test effchange(profteffchddf, :Economic) ≈ [-166.0; -18.0; 4.0; -175.0; -136.0] atol = 1e-4
    @test effchange(profteffchddf, :Technical) ≈ [-52.0; 0.0; 0.0; -104.0; -62.0] atol = 1e-4
    @test effchange(profteffchddf, :Allocative) ≈ [-114.0; -18.0; 4.0; -71.0; -74.0] atol = 1e-4
    @test profteffchddf.profitmodelbase.normalization ≈ [1.0; 1.0; 1.0; 1.0; 1.0]
    @test profteffchddf.profitmodelcomp.normalization ≈ [1.0; 1.0; 1.0; 1.0; 1.0]
    show(IOBuffer(), profteffchddf)

    # Profit Efficiency Change Hölder DEA Model
    profteffchholder = deaprofitchangeholder(X, Y, W, P; l = 1, monetary = true)

    @test effchange(profteffchholder, :Economic) ≈ [-166.0; -18.0; 4.0; -175.0; -136.0] atol = 1e-4
    @test effchange(profteffchholder, :Technical) ≈ [-17.0; 0.0; 0.0; -34.0; -18.0] atol = 1e-4
    @test effchange(profteffchholder, :Allocative) ≈ [-149.0; -18.0; 4.0; -141.0; -118.0] atol = 1e-4
    @test profteffchholder.profitmodelbase.normalization ≈ [3.0; 3.0; 3.0; 3.0; 3.0]
    @test profteffchholder.profitmodelcomp.normalization ≈ [5.0; 5.0; 5.0; 5.0; 5.0]
    show(IOBuffer(), profteffchholder)

    # Profit Efficiency Change Modified DDF DEA Model
    profteffchmddf = deaprofitchangemddf(X, Y, W, P; Gx = :Observed, Gy = :Observed, monetary = true)

    @test effchange(profteffchmddf, :Economic) ≈ [-166.0; -18.0; 4.0; -175.0; -136.0] atol = 1e-4
    @test effchange(profteffchmddf, :Technical) ≈ [-44.71428571428573; 0.0; 0; -69.0; -35.74285714285715] atol = 1e-4
    @test effchange(profteffchmddf, :Allocative) ≈ [-121.28571428571416; -17.999999999999886; 4.0; -106.0; -100.25714285714272] atol = 1e-4
    @test profteffchmddf.profitmodelbase.normalization ≈ [10.0; 4.0; 8.0; 8.0; 9.0]
    @test profteffchmddf.profitmodelcomp.normalization ≈ [42.0; 24.0; 30.0; 54.0; 42.0]
    show(IOBuffer(), profteffchmddf)

    # Profit Efficiency Change Reverse DDF DEA Model
    profteffchrddf = deaprofitchangerddf(X, Y, W, P, :ERG, monetary = true)

    @test effchange(profteffchrddf, :Economic) ≈ [-166.0; -18.0; 4.0; -175.0; -136.0] atol = 1e-4
    @test effchange(profteffchrddf, :Technical) ≈ [-170.0; 0.0; 0.0; -175.0; -118.0] atol = 1e-4
    @test effchange(profteffchrddf, :Allocative) ≈ [4.0; -18.0; 4.0; 0.0; -18.0] atol = 1e-4
    @test profteffchrddf.profitmodelbase.normalization ≈ [30.13129102844639; 8.0; 4.0; 41.333333333333336; 47.41935483870968]
    @test profteffchrddf.profitmodelcomp.normalization ≈ [256.780487804878; 48.0; 60.0; 274.0693360624281; 214.5456431535269]
    show(IOBuffer(), profteffchrddf)

    # General Direct Approach Profit Efficiency Change DEA Model
    profteffchgda = deaprofitchangegda(X, Y, W, P, :ERG, monetary = true)

    @test effchange(profteffchgda, :Economic) ≈ [-166.0; -18.0; 4.0; -175.0; -136.0] atol = 1e-4
    @test effchange(profteffchgda, :Technical) ≈ [-170.0; 0.0; 0.0; -175.0; -118.0] atol = 1e-4
    @test effchange(profteffchgda, :Allocative) ≈ [4.0; -18.0; 4.0; 0.0; -18.0] atol = 1e-4
    @test profteffchgda.profitmodelbase.normalization ≈ [30.13129102844639; 8.0; 4.0; 41.333333333333336; 47.41935483870968]
    @test profteffchgda.profitmodelcomp.normalization ≈ [256.780487804878; 48.0; 60.0; 274.0693360624281; 214.5456431535269]
    show(IOBuffer(), profteffchgda)

end
