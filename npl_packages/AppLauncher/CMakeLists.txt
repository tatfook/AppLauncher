# Author: LiXizhi
# Email: lixizhi@yeah.net
# Date: 2017.10.8
# Desc: this is a custom target. Rebuild to run sync_src.bat.

cmake_minimum_required(VERSION 3.2)

project (LauncherScript)

# since the project is for documentation only, we will turn relative path on. 
# set(CMAKE_USE_RELATIVE_PATHS ON)

##############################
file (GLOB_RECURSE LauncherScript_NPL_FILES ${PROJECT_SOURCE_DIR}/*.lua)
SOURCE_GROUP("npl\\" FILES ${LauncherScript_NPL_FILES})
list(APPEND LauncherScript_SRCS ${LauncherScript_NPL_FILES})

##############################
file (GLOB_RECURSE LauncherScript_XML_FILES ${PROJECT_SOURCE_DIR}/*.xml)
SOURCE_GROUP("mcml\\" FILES ${LauncherScript_XML_FILES})
list(APPEND LauncherScript_SRCS ${LauncherScript_XML_FILES})

file (GLOB_RECURSE LauncherScript_HTML_FILES ${PROJECT_SOURCE_DIR}/*.html)
SOURCE_GROUP("mcml\\" FILES ${LauncherScript_HTML_FILES})
list(APPEND LauncherScript_SRCS ${LauncherScript_HTML_FILES})

# textures
file (GLOB_RECURSE LauncherScript_TEXTURE_FILES ${PROJECT_SOURCE_DIR}/res/Texture/Aries/Creator/Theme/*.png)
SOURCE_GROUP("Texture\\Aries\\Creator\\" FILES ${LauncherScript_TEXTURE_FILES})
list(APPEND LauncherScript_SRCS ${LauncherScript_TEXTURE_FILES})

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
