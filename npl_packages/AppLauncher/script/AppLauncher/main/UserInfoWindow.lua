local Window = commonlib.gettable("System.Windows.Window")

NPL.load("script/AppLauncher/main/Utils.lua")
local Utils = commonlib.gettable("AppLauncher.Utils")
local MainWindow = commonlib.gettable("AppLauncher.MainWindow")

local UserInfoWindow = commonlib.gettable("AppLauncher.UserInfoWindow")

function UserInfoWindow.OnInit()
    UserInfoWindow.page = document:GetPageCtrl()

    UserInfoWindow.UpdateLanguage()
    UserInfoWindow.RefreshPage()
end

function UserInfoWindow.RefreshPage()
    if UserInfoWindow.page then
        UserInfoWindow.page:Refresh(0)
    end
end

function UserInfoWindow.ShowPage(username)
    UserInfoWindow.UserName = username

    local window = Window:new();
    url = "script/AppLauncher/main/UserInfoWindow.html";

    local width, height = 214, 210

	window:Show({
		url = url,
		alignment = "_ct", left = -width/2, top = -height/2, width = width, height = height,
	});

    UserInfoWindow.window = window

end

function UserInfoWindow.Close()
    if UserInfoWindow.window then
        UserInfoWindow.window:CloseWindow(true)
        UserInfoWindow.window = nil
    end
end

function UserInfoWindow.GetUserName()
    return UserInfoWindow.UserName
end

function UserInfoWindow.OnHome()
    local url = "http://keepwork.com/"..UserInfoWindow.UserName
    ParaGlobal.ShellExecute("open", "iexplore.exe", url, "", 1)
end

function UserInfoWindow.OnSetting()
    local url = "http://keepwork.com/wiki/user_center"
    ParaGlobal.ShellExecute("open", "iexplore.exe", url, "", 1)
end

function UserInfoWindow.OnLogout()
    Utils.Logout(function ()
        UserInfoWindow.Close()
        MainWindow.OnLogoutSuccess()
    end)
end

function UserInfoWindow.UpdateLanguage()
    local button_home = UserInfoWindow.page:GetNode("button_home")
    if button_home then
        button_home:SetValue(L"我的主页")
    end

    local button_setting = UserInfoWindow.page:GetNode("button_setting")
    if button_setting then
        button_setting:SetValue(L"设置中心")
    end

    local button_logout = UserInfoWindow.page:GetNode("button_logout")
    if button_logout then
        button_logout:SetValue(L"退出登录")
    end
end
