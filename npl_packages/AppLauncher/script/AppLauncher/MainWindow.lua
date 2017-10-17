--[[
Title: 
Author(s): MainWindow
Date: 2017/10/16
Desc: 
use the lib:
------------------------------------------------------------
NPL.load("script/AppLauncher/MainWindow.lua");
local MainWindow = commonlib.gettable("AppLauncher.MainWindow");
MainWindow.ShowPage();
------------------------------------------------------------
]]
NPL.load("(gl)script/ide/System/Windows/Window.lua");
local Window = commonlib.gettable("System.Windows.Window")
local MainWindow = commonlib.gettable("AppLauncher.MainWindow");
function MainWindow.OnInit()
    MainWindow.page = document:GetPageCtrl();
end
function MainWindow.ShowPage()
	local window = Window:new();
	window:Show({
		url="script/AppLauncher/MainWindow.html", 
		alignment="_fi", left = 0, top = 0, width = 0, height = 0,
	});

    NPL.load("script/AutoUpdater/test.lua");
    local test = commonlib.gettable("Mod.AutoUpdater.test");
    echo(test);
end