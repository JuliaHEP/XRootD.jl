project(XRootDWrap)
cmake_minimum_required(VERSION 3.21)

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

#---Generate wrapper if WrapIt is found---------------------------------------------
find_program(WRAPIT_EXECUTABLE wrapit)
if(WRAPIT_EXECUTABLE)
  configure_file(${SOURCE_DIR}/XRootD.wit.in ${SOURCE_DIR}/XRootD.wit @ONLY)
  add_custom_command(OUTPUT ${SOURCE_DIR}/cpp/jlXRootD.cxx
    COMMAND mkdir -p ${SOURCE_DIR}/jl
    COMMAND ${WRAPIT_EXECUTABLE} --force -v 1 ${SOURCE_DIR}/XRootD.wit
    WORKING_DIRECTORY ${SOURCE_DIR}
    DEPENDS ${SOURCE_DIR}/XRootD.wit ${SOURCE_DIR}/XRootD-veto.h)
else()
  message(STATUS "The executable wrapit was not found. Building wrapper using the generated jlXRootD.cxx/h files from the sources.")
endif()

file(GLOB GEN_SOURCES CONFIGURE_DEPENDS  ${SOURCE_DIR}/cpp/Jl*.cxx)
add_library(XRootDWrap SHARED ${SOURCE_DIR}/cpp/jlXRootD.cxx ${GEN_SOURCES})
target_include_directories(XRootDWrap PRIVATE ${SOURCE_DIR})
target_link_libraries(XRootDWrap JlCxx::cxxwrap_julia JlCxx::cxxwrap_julia_stl ${XRootD_LIBRARIES})

install(TARGETS XRootDWrap
        LIBRARY DESTINATION lib
        ARCHIVE DESTINATION lib
        RUNTIME DESTINATION lib)
