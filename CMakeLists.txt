# Author: LiXizhi
# Email: lixizhi@yeah.net
# Date: 2016.4.30
# Note: see NPLRuntime/cmakelist.txt

cmake_minimum_required (VERSION 2.6)

project (LAUNCHER)

# this is the directory to keep all binary
set(OUTPUT_BIN_DIR   ${LAUNCHER_SOURCE_DIR}/release/)

set(NPLRuntime_SOURCE_DIR   ${LAUNCHER_SOURCE_DIR}/NPLRuntime)
set(ParaEngineClient_SOURCE_DIR   ${NPLRuntime_SOURCE_DIR}/Client/trunk/ParaEngineClient)

set(Boost_USE_MULTITHREADED ON)
set(Boost_USE_STATIC_LIBS   ON)
set(Boost_USE_STATIC_RUNTIME ON)

# Add more boost components here
find_package( Boost 1.61 REQUIRED COMPONENTS thread date_time filesystem system chrono signals regex serialization iostreams) 

add_subdirectory (${LAUNCHER_SOURCE_DIR}/src)
# main NPL runtime
# add_subdirectory (${LAUNCHER_SOURCE_DIR}NPLRuntime ${LAUNCHER_BINARY_DIR}/NPLRuntime)