# MACRO_SET_BUILD_TYPES(name flags description [name flags description])
#
# The macro is disabled by setting BUILD_FLAGS_HAS_BEEN_CUSTOMIZED
#

MACRO(MACRO_SET_BUILD_TYPES)

  IF(NOT BUILD_FLAGS_HAS_BEEN_CUSTOMIZED)

    # built-in types
    IF (NOT CMAKE_CONFIGURATION_TYPES)
      SET(CMAKE_CONFIGURATION_TYPES RelWithDebInfo Release MinSizeRel Debug)
    ENDIF (NOT CMAKE_CONFIGURATION_TYPES)

    SET(_name)
    SET(_flags)
    SET(_desc)

    FOREACH(_arg ${ARGN})
      IF(NOT _name)
        SET(_name "${_arg}")
      ELSEIF(NOT _flags)
        SET(_flags "${_arg}")
      ELSE(NOT _name)
        SET(_desc "${_arg}")

        IF(_name)
          IF(NOT _desc)
            SET(_desc "${_name}")
          ENDIF(NOT _desc)

          STRING(TOUPPER "${_name}" _upper_name)
          SET(CMAKE_CXX_FLAGS_${_upper_name} "${_flags}" CACHE STRING "${_desc}" FORCE)
          LIST(APPEND CMAKE_CONFIGURATION_TYPES "${_name}")
          MARK_AS_ADVANCED(CMAKE_CXX_FLAGS_${_upper_name})

          SET(_name)
          SET(_flags)
          SET(_desc)
        ENDIF(_name)
      ENDIF(NOT _name)
    ENDFOREACH(_arg ${ARGN})

    SET(BUILD_FLAGS_HAS_BEEN_CUSTOMIZED yes CACHE INTERNEL "build falgs has been customized?")

    LIST(SORT CMAKE_CONFIGURATION_TYPES)
    LIST(REMOVE_DUPLICATES CMAKE_CONFIGURATION_TYPES)
    SET(CMAKE_CONFIGURATION_TYPES ${CMAKE_CONFIGURATION_TYPES} "Debugfull" "Profile" CACHE STRING "avalable build types" FORCE)
    MARK_AS_ADVANCED(CMAKE_CONFIGURATION_TYPES)

  ENDIF(NOT BUILD_FLAGS_HAS_BEEN_CUSTOMIZED)

  FOREACH(_type ${CMAKE_CONFIGURATION_TYPES})
    STRING(TOUPPER "${_type}" _upper_type)
    SET(CMAKE_C_FLAGS_${_upper_type} "${CMAKE_CXX_FLAGS_${_upper_type}}" CACHE STRING "_upper_type" FORCE)
  ENDFOREACH(_type)

ENDMACRO(MACRO_SET_BUILD_TYPES)
