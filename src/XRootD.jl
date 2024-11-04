module XRootD
    using CxxWrap
    using Libdl
    using XRootD_jll

    is_available() = XRootD_jll.is_available()

    if is_available()
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

        # export XRootD executables (from XRootD_jll)
        using XRootD_jll: xrootd, xrdfs, xrdcp 
        export xrootd, xrdfs, xrdcp
    end

    include("XrdCl.jl")

end # module XRootD
