# - Find kma installation.
#
# The following are set after the configuration is done:
#
# wisekma_FOUND        - Set to True if wisekma was found.
# wisekma_INCLUDE_DIRS - Include directories
# wisekma_LIBRARIES    - Libraries required to link
# wisekma_KNOWLEDGE    - Path to kma knowledge directory
# User can change the following variable in cache to indicate where
# lalib is installed.
#
# WISEKMA            - It can also be set as environemnt variable. The cmake
#                      variable can override the setting in environement
#                      variable. It should be set to the install root directory
#                      of kma. The header files should be in
#                      ${WISEKMA}/interface and libraries are in ${WISEKMA}/
#
# wisekma_INCLUDE_DIR
# wisekma_LIBRARY    - Specify include dir and library directly.
#

# Setup lalib_ROOT_DIR according to LALIB
IF(WISEKMA)
  SET(wisekma_ROOT_DIR ${WISEKMA})
ELSE(WISEKMA)
  SET(wisekma_ROOT_DIR $ENV{WISEKMA})
ENDIF(WISEKMA)

INCLUDE(MacroFindPackageWithCache)
MACRO_FIND_PACKAGE_WITH_CACHE(kma wisekma wk_analyzer.h wko)

IF(wisekma_FOUND)

  SET(_knowledge_root ${wisekma_ROOT_DIR})
  FOREACH(_dir ${wisekma_INCLUDE_DIRS})
    GET_FILENAME_COMPONENT(_root "${_dir}" PATH)
    IF(IS_DIRECTORY "${_root}")
      LIST(APPEND _knowledge_root "${_root}")
    ENDIF(IS_DIRECTORY "${_root}")
  ENDFOREACH(_dir)

  MESSAGE(STATUS "Try to find wisekma knowledge in ${_knowledge_root}")

  FIND_PATH(wisekma_KNOWLEDGE wko.klg
    PATHS ${_knowledge_root}
    PATH_SUFFIXES knowledge
    NO_DEFAULT_PATH
    )

  IF(wisekma_KNOWLEDGE)
    MESSAGE(STATUS "  Found: ${wisekma_KNOWLEDGE}")
  ELSE(wisekma_KNOWLEDGE)
    SET(wisekma_FOUND FALSE)
    SET(wisekma_INCLUDE_DIR)

    SET(_details "  Failed.")
    IF(${name}_FIND_REQUIRED)
      MESSAGE(FATAL_ERROR "${_details}")
    ELSEIF(NOT ${name}_FIND_QUIETLY)
      MESSAGE(STATUS "${_details}")
    ENDIF(${name}_FIND_REQUIRED)
  ENDIF(wisekma_KNOWLEDGE)

ENDIF(wisekma_FOUND)

MARK_AS_ADVANCED(WISEKMA wisekma_LIBRARY wisekma_KNOWLEDGE)
