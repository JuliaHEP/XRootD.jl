using Test
using XRootD.XrdCl

mutable struct Data
    a::Int64
    b::Float64
    c::Int32
    d::Bool
end
Data() = Data(0,0,0,false)
Base.:(==)(x::Data, y::Data) = x.a == y.a && x.b == y.b && x.c == y.c && x.d == y.d

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
    @test isopen(f)
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

    # Read more than the file size
    st, buffer = read(f, statinfo.size + 100)
    @test isOK(st)
    @test length(buffer) == statinfo.size

    # Read with offset
    st, buffer = read(f, 5, 5)
    @test isOK(st)
    @test buffer == Vector{UInt8}("D:Hel")

    # Read beyond the file size
    st, buffer = read(f, 100, 100)
    @test isOK(st)
    @test length(buffer) == 0

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

    # Open the file for reading lines
    st, response = open(f, "root://localhost:1094//tmp/testfile3", OpenFlags.Read)
    @test isOK(st)
    st, lines = readlines(f)
    @test isOK(st)
    @test lines == ["Hello\n", "World\n", "Folks!"]
    st, response = close(f)
    @test isOK(st)
    @test !isopen(f)

    # Create a test binary files
    d1 = Data(1, 2.0, 3, true)
    d2 = Data(4, 5.0, 6, false)
    open("/tmp/testfile4", "w") do io
        unsafe_write(io, pointer_from_objref(d1), sizeof(Data))
        unsafe_write(io, pointer_from_objref(d2), sizeof(Data))
    end

    # open the file and read it with unsafe_read
    f = File("root://localhost:1094//tmp/testfile4", OpenFlags.Read)
    output = Data()
    st, response = unsafe_read(f, pointer_from_objref(output), sizeof(Data))
    @test isOK(st)
    @test output == d1
    st, response = unsafe_read(f, pointer_from_objref(output), sizeof(Data), sizeof(Data))
    @test isOK(st)
    @test output == d2

    close(f)
    rm("/tmp/testfile4")

end