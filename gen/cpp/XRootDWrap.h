#include "XrdCl/XrdClPropertyList.hh"

inline void Set(XrdCl::PropertyList& pl, const std::string& key, const std::string& value){
    pl.Set(key, value); 
}

