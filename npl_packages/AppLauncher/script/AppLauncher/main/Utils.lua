NPL.load("script/AppLauncher/main/MessageWindow.lua")
local MessageWindow = commonlib.gettable("AppLauncher.MessageWindow")

local Utils = commonlib.gettable("AppLauncher.Utils")

function Utils.SaveUserInfo(username, password)
    local local_data = Utils.LoadLocalData("KeepWork_Local_UserInfo_Data", {}, true)
    local_data.username = username
    local_data.password = password
    Utils.SaveLocalData("KeepWork_Local_UserInfo_Data", local_data, true)
end

function Utils.ClearUserInfo()
    local local_data = Utils.LoadLocalData("KeepWork_Local_UserInfo_Data", {}, true)
    local_data.username = nil
    local_data.password = nil
    Utils.SaveLocalData("KeepWork_Local_UserInfo_Data", local_data, true)
end

function Utils.GetUserName()
    local local_data = Utils.LoadLocalData("KeepWork_Local_UserInfo_Data", {}, true)
    return local_data.username or ""
end

function Utils.GetPassword()
    local local_data = Utils.LoadLocalData("KeepWork_Local_UserInfo_Data", {}, true)
    return local_data.password or ""
end

function Utils.IsSavePassword()
    return string.len(Utils.GetPassword()) > 0
end

function Utils.SaveIsAutoLogin(isAutoLogin)
    local local_data = Utils.LoadLocalData("KeepWork_Local_UserInfo_Data", {}, true)
    local_data.isAutoLogin = isAutoLogin
    Utils.SaveLocalData("KeepWork_Local_UserInfo_Data", local_data, true)
end

function Utils.IsAutoLogin()
    local local_data = Utils.LoadLocalData("KeepWork_Local_UserInfo_Data", {}, true)
    return local_data.isAutoLogin
end

function Utils.ClearAutoLogin()
    local local_data = Utils.LoadLocalData("KeepWork_Local_UserInfo_Data", {}, true)
    local_data.isAutoLogin = nil
    Utils.SaveLocalData("KeepWork_Local_UserInfo_Data", local_data, true)
end

function Utils.LoadLocalData(name, default_value, bIsGlobal)
    local ls = System.localserver.CreateStore(nil, 3, nil--[[if_else(System.options.version == "teen", "userdata.teen", "userdata")]]);
	if(not ls) then
		LOG.std(nil, "warn", "AppLauncher", "Utils.LoadLocalData %s failed because userdata db is not valid", name)
		return default_value;
	end
	local url;
	-- make url
	if(not bIsGlobal) then
		url = NPL.EncodeURLQuery(name, {"nid", Map3DSystem.User.nid})
	else
		url = name;
	end

	local item = ls:GetItem(url)

	if(item and item.entry and item.payload) then
		local output_msg = commonlib.LoadTableFromString(item.payload.data);
		if(output_msg) then
			return output_msg.value;
		end
	end
	return default_value;
end

function Utils.SaveLocalData(name, value, bIsGlobal, bDeferSave)
	local ls = System.localserver.CreateStore(nil, 3, nil--[[if_else(System.options.version == "teen", "userdata.teen", "userdata")]]);
	if(not ls) then
		return;
	end
	-- make url
	local url;
	if(not bIsGlobal) then
		url = NPL.EncodeURLQuery(name, {"nid", Map3DSystem.User.nid})
	else
		url = name;
	end

	-- make entry
	local item = {
		entry = System.localserver.WebCacheDB.EntryInfo:new({
			url = url,
		}),
		payload = System.localserver.WebCacheDB.PayloadInfo:new({
			status_code = System.localserver.HttpConstants.HTTP_OK,
			data = {value = value},
		}),
	}
	-- save to database entry
	local res = ls:PutItem(item, not bDeferSave);
	if(res) then
		LOG.std("", "debug","AppLauncher", "Local user data %s is saved to local server", tostring(url));
		return true;
	else
		LOG.std("", "warn","AppLauncher", "failed saving local user data %s to local server", tostring(url))
	end
end

function Utils.Login(username, password, callback)
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
            if type(callback) == "function" then
                callback(false)
            end
            return
        end

        if data and data.data and data.data.token then
            local token = data.data.token
            local username = data.data.userinfo.username
		    LOG.std(nil, "debug", "keepwork login username", username)
		    LOG.std(nil, "debug", "keepwork login token", token)

            Utils.AgreeOauth(username, "1000003", token, callback)
            return
        end

        if data and data.error then
            MessageWindow.Show(data.error.message, nil, MessageWindow.Buttons.OK)
            if type(callback) == "function" then
                callback(false)
            end
            return
        end
    end)
end

function Utils.AgreeOauth(username, clientID, token, callback)
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
            if type(callback) == "function" then
                callback(false)
            end
            return
        end

        if data and data.data and data.data.code then
            local code = data.data.code;
		    LOG.std(nil, "debug", "keepwork agreeOauth code", code);

            if type(callback) == "function" then
                callback(true)
            end

            return
        end

        if data and data.error then
            MessageWindow.Show(data.error.message, nil, MessageWindow.Buttons.OK)

            if type(callback) == "function" then
                callback(false)
            end
        end
    end)
end

function Utils.Logout(callback)
    Utils.ClearToken()
    Utils.ClearUserInfo()
    Utils.ClearAutoLogin()

    if type(callback) == "function" then
        callback()
    end
end

function Utils.SaveToken(token)
    local local_data = Utils.LoadLocalData("KeepWork_Local_UserInfo_Data", {}, true)
    local_data.token = token
    Utils.SaveLocalData("KeepWork_Local_UserInfo_Data", local_data, true)
end

function Utils.GetToken()
    local local_data = Utils.LoadLocalData("KeepWork_Local_UserInfo_Data", {}, true)
    return local_data.token or ""
end

function Utils.ClearToken()
    local local_data = Utils.LoadLocalData("KeepWork_Local_UserInfo_Data", {}, true)
    local_data.token = nil
    Utils.SaveLocalData("KeepWork_Local_UserInfo_Data", local_data, true)
end
