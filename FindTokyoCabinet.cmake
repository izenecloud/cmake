# - Find Tokyo Cabinet installation.
#
# The following are set after the configuration is done:
#
# TokyoCabinet_FOUND        - Set to True if Tokyo Cabinet was found.
# TokyoCabinet_INCLUDE_DIRS - Include directories
# TokyoCabinet_LIBRARIES    - Libraries required to link
#
# User can change the following variable in cache to indicate where
# Tokyo Cabinet is installed.
#
# TokyoCabinet_ROOT_DIR     - Install root directory. The header files should be
#                             in ${TokyoCabinet_ROOT_DIR}/include and libraries
#                             are in ${TokyoCabinet_ROOT_DIR}/lib
#
# TokyoCabinet_INCLUDE_DIR
# TokyoCabinet_LIBRARY      - Set these two to specify include dir and
#                             libraries directly.
#

FUNCTION(GET_PACKAGE_VERSION)
  SET(TokyoCabinet_VERSION)
  SET(TokyoCabinet_TCUTIL_H)
  IF(TokyoCabinet_INCLUDE_DIR)
    FIND_FILE(TokyoCabinet_TCUTIL_H tcutil.h "${TokyoCabinet_INCLUDE_DIR}")
  ENDIF(TokyoCabinet_INCLUDE_DIR)

  IF(TokyoCabinet_TCUTIL_H)
    FILE(READ "${TokyoCabinet_INCLUDE_DIR}/tcutil.h" _tokyocabinet_tcutil_h_contents)
    STRING(REGEX REPLACE ".*#define _TC_VERSION[^\"]*\"([.0-9]+)\".*" "\\1" TokyoCabinet_VERSION "${_tokyocabinet_tcutil_h_contents}")
  ENDIF(TokyoCabinet_TCUTIL_H)
  SET(TokyoCabinet_VERSION ${TokyoCabinet_VERSION} PARENT_SCOPE)
ENDFUNCTION(GET_PACKAGE_VERSION)

SET(TokyoCabinet_NO_PKG_CONFIG ON)
INCLUDE(MacroFindPackageWithCacheAndVersionCheck)
MACRO_FIND_PACKAGE_WITH_CACHE_AND_VERSION_CHECK(
  tokyocabinet TokyoCabinet tcutil.h tokyocabinet
  )

MARK_AS_ADVANCED(TokyoCabinet_TCUTIL_H)
