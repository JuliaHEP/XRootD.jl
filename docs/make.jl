using Documenter
using XRootD
using XRootD.XrdCl

makedocs(;
    modules=[XRootD, XRootD.XrdCl],
    format = Documenter.HTML(
        prettyurls = Base.get(ENV, "CI", nothing) == "true",
        repolink="https://github.com/JuliaHEP/XRootD.jl",
    ),
    pages=[
        "Introduction" => "index.md",
        "Public APIs" => "api.md",
        "Release Notes" => "release_notes.md",
    ],
    checkdocs=:exports,
    repo="https://github.com/JuliaHEP/XRootD.jl/blob/{commit}{path}#L{line}",
    sitename="XRootD.jl",
    authors="Pere Mato",
)

deploydocs(;
    repo="github.com/JuliaHEP/XRootD.jl",
    push_preview = true
)
