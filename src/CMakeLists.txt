find_package (PkgConfig)

# Add all your dependencies to the list below
pkg_check_modules (DEPS_PLUG REQUIRED gthread-2.0 gtk+-3.0 switchboard-2.0 glib-2.0 gio-2.0 granite)
pkg_check_modules (DEPS_WING REQUIRED gthread-2.0 gtk+-3.0 wingpanel-2.0 glib-2.0 gio-2.0 granite)
pkg_check_modules (DEPS_DAEMON REQUIRED glib-2.0 gio-2.0 granite)

add_definitions (${DEPS_PLUG_CFLAGS} ${DEPS_WING_CFLAGS} ${DEPS_DAEMON_CFLAGS})
link_directories (${DEPS_PLUG_LIBRARY_DIRS} ${DEPS_WING_LIBRARY_DIRS} ${DEPS_DAEMON_LIBRARY_DIRS})

find_package (Vala REQUIRED)
include (ValaVersion)
ensure_vala_version ("0.22.0" MINIMUM)

include (ValaPrecompile)

# Build Plug
vala_precompile (PLUG_VALA_C ${CMAKE_PROJECT_NAME}-plug
    Plug.vala
    Services/Settings.vala
    Widgets/General.vala
    Widgets/Schedule.vala
    Widgets/SettingLabel.vala
    Widgets/Temperature.vala
    ${CMAKE_CURRENT_BINARY_DIR}/config.vala
PACKAGES
    gtk+-3.0
    switchboard-2.0
    granite
OPTIONS
    --thread
)
add_library (${CMAKE_PROJECT_NAME}-plug MODULE ${PLUG_VALA_C})
target_link_libraries (${CMAKE_PROJECT_NAME}-plug ${DEPS_PLUG_LIBRARIES})

# Build Wingpanel Indicator
vala_precompile (WING_VALA_C ${CMAKE_PROJECT_NAME}-wing
    Indicator.vala
    Services/Settings.vala
    Widgets/InformationGrid.vala
    Widgets/SettingLabel.vala
    ${CMAKE_CURRENT_BINARY_DIR}/config.vala
PACKAGES
    gtk+-3.0
    wingpanel-2.0
    granite
OPTIONS
    --thread
)
add_library (${CMAKE_PROJECT_NAME}-wing MODULE ${WING_VALA_C})
target_link_libraries (${CMAKE_PROJECT_NAME}-wing ${DEPS_WING_LIBRARIES})

# Build Redshift Daemon
vala_precompile (DAEMON_VALA_C ${CMAKE_PROJECT_NAME}-daemon
    Daemon/Child.vala
    Daemon/RedshiftDaemon.vala
    Services/Settings.vala
PACKAGES
    glib-2.0
    gio-2.0
    granite
)
add_executable (${CMAKE_PROJECT_NAME}-daemon ${DAEMON_VALA_C})
target_link_libraries (${CMAKE_PROJECT_NAME}-daemon ${DEPS_DAEMON_LIBRARIES})

# Installation
install (TARGETS ${CMAKE_PROJECT_NAME}-plug DESTINATION ${PLUG_PKGDATADIR})
install (TARGETS ${CMAKE_PROJECT_NAME}-wing DESTINATION ${WING_PKGDATADIR})
install (TARGETS ${CMAKE_PROJECT_NAME}-daemon RUNTIME DESTINATION bin)
