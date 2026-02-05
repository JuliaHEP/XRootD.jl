module XRootD
    using CxxWrap
    using Libdl
    using XRootD_jll
    import Base: Set

    is_available() = XRootD_jll.is_available()

    if is_available()
        # Check whether the wrappers have been build locally otherwise use the binary package XRootD_cxxwrap_jll
        gendir = normpath(joinpath(@__DIR__, "../gen"))
        if isdir(joinpath(gendir, "build/lib"))
            include(joinpath(gendir, "jl/src/XRootD-export.jl"))
            println("Using local XRootD wrapper code from: $gendir")
            @wrapmodule(()->joinpath(gendir, "build/lib", "libXRootDWrap.$(Libdl.dlext)"))
        else
            using XRootD_cxxwrap_jll
            if XRootD_cxxwrap_jll.is_available()
                include(XRootD_cxxwrap_jll.XRootD_exports)
                @wrapmodule(()->XRootD_cxxwrap_jll.libXRootDWrap)
            else
                error("XRootD binaries not available for $(Sys.KERNEL) $(Sys.ARCH) and Julia version $(VERSION).")
            end
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
