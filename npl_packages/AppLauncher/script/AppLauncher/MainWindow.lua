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
    --MainWindow.DoUpdate();
end
function MainWindow.ShowState(s)
    if(MainWindow.page)then
        MainWindow.page:SetValue("state_txt",s);
    end
end
function MainWindow.ShowPercent(s)
    if(MainWindow.page)then
        MainWindow.page:SetValue("percent_txt",tostring(s));
    end
end
function MainWindow.DoUpdate()
    NPL.load("(gl)script/ide/timer.lua");
    local redist_root = "test/";
	ParaIO.CreateDirectory(redist_root);

    NPL.load("npl_mod/AutoUpdater/AssetsManager.lua");
    local AssetsManager = commonlib.gettable("Mod.AutoUpdater.AssetsManager");
    local a = AssetsManager:new();
    local timer;
    a:onInit(redist_root,"npl_mod/AutoUpdater/configs/paracraft.xml",function(state)
        if(state)then
            if(state == AssetsManager.State.PREDOWNLOAD_VERSION)then
                MainWindow.ShowState("=========PREDOWNLOAD_VERSION");
            elseif(state == AssetsManager.State.DOWNLOADING_VERSION)then
                MainWindow.ShowState("=========DOWNLOADING_VERSION");
            elseif(state == AssetsManager.State.VERSION_CHECKED)then
                MainWindow.ShowState("=========VERSION_CHECKED");
            elseif(state == AssetsManager.State.VERSION_ERROR)then
                MainWindow.ShowState("=========VERSION_ERROR");
            elseif(state == AssetsManager.State.PREDOWNLOAD_MANIFEST)then
                MainWindow.ShowState("=========PREDOWNLOAD_MANIFEST");
            elseif(state == AssetsManager.State.DOWNLOADING_MANIFEST)then
                MainWindow.ShowState("=========DOWNLOADING_MANIFEST");
            elseif(state == AssetsManager.State.MANIFEST_DOWNLOADED)then
                MainWindow.ShowState("=========MANIFEST_DOWNLOADED");
            elseif(state == AssetsManager.State.MANIFEST_ERROR)then
                MainWindow.ShowState("=========MANIFEST_ERROR");
            elseif(state == AssetsManager.State.PREDOWNLOAD_ASSETS)then
                MainWindow.ShowState("=========PREDOWNLOAD_ASSETS");
                timer = commonlib.Timer:new({callbackFunc = function(timer)
                    MainWindow.ShowPercent(a:getPercent());
                end})
                timer:Change(0, 100)
            elseif(state == AssetsManager.State.DOWNLOADING_ASSETS)then
                MainWindow.ShowState("=========DOWNLOADING_ASSETS");
            elseif(state == AssetsManager.State.ASSETS_DOWNLOADED)then
                MainWindow.ShowState("=========ASSETS_DOWNLOADED");
                MainWindow.ShowPercent(a:getPercent());
                if(timer)then
                    timer:Change();
                end
                a:apply();
            elseif(state == AssetsManager.State.ASSETS_ERROR)then
                MainWindow.ShowState("=========ASSETS_ERROR");
            elseif(state == AssetsManager.State.PREUPDATE)then
                MainWindow.ShowState("=========PREUPDATE");
            elseif(state == AssetsManager.State.UPDATING)then
                MainWindow.ShowState("=========UPDATING");
            elseif(state == AssetsManager.State.UPDATED)then
                MainWindow.ShowState("=========UPDATED");
            elseif(state == AssetsManager.State.FAIL_TO_UPDATED)then
                MainWindow.ShowState("=========FAIL_TO_UPDATED");
            end    
        end
    end);
    a:check(nil,function()
        local cur_version = a:getCurVersion();
        local latest_version = a:getLatestVersion();
        MainWindow.ShowState("=========version");
        MainWindow.ShowState({cur_version = cur_version, latest_version = latest_version});
        if(a:isNeedUpdate())then
            a:download();
        else
            MainWindow.ShowState("=========is latest version");
        end
    end);
end