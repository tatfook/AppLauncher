--[[
Title: MainWindow
Author(s): leio
Date: 2017/10/16
Desc: 
use the lib:
------------------------------------------------------------
NPL.load("script/AppLauncher/main/MainWindow.lua");
local MainWindow = commonlib.gettable("AppLauncher.MainWindow");
MainWindow.ShowPage();
------------------------------------------------------------
]]
NPL.load("(gl)script/ide/System/Windows/Window.lua");
NPL.load("(gl)script/ide/System/os/run.lua");
NPL.load("npl_mod/AutoUpdater/AssetsManager.lua");
local Window = commonlib.gettable("System.Windows.Window")
local MainWindow = commonlib.gettable("AppLauncher.MainWindow");
local AssetsManager = commonlib.gettable("Mod.AutoUpdater.AssetsManager");
MainWindow.selected_index = 1;
MainWindow.cmdlines = {
    ["paracraft"] = [[single="false" noupdate="true" mc="true" updateurl="http://update.61.com/haqi/coreupdate/;http://tmlog.paraengine.com/;http://tmver.pala5.cn;"]],
    ["haqi"] = [[single="false" version="kids" noupdate="true" updateurl="http://update.61.com/haqi/coreupdate/;http://tmlog.paraengine.com/;http://tmver.pala5.cn;"]],
    ["haqi2"] = [[single="false" version="teen" noupdate="true" updateurl="http://update.61.com/haqi/coreupdate_teen/;http://teenver.paraengine.com/;http://teenver.pala5.cn/;"]],
}
MainWindow.menus = {
    { id = "paracraft",     label = "Paracraft创意空间",    icon = "Texture/AppLauncherRes/paracraft_logo_32bits.png#0 0 36 36",    config_file = "npl_mod/AutoUpdater/configs/paracraft.xml", },
    { id = "haqi",          label = "魔法哈奇",             icon = "Texture/AppLauncherRes/haqi_logo_32bits.png#0 0 36 36",         config_file = "npl_mod/AutoUpdater/configs/haqi.xml",      },
    { id = "haqi2",         label = "魔法哈奇2",            icon = "Texture/AppLauncherRes/haqi_logo_32bits.png#0 0 36 36",         config_file = "npl_mod/AutoUpdater/configs/haqi2.xml",      },
}
MainWindow.asset_managers = {};
function MainWindow.OnInit()
    MainWindow.page = document:GetPageCtrl();
end
function MainWindow.OnClick(index)
    MainWindow.selected_index = index;
    local node = MainWindow.GetSelectedNode();
    if(node)then
        MainWindow.OnCheck(node.id,node.config_file)
    end
    MainWindow.RefreshPage();
end
function MainWindow.RefreshPage()
    if(MainWindow.page)then
        MainWindow.page:Refresh(0);
    end
end
function MainWindow.ShowPage(url)
	local window = Window:new();
    url = url or "script/AppLauncher/main/MainWindow.html";
	window:Show({
		url = url, 
		alignment = "_fi", left = 0, top = 0, width = 0, height = 0,
	});
    MainWindow.OnClick(MainWindow.selected_index);
end
function MainWindow.ShowState(s)
    if(MainWindow.page)then
        MainWindow.page:SetValue("state_txt",tostring(s));
    end
end
function MainWindow.GetSelectedIndex()
    return MainWindow.selected_index;
end
function MainWindow.GetSelectedNode()
    return MainWindow.menus[MainWindow.selected_index];
end
function MainWindow.OnRun()
    local node = MainWindow.GetSelectedNode();
    if(node)then
        local id = node.id;
        local a = MainWindow.CreateOrGetAssetsManager(id);
        if(a)then
            if(not a:hasVersionFile())then
                MainWindow.OnUpdate();
                return
            end
            local cmdline = MainWindow.cmdlines[id];
            if(System.os.GetPlatform()=="win32") then
                local exe = string.format("%s%s/paraengineclient.exe",ParaIO.GetCurDirectory(0),id);
	            LOG.std(nil, "debug", "AppLauncher", "start:%s",exe);
                ParaGlobal.ShellExecute("open", exe, cmdline, "", 1);
            end        
        end
        
    end
