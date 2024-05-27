using Revise
using Test

using XRootD_jll
using XRootD.XrdCl

#---Start the xrootd server-----------------------------------------------------------------------
xrootd_server = run(XRootD_jll.xrootd(); wait=false)
sleep(1)

@testset "XRootD tests" verbose = true begin
    include("testFileSystem.jl")
    include("testFile.jl")
end

#---Stop the xrootd server------------------------------------------------------------------------
kill(xrootd_server)


