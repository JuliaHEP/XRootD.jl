using Test
using XRootD.XrdCl

@testset "File tests" begin

    open("/tmp/testfile", "w") do f
        write(f, "Hello, world!")
    end
    
    f = File("root://localhost:1094//tmp/nonexisting")
    @test isnothing(f)

    f = File("root://localhost:1094//tmp/testfile")
    st, statinfo = stat(f)
    @test isOK(st)
    @test isfile(statinfo)
    @test statinfo.size == 13

    f = File()
    st, response = open(f, "root://localhost:1094//tmp/new_testfile", OpenFlags.Write|OpenFlags.Delete)
    @test isOK(st)
    st, response = truncate(f, 0)
    @test isOK(st)
    st, statinfo = stat(f)
    @test isOK(st)
    @test isfile(statinfo)
    @test statinfo.size == 0

    # Write data
    data = "XRootD:Hello, world!"
    st, response = write(f, data)
    @test isOK(st)

    # Close the file
    st, response = close(f)

    # Open the file for reading
    f = File("root://localhost:1094//tmp/new_testfile")
    st, statinfo = stat(f)
    @test isOK(st)
    @test isfile(statinfo)
    @test statinfo.size == length(data)

    # Read the data
    st, buffer = read(f, statinfo.size)
    @test isOK(st)
    @test buffer == Vector{UInt8}(data)

    # Close the file
    st, response = close(f)
    @test isOK(st)

    # Write multi-line data
    open("/tmp/testfile3", "w") do f
        write(f, "Hello\nWorld\nFolks!")
    end
    f = File("root://localhost:1094//tmp/testfile3")
    st, statinfo = stat(f)
    @test isOK(st)
    @test isfile(statinfo)
    st, line1 = readline(f)
    @test isOK(st)
    @test line1 == "Hello\n"
    st, line2 = readline(f)
    @test isOK(st)
    @test line2 == "World\n"
    st, line3 = readline(f)
    @test isOK(st)
    @test line3 == "Folks!"
    st, line4 = readline(f)
    @test isOK(st)
    @test isempty(line4)
    @test eof(f)

    # Close the file
    st, response = close(f)
    @test isOK(st)

    st, response = open(f, "root://localhost:1094//tmp/testfile3", OpenFlags.Read)
    @test isOK(st)
    st, lines = readlines(f)
    @test isOK(st)
    @test lines == ["Hello\n", "World\n", "Folks!"]
    


end