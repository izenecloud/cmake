# - Find ilplib installation.
#
# The following are set after the configuration is done:
#
# ilplib_FOUND        - Set to True if izenecma was found.
# ilplib_INCLUDE_DIRS - Include directories
# ilplib_LIBRARIES    - Libraries required to link
# ilplib_LANGUAGEIDENTIFIER_DB    - Path to ilp language identifier database directory
#
# ILPLIB            - It can also be set as environemnt variable. The cmake
#                      variable can override the setting in environement
#                      variable. It should be set to the install root directory
#                      of cma. The header files should be in
#                      ${ILPLIB}/include and libraries are in ${ILPLIB}/lib
#
# ilplib_INCLUDE_DIR
# ilplib_LIBRARY    - Specify include dir and library directly.
#

# Setup ilplib_ROOT_DIR according to ILPLIB
IF(ILPLIB)
  SET(ilplib_ROOT_DIR ${ILPLIB})
ELSE(ILPLIB)
  SET(ilplib_ROOT_DIR $ENV{ILPLIB})
ENDIF(ILPLIB)

INCLUDE(MacroFindPackageWithCache)
INCLUDE(MacroFindPackageWithCache)
#MACRO_FIND_PACKAGE_WITH_CACHE(ilplib ilplib langid/analyzer.h ${ilplib_FIND_COMPONENTS})
MACRO_FIND_PACKAGE_WITH_CACHE(ilplib ilplib langid/analyzer.h ilplib)

IF(ilplib_FOUND)
  # set the knowledge directly
  SET(ilplib_LANGUAGEIDENTIFIER_DB ${ilplib_ROOT_DIR}/db/langid)

  IF(ilplib_LANGUAGEIDENTIFIER_DB)
    MESSAGE(STATUS "  Found: ${ilplib_LANGUAGEIDENTIFIER_DB}")
  ELSE(ilplib_LANGUAGEIDENTIFIER_DB)
    SET(ilplib_FOUND FALSE)
    SET(ilplib_INCLUDE_DIR)

    SET(_details "  Failed.")
    IF(${name}_FIND_REQUIRED)
      MESSAGE(FATAL_ERROR "${_details}")
    ELSEIF(NOT ${name}_FIND_QUIETLY)
      MESSAGE(STATUS "${_details}")
    ENDIF(${name}_FIND_REQUIRED)
  ENDIF(ilplib_LANGUAGEIDENTIFIER_DB)

ENDIF(ilplib_FOUND)

#MARK_AS_ADVANCED(ILPLIB ilplib_LIBRARY ilplib_LANGUAGEIDENTIFIER_DB)
MARK_AS_ADVANCED(ILPLIB)
