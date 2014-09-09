# MACRO_CHECK_SHOULD_BUILD(name [assert ...])
#
# The component should be built if all assertions succeed.
#
# And the check also respects two variables:
#
# BUILD_COMPONENTS     - If it is not empty, then only components listed here
#                        and not in NON_BUILD_COMPONENTS will be
#                        built. Otherwise all components not listed in
#                        NON_BUILD_COMPONENTS will be built.
#
# NON_BUILD_COMPONENTS - Components should not be built. It can override the
#                        settings in BUILD_COMPONENTS
#
# Variable ${name}_SHOULD_BUILD is set after find_package()
#
# Global properties BUILD_COMPONENTS and NON_BUILD_COMPONENTS are updated for
# the real build components and non-build components
#

MACRO(MACRO_CHECK_SHOULD_BUILD name)

  SET(_failed_assertions)

  # Check whether in BUILD_COMPONENTS.
  # Fail if list is not empty and current component is not in the list
  IF(BUILD_COMPONENTS)
    LIST(FIND BUILD_COMPONENTS ${name} _index)
    IF(_index LESS 0)
      LIST(APPEND _failed_assertions "in BUILD_COMPONENTS")
    ENDIF(_index LESS 0)
  ENDIF(BUILD_COMPONENTS)

  # Check whether in NON_BUILD_COMPONENTS
  # Fail if in the list
  LIST(FIND NON_BUILD_COMPONENTS ${name} _index)
  IF(NOT _index LESS 0)
    LIST(APPEND _failed_assertions "not in NON_BUILD_COMPONENTS")
  ENDIF(NOT _index LESS 0)

  FOREACH(_assert ${ARGN})
    IF(NOT ${_assert})
      LIST(APPEND _failed_assertions "${_assert}")
    ENDIF(NOT ${_assert})
  ENDFOREACH(_assert ${ARGN})

  SET(${name}_SHOULD_BUILD TRUE)
  IF(_failed_assertions)
    SET(${name}_SHOULD_BUILD FALSE)
    SET(_first TRUE)
    MESSAGE(STATUS "!!WARNING: ${name} not build because of failed assertions:")
    FOREACH(_failed ${_failed_assertions})
      MESSAGE(STATUS "  ${_failed}")
    ENDFOREACH(_failed)
  ENDIF(_failed_assertions)

  IF(${name}_SHOULD_BUILD)
    SET_PROPERTY(GLOBAL APPEND PROPERTY BUILD_COMPONENTS ${name})
  ELSE(${name}_SHOULD_BUILD)
    SET_PROPERTY(GLOBAL APPEND PROPERTY NON_BUILD_COMPONENTS ${name})
  ENDIF(${name}_SHOULD_BUILD)

ENDMACRO(MACRO_CHECK_SHOULD_BUILD)
