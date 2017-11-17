--[[
Title: LauncherVersion.lua
Author(s): leio
Date: 2017/11/17
Desc: 
use the lib:
------------------------------------------------------------
local LauncherVersion = NPL.load("version/LauncherVersion.lua");
local LauncherVersion = NPL.load("script/AppLauncher/versions/LauncherVersion.lua");
------------------------------------------------------------
]]
local LauncherVersion = NPL.export();
LauncherVersion.version = 0;-- increase this value to control version
LauncherVersion.latest_assets = {
    { name = "script/AppLauncher/main/MainWindow.html",         url  = "https://raw.githubusercontent.com/tatfook/AppLauncher/master/npl_packages/AppLauncher/script/AppLauncher/main/MainWindow.html", },
    { name = "script/AppLauncher/main/MainWindow.lua",          url  = "https://raw.githubusercontent.com/tatfook/AppLauncher/master/npl_packages/AppLauncher/script/AppLauncher/main/MainWindow.lua", },

    { name = "Texture/AppLauncherRes/icons/zysy_32bits.png",    url  = "https://raw.githubusercontent.com/tatfook/AppLauncher/master/npl_packages/AppLauncher/Texture/AppLauncherRes/icons/zysy_32bits.png", }
};

