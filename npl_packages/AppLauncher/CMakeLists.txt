# Author: LiXizhi
# Email: lixizhi@yeah.net
# Date: 2017.10.8
# Desc: this is a custom target. Rebuild to run sync_src.bat.

cmake_minimum_required(VERSION 3.2)

project (LauncherScript)

# since the project is for documentation only, we will turn relative path on. 
# set(CMAKE_USE_RELATIVE_PATHS ON)

# script/AppLauncher/main
file (GLOB_RECURSE LauncherScript_AppLauncher_main_FILES ${PROJECT_SOURCE_DIR}/script/AppLauncher/main/*.*)
SOURCE_GROUP("script\\AppLauncher\\main" FILES ${LauncherScript_AppLauncher_main_FILES})
list(APPEND LauncherScript_SRCS ${LauncherScript_AppLauncher_main_FILES})

# script/AppLauncher/configs
file (GLOB_RECURSE LauncherScript_AppLauncher_configs_FILES ${PROJECT_SOURCE_DIR}/script/AppLauncher/configs/*.*)
SOURCE_GROUP("script\\AppLauncher\\configs" FILES ${LauncherScript_AppLauncher_configs_FILES})
list(APPEND LauncherScript_SRCS ${LauncherScript_AppLauncher_configs_FILES})

# script/AppLauncher/lang
file (GLOB_RECURSE LauncherScript_AppLauncher_lang_FILES ${PROJECT_SOURCE_DIR}/script/AppLauncher/lang/*.*)
SOURCE_GROUP("script\\AppLauncher\\lang" FILES ${LauncherScript_AppLauncher_lang_FILES})
list(APPEND LauncherScript_SRCS ${LauncherScript_AppLauncher_lang_FILES})

# script/AppLauncher/versions
file (GLOB_RECURSE LauncherScript_AppLauncher_versions_FILES ${PROJECT_SOURCE_DIR}/script/AppLauncher/versions/*.*)
SOURCE_GROUP("script\\AppLauncher\\versions" FILES ${LauncherScript_AppLauncher_versions_FILES})
list(APPEND LauncherScript_SRCS ${LauncherScript_AppLauncher_versions_FILES})

##############################
# misc
# SET(LauncherScript_MISC_FILES
	# Run.bat
# )
# source_group("" FILES ${LauncherScript_MISC_FILES})
# list(APPEND LauncherScript_SRCS ${LauncherScript_MISC_FILES})

##############################
add_custom_target(LauncherScript
	COMMAND ${CMAKE_COMMAND} -E tar "cfv" "${PROJECT_BINARY_DIR}/AppLauncher.zip" --format=zip ${PROJECT_SOURCE_DIR}/script
	COMMAND ${CMAKE_COMMAND} -E tar "cfv" "${PROJECT_BINARY_DIR}/AppLauncherTexture.zip" --format=zip ${PROJECT_SOURCE_DIR}/Texture
	WORKING_DIRECTORY "${PROJECT_SOURCE_DIR}"
	COMMENT "making npl_packges zip archive"
	SOURCES ${LauncherScript_SRCS}
	)
