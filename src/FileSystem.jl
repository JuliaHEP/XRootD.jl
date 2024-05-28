#--------------------------------------------------------------------------------------------------
#---FileSystem interface---------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------

export FileSystem, ping, locate, query, rmdir, protocol

const FileSystem = XRootD.XrdCl!FileSystem
 
"""
    FileSystem(url::String, isServer::Bool=false)

Create a FileSystem object.
"""
function FileSystem(url::String, isServer::Bool=false)
    FileSystem(XRootD.XrdCl!URL(url), false)
end

"""
    ping(fs::FileSystem)

Ping the server.    
"""
function ping(fs::FileSystem)
    st = XRootD.Ping(fs)
    return st, nothing
end

"""
    Base.stat(fs::FileSystem, path::String, timeout::UInt16=0x0000)

Get the StatInfo of a file or directory.
"""
function Base.stat(fs::FileSystem, path::String, timeout::UInt16=0x0000)
    statinfo_p = Ref(CxxPtr{StatInfo}(C_NULL))
    st = XRootD.Stat(fs, path, statinfo_p, timeout)
    if isOK(st)
        statinfo = StatInfo(statinfo_p[][]) # copy constructor
        XRootD.delete(statinfo_p[])         # delete the pointer
        return st, statinfo
    else
        return st, nothing
    end
end
"""
    copy(fs::FileSystem, src::String, dest::String; force::Bool=false)

Simple method to copy a file or directory. It uses some default options. For more control use the CopyProcess class.
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
"""
function locate(fs::FileSystem, path::String, flags::XRootD.XrdCl!OpenFlags!Flags, timeout::UInt16=0x0000)
    locations_p = Ref(CxxPtr{LocationInfo}(C_NULL))
    st = XRootD.Locate(fs, path, flags, locations_p, timeout)
    if isOK(st)
        #locations = LocationInfo(locations_p[][]) # copy constructor
        locations = [At(locations_p[], i)[] for i in 0:GetSize(locations_p[])-1]
        XRootD.delete(locations_p[])                   # delete the pointer
        return st, locations
    else
        return st, nothing
    end
end
"""
    Base.rm(fs::FileSystem, path::String, timeout::UInt16=0x0000)

Remove a file or directory.
"""
function Base.rm(fs::FileSystem, path::String, timeout::UInt16=0x0000)
    st = XRootD.Rm(fs, path, timeout)
    return st, nothing
end
"""
    Base.mv(fs::FileSystem, src::String, dest::String, timeout::UInt16=0x0000)

Move or rename a file or directory.
"""
function Base.mv(fs::FileSystem, src::String, dest::String, timeout::UInt16=0x0000)
    st = XRootD.Mv(fs, src, dest, timeout)
    return st, nothing
end
"""
Base.readdir(fs::FileSystem, path::String, flags::XRootD.XrdCl!DirListFlags!Flags=XRootD.XrdCl!DirListFlags!None; join::Bool = false, sort::Bool = false)

List entries in a directory    
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
    query(fs::FileSystem, code::XRootD.XrdCl!QueryCode!Code , arg::String, timeout::UInt16=0x0000)

Query the server.
"""
function query(fs::FileSystem, code::XRootD.XrdCl!QueryCode!Code , arg::String, timeout::UInt16=0x0000)
    buffer_p = Ref(CxxPtr{XRootD.XrdCl!Buffer}(C_NULL))
    arg_b = XRootD.XrdCl!Buffer()
    FromString(arg_b, arg)
    st = XRootD.Query(fs, code, arg_b, buffer_p, timeout)
    if isOK(st)
        response = ToString(buffer_p[][])
        XRootD.delete(buffer_p[])                   # delete the pointer
        return st, response
    else
        return st, nothing
    end
end
"""
    Base.truncate(fs::FileSystem, path::String, size::Int64, timeout::UInt16=0x0000)

Truncate a file to a specified size.
"""
function Base.truncate(fs::FileSystem, path::String, size::Int64, timeout::UInt16=0x0000)
    st = XRootD.Truncate(fs, path, size, timeout)
    return st, nothing
end

"""
    Base.mkdir(fs::FileSystem, path::String, mode::XRootD.XrdCl!Access!Mode=Access.None, timeout::UInt16=0x0000)

Create a directory.
"""
function Base.mkdir(fs::FileSystem, path::String, mode::XRootD.XrdCl!Access!Mode=Access.None, timeout::UInt16=0x0000)
    st = XRootD.MkDir(fs, path, XRootD.XrdCl!MkDirFlags!None, mode, timeout)
    return st, nothing
end

"""
    rmdir(fs::FileSystem, path::String, timeout::UInt16=0x0000)

Remove a directory.
"""
function  rmdir(fs::FileSystem, path::String, timeout::UInt16=0x0000)
    st = XRootD.RmDir(fs, path, timeout)
    return st, nothing
end

"""
    Base.chmod(fs::FileSystem, path::String, mode, timeout::UInt16=0x0000)

Change the mode of a file or directory.
"""
function Base.chmod(fs::FileSystem, path::String, mode, timeout::UInt16=0x0000)
    st = XRootD.ChMod(fs, path, mode, timeout)
    return st, nothing
end

"""
    protocol(fs::FileSystem, timeout::UInt16=0x0000)

Get the protocol information.
"""
function protocol(fs::FileSystem, timeout::UInt16=0x0000)
    protocol_p = Ref(CxxPtr{ProtocolInfo}(C_NULL))
    st = XRootD.Protocol(fs, protocol_p, timeout)
    if isOK(st)
        protocol = ProtocolInfo(GetVersion(protocol_p[][]), GetHostInfo(protocol_p[][])) # constructor
        XRootD.delete(protocol_p[])                   # delete the pointer
        return st, protocol
    else
        return st, nothing
    end
end


