using Documenter, BenchmarkingEconomicEfficiency

makedocs(sitename = "BenchmarkingEconomicEfficiency",
        authors = "Javier Barbero and José Luis Zofío.",
        pages = [
        "Home" => "index.md",
        "Cost Models" => Any[
                "Cost Directional Distance Function model" => "cost/costddf.md",
                "Cost Additive model" => "cost/costadditive.md"
                ],
        "Revenue Models" => Any[
                "Revenue Directional Distance Function model" => "revenue/revenueddf.md"
                ],
        "Configuring Optimizer" => "optimizer.md",
        ],
        format = Documenter.HTML(prettyurls = get(ENV, "CI", nothing) == "true")
)

deploydocs(
    repo = "github.com/javierbarbero/BenchmarkingEconomicEfficiency.jl.git",
    devbranch = "main"
)


