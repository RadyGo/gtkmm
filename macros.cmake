# this will create hard links from gtk+ submodule folders for all
# CMakeLists.txt files in gtk+.local
macro(MKLINK FROM TO)
file(GLOB_RECURSE CMAKE_GTK_FILES
     RELATIVE ${CMAKE_CURRENT_SOURCE_DIR}/${FROM}
     ${FROM}/*CMakeLists.txt ${FROM}/CMakeLists.txt) 
foreach(FILE ${CMAKE_GTK_FILES})
  set(LINK ${CMAKE_CURRENT_SOURCE_DIR}/${TO}/${FILE})
  file(TO_NATIVE_PATH ${LINK} LINK)
  if(NOT EXISTS ${LINK})
    file(TO_NATIVE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/${FROM}/${FILE} TARGET)
    if(${CMAKE_SYSTEM_VERSION} VERSION_LESS "5.2") #XP is 5.1
      execute_process(COMMAND ln "${TARGET}" "${LINK}")
    elseif()
      execute_process(COMMAND cmd /C mklink /H "${LINK}" "${TARGET}")
    endif()
  endif()
endforeach(FILE)
endmacro()

macro(GET URL)
get_filename_component(FILE ${URL} NAME)
string(REGEX REPLACE "(.+)-.+" "\\1" NAME ${FILE})
string(REGEX REPLACE ".+-([0-9]+)[.]([0-9]+)[.]([0-9]+)[.].+" "\\1.\\2.\\3" VERSION ${FILE})
if(NOT EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/${NAME}-${VERSION})
  message("Source directory ${NAME}-${VERSION} is missing")
  # Download stuff
  if(NOT EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/${FILE})
    message("Downloading ${URL}")
    file(DOWNLOAD ${URL}
    ${CMAKE_CURRENT_SOURCE_DIR}/${FILE} SHOW_PROGRESS)
  endif()
  string(REGEX MATCH "tar.gz$" GZ ${FILE})
  message("Unpacking ${FILE}")
  if(${GZ})
    execute_process(COMMAND ${CMAKE_COMMAND} -E tar xjz ${FILE}
    WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR})
  else()
    execute_process(COMMAND ${CMAKE_COMMAND} -E tar xjf ${FILE}
    WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR})
  endif()
endif()
MKLINK(${NAME} ${NAME}-${VERSION})
endmacro()

macro(VERSION DIR VER)
string(REGEX REPLACE ".+-([0-9]+)[.]([0-9]+)[.].+" "\\1.\\2" ${VER} ${DIR})
endmacro()

MACRO (TODAY RESULT)
    IF (WIN32)
        EXECUTE_PROCESS(COMMAND "cmd" "/C" "date /T" OUTPUT_VARIABLE ${RESULT})
        string(REGEX REPLACE ".*(..)/(..)/(....).*" "\\3\\2\\1" ${RESULT} ${${RESULT}})
    ELSEIF(UNIX)
        EXECUTE_PROCESS(COMMAND "date" "+%d/%m/%Y" OUTPUT_VARIABLE ${RESULT})
        string(REGEX REPLACE "(..)/(..)/(....).*" "\\3\\2\\1" ${RESULT} ${${RESULT}})
    ELSE (WIN32)
        MESSAGE(SEND_ERROR "date not implemented")
        SET(${RESULT} 000000)
    ENDIF (WIN32)
ENDMACRO (TODAY)

# should have 7z, patch, and python 3.2 in the path
macro(OBS)
execute_process(COMMAND C:\\Python32\\python.exe download-mingw-rpm.py --no-clean --deps libxml2 libxml2-devel atk atk-devel libcairo2 libcairo-gobject2 cairo-devel pango pango-devel gstreamer gstreamer-devel gdk-pixbuf gdk-pixbuf-devel
WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR})
execute_process(COMMAND C:\\Python32\\python.exe a2lib.py
WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR})
execute_process(COMMAND patch -p0 --binary -i patches\\fontconfig_h.patch
WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR})
execute_process(COMMAND patch -p0 --binary -i patches\\glib_gmessages_h.patch
WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR})
endmacro()
