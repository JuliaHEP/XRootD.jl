#--------------------------------------------------------------------------------------------------
#---FileSystem interface---------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------

export FileSystem, ping, locate, query, rmdir, protocol

const FileSystem = XRootD.XrdCl!FileSystem
 
"""
    FileSystem(url::String, isServer::Bool=false)

Creates a FileSystem object. It is a wrapper around the XRootD FileSystem class that is used for sending queries to the XRootD server. 
"""
function FileSystem(url::String, isServer::Bool=false)
    FileSystem(XRootD.XrdCl!URL(url), false)
end

"""
    ping(fs::FileSystem)

Check if the server is alive - sync
# Arguments
- `fs::FileSystem`: The FileSystem object
- `timeout::UInt16`: The timeout in seconds
# Returns
- `Tuple` of:
    - `st::XRootD.XrdCl!Status`: The status of the operation
    - `nothing`: Always    
"""
function ping(fs::FileSystem, timeout::UInt16=0x0000)
    st = XRootD.Ping(fs, timeout)
    return st, nothing
end

"""
    Base.stat(fs::FileSystem, path::String, timeout::UInt16=0x0000)

Gets the StatInfo of a file or directory.
# Arguments
- `fs::FileSystem`: The FileSystem object
- `path::String`: The path of the file or directory
- `timeout::UInt16`: The timeout in seconds
# Returns
- `Tuple` of:
    - `st::XRootD.XrdCl!Status`: The status of the operation
    - `statinfo::StatInfo`: The StatInfo object (or `nothing` if the operation failed) 
"""
function Base.stat(fs::FileSystem, path::String, timeout::UInt16=0x0000)
    statinfo_p = Ref(CxxPtr{StatInfo}(C_NULL))
    st = XRootD.Stat(fs, path, statinfo_p, timeout)
    if isOK(st)
        statinfo = StatInfo(statinfo_p[][])         # copy constructor
        CxxWrap.CxxWrapCore.__delete(statinfo_p[])  # delete the pointer
        return st, statinfo
    else
        return st, nothing
    end
end

"""
    copy(fs::FileSystem, src::String, dest::String; force::Bool=false)

Simple method to copy a file or directory. It uses some default options. For more control use the CopyProcess class.
# Arguments
- `fs::FileSystem`: The FileSystem object
- `src::String`: The source path
- `dest::String`: The destination path
- `force::Bool`: If `true` the destination will be overwritten
# Returns
- `Tuple` of:
    - `st::XRootD.XrdCl!Status`: The status of the operation
    - `results::PropertyList`: The results of the operation (or `nothing` if the operation failed)
"""
function Base.copy(fs::FileSystem, src::String, dest::String; force::Bool=false)
    pl = XRootD.XrdCl!PropertyList()
    XRootD.Set(pl, "source", src)
    XRootD.Set(pl, "target", dest)
    XRootD.Set(pl, "force", force ? "1" : "0")
    
    cp = XRootD.XrdCl!CopyProcess()
    results = XRootD.XrdCl!PropertyList()
    st = AddJob(cp, pl, CxxPtr(results))
    isOK(st) || return st, nothing
    st = Prepare(cp)
    isOK(st) || return st, nothing

    handler = XRootD.XrdCl!CopyProgressHandler()
    st = Run(cp, CxxPtr(handler))
    isOK(st) || return st, nothing
    return st, results
end

"""
    locate(fs::FileSystem, path::String, flags::XRootD.XrdCl!OpenFlags!Flags, timeout::UInt16=0x0000)

Get the locations of a file or directory.
# Arguments
- `fs::FileSystem`: The FileSystem object
- `path::String`: The path of the file or directory
- `flags::XrdCl.OpenFlags`: The flags
- `timeout::UInt16`: The timeout in seconds
# Returns
- `Tuple` of:
    - `st::XRootD.XrdCl!Status`: The status of the operation
    - `locations::Vector{LocationInfo}`: The locations of the file or directory (or `nothing` if the operation failed)
"""
function locate(fs::FileSystem, path::String, flags::XRootD.XrdCl!OpenFlags!Flags, timeout::UInt16=0x0000)
    locations_p = Ref(CxxPtr{LocationInfo}(C_NULL))
    st = XRootD.Locate(fs, path, flags, locations_p, timeout)
    if isOK(st)
        #locations = LocationInfo(locations_p[][]) # copy constructor does not exists :-(
        locations = Location[]
        for i in 0:GetSize(locations_p[])-1
            loc = At(locations_p[], i)
            push!(locations, Location(loc |> GetAddress, loc |> GetType, loc |> GetAccessType))
        end
        CxxWrap.CxxWrapCore.__delete(locations_p[]) # delete the pointer
        return st, locations
    else
        return st, nothing
    end
