using Documenter, BenchmarkingEconomicEfficiency

makedocs(sitename = "BenchmarkingEconomicEfficiency",
        authors = "Javier Barbero and José Luis Zofío.",
        pages = [
        "Home" => "index.md",
        "Cost Models" => Any[
                "Cost Directional Distance Function model" => "cost/costddf.md",
                "Cost Additive model" => "cost/costadditive.md",
                "Cost Russell model" => "cost/costrussell.md",
                "Cost Hölder model" => "cost/costholder.md",
                "Cost Reverse Directional Distance Function model" => "cost/costrddf.md"
                ],
        "Revenue Models" => Any[
                "Revenue Directional Distance Function model" => "revenue/revenueddf.md",
                "Revenue Additive model" => "revenue/revenueadditive.md",
                "Revenue Russell model" => "revenue/revenuerussell.md",
                "Revenue Hölder model" => "revenue/revenueholder.md",
                "Revenue Reverse Directional Distance Function model" => "revenue/revenuerddf.md"
                ],
        "Profit Models" => [
                "Profit Additive model" => "profit/profitadditive.md",
                "Profit Russell model" => "profit/profitrussell.md",
                "Profit Enhanced Russell Graph Slack Based Measure" => "profit/profitenhancedrussell.md",
                "Profit Modified Directional Distance Function model" => "profit/profitmodifiedddf.md",
                "Profit Hölder model" => "profit/profitholder.md"
                ],
        "Configuring Optimizer" => "optimizer.md",
        ],
        format = Documenter.HTML(prettyurls = get(ENV, "CI", nothing) == "true")
)

deploydocs(
    repo = "github.com/javierbarbero/BenchmarkingEconomicEfficiency.jl.git",
    devbranch = "main"
)