end
function MainWindow.OnUpdate()
    local node = MainWindow.GetSelectedNode();
    local id = node.id;
    local a = MainWindow.CreateOrGetAssetsManager(id);
    if(a)then
        if(a:isNeedUpdate())then
            a:download();
        else
            MainWindow.ShowState("已经最最新版，不需要在更新");
        end
    end
end
function MainWindow.CreateOrGetAssetsManager(id,redist_root,config_file)
    if(not id)then return end
    local a = MainWindow.asset_managers[id];
    if(not a)then
        a = AssetsManager:new();
        local timer;
        if(redist_root and config_file)then
            a:onInit(redist_root,config_file,function(state)
                if(state)then
                    if(state == AssetsManager.State.PREDOWNLOAD_VERSION)then
                        MainWindow.ShowState("准备下载版本号");
                    elseif(state == AssetsManager.State.DOWNLOADING_VERSION)then
                        MainWindow.ShowState("下载版本号");
                    elseif(state == AssetsManager.State.VERSION_CHECKED)then
                        MainWindow.ShowState("检测版本号");
                    elseif(state == AssetsManager.State.VERSION_ERROR)then
                        MainWindow.ShowState("版本号错误");
                    elseif(state == AssetsManager.State.PREDOWNLOAD_MANIFEST)then
                        MainWindow.ShowState("准备下载文件列表");
                    elseif(state == AssetsManager.State.DOWNLOADING_MANIFEST)then
                        MainWindow.ShowState("下载文件列表");
                    elseif(state == AssetsManager.State.MANIFEST_DOWNLOADED)then
                        MainWindow.ShowState("下载文件列表完成");
                    elseif(state == AssetsManager.State.MANIFEST_ERROR)then
                        MainWindow.ShowState("下载文件列表错误");
                    elseif(state == AssetsManager.State.PREDOWNLOAD_ASSETS)then
                        MainWindow.ShowState("准备下载资源文件");
                        timer = commonlib.Timer:new({callbackFunc = function(timer)
                            MainWindow.ShowState(a:getPercent());
                        end})
                        timer:Change(0, 100)
                    elseif(state == AssetsManager.State.DOWNLOADING_ASSETS)then
                    elseif(state == AssetsManager.State.ASSETS_DOWNLOADED)then
                        MainWindow.ShowState("下载资源文件结束");
                        MainWindow.ShowState(a:getPercent());
                        if(timer)then
                            timer:Change();
                        end
                        a:apply();
                    elseif(state == AssetsManager.State.ASSETS_ERROR)then
                        MainWindow.ShowState("下载资源文件错误");
                    elseif(state == AssetsManager.State.PREUPDATE)then
                        MainWindow.ShowState("准备更新");
                    elseif(state == AssetsManager.State.UPDATING)then
                        MainWindow.ShowState("更新中");
                    elseif(state == AssetsManager.State.UPDATED)then
                        MainWindow.ShowState("更新完成");
                    elseif(state == AssetsManager.State.FAIL_TO_UPDATED)then
                        MainWindow.ShowState("更新错误");
                    end    
                end
            end);
        end
        MainWindow.asset_managers[id] = a;
    end
    return a;
end
function MainWindow.OnCheck(id,config_file)
    if(not id or not config_file)then return end
    local redist_root = id .. "/"
	ParaIO.CreateDirectory(redist_root);
    local a = MainWindow.CreateOrGetAssetsManager(id,redist_root,config_file);
    if(not a)then return end
    a:check(nil,function()
        local cur_version = a:getCurVersion();
        local latest_version = a:getLatestVersion();
        if(a:isNeedUpdate())then
            MainWindow.ShowState(string.format(L"当前版本(%s)        最新版本(%s)",cur_version, latest_version));
        else
            MainWindow.ShowState(string.format(L"版本(%s)",latest_version));
        end
    end);
end