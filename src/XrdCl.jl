module XrdCl

export FileSystem, ping, locate, query, rmdir, protocol
    using CxxWrap, XRootD

    include("Responses.jl")
    include("FileSystem.jl")
    include("File.jl")

end