end

"""
    Base.rm(fs::FileSystem, path::String, timeout::UInt16=0x0000)

Remove a file or directory.
# Arguments
- `fs::FileSystem`: The FileSystem object
- `path::String`: The path of the file or directory
- `timeout::UInt16`: The timeout in seconds
# Returns
- `Tuple` of:
    - `st::XRootD.XrdCl!Status`: The status of the operation
    - `nothing`: Always
"""
function Base.rm(fs::FileSystem, path::String, timeout::UInt16=0x0000)
    st = XRootD.Rm(fs, path, timeout)
    return st, nothing
end

"""
    Base.mv(fs::FileSystem, src::String, dest::String, timeout::UInt16=0x0000)

Move or rename a file or directory.
# Arguments
- `fs::FileSystem`: The FileSystem object
- `src::String`: The source path
- `dest::String`: The destination path
- `timeout::UInt16`: The timeout in seconds
# Returns
- `Tuple` of:
    - `st::XRootD.XrdCl!Status`: The status of the operation
    - `nothing`: Always
"""
function Base.mv(fs::FileSystem, src::String, dest::String, timeout::UInt16=0x0000)
    st = XRootD.Mv(fs, src, dest, timeout)
    return st, nothing
end

"""
Base.readdir(fs::FileSystem, path::String, flags::XRootD.XrdCl!DirListFlags!Flags=XRootD.XrdCl!DirListFlags!None; join::Bool = false, sort::Bool = false)

List entries in a directory.
# Arguments
- `fs::FileSystem`: The FileSystem object
- `path::String`: The path of the directory
- `flags::XrdCl.DirListFlags`: The flags
- `join::Bool`: If `true` the entries will be joined with the path
- `sort::Bool`: If `true` the entries will be sorted
# Returns
- `Tuple` of:
    - `st::XRootD.XrdCl!Status`: The status of the operation
    - `entries::Vector{String}`: The entries in the directory (or `nothing` if the operation failed)
"""
function Base.readdir(fs::FileSystem, path::String, flags::XRootD.XrdCl!DirListFlags!Flags=XRootD.XrdCl!DirListFlags!None; 
                        join::Bool = false, sort::Bool = false)
    entries_p = Ref(CxxPtr{XRootD.XrdCl!DirectoryList}(C_NULL))
    st = XRootD.DirList(fs, path, flags, entries_p)
    if isOK(st)
        entries = [GetName(At(entries_p[], i)) |> String for i in 0:GetSize(entries_p[])-1]
        join && (entries = joinpath.(Ref(path), entries))
        sort && (sort!(entries))
        return st, entries
    else
        return st, nothing
    end
end


