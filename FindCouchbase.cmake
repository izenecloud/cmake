# Locate libev library
# This module defines
#  LIBCOUCHBASE_FOUND, if false, do not try to link with libev
#  LIBCOUCHBASE_LIBRARIES, Library path and libs
#  LIBCOUCHBASE_INCLUDE_DIR, where to find the libev headers

FIND_PATH(LIBCOUCHBASE_INCLUDE_DIR couchbase.h
    PATHS ${LIBCOUCHBASE_ROOT}
    PATH_SUFFIXES include libcouchbase
    NO_DEFAULT_PATH)

FIND_LIBRARY(LIBCOUCHBASE_LIBRARIES
    NAMES couchbase libcouchbase
    PATHS ${LIBCOUCHBASE_ROOT}
    PATH_SUFFIXES lib libcouchbase
    NO_DEFAULT_PATH)

FIND_PATH(LIBCOUCHBASE_INCLUDE_DIR couchbase.h
    HINTS
        ENV LIBCOUCHBASE_DIR
    PATH_SUFFIXES include include/libcouchbase
    PATHS
        ${DEPS_INCLUDE_DIR}
        ~/Library/Frameworks
        /Library/Frameworks
        /opt/local
        /opt/libcouchbase
        /opt)

FIND_LIBRARY(LIBCOUCHBASE_LIBRARIES
    NAMES couchbase libcouchbase
    HINTS
        ENV LIBCOUCHBASE_DIR
    PATH_SUFFIXES lib libcouchbase
    PATHS
        ${DEPS_LIB_DIR}
        ~/Library/Frameworks
        /Library/Frameworks
        /opt/local
        /opt/libcouchbase
        /opt)

IF (LIBCOUCHBASE_LIBRARIES AND LIBCOUCHBASE_INCLUDE_DIR)
    SET(LIBCOUCHBASE_FOUND true)
    MESSAGE(STATUS "Found libcouchbase in ${LIBCOUCHBASE_INCLUDE_DIR} : ${LIBCOUCHBASE_LIBRARIES}")
ELSE (LIBCOUCHBASE_LIBRARIES)
    SET(LIBCOUCHBASE_FOUND false)
ENDIF (LIBCOUCHBASE_LIBRARIES AND LIBCOUCHBASE_INCLUDE_DIR)

#INCLUDE(CMakePushCheckState)
#INCLUDE(CheckFunctionExists)

IF(LIBCOUCHBASE_FOUND)
    #CMAKE_PUSH_CHECK_STATE()
    SET(CMAKE_REQUIRED_FLAGS "-I${LIBCOUCHBASE_INCLUDE_DIR}")
    SET(CMAKE_REQUIRED_LIBRARIES ${LIBCOUCHBASE_LIBRARIES})
    SET(CMAKE_REQUIRED_INCLUDES "couchbase.h")
    #CMAKE_POP_CHECK_STATE()
    IF(LIBCOUCHBASE_FOUND)
        MESSAGE(STATUS "libcouchbase found")
    ELSE()
        MESSAGE(STATUS "libcouchbase not found")
    ENDIF()
ENDIF()

MARK_AS_ADVANCED(HAVE_LIBCOUCHBASE LIBCOUCHBASE_INCLUDE_DIR LIBCOUCHBASE_LIBRARIES)
