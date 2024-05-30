export XRootDStatus, isOK, isError, isFatal
export StatInfo, getFlags, isExecutable, isOffline
export OpenFlags, DirListFlags, QueryCode, Access

const URL = XRootD.XrdCl!URL
const StatInfo = XRootD.XrdCl!StatInfo
const LocationInfo = XRootD.XrdCl!LocationInfo
const Location = XRootD.XrdCl!LocationInfo!Location
const ProtocolInfo = XRootD.XrdCl!ProtocolInfo
const XRootDStatus = XRootD.XrdCl!XRootDStatus
const Status = XRootD.XrdCl!Status


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

module Access
    using XRootD
    const None = XRootD.XrdCl!Access!None
    const UR = XRootD.XrdCl!Access!UR
    const UW = XRootD.XrdCl!Access!UW
    const UX = XRootD.XrdCl!Access!UX
    const GR = XRootD.XrdCl!Access!GR
    const GW = XRootD.XrdCl!Access!GW
    const GX = XRootD.XrdCl!Access!GX
    const OR = XRootD.XrdCl!Access!OR
    const OW = XRootD.XrdCl!Access!OW
    const OX = XRootD.XrdCl!Access!OX
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

module QueryCode
    using XRootD
    const Config = XRootD.XrdCl!QueryCode!Config
    const ChecksumCancel = XRootD.XrdCl!QueryCode!ChecksumCancel
    const Checksum = XRootD.XrdCl!QueryCode!Checksum
    const Opaque = XRootD.XrdCl!QueryCode!Opaque
    const OpaqueFile = XRootD.XrdCl!QueryCode!OpaqueFile
    const Prepare = XRootD.XrdCl!QueryCode!Prepare
    const Space = XRootD.XrdCl!QueryCode!Space
    const Stats = XRootD.XrdCl!QueryCode!Stats
    const Visa = XRootD.XrdCl!QueryCode!Visa
    const XAttr = XRootD.XrdCl!QueryCode!XAttr
end

#---XRootDStatus and Status interface----------------------------------------------------------
Base.show(io::IO, status::XRootDStatus) = print(io, XRootD.ToStr(status))
Base.show(io::IO, status::Status) = print(io, XRootD.ToString(status))
"""
    isOK(status::Status)

Check if the status is OK.
"""
isOK(status::Status) = XRootD.IsOK(status)
"""
    isError(status::Status)

Check if the status is an error.
"""
isError(status::Status) = XRootD.IsError(status)
"""
    isFatal(status::Status)

Check if the status is fatal.
"""
isFatal(status::Status) = XRootD.IsFatal(status)

#---StatInfo interface-------------------------------------------------------------------------
function Base.show(io::IO, s::StatInfo)
    mode = XRootD.GetModeAsOctString(s) |> String
    owner = XRootD.GetOwner(s) |> String
    group = XRootD.GetGroup(s) |> String
    size = XRootD.GetSize(s) |> Int
    date = XRootD.GetModTimeAsString(s)
    print(io, "[$mode $owner $group $size $date]")
