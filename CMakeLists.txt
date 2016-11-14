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

#########################################################
# Only alter stuff below if you know what you are doing #
#########################################################

include (GNUInstallDirs)
set (PLUG_DATADIR "${CMAKE_INSTALL_FULL_LIBDIR}/switchboard")
set (PLUG_PKGDATADIR "${PLUG_DATADIR}/${PLUGCATEGORY}/${CMAKE_PROJECT_NAME}")

set (WING_DATADIR "${CMAKE_INSTALL_FULL_LIBDIR}/wingpanel")
set (WING_PKGDATADIR "${WING_DATADIR}/${CMAKE_PROJECT_NAME}")

set (GETTEXT_PACKAGE "${CMAKE_PROJECT_NAME}")

list (APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake)

# Configure file
configure_file (${CMAKE_SOURCE_DIR}/config.vala.cmake ${CMAKE_BINARY_DIR}/src/config.vala)
add_definitions (-DGETTEXT_PACKAGE=\"${GETTEXT_PACKAGE}\")

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

# uninstall command / target
configure_file(
    "${CMAKE_CURRENT_SOURCE_DIR}/cmake_uninstall.cmake.in"
    "${CMAKE_CURRENT_BINARY_DIR}/cmake_uninstall.cmake"
    IMMEDIATE @ONLY)

add_custom_target(uninstall
    COMMAND ${CMAKE_COMMAND} -P ${CMAKE_CURRENT_BINARY_DIR}/cmake_uninstall.cmake)