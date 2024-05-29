#---File interface-------------------------------------------------------------------------------
export File

mutable struct File
    file::XRootD.XrdCl!File
    currentOffset::UInt64
    filesize::UInt64
end
File() = File(XRootD.XrdCl!File(), 0, 0)
    
"""
    File(url::String, flags=0x0000, mode=0x0000)

Create a File object and to open it.
# Arguments
- `url::String`: the URL of the file.
- `flags::Int`: the flags to open the file (examples: OpenFlags.Read, OpenFlags.Write, OpenFlags.Delete).
- `mode::Int`: the mode to open the file (examples: Access.UR, Access.UW).
# Returns
- `File`: the File object (if the file is opened successfully) or `nothing`.
"""
function File(url::String, flags=0x0000, mode=0x0000)
    file = XRootD.XrdCl!File()
    st = XRootD.Open(file, url, flags, mode)
    if isOK(st)
        f = File(file, 0, 0)
        f.filesize = stat(f)[2].size
        return f
    else
        return nothing
    end
end

"""
    Base.isopen(f::File)

Check if the file is open.
# Arguments
- `f::File`: the File object.
# Returns
- `Bool`: `true` if the file is open, `false` otherwise.
"""
function Base.isopen(f::File)
    XRootD.IsOpen(f.file)
end

"""
    Base.open(f::File, url::String, flags=0x0000, mode=0x0000)

Open a file.
# Arguments
- `f::File`: the File object.
- `url::String`: the URL of the file.
- `flags::Int`: the flags to open the file (examples: OpenFlags.Read, OpenFlags.Write, OpenFlags.Delete).
- `mode::Int`: the mode to open the file (examples: Access.UR, Access.UW).
# Returns
- `Tuple` of:
    - `XRootDStatus`: the status of the operation.
    - `nothing`
"""
function Base.open(f::File, url::String, flags=0x0000, mode=0x0000)
    st = Open(f.file, url, flags, mode)
    if isOK(st)
        f.filesize = stat(f)[2].size
    end
    return st, nothing
end

"""
    Base.close(f::File)

Close the file.
# Arguments
- `f::File`: the File object.
# Returns
- `Tuple` of:
    - `XRootDStatus`: the status of the operation.
    - `nothing`
"""
function Base.close(f::File)
    st = Close(f.file)
    f.currentOffset = 0
    f.filesize = 0
    return st, nothing
end

"""
    Base.stat(f::File, force::Bool=true)

Stat the file.
# Arguments
- `f::File`: the File object.
- `force::Bool`: force the stat operation.
# Returns
- `Tuple` of:
    - `XRootDStatus`: the status of the operation.
    - `StatInfo`: the stat information (or `nothing` if the operation failed).
"""
function Base.stat(f::File, force::Bool=true)
    statinfo_p = Ref(CxxPtr{StatInfo}(C_NULL))
    st = XRootD.Stat(f.file, force, statinfo_p)
    if isOK(st)
        statinfo = StatInfo(statinfo_p[][]) # copy constructor
        XRootD.delete(statinfo_p[])         # delete the pointer
        return st, statinfo
    else
        return st, nothing
    end
end

"""
    Base.eof(f::File)

Check if the file is at the end.
# Arguments
- `f::File`: the File object.
# Returns
- `Bool`: `true` if the file is at the end, `false` otherwise.
"""
function Base.eof(f::File)
    return f.currentOffset >= f.filesize
end

"""
    Base.truncate(f::File, size::Int64)

Truncate the file.
# Arguments
- `f::File`: the File object.
- `size::Int64`: the size to truncate the file.
# Returns
- `Tuple` of:
    - `XRootDStatus`: the status of the operation.
    - `nothing`
"""
function Base.truncate(f::File, size::Int64)
    st = Truncate(f.file, size)
    return st, nothing
end

"""
    Base.write(f::File, data::Array{UInt8}, size, offset=0)

Write data to the file.
# Arguments
- `f::File`: the File object.
- `data::Array{UInt8}`: the data to write.
- `size::Int`: the size of the data to be writen.
- `offset::Int`: the offset to write the data.
# Returns
- `Tuple` of:
    - `XRootDStatus`: the status of the operation.
    - `nothing`
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
# Arguments
- `f::File`: the File object.
- `size::Int`: the size of the data to read.
- `offset::Int`: the offset to read the data.
# Returns
- `Tuple` of:
    - `XRootDStatus`: the status of the operation.
    - `Array{UInt8}`: the data read (or `nothing` if the operation failed).

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

"""
    Base.readline(f::File, size=0, offset=0, chunk=0)

read one line from the file until it finds a linefeed (\n) or reaches the end of the file.
# Arguments
- `f::File`: the File object.
- `size::Int`: the maximum size of the line to read.
- `offset::Int`: the offset in the file (0 indicates to continue reading from previous position).
- `chunk::Int`: the size of the chunk to read (0 indicates 2MB).
# Returns
- `Tuple` of:
    - `XRootDStatus`: the status of the operation.
    - `String`: the line read (or `nothing` if the operation failed).
"""
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
    while offset < off_end
        readsize = Ref{UInt32}(0)
        st = Read(f.file, UInt64(offset), UInt32(chunk), buffer_p, readsize)
        isError(st) && break
        readsize[] == 0 && break
        offset += readsize[]
        nl = findfirst(isequal(0x0A), buffer[1:readsize[]])
        if isnothing(nl)
            line *= String(buffer[1:readsize[]])
        else
            line *= String(buffer[1:nl])
            offset = off_end
        end
    end
    f.currentOffset += Base.length(line)
    return st, line
end

"""
    Base.readlines(f::File, size=0, offset=0, chunk=0)

readlines reads lines from the file.
# Arguments
- `f::File`: the File object.
- `size::Int`: the maximum size of the lines to read.
- `offset::Int`: the offset in the file (0 indicates to continue reading from previous position).
- `chunk::Int`: the size of the chunk to read (0 indicates 2MB).
# Returns
- `Tuple` of:
    - `XRootDStatus`: the status of the operation.
    - `Array{String}`: the lines read (or `nothing` if the operation failed).
"""
function Base.readlines(f::File, size=0, offset=0, chunk=0)
    lines = String[]
    st = XRootDStatus()
    offset != 0 && (f.currentOffset = offset)
    while !eof(f)
        st, line = readline(f, size, 0, chunk)
        isError(st) && break
        push!(lines, line)
    end
    return st, lines
end
