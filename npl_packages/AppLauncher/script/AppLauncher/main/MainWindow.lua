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
NPL.load("script/AppLauncher/main/TipsWindow.lua");
NPL.load("script/AppLauncher/main/ActivationDialogWindow.lua");
NPL.load("script/AppLauncher/main/AppUrlProtocolHandler.lua");
local Window = commonlib.gettable("System.Windows.Window")
local MainWindow = commonlib.gettable("AppLauncher.MainWindow");
local AssetsManager = commonlib.gettable("Mod.AutoUpdater.AssetsManager");
local AppUrlProtocolHandler = commonlib.gettable("AppLauncher.AppUrlProtocolHandler");
MainWindow.protocol_name = "test_app";
MainWindow.protocol_exe_name = "AppLauncher_d.exe";
MainWindow.selected_index = 1;
MainWindow.cmdlines = {
    ["paracraft"] = [[single="true" noupdate="true" worlddir="../worlds" mc="true" updateurl="http://update.61.com/haqi/coreupdate/;http://tmlog.paraengine.com/;http://tmver.pala5.cn;"]],
    ["paracraft-haqi"] = [[single="true" noupdate="true" version="kids" updateurl="http://update.61.com/haqi/coreupdate/;http://tmlog.paraengine.com/;http://tmver.pala5.cn;"]],
    ["haqi"] = [[single="true" version="kids" noupdate="true" updateurl="http://update.61.com/haqi/coreupdate/;http://tmlog.paraengine.com/;http://tmver.pala5.cn;"]],
    ["haqi2"] = [[single="true" version="teen" noupdate="true" updateurl="http://update.61.com/haqi/coreupdate_teen/;http://teenver.paraengine.com/;http://teenver.pala5.cn/;"]],
    ["truckstar"] = [[]],
}
MainWindow.menus = {
    {
        id = "paracraft",
        folder = "paracraft",
        executable="paraengineclient",
        label = "Paracraft创意空间",
        icon = "Texture/AppLauncherRes/paracraft_logo_32bits.png#0 0 36 36",
        window_bg = "newskin/background1_32bits.png",
        config_file = "script/AppLauncher/configs/paracraft.xml",
        pagename = "paracraft.html",
        pagepath = "script/AppLauncher/pages/paracraft",
        pageTempPath = "script/AppLauncher/pages/paracraft/temp",
        pageurl = "https://raw.githubusercontent.com/tatfook/AppLauncher/master/npl_packages/AppLauncher/script/AppLauncher/pages/paracraft/paracraft.html"
    },
    {
        id = "paracraft-haqi",
        folder = "paracraft",
        executable="paraengineclient",
        label = "Paracraft-魔法哈奇",
        icon = "Texture/AppLauncherRes/paracraft_logo_32bits.png#0 0 36 36",
        window_bg = "",
        config_file = "script/AppLauncher/configs/haqi2.xml",
        page = "script/AppLauncher/pages/paracraft/paracraft.html",
        pageurl = "https://raw.githubusercontent.com/tatfook/AppLauncher/master/npl_packages/AppLauncher/script/AppLauncher/pages/paracraft/paracraft.html"
    },
    {
        id = "haqi",
        folder = "haqi",
        executable="paraengineclient",
        label = "魔法哈奇",
        icon = "Texture/AppLauncherRes/haqi_logo_32bits.png#0 0 36 36",
        window_bg = "",
        config_file = "script/AppLauncher/configs/haqi.xml",
    },
    {
        id = "haqi2",
        folder = "haqi2",
        executable="paraengineclient",
        label = "魔法哈奇2",
        icon = "Texture/AppLauncherRes/haqi_logo_32bits.png#0 0 36 36",
        window_bg = "",
        config_file = "script/AppLauncher/configs/haqi2.xml",
    },
    {
        id = "truckstar",
        folder = "truckstar",
        executable="Launcher",
        label = "创意空间童趣版",
        icon = "Texture/AppLauncherRes/truckstar_logo_32bits.png#0 0 36 36",
        window_bg = "truckstar/truckstar_window_bg_32bit.png",
        config_file = "script/AppLauncher/configs/truckstar.xml",
    },
}
MainWindow.asset_managers = {};

MainWindow.IsUpdating = false

function MainWindow.OnInit()
    MainWindow.page = document:GetPageCtrl();
end
function MainWindow.OnClick(index)
	if MainWindow.IsUpdating then return end

    MainWindow.selected_index = index;
    local node = MainWindow.GetSelectedNode();
    if(node)then
        MainWindow.OnCheck(node.id,node.folder,node.config_file)
        MainWindow.OnLoadAppPage(index)
    end
    MainWindow.RefreshPage();
