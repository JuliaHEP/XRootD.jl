module XrdCl

    export XRootDStatus, isOK, isError, isFatal
    export FileSystem, ping, locate
    export File
    export StatInfo, getFlags, isExecutable, isOffline
    export OpenFlags, DirListFlags

    using CxxWrap, XRootD

    const FileSystem = XRootD.XrdCl!FileSystem
    const File = XRootD.XrdCl!File
    const URL = XRootD.XrdCl!URL
    const StatInfo = XRootD.XrdCl!StatInfo
    const LocationInfo = XRootD.XrdCl!LocationInfo
    const XRootDStatus = XRootD.XrdCl!XRootDStatus

    module OpenFlags
        using XRootD
        const None = XRootD.XrdCl!OpenFlags!None
        const New = XRootD.XrdCl!OpenFlags!New
        const Read = XRootD.XrdCl!OpenFlags!Read
        const Write = XRootD.XrdCl!OpenFlags!Write
        const Update = XRootD.XrdCl!OpenFlags!Update
        const Delete = XRootD.XrdCl!OpenFlags!Delete
        const Compress = XRootD.XrdCl!OpenFlags!Compress
        const Force = XRootD.XrdCl!OpenFlags!Force
        const IntentDirList = XRootD.XrdCl!OpenFlags!IntentDirList
        const MakePath = XRootD.XrdCl!OpenFlags!MakePath
        const NoWait = XRootD.XrdCl!OpenFlags!NoWait
        const POSC = XRootD.XrdCl!OpenFlags!POSC
        const PrefName = XRootD.XrdCl!OpenFlags!PrefName
        const Refresh = XRootD.XrdCl!OpenFlags!Refresh
        const Replica = XRootD.XrdCl!OpenFlags!Replica
        const SeqIO = XRootD.XrdCl!OpenFlags!SeqIO
    end

    module DirListFlags
        using XRootD
        const Chunked =  XRootD.XrdCl!DirListFlags!Chunked
        const Cksm = XRootD.XrdCl!DirListFlags!Cksm
        const Locate = XRootD.XrdCl!DirListFlags!Locate
        const Merge = XRootD.XrdCl!DirListFlags!Merge
        const None = XRootD.XrdCl!DirListFlags!None
        const Recursive = XRootD.XrdCl!DirListFlags!Recursive
        const Stat = XRootD.XrdCl!DirListFlags!Stat
        const Zip = XRootD.XrdCl!DirListFlags!Zip
    end

    #---XRootDStatus interface---------------------------------------------------------------------
    Base.show(io::IO, status::XRootDStatus) = print(io, XRootD.ToStr(status))
    isOK(status::XRootDStatus) = XRootD.IsOK(status)
    isError(status::XRootDStatus) = XRootD.IsError(status)
    isFatal(status::XRootDStatus) = XRootD.IsFatal(status)

    #---StatInfo interface-------------------------------------------------------------------------
    function Base.show(io::IO, s::StatInfo)
        d = isdir(s) ? "d" : "-"
        w = iswritable(s) ? "w" : "-"
        r = isreadable(s) ? "r" : "-"
        x = isExecutable(s) ? "x" : "-"
        o = isOffline(s) ? "o" : "-"
        owner = XRootD.GetOwner(s) |> String
        group = XRootD.GetGroup(s) |> String
        size = XRootD.GetSize(s) |> Int
        date = XRootD.GetModTimeAsString(s)
        print(io, "[$d$w$r$x$o $owner $group $size $date]")
    end
    getFlags(statinfo::StatInfo) = XRootD.GetFlags(statinfo)
    Base.isdir(statinfo::StatInfo) = XRootD.GetFlags(statinfo) & XRootD.XrdCl!StatInfo!IsDir != 0   
    Base.isreadable(statinfo::StatInfo) = XRootD.GetFlags(statinfo) & XRootD.XrdCl!StatInfo!IsReadable != 0
    Base.iswritable(statinfo::StatInfo) = XRootD.GetFlags(statinfo) & XRootD.XrdCl!StatInfo!IsWritable != 0
    isExecutable(statinfo::StatInfo) = XRootD.GetFlags(statinfo) & XRootD.XrdCl!StatInfo!XBitSet != 0
    isOffline(statinfo::StatInfo) = XRootD.GetFlags(statinfo) & XRootD.XrdCl!StatInfo!Offline != 0

    #---LocationInfo interface---------------------------------------------------------------------
    function Base.show(io::IO, l::XRootD.XrdCl!LocationInfo!Location)
        address = XRootD.GetAddress(l) |> String
        type = XRootD.GetType(l) |> UInt32
        acct = XRootD.GetAccessType(l) |> UInt32
        manager = XRootD.IsManager(l) |> string
        server = XRootD.IsServer(l) |> string
        print(io, "<type: $type, address: $address, accesstype: $acct, is_manager: $manager, is_server: $server>")
    end

    #---FileSystem interface------------------------------------------------------------------------    
    FileSystem(url::String) = FileSystem(URL(url), false)
    FileSystem(url::String, isServer::Bool) = FileSystem(XRootD.XrdCl!URL(url), isServer)
    ping(fs::FileSystem) = XRootD.Ping(fs)
    """
        Base.stat(fs::FileSystem, path::String, timeout::UInt16=0x0000)

    Get the StatInfo of a file or directory.
    """
    function Base.stat(fs::FileSystem, path::String, timeout::UInt16=0x0000)
        statinfo_p = Ref(CxxPtr{StatInfo}(C_NULL))
        st = XRootD.Stat(fs, path, statinfo_p, timeout)
        if isOK(st)
            statinfo = StatInfo(statinfo_p[][]) # copy constructor
            # delete(statinfo_p[])              # delete the pointer
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
            # delete(locations_p[])                   # delete the pointer
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

    Move a file or directory.
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

    #---File interface-------------------------------------------------------------------------------
    function File(url::String, flags::UInt16=0x0000, mode::UInt16=0x0000, timeout::UInt16=0x0000)
        file = File()
        st = XRootD.Open(file, url, flags, mode, timeout)
        return isOK(st) ? file : nothing
    end
    function Base.stat(f::File, force::Bool=true, timeout::UInt16=0x0000)
        statinfo_p = Ref(CxxPtr{StatInfo}(C_NULL))
        st = XRootD.Stat(f, force, statinfo_p, timeout)
        if isOK(st)
            statinfo = StatInfo(statinfo_p[][]) # copy constructor
            # delete(statinfo_p[])              # delete the pointer
            return st, statinfo
        else
            return st, nothing
        end
    end
end