"""
Base.walkdir(fs::FileSystem, root::AbstractString; topdown=true)

Walks in a directory tree.
# Arguments
- `fs::FileSystem`: The FileSystem object
- `root::AbstractString`: The path of the directory
- `topdown::Bool`: start from the top of the directory tree
# Returns
- `Tuple` of:
    -  dirpath, dirnames, files : Tuple{String,Vector{String},Vector{String}}
- Throws an exception if the operation fails.
"""
# Example
```julia
for (dirpath, dirnames, filenames) in walkdir(fs, "/tmp")
    println("dirpath: $dirpath")
    println("dirnames: $dirnames")
    println("filenames: $filenames")
end
"""
function Base.walkdir(fs::FileSystem, root::AbstractString; topdown=true)
    function _walkdir(chnl, root)
        dirs = String[]
        files = String[]
        entries_p = Ref(CxxPtr{XRootD.XrdCl!DirectoryList}(C_NULL))
        st = XRootD.DirList(fs, root, XRootD.XrdCl!DirListFlags!Stat, entries_p)
        if !isOK(st)
            try
                throw(ErrorException("$st"))
            catch err
                close(chnl, err)
            end
            return
        end
        for i in 0:GetSize(entries_p[])-1
            entry = At(entries_p[], i)
            name = entry |> GetName |> String
            stat = entry |> GetStatInfo
            if isdir(stat[])
                push!(dirs, name)
            else
                push!(files, name)
            end
        end
        if topdown
            push!(chnl, (root, dirs, files))
        end
        for dir in dirs
            _walkdir(chnl, joinpath(root, dir))
        end
        if !topdown
            push!(chnl, (root, dirs, files))
        end
        nothing
    end
    return Channel{Tuple{String,Vector{String},Vector{String}}}(chnl -> _walkdir(chnl, root))
end

"""
    query(fs::FileSystem, code::XRootD.XrdCl!QueryCode!Code , arg::String, timeout::UInt16=0x0000)

Query the server.
# Arguments
- `fs::FileSystem`: The FileSystem object
- `code::XrdCl.QueryCode`: The query code
- `arg::String`: The argument
- `timeout::UInt16`: The timeout in seconds
# Returns
- `Tuple` of:
    - `st::XRootD.XrdCl!Status`: The status of the operation
    - `response::String`: The response (or `nothing` if the operation failed)
"""
function query(fs::FileSystem, code::XRootD.XrdCl!QueryCode!Code , arg::String, timeout::UInt16=0x0000)
    buffer_p = Ref(CxxPtr{XRootD.XrdCl!Buffer}(C_NULL))
    arg_b = XRootD.XrdCl!Buffer()
    FromString(arg_b, arg)
    st = XRootD.Query(fs, code, arg_b, buffer_p, timeout)
    if isOK(st)
        response = ToString(buffer_p[][])
        CxxWrap.CxxWrapCore.__delete(buffer_p[]) # delete the pointer
        return st, response
    else
        return st, nothing
    end
end

"""
    Base.truncate(fs::FileSystem, path::String, size::Int64, timeout::UInt16=0x0000)

Truncate a file to a specified size.
# Arguments
- `fs::FileSystem`: The FileSystem object
- `path::String`: The path of the file
- `size::Int64`: The new size
- `timeout::UInt16`: The timeout in seconds
# Returns
- `Tuple` of:
    - `st::XRootD.XrdCl!Status`: The status of the operation
    - `nothing`: Always
"""
function Base.truncate(fs::FileSystem, path::String, size::Int64, timeout::UInt16=0x0000)
    st = XRootD.Truncate(fs, path, size, timeout)
    return st, nothing
end

"""
    Base.mkdir(fs::FileSystem, path::String, mode::XRootD.XrdCl!Access!Mode=Access.None, timeout::UInt16=0x0000)

Create a directory.
# Arguments
- `fs::FileSystem`: The FileSystem object
- `path::String`: The path of the directory
- `mode::XrdCl.Access.Mode`: The mode
- `timeout::UInt16`: The timeout in seconds
# Returns
- `Tuple` of:
    - `st::XRootD.XrdCl!Status`: The status of the operation
    - `nothing`: Always
"""
function Base.mkdir(fs::FileSystem, path::String, mode::XRootD.XrdCl!Access!Mode=Access.None, timeout::UInt16=0x0000)
    st = XRootD.MkDir(fs, path, XRootD.XrdCl!MkDirFlags!None, mode, timeout)
    return st, nothing
end

"""
    rmdir(fs::FileSystem, path::String, timeout::UInt16=0x0000)

Remove a directory.
# Arguments
- `fs::FileSystem`: The FileSystem object
- `path::String`: The path of the directory
- `timeout::UInt16`: The timeout in seconds
# Returns
- `Tuple` of:
    - `st::XRootD.XrdCl!Status`: The status of the operation
    - `nothing`: Always
"""
function  rmdir(fs::FileSystem, path::String, timeout::UInt16=0x0000)
    st = XRootD.RmDir(fs, path, timeout)
    return st, nothing
end

"""
    Base.chmod(fs::FileSystem, path::String, mode, timeout::UInt16=0x0000)

Change the mode of a file or directory.
# Arguments
- `fs::FileSystem`: The FileSystem object
- `path::String`: The path of the file or directory
- `mode`: The new mode
- `timeout::UInt16`: The timeout in seconds
# Returns
- `Tuple` of:
    - `st::XRootD.XrdCl!Status`: The status of the operation
    - `nothing`: Always
"""
function Base.chmod(fs::FileSystem, path::String, mode, timeout::UInt16=0x0000)
    st = XRootD.ChMod(fs, path, mode, timeout)
    return st, nothing
end

"""
    protocol(fs::FileSystem, timeout::UInt16=0x0000)

Get the protocol information.
# Arguments
- `fs::FileSystem`: The FileSystem object
- `timeout::UInt16`: The timeout in seconds
# Returns
- `Tuple` of:
    - `st::XRootD.XrdCl!Status`: The status of the operation
    - `protocol::ProtocolInfo`: The protocol information (or `nothing` if the operation failed)
"""
function protocol(fs::FileSystem, timeout::UInt16=0x0000)
    protocol_p = Ref(CxxPtr{ProtocolInfo}(C_NULL))
    st = XRootD.Protocol(fs, protocol_p, timeout)
    if isOK(st)
        protocol = ProtocolInfo(GetVersion(protocol_p[][]), GetHostInfo(protocol_p[][])) # constructor
        CxxWrap.CxxWrapCore.__delete(protocol_p[]) # delete the pointer
        return st, protocol
    else
        return st, nothing
    end
end
