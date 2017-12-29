--[[
Title: URL protocol handler
Author(s): LiXizhi,leio
Date: 2016/1/19
Desc: singleton class
Use Lib:
-------------------------------------------------------
NPL.load("script/AppLauncher/main/AppUrlProtocolHandler.lua");
local AppUrlProtocolHandler = commonlib.gettable("AppLauncher.AppUrlProtocolHandler");
-------------------------------------------------------
]]
NPL.load("script/AppLauncher/main/MessageWindow.lua");
local MessageWindow = commonlib.gettable("AppLauncher.MessageWindow");

local AppUrlProtocolHandler = commonlib.gettable("AppLauncher.AppUrlProtocolHandler");

--@param cmdline: if nil we will read from current cmd line
function AppUrlProtocolHandler:ParseCommand(cmdline)
	local cmdline = cmdline or ParaEngine.GetAppCommandLine();
	local urlProtocol = string.match(cmdline or "", "paracraft://(.*)$");

	if(urlProtocol) then

		NPL.load("(gl)script/ide/Encoding.lua");
		urlProtocol = commonlib.Encoding.url_decode(urlProtocol);
		LOG.std(nil, "info", "AppUrlProtocolHandler", "protocol paracraft://%s", urlProtocol);
		-- paracraft://cmd/loadworld/[url_filename]
		local world_url = urlProtocol:match("^cmd/loadworld[%s/]+([%S]*)");
		if(world_url and world_url:match("^https?://")) then
			System.options.cmdline_world = world_url;
		end
	end
end

-- this will spawn a new process that request for admin right
-- @param protocol_name: TODO: default to "paracraft"
function AppUrlProtocolHandler:RegisterUrlProtocol(protocol_name,protocol_exe_name)
	local protocol_name = protocol_name or "paracraft";
	local res = System.os([[reg query "HKCR\]]..protocol_name)
	if(res and res:match("URL Protocol")) then
		LOG.std(nil, "info", "RegisterUrlProtocol", "%s url protocol is already installed. We will overwrite it anyway", protocol_name);
	end
	protocol_exe_name = protocol_exe_name or "ParaEngineClient.exe";
	local bindir = ParaIO.GetCurDirectory(0):gsub("/", "\\");
	local file = ParaIO.open("path.txt", "w");
	file:WriteString(bindir..protocol_exe_name);
	file:close();
	local res = System.os.runAsAdmin([[
reg add "HKCR\paracraft" /ve /d "URL:paracraft" /f
reg add "HKCR\paracraft" /v "URL Protocol" /d ""  /f
set /p EXEPATH=<"%~dp0path.txt"
reg add "HKCR\paracraft\shell\open\command" /ve /d "\"%EXEPATH%\" mc=\"true\" %%1" /f
del "%~dp0path.txt"
]]);
	LOG.std(nil, "info", "RegisterUrlProtocol", "%s to %s", protocol_name, bindir..protocol_exe_name);
end

-- return true if url protocol is installed
-- @param protocol_name: default to "paracraft://"
function AppUrlProtocolHandler:HasUrlProtocol(protocol_name)
	protocol_name = protocol_name or "paracraft";
	protocol_name = protocol_name:gsub("[://]+","");

	local has_protocol = ParaGlobal.ReadRegStr("HKCR", protocol_name, "URL Protocol") or "";
	if(has_protocol == "") then
		-- following code is further check, which is not needed. 
		has_protocol = ParaGlobal.ReadRegStr("HKCR", protocol_name, "");
		if(has_protocol == "URL:"..protocol_name) then
			local cmd = ParaGlobal.ReadRegStr("HKCR", protocol_name.."/shell/open/command", "");
			if(cmd) then
				local filename = cmd:gsub("/", "\\"):match("\"([^\"]+)");
				if(ParaIO.DoesFileExist(filename, false)) then
					LOG.std(nil, "info", "Url protocol", "%s:// is %s", protocol_name, cmd);
					return true;
				else
					LOG.std(nil, "warn", "Url protocol", "%s:// file not found at %s", protocol_name, filename);
				end
			end
		end
	end
end

function AppUrlProtocolHandler:CheckInstallUrlProtocol(protocol_name,protocol_exe_name)
	if(System.os.GetPlatform() == "win32") then
		if(self:HasUrlProtocol(protocol_name)) then
			return true;
		else
			MessageWindow.Show(L"安装URL Protocol, 可用浏览器打开3D世界, 是否现在安装？(可能需要管理员权限)",function(res)
				if(res and res == MessageWindow.DialogResult.Yes) then
						self:RegisterUrlProtocol(protocol_name,protocol_exe_name);
				end
			end,MessageWindow.Buttons.YesNo);
		end
	end
end