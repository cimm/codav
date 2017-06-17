project (codav)
cmake_minimum_required (VERSION 2.8)

list (APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake/vala)

set (DATADIR "${CMAKE_INSTALL_PREFIX}/share")
set (PKGDATADIR "${DATADIR}/codav")
set (GETTEXT_PACKAGE "codav")
set (RELEASE_NAME "Ex nihilo")
set (VERSION "0.1")
set (VERSION_INFO "Development")

list (APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake)

set (ARCHIVE_NAME codav-${VERSION})

add_custom_target (uninstall "${CMAKE_COMMAND}" -P
    "${CMAKE_SOURCE_DIR}/cmake/uninstall.cmake")

find_package(PkgConfig)

pkg_check_modules(DEPS REQUIRED
        gtk+-3.0>=3.16
        libxml-2.0>=2.0)

add_definitions(${DEPS_CFLAGS})

link_libraries(${DEPS_LIBRARIES})
link_directories(${DEPS_LIBRARY_DIRS})

find_package(Vala REQUIRED)

include(ValaVersion)
ensure_vala_version("0.34.0" MINIMUM)

include(ValaPrecompile)
vala_precompile(VALA_C
        src/codav.vala
        src/group_header.vala
        src/transaction.vala
        src/transaction_list.vala
        src/window.vala
PACKAGES
        gtk+-3.0
        libxml-2.0
OPTIONS
        --thread
)

add_definitions(${CFLAGS} -Wall -Winit-self -Wwrite-strings -Wunreachable-code -Wstrict-prototypes)
add_executable(codav ${VALA_C})

install (TARGETS codav RUNTIME DESTINATION bin)
install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/data/codav.desktop DESTINATION share/applications)
install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/data/codav.appdata.xml DESTINATION share/appdata)
