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
NPL.load("script/AppLauncher/main/LoginWindow.lua")
NPL.load("script/AppLauncher/main/ActivationDialogWindow.lua");
NPL.load("script/AppLauncher/main/AppUrlProtocolHandler.lua");
NPL.load("script/AppLauncher/main/Utils.lua")
NPL.load("script/AppLauncher/main/UserInfoWindow.lua");
NPL.load("script/AppLauncher/main/Translation.lua")
local Translation = commonlib.gettable("AppLauncher.Translation")
local UserInfoWindow = commonlib.gettable("AppLauncher.UserInfoWindow")
local Utils = commonlib.gettable("AppLauncher.Utils")
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
    ["truckstar"] = [[noupdate="true" debug="main" mc="true" bootstrapper="script/apps/Aries/main_loop.lua" mod="Seer" isDevEnv="true"]],
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
        pagepath = "pages/",
        pageTempPath = "temp/",
        pageurl = "https://raw.githubusercontent.com/tatfook/AppLauncher/master/npl_packages/AppLauncher/script/AppLauncher/pages/paracraft.html"
    },
    {
        id = "paracraft-haqi",
        folder = "paracraft",
        executable="paraengineclient",
        label = "Paracraft-魔法哈奇",
        icon = "Texture/AppLauncherRes/paracraft_logo_32bits.png#0 0 36 36",
        window_bg = "",
        config_file = "script/AppLauncher/configs/haqi2.xml",
        pagename = "paracraft.html",
        pagepath = "pages/",
        pageTempPath = "temp/",
        pageurl = "https://raw.githubusercontent.com/tatfook/AppLauncher/master/npl_packages/AppLauncher/script/AppLauncher/pages/paracraft.html"
    },
    {
        id = "haqi",
        folder = "haqi",
        executable="paraengineclient",
        label = "魔法哈奇",
        icon = "Texture/AppLauncherRes/haqi_logo_32bits.png#0 0 36 36",
        window_bg = "",
        config_file = "script/AppLauncher/configs/haqi.xml",
        pagename = "paracraft.html",
        pagepath = "pages/",
        pageTempPath = "temp/",
        pageurl = "https://raw.githubusercontent.com/tatfook/AppLauncher/master/npl_packages/AppLauncher/script/AppLauncher/pages/paracraft.html"
    },
    {
        id = "haqi2",
        folder = "haqi2",
        executable="paraengineclient",
        label = "魔法哈奇2",
        icon = "Texture/AppLauncherRes/haqi_logo_32bits.png#0 0 36 36",
        window_bg = "",
        config_file = "script/AppLauncher/configs/haqi2.xml",
        pagename = "paracraft.html",
        pagepath = "pages/",
        pageTempPath = "temp/",
        pageurl = "https://raw.githubusercontent.com/tatfook/AppLauncher/master/npl_packages/AppLauncher/script/AppLauncher/pages/paracraft.html"
    },
    {
        id = "truckstar",
        folder = "truckstar",
        executable="Container/AwesomeTruck",
        label = "创意空间童趣版",
        icon = "Texture/AppLauncherRes/truckstar_logo_32bits.png#0 0 36 36",
        window_bg = "truckstar/truckstar_window_bg_32bit.png",
        config_file = "script/AppLauncher/configs/truckstar.xml",
        pagename = "paracraft.html",
        pagepath = "pages/",
        pageTempPath = "temp/",
        pageurl = "https://raw.githubusercontent.com/tatfook/AppLauncher/master/npl_packages/AppLauncher/script/AppLauncher/pages/paracraft.html"
    },
}
MainWindow.asset_managers = {};

MainWindow.IsUpdating = false

function MainWindow.OnInit()
    MainWindow.page = document:GetPageCtrl();

    MainWindow.UpdateLanguage()
    MainWindow.CheckAutoLogin()

    MainWindow.RefreshPage()
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
            MainWindow.ShowState(L"已经最最新版，不需要在更新");
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

local function createTruckStarAssetsManager()
	luaopen_pb();
	NPL.load("script/Launcher/Headers.lua");
	local Launcher = NPL.load("script/Launcher/Launcher.lua");
	Launcher.init("120.132.120.164", 18000, "truckstar/");
	local versionfilepath = "truckstar/version";
			
	local a = 
	{
		currentVer = {0,0,0,0},
		lastestVer = {},
		hasVersionFile = function (self)
			return ParaIO.DoesFileExist(versionfilepath)
		end,
		isNeedUpdate = function (self)
			self:getCurVersion();
			for i = 1, 4 do 
				if self.currentVer[i] ~= self.lastestVer[i] then 
					return true;
				end
			end
			return false;
		end,
		download = function (self)
			MainWindow.ShowState(L"正在更新")
			Launcher.update(self.currentVer, self.lastestVer, function (err)
				if err then 
					MainWindow.ShowState(err);
				else
                    MainWindow.ShowPercent(100);
					MainWindow.ShowState(L"已经是最新版本")
					self.cur_version = {self.lastestVer[1], self.lastestVer[2], self.lastestVer[3], self.lastestVer[4]}
					commonlib.SaveTableToFile(self.lastestVer, versionfilepath);
				end

				MainWindow.IsUpdating = false;
			end, function (count, sum)
				MainWindow.ShowPercent(math.floor(count * 100 / sum));
			end)
		end,
		check = function (self, _, callback)
			MainWindow.ShowState(L"检测版本号")
			Launcher.checkVersion(function (ver)
				self.lastestVer = ver;
				callback();
			end)
		end,
		getCurVersion = function (self) 
				self.currentVer = commonlib.LoadTableFromFile(versionfilepath) or {0,0,0,0};
				return string.format("%s.%s.%s.%s",self.currentVer[1],self.currentVer[2],self.currentVer[3],self.currentVer[4]) 
			end,
		getLatestVersion = function (self) 
				return string.format("%s.%s.%s.%s",self.lastestVer[1],self.lastestVer[2],self.lastestVer[3],self.lastestVer[4]) 
			end,
	};
	return a;
