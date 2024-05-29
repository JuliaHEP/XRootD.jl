# Julia bindings for XRootD

## Description

Julia bindings for the [XRootD](https://xrootd.slac.stanford.edu) high performance, scalable, and fault tolerant access to data repositories. It facilitates the interface with the XRootD client, by writing Julia code instead of having to write C++ code.
This package is developed using the [CxxWrap.jl](https://github.com/JuliaInterop/CxxWrap.jl) package to wrap C++ types and functions to Julia. Wrapper C++ code is generated with the help of [WrapIt](https://github.com/grasph/wrapit) tool that uses of the clang library.

The Julia interface has been inspired by the functionality provided by [pyxrootd](https://xrootd.slac.stanford.edu/doc/doxygen/5.6.4/python/), which provide a set of simple but pythonic bindings for XRootD. In the case of Julia we have used the same function names if there was an equivalent in the `Base` module.

## Installation
The XRootD.jl package does no require any special installation. Stable releases are registered into the Julia general registry, and therefore can be deployed with the standard `Pkg` Julia package manager.
```julia
julia> using Pkg
julia> Pkg.add("XRootD")
```
## API Guidelines
Besides de constructors for `XrdCl.File` and `XrdCl.FileSystem` all the other functions returns a Tuple `(status, response)`, where `status` is an instance of `XRootDStatus` and response is the returned object or `nothing` if the function does not return a value.

The returned `status` can be directly printed with `println(status)` or similar functions. It can also be checked with `isOK(status)` or `isError(status)` helper functions returning a `Bool`value. 

## Getting Started

```Julia
using XRootD.XrdCl

#---FileSystem interface---------------------------------------
fs = FileSystem("root://localhost:1094")  # create a FileSystem

st, _ = ping(fs)                          # is server alive?
isError(st) && error(st)

st, statinfo = stat(fs, "/tmp")           # get statinfo 

if isOK(st) && isdir(statinfo)              
    st, entries = readdir(fs, "/tmp")     # ls the directory
    isError(st) && error(st)
    for f in entries
        println(f)
    end
end

#---File interface--------------------------------------------
f = File()

# create file and write
st, _ = open(f, "root://localhost:1094//tmp/testfile.txt", OpenFlags.New|OpenFlags.Write)
isError(st) && error(st)
write(f, "Hello\nWorld\nFolks!")
close(f)

# re-open file and read
st, _ = open(f, "root://localhost:1094//tmp/testfile.txt", OpenFlags.Read)
isError(st) && error(st)
st, lines = readlines(f)
isError(st) && error(st)
for line in lines
  print(line)
end
close(f)

# delete file (using FileSystem)
st, _ = rm(fs, "/tmp/testfile.txt")
```

## Tests
Unit tests can be run with `julia --project=. test/runtests.jl`

## Roadmap
There are a number of issues and problems still to be resolved. We keep track of them in this list:
- Is is necessary to have the async interface?
- Benchmark the performance of `XRootD` versus `xrootdgo`
