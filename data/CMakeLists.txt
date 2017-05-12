install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/${CMAKE_PROJECT_NAME}-daemon.desktop DESTINATION /etc/xdg/autostart)
install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/com.github.sgpthomas.elementary-redshift.appdata.xml DESTINATION ${DATADIR}/metainfo)
install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/symbolic/redshift-off-symbolic.svg DESTINATION ${DATADIR}/icons/hicolor/symbolic/apps/)
install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/symbolic/redshift-on-symbolic.svg DESTINATION ${DATADIR}/icons/hicolor/symbolic/apps/)