end

function MainWindow.CreateOrGetAssetsManager(id,redist_root,config_file)
    if(not id)then return end

    local a = MainWindow.asset_managers[id];
    if(not a)then
		if id == "truckstar" then 
			a = createTruckStarAssetsManager();
			MainWindow.asset_managers[id] = a;
			return a;
		end

        a = AssetsManager:new();
        local timer;
        if(redist_root and config_file)then
            a:onInit(redist_root,config_file,function(state)
                if(state)then
                    if(state == AssetsManager.State.PREDOWNLOAD_VERSION)then
                        MainWindow.ShowState(L"准备下载版本号");
                    elseif(state == AssetsManager.State.DOWNLOADING_VERSION)then
                        MainWindow.ShowState(L"下载版本号");
                    elseif(state == AssetsManager.State.VERSION_CHECKED)then
                        MainWindow.ShowState(L"检测版本号");
                    elseif(state == AssetsManager.State.VERSION_ERROR)then
                        MainWindow.ShowState(L"版本号错误");
						MainWindow.IsUpdating = false
                    elseif(state == AssetsManager.State.PREDOWNLOAD_MANIFEST)then
                        MainWindow.ShowState(L"准备下载文件列表");
                    elseif(state == AssetsManager.State.DOWNLOADING_MANIFEST)then
                        MainWindow.ShowState(L"下载文件列表");
                    elseif(state == AssetsManager.State.MANIFEST_DOWNLOADED)then
                        MainWindow.ShowState(L"下载文件列表完成");
                    elseif(state == AssetsManager.State.MANIFEST_ERROR)then
                        MainWindow.ShowState(L"下载文件列表错误");
						MainWindow.IsUpdating = false
                    elseif(state == AssetsManager.State.PREDOWNLOAD_ASSETS)then
                        MainWindow.ShowState(L"准备下载资源文件");

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
                        MainWindow.ShowState(L"下载资源文件结束");
                        local p = a:getPercent();
                        p = math.floor(p * 100);
                        MainWindow.ShowPercent(p);
                        if(timer)then
                             timer:Change();
                             MainWindow.LastDownloadedSize = 0
                        end
                        a:apply();
                    elseif(state == AssetsManager.State.ASSETS_ERROR)then
                        MainWindow.ShowState(L"下载资源文件错误");
						MainWindow.IsUpdating = false
                    elseif(state == AssetsManager.State.PREUPDATE)then
                        MainWindow.ShowState(L"准备更新");
                    elseif(state == AssetsManager.State.UPDATING)then
                        MainWindow.ShowState(L"更新中");
                    elseif(state == AssetsManager.State.UPDATED)then
                        LOG.std(nil, "debug", "AppLauncher", "更新完成")
                        MainWindow.ShowState(L"更新完成");
						MainWindow.IsUpdating = false
                    elseif(state == AssetsManager.State.FAIL_TO_UPDATED)then
                        MainWindow.ShowState(L"更新错误");
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
	AppUrlProtocolHandler:CheckInstallUrlProtocol(MainWindow.protocol_name,MainWindow.protocol_exe_name)
end

function MainWindow.OnLoadAppPage(appIndex)
    MainWindow.LoadLocalAppPage(appIndex)

    MainWindow.DowloadLatestAppPage(appIndex, function (data)
        -- comparing the latest file and the local file
        local pagepath = MainWindow.menus[appIndex].pagepath
        local pageTempPath = MainWindow.menus[appIndex].pageTempPath
        local pagename = MainWindow.menus[appIndex].pagename
        local localFileName = pagepath .. "/" .. pagename

        local isUpdate = false

        ParaIO.CreateDirectory(pagepath)
        local file = ParaIO.open(localFileName, "r")
    	if file:IsValid() then
    		local text = file:ReadBytes(-1, nil)
            file:close()

            if text ~= data then
                isUpdate = true
            end
        else
            LOG.std(nil, "debug", "AppLauncher", "can not open file %s", localFileName)
            isUpdate = true
        end

        if isUpdate then
            ParaIO.MoveFile(pageTempPath.."/"..pagename, localFileName)
            MainWindow.LoadLocalAppPage(appIndex)
        end
    end)
end

function MainWindow.LoadLocalAppPage(appIndex)
    local frame = MainWindow.page:GetNode("AppPage")
    if frame then
        local pagepath = MainWindow.menus[appIndex].pagepath
        local pagename = MainWindow.menus[appIndex].pagename
        local url = pagepath .. "/" .. pagename
        frame:SetAttribute("src", url)
    end
end

function MainWindow.DowloadLatestAppPage(appIndex, callback)
    local cfg = MainWindow.menus[appIndex]
    System.os.GetUrl(cfg.pageurl, function(err, msg, data)
        LOG.std(nil, "debug", "AppLauncher", "MainWindow.DowloadLatestAppPage: System.os.GetUrl callback")
        if err == 200 then
            if data then
                ParaIO.CreateDirectory(cfg.pageTempPath)
                local file = ParaIO.open(cfg.pageTempPath .. "/" .. cfg.pagename, "w")
                if file:IsValid() then
					file:write(data, #data)
					file:close()

                    if callback and type(callback) == "function" then
                        LOG.std(nil, "debug", "AppLauncher", "download latest app page finished. Calling the callback function")
                        callback(data)
                    end
                end
            else
                LOG.std(nil, "debug", "AppLauncher", "MainWindow.DowloadLatestAppPage: no data: %s", tostring(msg))
            end
        else
            LOG.std(nil, "debug", "AppLauncher", "MainWindow.DowloadLatestAppPage: error: %s, msg: %s", tostring(err), tostring(msg))
        end
    end)
end

function MainWindow.OnLogin()
    if MainWindow.IsUpdating then return end

    local LoginWindow = commonlib.gettable("AppLauncher.LoginWindow")
    LoginWindow.ShowPage()
    --[[
    NPL.load("script/AppLauncher/main/MessageWindow.lua");
	local MessageWindow = commonlib.gettable("AppLauncher.MessageWindow");
	MessageWindow.Show("hello message window MessageWindow.Buttons.YesNo",function(result)
		commonlib.echo(result);
    end,MessageWindow.Buttons.YesNo);
    --]]
end

function MainWindow.OnRegister()
    if MainWindow.IsUpdating then return end

    local url = "http://keepwork.com/wiki/join"
    ParaGlobal.ShellExecute("open", "iexplore.exe", url, "", 1)
end

function MainWindow.OnLoginSuccess(username)
    MainWindow.LoginSuccess = true
    MainWindow.Username = username

    MainWindow.RefreshPage()
end

function MainWindow.OnLogoutSuccess()
    MainWindow.LoginSuccess = false
    MainWindow.Username = ""

    MainWindow.RefreshPage()
end

function MainWindow.IsLoginSuccess()
    return MainWindow.LoginSuccess
end

function MainWindow.GetUsername()
    return MainWindow.Username
end

function MainWindow.CheckAutoLogin()
    if Utils.IsAutoLogin() then
        local username = Utils.GetUserName()
        local password = Utils.GetPassword()
        LOG.std(nil, "debug", "AppLauncher", string.format("MainWindow.CheckAutoLogin(): username '%s', password '%s'", username, password))
        if #username > 0 and #password > 0 then
            Utils.Login(username, password, function (isSuccess, showUserName)
                if isSuccess then
                    MainWindow.OnLoginSuccess(username, showUserName)
                end
            end)
        end
    else
        LOG.std(nil, "debug", "AppLauncher", "MainWindow.CheckAutoLogin(): not auto login")
    end
end

function MainWindow.OnUserInfo()
    if MainWindow.IsUpdating then return end

    UserInfoWindow.ShowPage(MainWindow.Username)
end

function MainWindow.OnLanguage()
    if MainWindow.IsUpdating then return end

    local lan = Translation.GetCurrentLanguage()
    if lan == "enUS" then
        Translation.SetCurrentLanguage("zhCN")
    else
        Translation.SetCurrentLanguage("enUS")
    end

    MainWindow.UpdateLanguage()
    MainWindow.RefreshPage()
end

function MainWindow.GetLanguage()
    local lan = Translation.GetCurrentLanguage()
    if lan == "enUS" then
        return "English"
    else
        return "中文"
    end
end

function MainWindow.UpdateLanguage()
    LOG.std(nil, "debug", "AppLauncher", string.format("current language: %s", Translation.GetCurrentLanguage()))

    local button_login = MainWindow.page:GetNode("button_login")
    button_login:SetValue(L"登录")

    local button_register = MainWindow.page:GetNode("button_register")
    button_register:SetValue(L"注册")

    local button_activated = MainWindow.page:GetNode("button_activated")
    button_activated:SetValue(L"已经激活")

    local button_activate = MainWindow.page:GetNode("button_activate")
    button_activate:SetValue(L"激活")

    local button_enter = MainWindow.page:GetNode("button_enter")
    button_enter:SetValue(L"进入")

    local button_update = MainWindow.page:GetNode("button_update")
    button_update:SetValue(L"更新")
end
