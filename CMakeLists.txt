cmake_minimum_required (VERSION 2.6)
cmake_policy (VERSION 2.6)

project (codav)

include (GNUInstallDirs)

set (DATADIR "${CMAKE_INSTALL_PREFIX}/share")
set (PKGDATADIR "${DATADIR}/${CMAKE_PROJECT_NAME}")

list (APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake)

add_definitions (-w) # remove to enable compiler warnings

add_subdirectory (src)
