# MACRO_ADD_LIBRARY(name [component_name] [SRCS src1 src2 ...])
#
# The macro is a wrapper of ADD_LIBRARY. It add the library and install library
# in lib as component.
#
MACRO(MACRO_ADD_LIBRARY name component_name)
  SET(_srcs "${ARGN}")

  IF(${component_name} STREQUAL "SRCS")
    SET(component_name ${name})
  ELSE()
    LIST(REMOVE_AT _srcs 0)
  ENDIF()

  ADD_LIBRARY(${name} ${_srcs})
  INSTALL(TARGETS ${name}
    LIBRARY DESTINATION lib
    ARCHIVE DESTINATION lib
    COMPONENT ${component_name}
    )
ENDMACRO()
