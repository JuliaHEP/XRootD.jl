#---File interface-------------------------------------------------------------------------------
export File

mutable struct File
    file::XRootD.XrdCl!File
    currentOffset::UInt64
end
File() = File(XRootD.XrdCl!File(), 0)
    
"""
    File(url::String, flags::UInt16=0x0000, mode::UInt16=0x0000)

File crates a File object and opens it.
"""
function File(url::String, flags::UInt16=0x0000, mode::UInt16=0x0000)
    file = XRootD.XrdCl!File()
    st = XRootD.Open(file, url, flags, mode)
    return isOK(st) ? File(file,0) : nothing
end

"""
    Base.isopen(f::File)

Check if the file is open.
"""
function Base.isopen(f::File)
    XRootD.IsOpen(f.file)
end

"""
    Base.open(f::File, url::String, flags=0x0000, mode=0x0000)

Open a file.
"""
function Base.open(f::File, url::String, flags=0x0000, mode=0x0000)
    st = Open(f.file, url, flags, mode)
    return st, nothing
end

"""
    Base.close(f::File)

Close the file.
"""
function Base.close(f::File)
    st = Close(f.file)
    return st, nothing
end

"""
    Base.stat(f::File, force::Bool=true)

Stat the file.
"""
function Base.stat(f::File, force::Bool=true)
    statinfo_p = Ref(CxxPtr{StatInfo}(C_NULL))
    st = XRootD.Stat(f.file, force, statinfo_p)
    if isOK(st)
        statinfo = StatInfo(statinfo_p[][]) # copy constructor
        # delete(statinfo_p[])              # delete the pointer
        return st, statinfo
    else
        return st, nothing
    end
end

"""
    Base.truncate(f::File, size::Int64)

Truncate the file.
"""
function Base.truncate(f::File, size::Int64)
    st = Truncate(f.file, size)
    return st, nothing
end

"""
    Base.write(f::File, data::Array{UInt8}, size, offset=0)

Write data to the file.
"""
function Base.write(f::File, data::Array{UInt8}, size, offset=0)
    data_p = convert(Ptr{Nothing}, pointer(data))
    st = Write(f.file, UInt64(offset), UInt32(size), data_p)
    return st, nothing
end
Base.write(f::File, data::String, offset=0) = Base.write(f, Vector{UInt8}(data), Base.length(data), offset)

"""
    Base.read(f::File, size, offset=0)

Read data from the file.
"""
function Base.read(f::File, size, offset=0)
    buffer = Array{UInt8}(undef, size)
    buffer_p = convert(Ptr{Nothing}, pointer(buffer))
    readsize = Ref{UInt32}(0)
    if offset == 0
        offset = f.currentOffset
    else
        f.currentOffset = offset
    end
    st = Read(f.file, UInt64(offset), UInt32(size), buffer_p, readsize)
    if isOK(st)
        return st, buffer[1:readsize[]]
    else
        return st, nothing
    end
end

function Base.readline(f::File, size=0, offset=0, chunk=0)
    if offset == 0
        offset = f.currentOffset
    else
        f.currentOffset = offset
    end
    chunk == 0 && (chunk = 1024 * 1024 * 2)  # 2MB
    size == 0 && (size = typemax(UInt32))
    size < chunk && (chunk = size)
    off_end = offset + size
    buffer = Array{UInt8}(undef, chunk)
    buffer_p = convert(Ptr{Nothing}, pointer(buffer))
    line = ""
    st = XRootDStatus(0x0001)
    @show 1, st  
    while offset < off_end
        readsize = Ref{UInt32}(0)
        st = Read(f.file, UInt64(offset), UInt32(chunk), buffer_p, readsize)
        if isError(st) || readsize[] == 0
            @show 2, st 
            break
        end
        offset += readsize[]
        nl = findfirst(isequal(0x0A), buffer[1:readsize[]])
        if isnothing(nl)
            line *= String(buffer[1:readsize[]])
        else
            line *= String(buffer[1:nl])
            offset = off_end
        end
    end
    @show 3, st, line 
    f.currentOffset += Base.length(line)
    return st, line
end