end
function MainWindow.RefreshPage()
    if(MainWindow.page)then
        MainWindow.page:Refresh(0);
    end
end
function MainWindow.ShowPage()
	local window = Window:new();
    url = "script/AppLauncher/main/MainWindow.html";
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
function MainWindow.ShowPercent(percent)
    if(MainWindow.page)then
        MainWindow.page:SetValue("progress_bar",percent);
    end
end
function MainWindow.GetSelectedIndex()
    return MainWindow.selected_index;
end
function MainWindow.GetSelectedNode()
    return MainWindow.menus[MainWindow.selected_index];
end
function MainWindow.OnRun()
	if MainWindow.IsUpdating then return end

	if MainWindow.IsOpenApp then return end

    local node = MainWindow.GetSelectedNode();
    if(node)then
        local id = node.id;
        local a = MainWindow.CreateOrGetAssetsManager(id);
        if(a)then
            if not a:hasVersionFile() or a:isNeedUpdate() then
                --MainWindow.OnUpdate();

                local TipsWindow = commonlib.gettable("AppLauncher.TipsWindow")
                TipsWindow.ShowPage()
            else
                MainWindow.OpenApp(id)
            end
        end
    end
end

function MainWindow.OnUpdate()
	if MainWindow.IsUpdating then return end

    local node = MainWindow.GetSelectedNode();
    local id = node.id;
    local a = MainWindow.CreateOrGetAssetsManager(id);
    if(a)then
        if(a:isNeedUpdate())then
            a:download();
			MainWindow.IsUpdating = true
        else
            MainWindow.ShowState("已经最最新版，不需要在更新");
        end
    end
end

function MainWindow.OpenApp(id)
    local cmdline = MainWindow.cmdlines[id];
    local node = MainWindow.GetSelectedNode();
    if(System.os.GetPlatform()=="win32" and node) then
        local exe = string.format("%s%s/%s.exe",ParaIO.GetCurDirectory(0),id,node.executable);
        LOG.std(nil, "debug", "AppLauncher", "start:%s",exe);
        ParaGlobal.ShellExecute("open", exe, cmdline, "", 1);

        MainWindow.IsOpenApp = true

        ParaGlobal.Exit(0)
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
						MainWindow.IsUpdating = false
                    elseif(state == AssetsManager.State.PREDOWNLOAD_MANIFEST)then
                        MainWindow.ShowState("准备下载文件列表");
                    elseif(state == AssetsManager.State.DOWNLOADING_MANIFEST)then
                        MainWindow.ShowState("下载文件列表");
                    elseif(state == AssetsManager.State.MANIFEST_DOWNLOADED)then
                        MainWindow.ShowState("下载文件列表完成");
                    elseif(state == AssetsManager.State.MANIFEST_ERROR)then
                        MainWindow.ShowState("下载文件列表错误");
						MainWindow.IsUpdating = false
                    elseif(state == AssetsManager.State.PREDOWNLOAD_ASSETS)then
                        MainWindow.ShowState("准备下载资源文件");

                        local nowTime = 0
                        local lastTime = 0
                        local interval = 100
                        local lastDownloadedSize = 0
                        timer = commonlib.Timer:new({callbackFunc = function(timer)
                            local p = a:getPercent();
                            p = math.floor(p * 100);
                            MainWindow.ShowPercent(p);

                            local totalSize = a:getTotalSize()
                            local downloadedSize = a:getDownloadedSize()

                            nowTime = nowTime + interval

                            if downloadedSize > lastDownloadedSize then
                                local downloadSpeed = (downloadedSize - lastDownloadedSize) / ((nowTime - lastTime) / 1000)
                                lastDownloadedSize = downloadedSize
                                lastTime = nowTime

                                local tips = string.format("%.1f/%.1fMB(%.1fKB/S)", downloadedSize / 1024 / 1024, totalSize / 1024 / 1024, downloadSpeed / 1024)
                                MainWindow.ShowState(tips)
                            end
                        end})
                        timer:Change(0, interval)
                    elseif(state == AssetsManager.State.DOWNLOADING_ASSETS)then
                    elseif(state == AssetsManager.State.ASSETS_DOWNLOADED)then
                        MainWindow.ShowState("下载资源文件结束");
                        local p = a:getPercent();
                        p = math.floor(p * 100);
                        MainWindow.ShowPercent(p);
                        if(timer)then
                             timer:Change();
                             MainWindow.LastDownloadedSize = 0
                        end
                        a:apply();
                    elseif(state == AssetsManager.State.ASSETS_ERROR)then
                        MainWindow.ShowState("下载资源文件错误");
						MainWindow.IsUpdating = false
                    elseif(state == AssetsManager.State.PREUPDATE)then
                        MainWindow.ShowState("准备更新");
                    elseif(state == AssetsManager.State.UPDATING)then
                        MainWindow.ShowState("更新中");
                    elseif(state == AssetsManager.State.UPDATED)then
                        LOG.std(nil, "debug", "AppLauncher", "更新完成")
                        MainWindow.ShowState("更新完成");
						MainWindow.IsUpdating = false
                    elseif(state == AssetsManager.State.FAIL_TO_UPDATED)then
                        MainWindow.ShowState("更新错误");
						MainWindow.IsUpdating = false
                    end
                end
            end, function (dest, cur, total)
                MainWindow.OnMovingFileCallback(dest, cur, total)
            end);
        end
        MainWindow.asset_managers[id] = a;
    end
    return a;
