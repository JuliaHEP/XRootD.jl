module XrdCl
    using CxxWrap, XRootD

    if XRootD.is_available()
        include("Responses.jl")
        include("FileSystem.jl")
        include("File.jl")
    else
        # Dummy module to delay the error at runtime
        struct File
            File() = error("XRootD binaries are not available for this platform: $(Sys.MACHINE)")
        end
        struct FileSystem
            FileSystem(url, sever=false) = error("XRootD binaries are not available for this platform: $(Sys.MACHINE)")
        end
        export File, FileSystem
    end
end