include_directories(
     ${GlibEtcInstallRoot}/include/gstreamer-1.0
     ${GlibEtcInstallRoot}/include/libxml2
     ${CMAKE_SOURCE_DIR}/${XMLMM_DIR}
     ${CMAKE_SOURCE_DIR}/${XMLMM_DIR}/${EXTRA}/libxml++
     ../../gstreamer
)

#add_definitions(-DLIBXMLPP_BUILD -DGSTREAMERMM_BUILD -D_WINDLL -DGLIBMM_DLL -DGLIBMM_MSC) # -DG_HAVE_ISO_VARARGS "-DGST_MINI_OBJECT_FLAG_RESERVED1=(1<<1)")

#add_definitions(-DGLIBMM_MSC -DG_HAVE_ISO_VARARGS "-DGST_MINI_OBJECT_FLAG_RESERVED1=(1<<1)")

set(PLAYER_SRCS
player_window.cc
main.cc
)

add_executable(media_player_gtkmm ${PLAYER_SRCS})

target_link_libraries(media_player_gtkmm gtkmm-${GTKMM_VERSION} gstreamermm-${GSTREAMERMM_VERSION} sigc-${SIGC_VERSION} glibmm-${GLIBMM_VERSION} xmlpp-${XMLMM_VERSION} gstaudio-1.0 gstbase-1.0 gstvideo-1.0)

install(TARGETS media_player_gtkmm
LIBRARY DESTINATION "lib"
ARCHIVE DESTINATION "lib"
RUNTIME DESTINATION "bin")
