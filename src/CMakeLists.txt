find_package (PkgConfig)

pkg_check_modules (DEPS REQUIRED
  gtk+-3.0>=3.16
  libxml-2.0>=2.0
)

add_definitions (${DEPS_CFLAGS})
link_libraries (${DEPS_LIBRARIES})
link_directories (${DEPS_LIBRARY_DIRS})

find_package (Vala REQUIRED)

include (ValaVersion)
ensure_vala_version ("0.30.0" MINIMUM)

include (ValaPrecompile)
vala_precompile (VALA_C ${CMAKE_PROJECT_NAME}
  codav.vala
  group_header.vala
  transaction.vala
  transaction_list.vala
  window.vala
PACKAGES
  gtk+-3.0
  libxml-2.0
OPTIONS
  --thread
  --gresources=${CMAKE_SOURCE_DIR}/${PROJECT_NAME}.gresource.xml
)

include (GResource)
glib_compile_resources (GLIB_RESOURCES
  SOURCE
  ../data/${PROJECT_NAME}.gresource.xml
)

add_executable (${CMAKE_PROJECT_NAME} ${VALA_C} ${GLIB_RESOURCES})

install (FILES ${CMAKE_SOURCE_DIR}/data/codav.desktop DESTINATION share/applications)
install (FILES ${CMAKE_SOURCE_DIR}/data/codav.appdata.xml DESTINATION share/codav)
install (FILES ${CMAKE_SOURCE_DIR}/data/codav.png DESTINATION share/pixmaps)
install (TARGETS ${CMAKE_PROJECT_NAME} DESTINATION bin)
