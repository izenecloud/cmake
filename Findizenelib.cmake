# - Find izenelib installation.
#
# == Using Header-Only libraries from within izenelib: ==
#
#   FIND_PACKAGE(izenelib)
#   IF(izenelib_FOUND)
#      INCLUDE_DIRECTORIES(${izenelib_INCLUDE_DIRS})
#      ADD_EXECUTABLE(foo foo.cpp)
#   ENDIF()
#
# == Using actual libraries from within izenelib: ==
#
#   FIND_PACKAGE(izenelib COMPONENTS febird index_manager message_framework)
#
#   IF(izenelib_FOUND)
#      INCLUDE_DIRECTORIES(${izenelib_INCLUDE_DIRS})
#      ADD_EXECUTABLE(foo foo.cpp)
#      TARGET_LINK_LIBRARIES(foo ${izenelib_LIBRARIES})
#   ENDIF()
#
# The following are set after the configuration is done:
#
# izenelib_FOUND        - Set to True if Tokyo Cabinet was found.
# izenelib_INCLUDE_DIRS - Include directories
# izenelib_LIBRARIES    - Libraries required to link
#
# User can change the following variable in cache to indicate where
# izenelib is installed.
#
# IZENELIB           - It can also be set as environemnt variable. The cmake
#                     variable can override the setting in environement
#                     variable. It should be set to the install root directory
#                     of izenelib. The header files should be in
#                     ${IZENELIB}/include and libraries are in ${IZENELIB}/lib
#
# izenelib_INCLUDE_DIR
# izenelib_${COMPONENT}_LIBRARY
#                    - Set include dir and each library directly. ${COMPONENT}
#                      is the components specified in find_package. Such as
#                      izenelib_index_manager_LIBRARY
#
# For each component the variable izenelib_${COMPONENT}_LIBRARY has also been
# set.
#

# Setup izenelib_ROOT_DIR according to IZENELIB
IF(IZENELIB)
  SET(izenelib_ROOT_DIR ${IZENELIB})
ELSE(IZENELIB)
  SET(izenelib_ROOT_DIR $ENV{IZENELIB})
ENDIF(IZENELIB)

INCLUDE(MacroFindPackageWithCache)
MACRO_FIND_PACKAGE_WITH_CACHE(
  izenelib izenelib am/am.h ${izenelib_FIND_COMPONENTS}
  )

SET(_thirdparty)
FOREACH(_dir ${izenelib_INCLUDE_DIRS})
  LIST(APPEND _thirdparty "${_dir}/3rdparty")
ENDFOREACH(_dir)
SET(izenelib_INCLUDE_DIRS ${izenelib_INCLUDE_DIRS} ${_thirdparty})

MARK_AS_ADVANCED(IZENELIB)