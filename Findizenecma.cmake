# - Find cma installation.
#
# The following are set after the configuration is done:
#
# izenecma_FOUND        - Set to True if izenecma was found.
# izenecma_INCLUDE_DIRS - Include directories
# izenecma_LIBRARIES    - Libraries required to link
# izenecma_KNOWLEDGE    - Path to cma knowledge directory
# User can change the following variable in cache to indicate where
# lalib is installed.
#
# IZENECMA            - It can also be set as environemnt variable. The cmake
#                      variable can override the setting in environement
#                      variable. It should be set to the install root directory
#                      of cma. The header files should be in
#                      ${IZENECMA}/include and libraries are in ${IZENECMA}/lib
#
# izenecma_INCLUDE_DIR
# izenecma_LIBRARY    - Specify include dir and library directly.
#

# Setup izenecma_ROOT_DIR according to IZENECMA
IF(IZENECMA)
  SET(izenecma_ROOT_DIR ${IZENECMA})
ELSE(IZENECMA)
  SET(izenecma_ROOT_DIR $ENV{IZENECMA})
ENDIF(IZENECMA)

INCLUDE(MacroFindPackageWithCache)
MACRO_FIND_PACKAGE_WITH_CACHE(icma izenecma icma/icma.h cmac)

IF(izenecma_FOUND)
  # set the knowledge directly
  SET(izenecma_KNOWLEDGE ${izenecma_ROOT_DIR}/db/icwb/utf8)

  IF(izenecma_KNOWLEDGE)
    MESSAGE(STATUS "  Found: ${izenecma_KNOWLEDGE}")
  ELSE(izenecma_KNOWLEDGE)
    SET(izenecma_FOUND FALSE)
    SET(izenecma_INCLUDE_DIR ${izenecma_ROOT_DIR}/include)

    SET(_details "  Failed.")
    IF(${name}_FIND_REQUIRED)
      MESSAGE(FATAL_ERROR "${_details}")
    ELSEIF(NOT ${name}_FIND_QUIETLY)
      MESSAGE(STATUS "${_details}")
    ENDIF(${name}_FIND_REQUIRED)
  ENDIF(izenecma_KNOWLEDGE)

ENDIF(izenecma_FOUND)

MARK_AS_ADVANCED(IZENECMA izenecma_LIBRARY izenecma_KNOWLEDGE)
