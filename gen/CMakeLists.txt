cmake_minimum_required(VERSION 3.21)
project(XRootDWrap)

set(CMAKE_MACOSX_RPATH 1)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/lib")

#---Find JlCxx package-------------------------------------------------------------
find_package(JlCxx)
get_target_property(JlCxx_location JlCxx::cxxwrap_julia LOCATION)
get_filename_component(JlCxx_location ${JlCxx_location} DIRECTORY)
set(CMAKE_INSTALL_RPATH "${CMAKE_INSTALL_PREFIX}/lib;${JlCxx_location}")
message(STATUS "Found JlCxx at ${JlCxx_location}")
set(CMAKE_FIND_PACKAGE_PREFER_CONFIG TRUE)
#---Find XRootD---------------------------------------------------------------------
find_package(XRootD)

#  Files are in gen folder----------------------------------------------------------
file(REAL_PATH ${CMAKE_SOURCE_DIR}/../gen SOURCE_DIR)
file(GLOB GEN_SOURCES CONFIGURE_DEPENDS  ${SOURCE_DIR}/cpp/Jl*.cxx)
add_library(XRootDWrap SHARED ${SOURCE_DIR}/cpp/jlXRootD.cxx ${GEN_SOURCES})
target_include_directories(XRootDWrap PRIVATE ${SOURCE_DIR} ${XRootD_INCLUDE_DIRS})
target_link_libraries(XRootDWrap JlCxx::cxxwrap_julia JlCxx::cxxwrap_julia_stl ${XRootD_LIBRARIES})

install(TARGETS XRootDWrap
        LIBRARY DESTINATION lib
        ARCHIVE DESTINATION lib
        RUNTIME DESTINATION lib)
