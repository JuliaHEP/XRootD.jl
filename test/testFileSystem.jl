using Test
using XRootD.XrdCl

@testset "FileSystem tests" begin
    fs = FileSystem("root://localhost:1094")
    st, response = ping(fs)
    @test st |> isOK

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
    @test isfile(statinfo)

    show(devnull, statinfo) # test the show method

    st, result = copy(fs, "/tmp/testfile", "/tmp/testfile2", force=true)
    @test isOK(st)
    @test isfile("/tmp/testfile2")  # Check if the file was copied

    # test stat of newly copied file
    st, statinfo2 = stat(fs, "/tmp/testfile2")
    isOK(st)
    isfile(statinfo2)
    @test statinfo.size == 13
    @test isreadable(statinfo2)
    @test iswritable(statinfo2)
    @test !isdir(statinfo2)
    @test !isExecutable(statinfo2)
    @test !isOffline(statinfo2)
    @test statinfo2.owner == statinfo.owner
    @test statinfo2.group == statinfo.group
    @test statinfo2.modtime == statinfo.modtime
    @test statinfo2.flags == statinfo.flags
    @test statinfo2.octmode[1:3] == statinfo.octmode[1:3]  # owner permissions the same


    # Locate
    st , locations = locate(fs, "/tmp", OpenFlags.Refresh)
    @test isOK(st)
    @test length(locations) > 0

    show(devnull, locations[1]) # test the show method

    # Remove
    st, result = rm(fs, "/tmp/testfile2")
    @test isOK(st)
    @test !isfile("/tmp/testfile2")

    # Move
    st, result = mv(fs, "/tmp/testfile", "/tmp/testfile2")
    @test isOK(st)
    @test isfile("/tmp/testfile2")
    @test !isfile("/tmp/testfile")
    
    # DirectoryList
    st, entries = readdir(fs, "/tmp")
    @test isOK(st)
    @test length(entries) > 0

    # Query
    st, response = query(fs, QueryCode.Stats, "/tmp")
    @test isOK(st)
    st, response = query(fs, QueryCode.Space, "/tmp")
    @test isOK(st)

    # Truncate
    st, result = truncate(fs, "/tmp/testfile2", 5)
    @test isOK(st)
    st, statinfo = stat(fs, "/tmp/testfile2")
    @test isOK(st)
    @test statinfo.size == 5

    # Make dir
    st, result = mkdir(fs, "/tmp/somedir")
    @test isOK(st)
    @test isnothing(result)
    st, statinfo = stat(fs, "/tmp/somedir")
    @test isOK(st)
    @test isdir(statinfo)
    st, result = mkdir(fs, "/tmp/some/dir")
    @test !isOK(st)

    # Remove dir
    st, result = rmdir(fs, "/tmp/somedir")
    @test isOK(st)
    @test isnothing(result)
    st, statinfo = stat(fs, "/tmp/somedir")
    @test !isOK(st)

    # Change mode
    st, result = stat(fs, "/tmp/testfile2")
    @test isOK(st)
    @test result.octmode == "rw-r--r--"

    st, result = chmod(fs, "/tmp/testfile2", 0o775)
    @test isOK(st)
    @test isnothing(result)

    st, statinfo = stat(fs, "/tmp/testfile2")
    @test statinfo.mode == "0775"
    @test statinfo.octmode == "rwxrwxr-x"

    st, result = chmod(fs, "/tmp/testfile2", Access.UR|Access.UW)
    @test isOK(st)
    st, statinfo = stat(fs, "/tmp/testfile2")
    @test statinfo.mode == "0600"
    @test statinfo.octmode == "rw-------"

    # Get protocol
    st, protocolinfo = protocol(fs)
    @test isOK(st)
    show(devnull, protocolinfo) # test the show method

end

