FIND_PATH(XML2_INCLUDE_DIR libxml/xmlmemory.h
  $ENV{XML2_DIR}/include/libxml2
  $ENV{XML2_HOME}/include/libxml2
  /usr/include/libxml2
  /usr/local/include/libxml2
  )
FIND_LIBRARY(XML2_LIBRARY xml2
  $ENV{XML2_DIR}/lib
  $ENV{XML2_HOME}/lib
  /usr/lib
  /usr/local/lib
  )

IF(XML2_LIBRARY)
  SET( XML2_FOUND TRUE )
  SET( XML2_LIBRARIES ${XML2_LIBRARY} )
ENDIF(XML2_LIBRARY)

MARK_AS_ADVANCED(
  XML2_INCLUDE_DIR
  XML2_LIBRARIES
  XML2_LIBRARY
  )
