project (com.github.cimm.codav)
cmake_minimum_required (VERSION 2.8)

list (APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake)

set (DATADIR "${CMAKE_INSTALL_PREFIX}/share")

set (PKGDATADIR "${DATADIR}/com.github.cimm.codav")

set (EXEC_NAME "com.github.cimm.codav")
set (RELEASE_NAME "Ex nihilo")
set (VERSION "0.1")
set (VERSION_INFO "Ex nihilo")

find_package(PkgConfig)

pkg_check_modules(DEPS REQUIRED gtk+-3.0)

add_definitions(${DEPS_CFLAGS})
link_libraries(${DEPS_LIBRARIES})
link_directories(${DEPS_LIBRARY_DIRS})

find_package(Vala REQUIRED)
include(ValaVersion)
ensure_vala_version("0.26.2" MINIMUM)

include(ValaPrecompile)
vala_precompile(VALA_C ${EXEC_NAME}
    src/codav.vala
    src/group_header.vala
    src/transaction_list.vala
    src/transaction.vala
    src/window.vala

PACKAGES
    gtk+-3.0
)

add_executable(${EXEC_NAME} ${VALA_C})

install (TARGETS ${EXEC_NAME} RUNTIME DESTINATION bin)

install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/data/com.github.cimm.codav.desktop DESTINATION ${DATADIR}/applications/)

install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/data/com.github.cimm.codav.appdata.xml DESTINATION ${DATADIR}/metainfo/)
