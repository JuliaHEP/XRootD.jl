using CxxWrap
using XRootD_jll

#---Build the wrapper library----------------------------------------------------------------------
builddir = joinpath(@__DIR__, "build")
sourcedir = @__DIR__
cd(@__DIR__)
mkpath(builddir)
cd(builddir)

if Sys.isapple()
    ENV["SDKROOT"]=readchomp(`xcrun --sdk macosx --show-sdk-path`)
end

cxxwrap_prefix = CxxWrap.prefix_path()
xrootd_prefix = XRootD_jll.artifact_dir

run(`cmake -DCMAKE_BUILD_TYPE=Release
           -DCMAKE_CXX_STANDARD=17
           -DCMAKE_PREFIX_PATH=$cxxwrap_prefix\;$xrootd_prefix  $sourcedir
           -DCxxWrap_VERSION=$(pkgversion(CxxWrap))`)
run(`cmake --build . --config Release --parallel 8`)
