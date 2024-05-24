using Revise
using Test

using XRootD_jll
using XRootD.XrdCl

#---Start the xrootd server-----------------------------------------------------------------------
xrootd_server = run(XRootD_jll.xrootd(); wait=false)
sleep(1)

#=
fs = FileSystem("root://eospublic.cern.ch")
@test ping(fs) |> isOK

st, statinfo = stat(fs, "/eos/experiment/fcc/ee/generation/DelphesEvents/winter2023/IDEA/p8_ee_ZZ_ecm240")

file = File("root://eospublic.cern.ch//eos/experiment/fcc/ee/generation/DelphesEvents/winter2023/IDEA/p8_ee_ZZ_ecm240/events_000189367.root")
st, statinfo = stat(file)
=#


@testset "XRootD tests" verbose = true begin
    fs = FileSystem("root://localhost:1094")
    @test ping(fs) |> isOK

    st, statinfo = stat(fs, "/tmp")
    @test isOK(st)
    @test isdir(statinfo)

    st, statinfo = stat(fs, "/tmp/doesnotexist")
    @test !isOK(st)

    open("/tmp/testfile", "w") do f
        write(f, "Hello, world!")
    end
    st, statinfo = stat(fs, "/tmp/testfile")
    @test isOK(st)
    st, result = copy(fs, "/tmp/testfile", "/tmp/testfile2", force=true)
    @test isOK(st)
    @test isfile("/tmp/testfile2")

    st , locations = locate(fs, "/tmp", OpenFlags.Refresh)
    @test isOK(st)
    @test length(locations) > 0

    st, result = rm(fs, "/tmp/testfile2")
    @test isOK(st)
    @test !isfile("/tmp/testfile2")

    st, result = mv(fs, "/tmp/testfile", "/tmp/testfile2")
    @test isOK(st)
    @test isfile("/tmp/testfile2")
    @test !isfile("/tmp/testfile")
    
    # DirectoryList
    st, entries = readdir(fs, "/tmp")
    @test isOK(st)
    @test length(entries) > 0

end

#---Stop the xrootd server------------------------------------------------------------------------
kill(xrootd_server)