end
function MainWindow.OnCheck(id,folder,config_file)
    --setting up window bg for current app
    local window_bg = MainWindow.page:GetNode("window_background");
    if window_bg then
        local current_node = MainWindow.GetSelectedNode();
        local win_bg_img = "bg_32bits.png#0 0 1110 660:4 4 4 4";
        if current_node and current_node.window_bg and string.len(current_node.window_bg)>0 then
            win_bg_img = current_node.window_bg;
        end
        local style_str = string.format("background:url(Texture/AppLauncherRes/%s)", win_bg_img);
        window_bg:SetAttribute("style", style_str);
        MainWindow.RefreshPage();
    end

    if(not id or not folder or not config_file)then return end
    local redist_root = folder .. "/"
	ParaIO.CreateDirectory(redist_root);
    local a = MainWindow.CreateOrGetAssetsManager(id,redist_root,config_file);
    if(not a)then return end
    MainWindow.ShowPercent(0);
    a:check(nil,function()
        local cur_version = a:getCurVersion();
        local latest_version = a:getLatestVersion();
        if(a:isNeedUpdate())then
            MainWindow.ShowState(string.format(L"当前版本(%s)        最新版本(%s)",cur_version, latest_version));
        else
            MainWindow.ShowState(string.format(L"版本(%s)",latest_version));
            MainWindow.ShowPercent(100);
        end
    end);
end

function MainWindow.OnMovingFileCallback(dest, cur, total)
    local tips = string.format(L"更新%s (%d/%d)", dest, cur, total)
    MainWindow.ShowState(tips)

    local percent = 100 * cur / total
    MainWindow.ShowPercent(percent)
end

function MainWindow.OnActivation()
    --local ActivationDialogWindow = commonlib.gettable("AppLauncher.ActivationDialogWindow")
    --ActivationDialogWindow.ShowPage()
	AppUrlProtocolHandler:CheckInstallUrlProtocol(MainWindow.protocol_name,MainWindow.protocol_exe_name)
end

function MainWindow.OnLoadAppPage(appIndex)
    MainWindow.LoadLocalAppPage(appIndex)

    MainWindow.DowloadLatestAppPage(appIndex, function ()
        -- comparing the latest file and the local file
        if not IsFilesSame(tempPath, writablePath) then
            CopyFiles(tempPath, writablePath)
            DeleteFiles(tempPath)

            MainWindow.LoadLocalAppPage(appIndex)
        end
    end)
end

function MainWindow.LoadLocalAppPage(appIndex)
    local pagepath = MainWindow.menus[appIndex].pagepath
    local pagename = MainWindow.menus[appIndex].pagename
    local url = pagepath .. "/" .. pagename

    local window = Window:new()
	window:Show({
		url = url,
		alignment = "_ct", left = -100, top = -200, width = 500, height = 309,
	})

    MainWindow.CurrentAppPage = window
end

function MainWindow.DowloadLatestAppPage(appIndex, callback)
    local cfg = MainWindow.menus[appIndex]
    System.os.GetUrl(cfg.pageurl, function(err, msg, data)
        if err == 200 then
            if data then
                ParaIO.CreateDirectory(cfg.pageTempPath)
                local file = ParaIO.open(cfg.pageTempPath .. "/" .. cfg.pagename, "w")
                if file:IsValid() then
					file:write(data, #data)
					file:close()

                    if callback and type(callback) == "function" then
                        callback()
                    end
                end
            else
                LOG.std(nil, "debug", "AppLauncher", msg)
            end
        else
            LOG.std(nil, "debug", "AppLauncher", msg)
        end
    end)
end