end
"""
    getFlags(statinfo::StatInfo)

The flags of the stat info.
"""
getFlags(statinfo::StatInfo) = XRootD.GetFlags(statinfo)
"""
    Base.isdir(statinfo::StatInfo)

Check if the stat info is a directory.
"""
Base.isdir(statinfo::StatInfo) = XRootD.GetFlags(statinfo) & XRootD.XrdCl!StatInfo!IsDir != 0
"""
    Base.isfile(statinfo::StatInfo)

Check if the stat info is a file.
"""
Base.isfile(statinfo::StatInfo) = XRootD.GetFlags(statinfo) & (XRootD.XrdCl!StatInfo!IsDir | XRootD.XrdCl!StatInfo!Other) == 0   
"""
    Base.isreadable(statinfo::StatInfo)

Check if the stat info is readable.
"""
Base.isreadable(statinfo::StatInfo) = XRootD.GetFlags(statinfo) & XRootD.XrdCl!StatInfo!IsReadable != 0
"""
    Base.iswritable(statinfo::StatInfo)

Check if the stat info is writable.
"""
Base.iswritable(statinfo::StatInfo) = XRootD.GetFlags(statinfo) & XRootD.XrdCl!StatInfo!IsWritable != 0
"""
    isExecutable(statinfo::StatInfo)

Check if the stat info is executable.
"""
isExecutable(statinfo::StatInfo) = XRootD.GetFlags(statinfo) & XRootD.XrdCl!StatInfo!XBitSet != 0
"""
    isOffline(statinfo::StatInfo)

Check if the stat info is offline.
"""
isOffline(statinfo::StatInfo) = XRootD.GetFlags(statinfo) & XRootD.XrdCl!StatInfo!Offline != 0
"""
    Base.getproperty(statinfo::StatInfo, prop::Symbol)

Get the property of the stat info.
# Arguments
- `statinfo::StatInfo`: the stat info.
- `prop::Symbol`: the property to get (examples: `:size`, `:owner`, `:group`, `:modtime`, `:flags`, `:octmode`, `:mode`).
"""
function Base.getproperty(statinfo::StatInfo, prop::Symbol)
    if prop == :size
        return XRootD.GetSize(statinfo)
    elseif prop == :owner
        return XRootD.GetOwner(statinfo) |> String
    elseif prop == :group
        return XRootD.GetGroup(statinfo) |> String
    elseif prop == :modtime
        return XRootD.GetModTime(statinfo)
    elseif prop == :modtime_str
        return XRootD.GetModTimeAsString(statinfo)
    elseif prop == :changetime
        return XRootD.GetChangeTime(statinfo)
    elseif prop == :changetime_str
        return XRootD.GetChangeTimeAsString(statinfo)
    elseif prop == :accesstime
        return XRootD.GetAccessTime(statinfo)
    elseif prop == :accesstime_str
        return XRootD.GetAccessTimeAsString(statinfo)
    elseif prop == :flags
        return XRootD.GetFlags(statinfo)
    elseif prop == :octmode
        return XRootD.GetModeAsOctString(statinfo)
    elseif prop == :mode
        return XRootD.GetModeAsString(statinfo) |> String
    else
        return getfield(statinfo, prop)
    end
end

#---LocationInfo interface---------------------------------------------------------------------
function Base.show(io::IO, l::Location)
    address = XRootD.GetAddress(l) |> String
    type = XRootD.GetType(l) |> UInt32
    acct = XRootD.GetAccessType(l) |> UInt32
    manager = XRootD.IsManager(l) |> string
    server = XRootD.IsServer(l) |> string
    print(io, "<type: $type, address: $address, accesstype: $acct, is_manager: $manager, is_server: $server>")
end
"""
    Base.getproperty(l::Location, prop::Symbol)

Get the property of the location.
# Arguments
- `l::Location`: the location.
- `prop::Symbol`: the property to get (examples: `:address`, `:type`, `:accesstype`, `:is_manager`, `:is_server`).
"""
function Base.getproperty(l::Location, prop::Symbol)
    if prop == :address
        return XRootD.GetAddress(l) |> String
    elseif prop == :type
        return XRootD.GetType(l) |> UInt32
    elseif prop == :accesstype
        return XRootD.GetAccessType(l) |> UInt32
    elseif prop == :is_manager
        return XRootD.IsManager(l)
    elseif prop == :is_server
        return XRootD.IsServer(l)
    else
        return getfield(l, prop)
    end
end

#---ProtocolInfo interface---------------------------------------------------------------------
function Base.show(io::IO, p::XRootD.XrdCl!ProtocolInfo)
    info = XRootD.GetHostInfo(p)
    version = XRootD.GetVersion(p)
    print(io, "<hostinfo: $info, version: $version>")
end
"""
    Base.getproperty(p::ProtocolInfo, prop::Symbol)

Get the property of the protocol info.
# Arguments
- `p::ProtocolInfo`: the protocol info.
- `prop::Symbol`: the property to get (examples: `:hostinfo`, `:version`).
"""
function Base.getproperty(p::ProtocolInfo, prop::Symbol)
    if prop == :hostinfo
        return XRootD.GetHostInfo(p)
    elseif prop == :version
        return XRootD.GetVersion(p)
    else
        return getfield(p, prop)
    end
end
