module XrdCl
    using CxxWrap, XRootD
    include("Responses.jl")
    include("FileSystem.jl")
    include("File.jl")
end