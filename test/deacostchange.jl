# Tests for Cost Efficiency Change DEA Models
@testset "CostEfficiencyChangeDEAModel" begin

    # Test using 
    X1 = [5 3; 2 4; 4 2; 4 8; 7 9]
    Y1 = [7 4; 10 8; 8 10; 5 4; 3 6] 
    W1 = [2 1; 2 1; 2 1; 2 1; 2 1]

    X2 = [14 12; 8 10; 10 8; 16 20; 14 17]
    Y2 = [18 10; 36 28; 28 36; 18 14; 12 20]
    W2 = [3 4; 3 4; 3 4; 3 4; 3 4]
  
    X = Array{Float64,3}(undef, 5, 2, 2);
    X[:, :, 1] = X1;
    X[:, :, 2] = X2;

    Y = Array{Float64,3}(undef, 5, 2, 2);
    Y[:, :, 1] = Y1;
    Y[:, :, 2] = Y2;

    W = Array{Float64,3}(undef, 5, 2, 2);
    W[:, :, 1] = W1;
    W[:, :, 2] = W2;

    # Cost Efficiency Change Radial DEA Model
    costeffchradial = deacostchange(X, Y, W)

    @test effchange(costeffchradial) == effchange(costeffchradial, :Economic)
    @test effchange(costeffchradial, :Economic) ≈ [1.1194444444444447; 1.0; 1.0; 0.96875; 1.6204545454545451]
    @test effchange(costeffchradial, :Technical) ≈ [0.9230769230769229; 1.0; 1.0; 1.0; 1.5483870967741933]
    @test effchange(costeffchradial, :Allocative) ≈ [1.212731481481482; 1.0; 1.0; 0.96875; 1.0465435606060605]
    show(IOBuffer(), costeffchradial)

    # Cost Efficiency Change Additive DEA Model
    costeffchadd = deacostchangeadd(X, Y, W, monetary = true)

    @test effchange(costeffchadd) == effchange(costeffchadd, :Economic)
    @test effchange(costeffchadd, :Economic) ≈ [-23.0; 0.0; 0.0; -58.0; -33.0]
    @test effchange(costeffchadd, :Technical) ≈ [-22.0; 0.0; 0.0; -48.0; -29.0]
    @test effchange(costeffchadd, :Allocative) ≈ [-1.0; 0.0; 0.0; -10.0; -4.0]
    @test costeffchadd.costmodelbase.normalization ≈ [1.0; 1.0; 1.0; 1.0; 1.0]
    @test costeffchadd.costmodelcomp.normalization ≈ [3.0; 3.0; 3.0; 3.0; 3.0]
    show(IOBuffer(), costeffchadd)

    @test_throws ArgumentError effchange(costeffchadd, :Error)

    # Cost Efficiency Change Russell DEA Model
    costeffchruss = deacostchangerussell(X, Y, W, monetary = true)

    @test effchange(costeffchruss, :Economic) ≈ [-23.0; 0.0; 0.0; -58.0; -33.0]
    @test effchange(costeffchruss, :Technical) ≈ [-24.4; 0.0; 0.0; -40.0; -23.865546218487385]
    @test effchange(costeffchruss, :Allocative) ≈ [1.4; 0.0; 0.0; -18.0; -9.13445378151263]
    @test costeffchruss.costmodelbase.normalization ≈ [6.0; 8.0; 4.0; 16.0; 18.0]
    @test costeffchruss.costmodelcomp.normalization ≈ [84.0; 48.0; 60.0; 96.0; 84.0]
    show(IOBuffer(), costeffchruss)

    # Cost Efficiency Change DEA DDF Model
    costeffchddf = deacostchangeddf(X, Y, W, Gx = :Monetary)

    @test effchange(costeffchddf, :Economic) ≈ [-23.0; 0.0; 0.0; -58.0; -33.0]
    @test effchange(costeffchddf, :Technical) ≈ [-25.0; 0.0; 0.0; -50.0; -27.0]
    @test effchange(costeffchddf, :Allocative) ≈ [2.0; 0.0; 0.0; -8.0; -6.0]
    @test costeffchddf.costmodelbase.normalization ≈ [1.0; 1.0; 1.0; 1.0; 1.0]
    @test costeffchddf.costmodelcomp.normalization ≈ [1.0; 1.0; 1.0; 1.0; 1.0]
    show(IOBuffer(), costeffchddf)

    # Cost Efficiency Change Hölder DEA Model
    costeffchholder = deacostchangeholder(X, Y, W; l = 1, monetary = true)

    @test effchange(costeffchholder, :Economic) ≈ [-23.0; 0.0; 0.0; -58.0; -33.0]
    @test effchange(costeffchholder, :Technical) ≈ [-14.0; 0.0; 0.0; -28.0; -14.0]
    @test effchange(costeffchholder, :Allocative) ≈ [-9.0; 0.0; 0.0; -30.0; -19.0]
    @test costeffchholder.costmodelbase.normalization ≈ [2.0; 2.0; 2.0; 2.0; 2.0]
    @test costeffchholder.costmodelcomp.normalization ≈ [4.0; 4.0; 4.0; 4.0; 4.0]
    show(IOBuffer(), costeffchholder)

    # Cost Efficiency Change Reverse DDF DEA Model
    costeffchrddf = deacostchangerddf(X, Y, W, :ERG, monetary = true)

    @test effchange(costeffchrddf, :Economic) ≈ [-23.0; 0.0; 0.0; -58.0; -33.0]
    @test effchange(costeffchrddf, :Technical) ≈ [-25.0; 0.0; 0.0; -56.0; -31.0]
    @test effchange(costeffchrddf, :Allocative) ≈ [2.0; 0.0; 0.0; -2.0; -2.0]
    @test costeffchrddf.costmodelbase.normalization ≈ [11.25; 8.0; 4.0; 16.0; 23.625]
    @test costeffchrddf.costmodelcomp.normalization ≈ [90.46153846153847; 48.0; 60.0; 128.0; 109.48]
    show(IOBuffer(), costeffchrddf)

    # General Direct Approach Cost Efficiency Change DEA Model
    costeffchgda = deacostchangegda(X, Y, W, :ERG, monetary = true)

    @test effchange(costeffchgda, :Economic) ≈ [-23.0; 0.0; 0.0; -58.0; -33.0]
    @test effchange(costeffchgda, :Technical) ≈ [-25.0; 0.0; 0.0; -56.0; -31.0]
    @test effchange(costeffchgda, :Allocative) ≈ [2.0; 0.0; 0.0; -2.0; -2.0]
    @test costeffchgda.costmodelbase.normalization ≈ [11.25; 8.0; 4.0; 16.0; 23.625]
    @test costeffchgda.costmodelcomp.normalization ≈ [90.46153846153847; 48.0; 60.0; 128.0; 109.48]
    show(IOBuffer(), costeffchgda)

end
