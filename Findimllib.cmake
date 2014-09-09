# - Find mllib installation.
#
# The following are set after the configuration is done:
#
# mllib_FOUND        - Set to True if mllib was found.
# mllib_INCLUDE_DIRS - Include directories
# mllib_LIBRARIES    - Libraries required to link
#
# User can change the following variable in cache to indicate where
# mllib is installed.
#
# MLLIB            - It can also be set as environemnt variable. The cmake
#                      variable can override the setting in environement
#                      variable. It should be set to the install root directory
#                      of lalib. The header files should be in
#                      ${MLLIB}/include and libraries are in ${MLLIB}/lib
#
# mllib_INCLUDE_DIR
# mllib_LIBRARY     - Specify include dir and library directly.
#

# Setup lalib_ROOT_DIR according to LALIB
IF(IMLLIB)
  SET(imllib_ROOT_DIR ${IMLLIB})
ELSE(IMLLIB)
  SET(imllib_ROOT_DIR $ENV{IMLLIB})
ENDIF(IMLLIB)

INCLUDE(MacroFindPackageWithCache)
INCLUDE(MacroFindPackageWithCache)

MACRO_FIND_PACKAGE_WITH_CACHE(
  imllib imllib ml/ml_common.h imllib 
  )

MARK_AS_ADVANCED(IMLLIB)

