var documenterSearchIndex = {"docs":
[{"location":"release_notes/#Release-Notes","page":"Release Notes","title":"Release Notes","text":"","category":"section"},{"location":"release_notes/#0.2.2-(11-12-2024)","page":"Release Notes","title":"0.2.2 (11-12-2024)","text":"","category":"section"},{"location":"release_notes/","page":"Release Notes","title":"Release Notes","text":"Added function walkdir to walk on a directory tree","category":"page"},{"location":"release_notes/#0.2.1-(4-11-2024)","page":"Release Notes","title":"0.2.1 (4-11-2024)","text":"","category":"section"},{"location":"release_notes/","page":"Release Notes","title":"Release Notes","text":"Added some protection to avoid pre-compilation errors in case the XRootD binary artifacts do not exist (e.g. Windows platform)","category":"page"},{"location":"release_notes/#0.2.0-(31-10-2024)","page":"Release Notes","title":"0.2.0 (31-10-2024)","text":"","category":"section"},{"location":"release_notes/","page":"Release Notes","title":"Release Notes","text":"Updated to XRootD 5.7.1, OpenSLL 3.0.15 and CxxWrap 0.16 (with libcxxwrapjuliajll 0.13.2)","category":"page"},{"location":"release_notes/#0.1.0-(31-05-2024)","page":"Release Notes","title":"0.1.0 (31-05-2024)","text":"","category":"section"},{"location":"release_notes/","page":"Release Notes","title":"Release Notes","text":"First release. It provides similar functionality as for the python bindings of the client library of XRootD","category":"page"},{"location":"api/#Public-Documentation","page":"Public APIs","title":"Public Documentation","text":"","category":"section"},{"location":"api/","page":"Public APIs","title":"Public APIs","text":"Documentation for XRootD.jl public interface.","category":"page"},{"location":"api/","page":"Public APIs","title":"Public APIs","text":"","category":"page"},{"location":"api/#Index","page":"Public APIs","title":"Index","text":"","category":"section"},{"location":"api/","page":"Public APIs","title":"Public APIs","text":"Modules = [XRootD, XRootD.XrdCl, Base, Base.Filesystem]\nOrder   = [:type]","category":"page"},{"location":"api/","page":"Public APIs","title":"Public APIs","text":"Modules = [XRootD, XRootD.XrdCl, Base, Base.Filesystem]\nOrder   = [:function]","category":"page"},{"location":"api/","page":"Public APIs","title":"Public APIs","text":"","category":"page"},{"location":"api/#Types","page":"Public APIs","title":"Types","text":"","category":"section"},{"location":"api/","page":"Public APIs","title":"Public APIs","text":"This is the list of all types and functions defined for XRootD","category":"page"},{"location":"api/","page":"Public APIs","title":"Public APIs","text":"Modules = [XRootD, XRootD.XrdCl]\nOrder = [:type]","category":"page"},{"location":"api/#XRootD.XrdCl.File","page":"Public APIs","title":"XRootD.XrdCl.File","text":"File(url::String, flags=0x0000, mode=0x0000)\n\nCreate a File object and to open it.\n\nArguments\n\nurl::String: the URL of the file.\nflags::Int: the flags to open the file (examples: OpenFlags.Read, OpenFlags.Write, OpenFlags.Delete).\nmode::Int: the mode to open the file (examples: Access.UR, Access.UW).\n\nReturns\n\nFile: the File object (if the file is opened successfully) or nothing.\n\n\n\n\n\n","category":"type"},{"location":"api/#XRootD.XrdCl.FileSystem","page":"Public APIs","title":"XRootD.XrdCl.FileSystem","text":"FileSystem(url::String, isServer::Bool=false)\n\nCreates a FileSystem object. It is a wrapper around the XRootD FileSystem class that is used for sending queries to the XRootD server. \n\n\n\n\n\n","category":"type"},{"location":"api/#Functions","page":"Public APIs","title":"Functions","text":"","category":"section"},{"location":"api/","page":"Public APIs","title":"Public APIs","text":"Modules = [XRootD, XRootD.XrdCl]\nOrder = [:function]","category":"page"},{"location":"api/#Base.Filesystem.chmod","page":"Public APIs","title":"Base.Filesystem.chmod","text":"Base.chmod(fs::FileSystem, path::String, mode, timeout::UInt16=0x0000)\n\nChange the mode of a file or directory.\n\nArguments\n\nfs::FileSystem: The FileSystem object\npath::String: The path of the file or directory\nmode: The new mode\ntimeout::UInt16: The timeout in seconds\n\nReturns\n\nTuple of:\nst::XRootD.XrdCl!Status: The status of the operation\nnothing: Always\n\n\n\n\n\n","category":"function"},{"location":"api/#Base.Filesystem.isdir-Tuple{XrdCl!StatInfo}","page":"Public APIs","title":"Base.Filesystem.isdir","text":"Base.isdir(statinfo::StatInfo)\n\nCheck if the stat info is a directory.\n\n\n\n\n\n","category":"method"},{"location":"api/#Base.Filesystem.isfile-Tuple{XrdCl!StatInfo}","page":"Public APIs","title":"Base.Filesystem.isfile","text":"Base.isfile(statinfo::StatInfo)\n\nCheck if the stat info is a file.\n\n\n\n\n\n","category":"method"},{"location":"api/#Base.Filesystem.mkdir","page":"Public APIs","title":"Base.Filesystem.mkdir","text":"Base.mkdir(fs::FileSystem, path::String, mode::XRootD.XrdCl!Access!Mode=Access.None, timeout::UInt16=0x0000)\n\nCreate a directory.\n\nArguments\n\nfs::FileSystem: The FileSystem object\npath::String: The path of the directory\nmode::XrdCl.Access.Mode: The mode\ntimeout::UInt16: The timeout in seconds\n\nReturns\n\nTuple of:\nst::XRootD.XrdCl!Status: The status of the operation\nnothing: Always\n\n\n\n\n\n","category":"function"},{"location":"api/#Base.Filesystem.mv","page":"Public APIs","title":"Base.Filesystem.mv","text":"Base.mv(fs::FileSystem, src::String, dest::String, timeout::UInt16=0x0000)\n\nMove or rename a file or directory.\n\nArguments\n\nfs::FileSystem: The FileSystem object\nsrc::String: The source path\ndest::String: The destination path\ntimeout::UInt16: The timeout in seconds\n\nReturns\n\nTuple of:\nst::XRootD.XrdCl!Status: The status of the operation\nnothing: Always\n\n\n\n\n\n","category":"function"},{"location":"api/#Base.Filesystem.readdir","page":"Public APIs","title":"Base.Filesystem.readdir","text":"Base.readdir(fs::FileSystem, path::String, flags::XRootD.XrdCl!DirListFlags!Flags=XRootD.XrdCl!DirListFlags!None; join::Bool = false, sort::Bool = false)\n\nList entries in a directory.\n\nArguments\n\nfs::FileSystem: The FileSystem object\npath::String: The path of the directory\nflags::XrdCl.DirListFlags: The flags\njoin::Bool: If true the entries will be joined with the path\nsort::Bool: If true the entries will be sorted\n\nReturns\n\nTuple of:\nst::XRootD.XrdCl!Status: The status of the operation\nentries::Vector{String}: The entries in the directory (or nothing if the operation failed)\n\n\n\n\n\n","category":"function"},{"location":"api/#Base.Filesystem.rm","page":"Public APIs","title":"Base.Filesystem.rm","text":"Base.rm(fs::FileSystem, path::String, timeout::UInt16=0x0000)\n\nRemove a file or directory.\n\nArguments\n\nfs::FileSystem: The FileSystem object\npath::String: The path of the file or directory\ntimeout::UInt16: The timeout in seconds\n\nReturns\n\nTuple of:\nst::XRootD.XrdCl!Status: The status of the operation\nnothing: Always\n\n\n\n\n\n","category":"function"},{"location":"api/#Base.Filesystem.walkdir-Tuple{XrdCl!FileSystem, AbstractString}","page":"Public APIs","title":"Base.Filesystem.walkdir","text":"Base.walkdir(fs::FileSystem, root::AbstractString; topdown=true)\n\nWalks in a directory tree.\n\nArguments\n\nfs::FileSystem: The FileSystem object\nroot::AbstractString: The path of the directory\ntopdown::Bool: start from the top of the directory tree\n\nReturns\n\nTuple of:\ndirpath, dirnames, files : Tuple{String,Vector{String},Vector{String}}\nThrows an exception if the operation fails.\n\nExamples\n\nfs = FileSystem(\"root://localhost:1094\")\nfor (path, dirs, files) in walkdir(fs, \"/tmp\")\n    println(\"Directories in $path\")\n    for dir in dirs\n        println(joinpath(path, dir)) # path to directories\n    end\n    println(\"Files in $path\")\n    for file in files\n        println(joinpath(path, file)) # path to files\n    end\nend\n\n\n\n\n\n","category":"method"},{"location":"api/#Base.close-Tuple{File}","page":"Public APIs","title":"Base.close","text":"Base.close(f::File)\n\nClose the file.\n\nArguments\n\nf::File: the File object.\n\nReturns\n\nTuple of:\nXRootDStatus: the status of the operation.\nnothing\n\n\n\n\n\n","category":"method"},{"location":"api/#Base.copy-Tuple{XrdCl!FileSystem, String, String}","page":"Public APIs","title":"Base.copy","text":"copy(fs::FileSystem, src::String, dest::String; force::Bool=false)\n\nSimple method to copy a file or directory. It uses some default options. For more control use the CopyProcess class.\n\nArguments\n\nfs::FileSystem: The FileSystem object\nsrc::String: The source path\ndest::String: The destination path\nforce::Bool: If true the destination will be overwritten\n\nReturns\n\nTuple of:\nst::XRootD.XrdCl!Status: The status of the operation\nresults::PropertyList: The results of the operation (or nothing if the operation failed)\n\n\n\n\n\n","category":"method"},{"location":"api/#Base.eof-Tuple{File}","page":"Public APIs","title":"Base.eof","text":"Base.eof(f::File)\n\nCheck if the file is at the end.\n\nArguments\n\nf::File: the File object.\n\nReturns\n\nBool: true if the file is at the end, false otherwise.\n\n\n\n\n\n","category":"method"},{"location":"api/#Base.getproperty-Tuple{XrdCl!LocationInfo!Location, Symbol}","page":"Public APIs","title":"Base.getproperty","text":"Base.getproperty(l::Location, prop::Symbol)\n\nGet the property of the location.\n\nArguments\n\nl::Location: the location.\nprop::Symbol: the property to get (examples: :address, :type, :accesstype, :is_manager, :is_server).\n\n\n\n\n\n","category":"method"},{"location":"api/#Base.getproperty-Tuple{XrdCl!ProtocolInfo, Symbol}","page":"Public APIs","title":"Base.getproperty","text":"Base.getproperty(p::ProtocolInfo, prop::Symbol)\n\nGet the property of the protocol info.\n\nArguments\n\np::ProtocolInfo: the protocol info.\nprop::Symbol: the property to get (examples: :hostinfo, :version).\n\n\n\n\n\n","category":"method"},{"location":"api/#Base.getproperty-Tuple{XrdCl!StatInfo, Symbol}","page":"Public APIs","title":"Base.getproperty","text":"Base.getproperty(statinfo::StatInfo, prop::Symbol)\n\nGet the property of the stat info.\n\nArguments\n\nstatinfo::StatInfo: the stat info.\nprop::Symbol: the property to get (examples: :size, :owner, :group, :modtime, :flags, :octmode, :mode).\n\n\n\n\n\n","category":"method"},{"location":"api/#Base.isopen-Tuple{File}","page":"Public APIs","title":"Base.isopen","text":"Base.isopen(f::File)\n\nCheck if the file is open.\n\nArguments\n\nf::File: the File object.\n\nReturns\n\nBool: true if the file is open, false otherwise.\n\n\n\n\n\n","category":"method"},{"location":"api/#Base.isreadable-Tuple{XrdCl!StatInfo}","page":"Public APIs","title":"Base.isreadable","text":"Base.isreadable(statinfo::StatInfo)\n\nCheck if the stat info is readable.\n\n\n\n\n\n","category":"method"},{"location":"api/#Base.iswritable-Tuple{XrdCl!StatInfo}","page":"Public APIs","title":"Base.iswritable","text":"Base.iswritable(statinfo::StatInfo)\n\nCheck if the stat info is writable.\n\n\n\n\n\n","category":"method"},{"location":"api/#Base.open","page":"Public APIs","title":"Base.open","text":"Base.open(f::File, url::String, flags=0x0000, mode=0x0000)\n\nOpen a file.\n\nArguments\n\nf::File: the File object.\nurl::String: the URL of the file.\nflags::Int: the flags to open the file (examples: OpenFlags.Read, OpenFlags.Write, OpenFlags.Delete).\nmode::Int: the mode to open the file (examples: Access.UR, Access.UW).\n\nReturns\n\nTuple of:\nXRootDStatus: the status of the operation.\nnothing\n\n\n\n\n\n","category":"function"},{"location":"api/#Base.read","page":"Public APIs","title":"Base.read","text":"Base.read(f::File, size, offset=0)\n\nRead data from the file.\n\nArguments\n\nf::File: the File object.\nsize::Int: the size of the data to read.\noffset::Int: the offset to read the data.\n\nReturns\n\nTuple of:\nXRootDStatus: the status of the operation.\nArray{UInt8}: the data read (or nothing if the operation failed).\n\n\n\n\n\n","category":"function"},{"location":"api/#Base.readline","page":"Public APIs","title":"Base.readline","text":"Base.readline(f::File, size=0, offset=0, chunk=0)\n\nread one line from the file until it finds a linefeed ( ) or reaches the end of the file.\n\nArguments\n\nf::File: the File object.\nsize::Int: the maximum size of the line to read.\noffset::Int: the offset in the file (0 indicates to continue reading from previous position).\nchunk::Int: the size of the chunk to read (0 indicates 2MB).\n\nReturns\n\nTuple of:\nXRootDStatus: the status of the operation.\nString: the line read (or nothing if the operation failed).\n\n\n\n\n\n","category":"function"},{"location":"api/#Base.readlines","page":"Public APIs","title":"Base.readlines","text":"Base.readlines(f::File, size=0, offset=0, chunk=0)\n\nreadlines reads lines from the file.\n\nArguments\n\nf::File: the File object.\nsize::Int: the maximum size of the lines to read.\noffset::Int: the offset in the file (0 indicates to continue reading from previous position).\nchunk::Int: the size of the chunk to read (0 indicates 2MB).\n\nReturns\n\nTuple of:\nXRootDStatus: the status of the operation.\nArray{String}: the lines read (or nothing if the operation failed).\n\n\n\n\n\n","category":"function"},{"location":"api/#Base.stat","page":"Public APIs","title":"Base.stat","text":"Base.stat(f::File, force::Bool=true)\n\nStat the file.\n\nArguments\n\nf::File: the File object.\nforce::Bool: force the stat operation.\n\nReturns\n\nTuple of:\nXRootDStatus: the status of the operation.\nStatInfo: the stat information (or nothing if the operation failed).\n\n\n\n\n\n","category":"function"},{"location":"api/#Base.stat-2","page":"Public APIs","title":"Base.stat","text":"Base.stat(fs::FileSystem, path::String, timeout::UInt16=0x0000)\n\nGets the StatInfo of a file or directory.\n\nArguments\n\nfs::FileSystem: The FileSystem object\npath::String: The path of the file or directory\ntimeout::UInt16: The timeout in seconds\n\nReturns\n\nTuple of:\nst::XRootD.XrdCl!Status: The status of the operation\nstatinfo::StatInfo: The StatInfo object (or nothing if the operation failed) \n\n\n\n\n\n","category":"function"},{"location":"api/#Base.truncate","page":"Public APIs","title":"Base.truncate","text":"Base.truncate(fs::FileSystem, path::String, size::Int64, timeout::UInt16=0x0000)\n\nTruncate a file to a specified size.\n\nArguments\n\nfs::FileSystem: The FileSystem object\npath::String: The path of the file\nsize::Int64: The new size\ntimeout::UInt16: The timeout in seconds\n\nReturns\n\nTuple of:\nst::XRootD.XrdCl!Status: The status of the operation\nnothing: Always\n\n\n\n\n\n","category":"function"},{"location":"api/#Base.truncate-Tuple{File, Int64}","page":"Public APIs","title":"Base.truncate","text":"Base.truncate(f::File, size::Int64)\n\nTruncate the file.\n\nArguments\n\nf::File: the File object.\nsize::Int64: the size to truncate the file.\n\nReturns\n\nTuple of:\nXRootDStatus: the status of the operation.\nnothing\n\n\n\n\n\n","category":"method"},{"location":"api/#Base.unsafe_read","page":"Public APIs","title":"Base.unsafe_read","text":"Base.unsafe_read(f::File, ptr::Ptr{Nothing}, size, offset=0)\n\nRead data from the file into a pointer.\n\nArguments\n\nf::File: the File object.\nptr::Ptr{Nothing}: the pointer to read the data.\nsize::Int: the size of the data to read (or 0 if failed).\n\n\n\n\n\n","category":"function"},{"location":"api/#Base.write","page":"Public APIs","title":"Base.write","text":"Base.write(f::File, data::Array{UInt8}, size, offset=0)\n\nWrite data to the file.\n\nArguments\n\nf::File: the File object.\ndata::Array{UInt8}: the data to write.\nsize::Int: the size of the data to be writen.\noffset::Int: the offset to write the data.\n\nReturns\n\nTuple of:\nXRootDStatus: the status of the operation.\nnothing\n\n\n\n\n\n","category":"function"},{"location":"api/#XRootD.XrdCl.getFlags-Tuple{XrdCl!StatInfo}","page":"Public APIs","title":"XRootD.XrdCl.getFlags","text":"getFlags(statinfo::StatInfo)\n\nThe flags of the stat info.\n\n\n\n\n\n","category":"method"},{"location":"api/#XRootD.XrdCl.isError-Tuple{XrdCl!Status}","page":"Public APIs","title":"XRootD.XrdCl.isError","text":"isError(status::Status)\n\nCheck if the status is an error.\n\n\n\n\n\n","category":"method"},{"location":"api/#XRootD.XrdCl.isExecutable-Tuple{XrdCl!StatInfo}","page":"Public APIs","title":"XRootD.XrdCl.isExecutable","text":"isExecutable(statinfo::StatInfo)\n\nCheck if the stat info is executable.\n\n\n\n\n\n","category":"method"},{"location":"api/#XRootD.XrdCl.isFatal-Tuple{XrdCl!Status}","page":"Public APIs","title":"XRootD.XrdCl.isFatal","text":"isFatal(status::Status)\n\nCheck if the status is fatal.\n\n\n\n\n\n","category":"method"},{"location":"api/#XRootD.XrdCl.isOK-Tuple{XrdCl!Status}","page":"Public APIs","title":"XRootD.XrdCl.isOK","text":"isOK(status::Status)\n\nCheck if the status is OK.\n\n\n\n\n\n","category":"method"},{"location":"api/#XRootD.XrdCl.isOffline-Tuple{XrdCl!StatInfo}","page":"Public APIs","title":"XRootD.XrdCl.isOffline","text":"isOffline(statinfo::StatInfo)\n\nCheck if the stat info is offline.\n\n\n\n\n\n","category":"method"},{"location":"api/#XRootD.XrdCl.locate","page":"Public APIs","title":"XRootD.XrdCl.locate","text":"locate(fs::FileSystem, path::String, flags::XRootD.XrdCl!OpenFlags!Flags, timeout::UInt16=0x0000)\n\nGet the locations of a file or directory.\n\nArguments\n\nfs::FileSystem: The FileSystem object\npath::String: The path of the file or directory\nflags::XrdCl.OpenFlags: The flags\ntimeout::UInt16: The timeout in seconds\n\nReturns\n\nTuple of:\nst::XRootD.XrdCl!Status: The status of the operation\nlocations::Vector{LocationInfo}: The locations of the file or directory (or nothing if the operation failed)\n\n\n\n\n\n","category":"function"},{"location":"api/#XRootD.XrdCl.ping","page":"Public APIs","title":"XRootD.XrdCl.ping","text":"ping(fs::FileSystem)\n\nCheck if the server is alive - sync\n\nArguments\n\nfs::FileSystem: The FileSystem object\ntimeout::UInt16: The timeout in seconds\n\nReturns\n\nTuple of:\nst::XRootD.XrdCl!Status: The status of the operation\nnothing: Always    \n\n\n\n\n\n","category":"function"},{"location":"api/#XRootD.XrdCl.protocol","page":"Public APIs","title":"XRootD.XrdCl.protocol","text":"protocol(fs::FileSystem, timeout::UInt16=0x0000)\n\nGet the protocol information.\n\nArguments\n\nfs::FileSystem: The FileSystem object\ntimeout::UInt16: The timeout in seconds\n\nReturns\n\nTuple of:\nst::XRootD.XrdCl!Status: The status of the operation\nprotocol::ProtocolInfo: The protocol information (or nothing if the operation failed)\n\n\n\n\n\n","category":"function"},{"location":"api/#XRootD.XrdCl.query","page":"Public APIs","title":"XRootD.XrdCl.query","text":"query(fs::FileSystem, code::XRootD.XrdCl!QueryCode!Code , arg::String, timeout::UInt16=0x0000)\n\nQuery the server.\n\nArguments\n\nfs::FileSystem: The FileSystem object\ncode::XrdCl.QueryCode: The query code\narg::String: The argument\ntimeout::UInt16: The timeout in seconds\n\nReturns\n\nTuple of:\nst::XRootD.XrdCl!Status: The status of the operation\nresponse::String: The response (or nothing if the operation failed)\n\n\n\n\n\n","category":"function"},{"location":"api/#XRootD.XrdCl.rmdir","page":"Public APIs","title":"XRootD.XrdCl.rmdir","text":"rmdir(fs::FileSystem, path::String, timeout::UInt16=0x0000)\n\nRemove a directory.\n\nArguments\n\nfs::FileSystem: The FileSystem object\npath::String: The path of the directory\ntimeout::UInt16: The timeout in seconds\n\nReturns\n\nTuple of:\nst::XRootD.XrdCl!Status: The status of the operation\nnothing: Always\n\n\n\n\n\n","category":"function"},{"location":"#Julia-bindings-for-XRootD","page":"Introduction","title":"Julia bindings for XRootD","text":"","category":"section"},{"location":"#Description","page":"Introduction","title":"Description","text":"","category":"section"},{"location":"","page":"Introduction","title":"Introduction","text":"Julia bindings for the XRootD high performance, scalable, and fault tolerant access to data repositories. It facilitates the interface with the XRootD client, by writing Julia code instead of having to write C++ code. This package is developed using the CxxWrap.jl package to wrap C++ types and functions to Julia. Wrapper C++ code is generated with the help of WrapIt tool that uses of the clang library.","category":"page"},{"location":"","page":"Introduction","title":"Introduction","text":"The Julia interface has been inspired by the functionality provided by pyxrootd, which provide a set of simple but pythonic bindings for XRootD. In the case of Julia we have used the same function names if there was an equivalent in the Base module.","category":"page"},{"location":"#Installation","page":"Introduction","title":"Installation","text":"","category":"section"},{"location":"","page":"Introduction","title":"Introduction","text":"The XRootD.jl package does no require any special installation. Stable releases are registered into the Julia general registry, and therefore can be deployed with the standard Pkg Julia package manager.","category":"page"},{"location":"","page":"Introduction","title":"Introduction","text":"julia> using Pkg\njulia> Pkg.add(\"XRootD\")","category":"page"},{"location":"#API-Guidelines","page":"Introduction","title":"API Guidelines","text":"","category":"section"},{"location":"","page":"Introduction","title":"Introduction","text":"Besides de constructors for XrdCl.File and XrdCl.FileSystem all the other functions returns a Tuple (status, response), where status is an instance of XRootDStatus and response is the returned object or nothing if the function does not return a value.","category":"page"},{"location":"","page":"Introduction","title":"Introduction","text":"The returned status can be directly printed with println(status) or similar functions. It can also be checked with isOK(status) or isError(status) helper functions returning a Boolvalue. ","category":"page"},{"location":"#Getting-Started","page":"Introduction","title":"Getting Started","text":"","category":"section"},{"location":"","page":"Introduction","title":"Introduction","text":"using XRootD.XrdCl\n\n#---FileSystem interface---------------------------------------\nfs = FileSystem(\"root://localhost:1094\")  # create a FileSystem\n\nst, _ = ping(fs)                          # is server alive?\nisError(st) && error(st)\n\nst, statinfo = stat(fs, \"/tmp\")           # get statinfo \n\nif isOK(st) && isdir(statinfo)              \n    st, entries = readdir(fs, \"/tmp\")     # ls the directory\n    isError(st) && error(st)\n    for f in entries\n        println(f)\n    end\nend\n\n#---File interface--------------------------------------------\nf = File()\n\n# create file and write\nst, _ = open(f, \"root://localhost:1094//tmp/testfile.txt\", OpenFlags.New|OpenFlags.Write)\nisError(st) && error(st)\nwrite(f, \"Hello\\nWorld\\nFolks!\")\nclose(f)\n\n# re-open file and read\nst, _ = open(f, \"root://localhost:1094//tmp/testfile.txt\", OpenFlags.Read)\nisError(st) && error(st)\nst, lines = readlines(f)\nisError(st) && error(st)\nfor line in lines\n  print(line)\nend\nclose(f)\n\n# delete file (using FileSystem)\nst, _ = rm(fs, \"/tmp/testfile.txt\")","category":"page"},{"location":"#Tests","page":"Introduction","title":"Tests","text":"","category":"section"},{"location":"","page":"Introduction","title":"Introduction","text":"Unit tests can be run with julia --project=. test/runtests.jl","category":"page"},{"location":"#Roadmap","page":"Introduction","title":"Roadmap","text":"","category":"section"},{"location":"","page":"Introduction","title":"Introduction","text":"There are a number of issues and problems still to be resolved. We keep track of them in this list:","category":"page"},{"location":"","page":"Introduction","title":"Introduction","text":"Is is necessary to have the async interface?\nBenchmark the performance of XRootD versus xrootdgo","category":"page"}]
}
