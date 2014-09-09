# - Find Tokyo Cabinet installation.
#
# The following are set after the configuration is done:
#
# TokyoCabinet_FOUND        - Set to True if Tokyo Cabinet was found.
# Toko_INCLUDE_DIRS - Include directories
# TokyoCabinet_LIBRARIES    - Libraries required to link
#
# User can change the following variable in cache to indicate where
# Tokyo Cabinet is installed.
#
# TokyoCabinet_ROOT_DIR     - Install root directory. The header files should be
#                             in ${TokyoCabinet_ROOT_DIR}/include and libraries
#                             are in ${TokyoCabinet_ROOT_DIR}/lib
#
# Toko_INCLUDE_DIR
# TokyoCabinet_LIBRARY      - Set these two to specify include dir and
#                             libraries directly.
#

find_path(Toku_INCLUDE_DIR tokudb.h PATHS
    /usr/local/include
    /usr/include
    /opt/local/include
  )

set(LibToku_LIB_PATH /usr/local/lib /usr/lib)
find_library(LibToku_portability_PATH NAMES tokuportability NO_DEFAULT_PATH PATHS ${LibToku_LIB_PATH})
find_library(Libdb_PATH NAMES db NO_DEFAULT_PATH PATHS ${LibToku_LIB_PATH})
find_library(LibToku_treeindex_PATH NAMES tokufractaltreeindex NO_DEFAULT_PATH PATHS ${LibToku_LIB_PATH})
 
set(LibToku_LIB_PATHS  ${LibToku_portability_PATH} ${LibToku_treeindex_PATH} ${Libdb_PATH})
if (Libdb_PAT AND LibToku_treeindex_PATH AND LibToku_portability_PATH)
    message(STATUS "Found Tokulib: ${LibToku_LIB_PATHS}")
endif ()
if (Toku_INCLUDE_DIR )
    message(STATUS "Found TokuInlucde: ${Toku_INCLUDE_DIR}")
endif ()

if (LibToku_LIB_PATHS AND Toku_INCLUDE_DIR)
  set(Toku_FOUND TRUE)
  set(Toku_LIBS ${LibToku_LIB_PATHS})
else ()
  set(Toku_FOUND FALSE)
endif ()


mark_as_advanced(
    LibToku_LIB
    Toku_INCLUDE_DIR
  )
