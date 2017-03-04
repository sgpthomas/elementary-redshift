# This a sample CMakeLists.txt for compiling plug for Switchboard
# http://elementaryos.org/docs/developer-guide/cmake 

cmake_minimum_required (VERSION 2.8)
cmake_policy (VERSION 2.8)

# Set the Category of the Plug, one of:
# personal, hardware, network, system
set (PLUGCATEGORY "personal")
# Set the Title to use for the Plug in the Overview and in the Titlebar
set (PLUGTITLE "Redshift")
# Set the version for the plug
set (VERSION "0.1")

# Set the Title to use for the Indicator (May be used in future features)
set (INDICATORTITLE "Elementary Redshift")
# The description of what your Indicator is
set (INDICATORDESCRIPTION "Adjusts the color temperature of your screen according to your surroundings")

# Set the Name of the plug, should be an executable command, lowercase, no spaces 
project (elementary-redshift)

set (PREFIX ${CMAKE_INSTALL_PREFIX})
set (DATADIR ${CMAKE_INSTALL_PREFIX}/share)
set (PKG_DATADIR ${DATADIR}/${CMAKE_PROJECT_NAME})
set (DOLLAR "$")

#########################################################
# Only alter stuff below if you know what you are doing #
#########################################################

include (GNUInstallDirs)
set (PLUG_DATADIR "${CMAKE_INSTALL_FULL_LIBDIR}/switchboard")
set (PLUG_PKGDATADIR "${PLUG_DATADIR}/${PLUGCATEGORY}/${CMAKE_PROJECT_NAME}")

set (WING_DATADIR "${CMAKE_INSTALL_FULL_LIBDIR}/wingpanel")
set (WING_PKGDATADIR "${WING_DATADIR}/${CMAKE_PROJECT_NAME}")

set (PREFIX ${CMAKE_INSTALL_PREFIX})
set (DATADIR ${CMAKE_INSTALL_PREFIX}/share)
set (DAEMON_DATADIR ${DATADIR}/${CMAKE_PROJECT_NAME}-daemon)

set (GETTEXT_PACKAGE "${CMAKE_PROJECT_NAME}")

list (APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake)

# Configure file
configure_file (${CMAKE_SOURCE_DIR}/config.vala.cmake ${CMAKE_BINARY_DIR}/src/config.vala)
configure_file (${CMAKE_SOURCE_DIR}/data/redshift-daemon.desktop.in ${CMAKE_SOURCE_DIR}/data/redshift-daemon.desktop)

# some other necessary things
add_definitions (-DGETTEXT_PACKAGE=\"${GETTEXT_PACKAGE}\")
add_definitions (-DVALA_VERSION="${VALA_SHORTVER}")
add_definitions (-w)

set(NORMAL_CFLAGS ${DEPS_CFLAGS} ${LIBSOURCE_CFLAGS} ${GCONF_CFLAGS})
set(NORMAL_LINK_DIRS ${DEPS_LIBRARY_DIRS} ${LIBSOURCE_LIBRARY_DIRS} ${GCONF_LIBRARY_DIRS})
set(NORMAL_LIBRARIES ${DEPS_LIBRARIES} ${LIBSOURCE_LIBRARIES} ${GCONF_LIBRARIES})

add_definitions (${DEPS_CFLAGS} ${LIBSOURCE_CFLAGS} ${GCONF_CFLAGS})
link_libraries (${DEPS_LIBRARIES} ${LIBSOURCE_LIBRARIES} ${GCONF_LIBRARIES})
link_directories (${DEPS_LIBRARY_DIRS} ${LIBSOURCE_LIBRARY_DIRS} ${GCONF_LIBRARY_DIRS})

#include source path
include_directories(${CMAKE_BINARY_DIR}/src)

# Add 'make dist' command for creating release tarball
set (CPACK_PACKAGE_VERSION ${VERSION})
set (CPACK_SOURCE_GENERATOR "TGZ")
set (CPACK_SOURCE_PACKAGE_FILE_NAME "${CMAKE_PROJECT_NAME}-${CPACK_PACKAGE_VERSION}")
set (CPACK_SOURCE_IGNORE_FILES "/build/;/.bzr/;/.bzrignore;~$;${CPACK_SOURCE_IGNORE_FILES}")
include (CPack)
add_custom_target (dist COMMAND ${CMAKE_MAKE_PROGRAM} package_source)

# Traslation stuff
# add_subdirectory (po)

add_subdirectory(src)
add_subdirectory(schemas)
add_subdirectory(data)

# uninstall command / target
configure_file(
    "${CMAKE_CURRENT_SOURCE_DIR}/cmake_uninstall.cmake.in"
    "${CMAKE_CURRENT_BINARY_DIR}/cmake_uninstall.cmake"
    IMMEDIATE @ONLY)

add_custom_target(uninstall
    COMMAND ${CMAKE_COMMAND} -P ${CMAKE_CURRENT_BINARY_DIR}/cmake_uninstall.cmake)
