--[[
Author(s): leio
Date: 2017/11/16
-------------------------------------------------------
NPL.load("(gl)script/AppLauncher/lang/lang.lua");
-------------------------------------------------------
]]
-- One can set a different language other than the default one in the application command line.
local lang = ParaEngine.GetAppCommandLineByParam("lang", nil);
echo("=======lang");
echo(lang);
if(lang~=nil) then
	if(lang=="enUS" or lang=="zhCN") then
		ParaEngine.SetLocale(lang);
	end	
end

NPL.load("(gl)script/ide/Locale.lua");
CommonCtrl.Locale.AutoLoadFile("script/AppLauncher/lang/AppLauncher-zhCN.lua");
CommonCtrl.Locale.AutoLoadFile("script/AppLauncher/lang/AppLauncher-enUS.lua");
-- global L variable, one may overwrite this during startup.
L = CommonCtrl.Locale("AppLauncher");
