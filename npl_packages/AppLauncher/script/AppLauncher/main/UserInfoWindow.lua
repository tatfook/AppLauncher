local Window = commonlib.gettable("System.Windows.Window")

NPL.load("script/AppLauncher/main/Utils.lua")
local Utils = commonlib.gettable("AppLauncher.Utils")
local MainWindow = commonlib.gettable("AppLauncher.MainWindow")

local UserInfoWindow = commonlib.gettable("AppLauncher.UserInfoWindow")

function UserInfoWindow.OnInit()
    UserInfoWindow.page = document:GetPageCtrl()
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

end

function UserInfoWindow.OnSetting()

end

function UserInfoWindow.OnLogout()
    Utils.Logout(function ()
        UserInfoWindow.Close()
        MainWindow.OnLogoutSuccess()
    end)
end
