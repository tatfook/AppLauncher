# Author: LiXizhi
# Email: lixizhi@yeah.net
# Date: 2017.10.3
# Note: see NPLRuntime/cmakelist.txt

cmake_minimum_required (VERSION 2.6)

project (LAUNCHER)

# this is the directory to keep all binary
set(APP_BIN_DIR   ${LAUNCHER_SOURCE_DIR}/release/)

set(NPLRuntime_SOURCE_DIR   ${LAUNCHER_SOURCE_DIR}/NPLRuntime)
set(ParaEngineClient_SOURCE_DIR   ${NPLRuntime_SOURCE_DIR}/Client/trunk/ParaEngineClient)

set(Boost_USE_MULTITHREADED ON)
set(Boost_USE_STATIC_LIBS   ON)
set(Boost_USE_STATIC_RUNTIME ON)

# Add more boost components here
find_package( Boost 1.61 REQUIRED COMPONENTS thread date_time filesystem system chrono signals regex serialization iostreams) 

# main NPL runtime and override default options to generate only static libs and skip some unused library
option(PARAENGINE_CLIENT_DLL "Generate Dll Or Exe" ON)
option(NPLRUNTIME_STATIC_LIB "static lib or not" ON)
option(NPLRUNTIME_LUAJIT21 "build luajit21 support GC64" OFF)
option(NPLRUNTIME_LUAJIT20   "build luajit2.0.4" OFF)
option(NPLRUNTIME_LUA51   "build lua5.1.5 with coco" ON)
option(NPLRUNTIME_SUPPORT_FBX "support FBX files (assimp)" OFF)
option(NPLRUNTIME_PHYSICS "include physics" OFF)

option(MAIN_PACKAGE_EMBEDDED "main package embedded" OFF)

add_subdirectory (${LAUNCHER_SOURCE_DIR}/NPLRuntime/Client)

# All NPL script package to be embedded to the executable
add_subdirectory (${LAUNCHER_SOURCE_DIR}/npl_packages/AppLauncher)
add_subdirectory (${LAUNCHER_SOURCE_DIR}/npl_packages/AutoUpdater)
IF(MAIN_PACKAGE_EMBEDDED)
	add_subdirectory (${LAUNCHER_SOURCE_DIR}/cmakes/main)
ENDIF(MAIN_PACKAGE_EMBEDDED)

# main executable
add_subdirectory (${LAUNCHER_SOURCE_DIR}/src)

