using Documenter
using DistSSHBase

DocMeta.setdocmeta!(DistSSHBase, :DocTestSetup, :(using DistSSHBase); recursive = true)

makedocs(;
    modules = [DistSSHBase],
    authors = "Takanori Yamamoto, Honoka Ampuku, and contributors",
    sitename = "DistSSHBase.jl",
    format = Documenter.HTML(;
        prettyurls = get(ENV, "CI", nothing) == "true",
        canonical = "https://yamanori99.github.io/DistSSHBase.jl",
        size_threshold_ignore = ["api.md"],
        edit_link = "main",
    ),
    pages = [
        "Introduction" => "index.md",
        "API" => "api.md",
    ],
    checkdocs = :none,
    warnonly = [:missing_docs, :docs_block, :cross_references],
)

deploydocs(;
    repo = "github.com/yamanori99/DistSSHBase.jl.git",
    devbranch = "main",
    push_preview = true,
    versions = ["stable" => "v^", "v#.#", "dev" => "dev"],
)
