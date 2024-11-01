module XRootD
    using CxxWrap
    using XRootD_jll: xrootd, xrdfs, xrdcp 
    using Libdl

    # Check whether the wrappers have been build locally otherwise use the binary package XRootD_cxxwrap_jll
    gendir = normpath(joinpath(@__DIR__, "../gen"))
    if isdir(joinpath(gendir, "build/lib"))
        include(joinpath(gendir, "jl/src/XRootD-export.jl"))
        @wrapmodule(()->joinpath(gendir, "build/lib", "libXRootDWrap.$(Libdl.dlext)"))
    else
        using XRootD_cxxwrap_jll
        include(XRootD_cxxwrap_jll.XRootD_exports)
        @wrapmodule(()->XRootD_cxxwrap_jll.libXRootDWrap)
    end

    function __init__()
        @initcxx
    end

    # Export XRootD executables (from XRootD_jll)
    export xrootd, xrdfs, xrdcp

    include("XrdCl.jl")

end # module XRootD
