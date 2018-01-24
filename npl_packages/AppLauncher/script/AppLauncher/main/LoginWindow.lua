local Window = commonlib.gettable("System.Windows.Window")
NPL.load("script/AppLauncher/main/MessageWindow.lua")
local MessageWindow = commonlib.gettable("AppLauncher.MessageWindow")
local MainWindow = commonlib.gettable("AppLauncher.MainWindow")

NPL.load("script/AppLauncher/main/Utils.lua")
local Utils = commonlib.gettable("AppLauncher.Utils")

local LoginWindow = commonlib.gettable("AppLauncher.LoginWindow")

function LoginWindow.OnInit()
    LoginWindow.page = document:GetPageCtrl()

    LoginWindow.IsSavePassword = Utils.IsSavePassword()
    LoginWindow.IsAutoLogin = Utils.IsAutoLogin()

    LOG.std(nil, "debug", "AppLauncher", string.format("Utils.IsSavePassword() --> %s", LoginWindow.IsSavePassword and "yes" or "no"))
    LOG.std(nil, "debug", "AppLauncher", string.format("Utils.IsAutoLogin() --> %s", LoginWindow.IsAutoLogin and "yes" or "no"))

    LoginWindow.SetCheckSavePassword(LoginWindow.IsSavePassword)
    LoginWindow.SetCheckAutoLogin(LoginWindow.IsAutoLogin)

    if LoginWindow.IsSavePassword then
        LoginWindow.Username = Utils.GetUserName()
        LoginWindow.Password = Utils.GetPassword()

        LoginWindow.SetUsernameToInput(LoginWindow.Username)
        LoginWindow.SetPasswordToInput(LoginWindow.Password)
    else
        LoginWindow.Username = ""
        LoginWindow.Password = ""
    end

    LoginWindow.UpdateLanguage()
    LoginWindow.RefreshPage()
end

function LoginWindow.ShowPage()
    local window = Window:new();
    url = "script/AppLauncher/main/LoginWindow.html";

    local width, height = 214, 210

	window:Show({
		url = url,
		alignment = "_ct", left = -width/2, top = -height/2, width = width, height = height,
	});

    LoginWindow.window = window

end

function LoginWindow.RefreshPage()
    if LoginWindow.page then
        LoginWindow.page:Refresh(0)
    end
end

function LoginWindow.Close()
    if LoginWindow.window then
        LoginWindow.window:CloseWindow(true)
        LoginWindow.window = nil
    end
end

function LoginWindow.OnLogin()
    LoginWindow.last_send_time = LoginWindow.last_send_time or 0
	local curTime = ParaGlobal.timeGetTime()
	if (curTime - LoginWindow.last_send_time) < 3000 then
        MessageWindow.Show(L"正在登陆，请等待。。。", nil, MessageWindow.Buttons.OK)
		return
	end
	LoginWindow.last_send_time = curTime

    local username = LoginWindow.GetUsernameFromInput()
    local password = LoginWindow.GetPasswordFromInput()
    LOG.std(nil, "debug", "AppLauncher", "username: %s, password: %s", username, password)

    Utils.Login(username, password, function (isSuccess, showUserName)
        if isSuccess then
            LoginWindow.Close()

            LoginWindow.SavePassword()

            MainWindow.OnLoginSuccess(showUserName)
        end
    end)
end

function LoginWindow.GetUsernameFromInput()
    if LoginWindow.page then
        local input = LoginWindow.page:GetNode("username_input")
        if input then
            local str = input:GetUIValue() or ""
            return string.gsub(str, "^%s*(.-)%s*$", "%1")
        end
    end
    return ""
end

function LoginWindow.SetUsernameToInput(username)
    if LoginWindow.page then
        local input = LoginWindow.page:GetNode("username_input")
        if input then
            input:SetUIValue(username)
        end
    end
end

function LoginWindow.GetPasswordFromInput()
    if LoginWindow.page then
        local input = LoginWindow.page:GetNode("password_input")
        if input then
            local str = input:GetUIValue() or ""
            return string.gsub(str, "^%s*(.-)%s*$", "%1")
        end
    end
    return ""
end

function LoginWindow.SetPasswordToInput(password)
    if LoginWindow.page then
        local input = LoginWindow.page:GetNode("username_input")
        if input then
            input:SetUIValue(password)
        end
    end
end

function LoginWindow.OnCheckSavePassword()
    if LoginWindow.page then
        local checkbox = LoginWindow.page:GetNode("checkbox_savepassword")
        LoginWindow.IsSavePassword = checkbox:GetControl():isChecked()
        LOG.std(nil, "debug", "AppLauncher", string.format("Save password? %s", LoginWindow.IsSavePassword and "yes" or "no"))

        LoginWindow.SavePassword()
    end
end

function LoginWindow.SetCheckSavePassword(isCheck)
    if LoginWindow.page then
        local checkbox = LoginWindow.page:GetNode("checkbox_savepassword")
        LOG.std(nil, "debug", "AppLauncher", string.format("LoginWindow.SetCheckSavePassword(%s)", isCheck and "true" or "false"))
        checkbox:setChecked(isCheck)
    end
end

function LoginWindow.OnCheckAutoLogin()
    if LoginWindow.page then
        local checkbox = LoginWindow.page:GetNode("checkbox_autologin")
        LoginWindow.IsAutoLogin = checkbox:GetControl():isChecked()
        LOG.std(nil, "debug", "AppLauncher", string.format("Auto login? %s", LoginWindow.IsAutoLogin and "yes" or "no"))

        Utils.SaveIsAutoLogin(LoginWindow.IsAutoLogin)
    end
end

function LoginWindow.SetCheckAutoLogin(isCheck)
    if LoginWindow.page then
        local checkbox = LoginWindow.page:GetNode("checkbox_autologin")
        checkbox:setChecked(isCheck)
    end
end

function LoginWindow.SavePassword()
    if LoginWindow.IsSavePassword then
        Utils.SaveUserInfo(LoginWindow.GetUsernameFromInput(), LoginWindow.GetPasswordFromInput())
    else
        Utils.SaveUserInfo(nil, nil)
    end
end

function LoginWindow.UpdateLanguage()
    local button_login = LoginWindow.page:GetNodeByID("button_login")
    button_login:SetValue(L"登录")

    local button_register = LoginWindow.page:GetNodeByID("button_register")
    button_register:SetValue(L"点击注册")
end

function LoginWindow.OnRegister()
    local url = "http://keepwork.com/wiki/join"
    ParaGlobal.ShellExecute("open", "iexplore.exe", url, "", 1)
end
