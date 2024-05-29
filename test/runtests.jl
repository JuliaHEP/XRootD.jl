using Test
using XRootD.XrdCl
import XRootD

#---Start the xrootd server-----------------------------------------------------------------------
xrootd_server = run(XRootD.xrootd(); wait=false)
sleep(1)

#---Test the XRootD.jl package---------------------------------------------------------------------
@testset "XRootD tests" verbose = true begin
    include("testFileSystem.jl")
    include("testFile.jl")
end

#---Stop the xrootd server------------------------------------------------------------------------
kill(xrootd_server)


