[![XRootD](docs/src/assets/xrootd-logo.png)](https://xrootd.slac.stanford.edu)


[![License](https://img.shields.io/badge/license-LGPL-blue.svg)](LICENSE)

## Description

Julia bindings for the [XRootD](https://xrootd.slac.stanford.edu) high performance, scalable, and fault tolerant access to data repositories. It facilitates the interface with the XRootD client, by writing Julia code instead of having to write C++.
This package is developed using the [CxxWrap.jl](https://github.com/JuliaInterop/CxxWrap.jl) package to wrap C++ types and functions to Julia. Wrapper C++ code is generated with the help of [WrapIt](https://github.com/grasph/wrapit) tool that uses of the clang library.

The Julia interface has been inspired by the functionality provided by [pyxrootd](https://xrootd.slac.stanford.edu/doc/doxygen/5.6.4/python/), which provide a set of simple but pythonic bindings for XRootD.

## Installation
The XRootD.jl package does no require any special installation. Stable releases are registered into the Julia general registry, and therefore can be deployed with the standard `Pkg` Julia package manager.
```julia
julia> using Pkg
julia> Pkg.add("XRootD")
```

## Getting Started

```Julia
using XRootD.XrdCl

fs = FileSystem("root://localhost:1094")  # create a FileSystem

st = ping(fs)                             # is server alive?
isError(st) && error(st)

st, statinfo = stat(fs, "/tmp")           # get statinfo 

if isOK(st) && isdir(statinfo)              
    st, entries = readdir(fs, "/tmp")     # ls the directory
    for f in entries
        println(f)
    end
end 
```
