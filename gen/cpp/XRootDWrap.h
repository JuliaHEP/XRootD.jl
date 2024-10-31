#include "XrdCl/XrdClPropertyList.hh"

inline void Set(XrdCl::PropertyList& pl, const std::string& key, const std::string& value){
    pl.Set(key, value); 
}

// BinaryBuilder uses old SDK which doesn't have ranges
#ifdef __APPLE__
    #undef JLCXX_HAS_RANGES
#endif