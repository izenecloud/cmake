# MACRO_FIND_PACKAGE_WITH_CACHE(pkg name header [lib ...])
#

MACRO(MACRO_FIND_PACKAGE_WITH_CACHE pkg name header)

  SET(_${name}_IN_CACHE FALSE)

  IF(${name}_INCLUDE_DIR)
    SET(_${name}_IN_CACHE TRUE)
    FOREACH(_lib ${ARGN})
      IF(NOT ${name}_${_lib}_LIBRARY)
        SET(_${name}_IN_CACHE FALSE)
      ENDIF(NOT ${name}_${_lib}_LIBRARY)
    ENDFOREACH(_lib)

    IF(NOT _${name}_IN_CACHE)
      SET(${name}_INCLUDE_DIR) # remove it
    ENDIF(NOT _${name}_IN_CACHE)
  ENDIF(${name}_INCLUDE_DIR)

  IF(_${name}_IN_CACHE)

    MESSAGE(STATUS "${pkg} in cache")

    SET(${name}_FOUND TRUE)

    SET(${name}_INCLUDE_DIRS ${${name}_INCLUDE_DIR})
    SET(${name}_LIBRARIES ${${name}_LIBRARY})
    FOREACH(_lib ${ARGN})
      IF(${name}_${_lib}_LIBRARY)
        LIST(APPEND ${name}_LIBRARIES ${${name}_${_lib}_LIBRARY})
      ENDIF(${name}_${_lib}_LIBRARY)
    ENDFOREACH(_lib)
    IF (${name}_LIBRARIES)
      LIST(REMOVE_DUPLICATES ${name}_LIBRARIES)
    ENDIF (${name}_LIBRARIES)

  ELSE(_${name}_IN_CACHE)
    # should search it

    INCLUDE(MacroFindPackage)
    MACRO_FIND_PACKAGE(${pkg} ${name} ${header} ${ARGN})

    SET(_details "Find ${pkg}: failed.")
    IF(NOT ${name}_FOUND)
      IF(${name}_FIND_REQUIRED)
        MESSAGE(FATAL_ERROR "${_details}")
      ELSEIF(NOT ${name}_FIND_QUIETLY)
        MESSAGE(STATUS "${_details}")
      ENDIF(${name}_FIND_REQUIRED)
    ENDIF(NOT ${name}_FOUND)

  ENDIF(_${name}_IN_CACHE)

ENDMACRO(MACRO_FIND_PACKAGE_WITH_CACHE)