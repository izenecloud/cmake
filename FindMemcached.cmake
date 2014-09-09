# - Find Google-glog installation.
#
# The following are set after the configuration is done:
#
# Glog_FOUND        - Set to True if Google-glog was found.
# Glog_INCLUDE_DIRS - Include directories
# Glog_LIBRARIES    - Libraries required to link
#
# User can change the following variable in cache to indicate where
# Google-glog is installed.
#
# Glog_ROOT_DIR     - Install root directory. The header files should be in
#                     ${Glog_ROOT_DIR}/include/glog and libraries are in
#                     ${Glog_ROOT_DIR}/lib
#
# Glog_INCLUDE_DIR
# Glog_LIBRARY      - Set these two to specify include dir and
#                     libraries directly.
#

SET(Memcached_NO_PKG_CONFIG ON)
INCLUDE(MacroFindPackageWithCache)
MACRO_FIND_PACKAGE_WITH_CACHE(
  libmemcached Memcached libmemcached/memcached.h memcached
  )
