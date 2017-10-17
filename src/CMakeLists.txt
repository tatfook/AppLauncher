# Author: LiXizhi
# Company: tatfook network
# Date: 2017.10.2
# Desc: All-in-one application for app launching and updating

project (AppLauncher)

# The version number.
set (AppLauncher_VERSION_MAJOR 1)
set (AppLauncher_VERSION_MINOR 0)

##############################  
# source code
SET(AppLauncher_SRCS
	AppLauncher.rc
	res/app.ico
	resource.h
	AppLauncher.cpp		AppLauncher.h
	../README.md
	../build_win32.bat
)

##############################  
# installer files
file (GLOB AppLauncher_install_FILES ${PROJECT_SOURCE_DIR}/*.bat)
SOURCE_GROUP("Installer" FILES ${AppLauncher_install_FILES})
list(APPEND AppLauncher_SRCS ${AppLauncher_install_FILES})


##############################  
# embedded files
set(EmbeddedResource_FILES)
embed_resources_abs(MyResource "${LauncherScript_BINARY_DIR}/AppLauncher.zip" "${LauncherScript_BINARY_DIR}/AppLauncherTexture.zip" "${AutoUpdater_BINARY_DIR}/AutoUpdater.zip")
list(APPEND EmbeddedResource_FILES ${MyResource})
list(APPEND AppLauncher_SRCS ${EmbeddedResource_FILES})
SOURCE_GROUP("ResEmbedded" FILES ${EmbeddedResource_FILES})


##############################
# add the binary tree to the search path for include files
include_directories("${Boost_INCLUDE_DIRS}")
include_directories("${PROJECT_BINARY_DIR}")
include_directories("${ParaEngineClient_SOURCE_DIR}")
include_directories("${ParaEngineClient_SOURCE_DIR}/Core")

IF(WIN32)
	ADD_DEFINITIONS(-D_WIN32_WINNT=0x0501)
ENDIF(WIN32)
ADD_DEFINITIONS(-DNPLRUNTIME_STATICLIB)
ADD_DEFINITIONS(-DCURL_STATICLIB)
ADD_DEFINITIONS(-DSQLITE_STATICLIB)
ADD_DEFINITIONS(-DLUA_STATICLIB)

IF(MSVC)
	# statically link MSVC to reduce dependancies
	foreach(flag_var CMAKE_CXX_FLAGS CMAKE_CXX_FLAGS_DEBUG CMAKE_CXX_FLAGS_RELEASE CMAKE_CXX_FLAGS_MINSIZEREL CMAKE_CXX_FLAGS_RELWITHDEBINFO CMAKE_C_FLAGS CMAKE_C_FLAGS_DEBUG CMAKE_C_FLAGS_RELEASE CMAKE_C_FLAGS_MINSIZEREL CMAKE_C_FLAGS_RELWITHDEBINFO)
	 	if(${flag_var} MATCHES "/MD")
	 		string(REGEX REPLACE "/MD" "/MT" ${flag_var} "${${flag_var}}")
	 	endif(${flag_var} MATCHES "/MD")
	 	if(${flag_var} MATCHES "/MDd")
	 		string(REGEX REPLACE "/MDd" "/MTd" ${flag_var} "${${flag_var}}")
		endif(${flag_var} MATCHES "/MDd")
	endforeach(flag_var)
	
	# /GR- Remove RTTI to miminize the executable size
	# /Zi generate program database (PDB symbol files even in release build)
	SET(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} /Zi /GR-")
	SET(CMAKE_C_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE} /Zi")
	# To turn size optimisations on again
	SET(CMAKE_EXE_LINKER_FLAGS_RELEASE "${CMAKE_EXE_LINKER_FLAGS_RELEASE} /opt:ref /DEBUG /LARGEADDRESSAWARE")
ENDIF()

# Link the executable to the libraries. 
link_directories(${NPLRUNTIME_LINK_DIRECTORIES})

# add the executable
add_executable(AppLauncher ${AppLauncher_SRCS})

# When this property is set to true the executable when linked on Windows will be created with a WinMain() entry point instead of of just main().
set_target_properties(AppLauncher PROPERTIES WIN32_EXECUTABLE true)
# set_target_properties(AppLauncher PROPERTIES LINK_FLAGS /MANIFESTUAC:"level='requireAdministrator' uiAccess='false'")
# Since we are installing to local app data dir from now on, we will only need medium integrity level to run the app, however protected mode IE only gives use low IL, in which we need to write to registry to promote this process to medium IL. 
# set_target_properties(AppLauncher PROPERTIES LINK_FLAGS /MANIFESTUAC:"level='highestAvailable' uiAccess='false'")

set_target_properties(AppLauncher PROPERTIES OUTPUT_NAME "AppLauncher")
set_target_properties(AppLauncher PROPERTIES DEBUG_OUTPUT_NAME "AppLauncher_d")

target_link_libraries(AppLauncher ${NPLRUNTIME_LINK_LIBRARIES}) 

# Copy files Link the executable to the libraries. 
ADD_CUSTOM_COMMAND(
   TARGET AppLauncher
   POST_BUILD
   COMMAND ${CMAKE_COMMAND} -E make_directory ${APP_BIN_DIR}
   COMMAND ${CMAKE_COMMAND} -E copy $<TARGET_FILE:AppLauncher> ${APP_BIN_DIR}
)

ADD_DEPENDENCIES(AppLauncher LauncherScript)