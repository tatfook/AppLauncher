local Window = commonlib.gettable("System.Windows.Window")
NPL.load("script/AppLauncher/main/MessageWindow.lua")
local MessageWindow = commonlib.gettable("AppLauncher.MessageWindow")
local MainWindow = commonlib.gettable("AppLauncher.MainWindow")

local LoginWindow = commonlib.gettable("AppLauncher.LoginWindow")

LoginWindow.client_id = "1000003"

function LoginWindow.OnInit()
    LoginWindow.page = document:GetPageCtrl()

    LoginWindow.IsSavePassword = false
    LoginWindow.IsAutoLogin = false

    LoginWindow.Username = ""
    LoginWindow.Password = ""
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

function LoginWindow.Close()
    if LoginWindow.window then
        LoginWindow.window.CloseWindow(true)
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

    if string.len(username) == 0 then
        MessageWindow.Show(L"账号不能为空!", nil, MessageWindow.Buttons.OK)
		return
    end

    if string.len(password) == 0 then
        MessageWindow.Show(L"密码不能为空!", nil, MessageWindow.Buttons.OK)
		return
    end

    local url = "http://keepwork.com/api/wiki/models/user/login"
    System.os.GetUrl({
        url = url,
        json = true,
        form = {
            username = username,
		    password = password,
        }
    }, function(err, msg, data)
		LOG.std(nil, "debug", "keepwork login err", err)
		LOG.std(nil, "debug", "keepwork login msg", msg)
		LOG.std(nil, "debug", "keepwork login data", data)

        if err and err == 503 then
            MessageWindow.Show(L"keepwork正在维护中，我们马上回来", nil, MessageWindow.Buttons.OK)
            return
        end

        if data and data.data and data.data.token then
            local token = data.data.token
            local username = data.data.userinfo.username
		    LOG.std(nil, "debug", "keepwork login username", username)
		    LOG.std(nil, "debug", "keepwork login token", token)

            LoginWindow.Username = username
            LoginWindow.Password = password

            LoginWindow.AgreeOauth(username, LoginWindow.client_id, token)
            return
        end

        if data and data.error then
            MessageWindow.Show(data.error.message, nil, MessageWindow.Buttons.OK)
            return
        end
    end)
end

function LoginWindow.AgreeOauth(username, clientID, token)
    local url = "http://keepwork.com/api/wiki/models/oauth_app/agreeOauth";
    System.os.GetUrl({
        url = url,
        json = true,
        form = {
            username = username,
		    client_id = clientID,
        },
        headers = {
            ["Authorization"] = " Bearer " .. token,
        },
    }, function(err, msg, data)
		LOG.std(nil, "debug", "keepwork agreeOauth err", err);
		LOG.std(nil, "debug", "keepwork agreeOauth msg", msg);
		LOG.std(nil, "debug", "keepwork agreeOauth data", data);
        if err and err == 503 then
            MessageWindow.Show(L"keepwork正在维护中，我们马上回来", nil, MessageWindow.Buttons.OK)
            return
        end

        if data and data.data and data.data.code then
            local code = data.data.code;
		    LOG.std(nil, "debug", "keepwork agreeOauth code", code);
            LoginWindow.Close()
            if LoginWindow.IsSavePassword then
                LoginWindow.SaveLocalData(username, LoginWindow.Password)
            else
                LoginWindow.SaveLocalData(username, nil)
            end

            LoginWindow.SaveLocalData("IsAutoLogin", LoginWindow.IsAutoLogin)

            MainWindow.OnLoginSuccess(username)
            return
        end

        if data and data.error then
            MessageWindow.Show(data.error.message, nil, MessageWindow.Buttons.OK)
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

function LoginWindow.OnCheckSavePassword()
    if LoginWindow.page then
        local checkbox = LoginWindow.page:GetNode("checkbox_savepassword")
        LoginWindow.IsSavePassword = checkbox:isChecked()
    end
end

function LoginWindow.OnCheckAutoLogin()
    if LoginWindow.page then
        local checkbox = LoginWindow.page:GetNode("checkbox_autologin")
        LoginWindow.IsAutoLogin = checkbox:isChecked()
    end
end

function LoginWindow.SaveLocalData(key, value)

end
