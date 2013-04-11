cmake_minimum_required(VERSION 2.6)
project(mdtest)

find_package(MPI REQUIRED)
include_directories(${MPI_INCLUDE_PATH})
add_definitions(-D_FILE_OFFSET_BITS=64 -D_LARGEFILE_SOURCE=1
  -D__USE_LARGEFILE64=1)

option(DISABLE_PLFS "Disable PLFS support in mdtest." OFF)
if (NOT DISABLE_PLFS)
  find_path(PLFS_INCLUDE_DIR
            NAMES "plfs.h"
            PATHS "/usr/local"
                  "/usr"
            ENV PLFS_ROOTDIR
            PATH_SUFFIXES "include")
  if (NOT PLFS_INCLUDE_DIR)
    message("Can't find PLFS header files.")
    set(DISABLE_PLFS ON)
  endif (NOT PLFS_INCLUDE_DIR)
  find_library(PLFS_LIBRARIES
               NAMES "libplfs.a"
                     "libplfs.so"
               PATHS "/usr/local"
                     "/usr"
               ENV PLFS_ROOTDIR
               PATH_SUFFIXES "lib")
  if (NOT PLFS_LIBRARIES)
    message("Can't find PLFS library.")
    set(DISABLE_PLFS ON)
  endif (NOT PLFS_LIBRARIES)
endif (NOT DISABLE_PLFS)
add_executable(mdtest mdtest.c)
target_link_libraries(mdtest ${MPI_LIBRARIES})
if (NOT DISABLE_PLFS)
  include_directories(${PLFS_INCLUDE_DIR})
  add_definitions(-D_HAS_PLFS)
  target_link_libraries(mdtest ${PLFS_LIBRARIES})
endif (NOT DISABLE_PLFS)
if(MPI_COMPILE_FLAGS)
  set_target_properties(mdtest PROPERTIES
    COMPILE_FLAGS "${MPI_COMPILE_FLAGS}")
endif()
if(MPI_LINK_FLAGS)
  set_target_properties(mdtest PROPERTIES
    LINK_FLAGS "${MPI_LINK_FLAGS}")
endif()
