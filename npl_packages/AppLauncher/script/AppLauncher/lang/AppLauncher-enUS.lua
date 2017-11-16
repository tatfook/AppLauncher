--[[
Author(s): leio
Date: 2017/11/16
------------------------------------------------------------
]]
NPL.load("(gl)script/ide/Locale.lua");
local L = CommonCtrl.Locale("AppLauncher");
L:RegisterTranslations("enUS", function() return {
    ["版本(%s)"] = "version(%s)",
    ["当前版本(%s)        最新版本(%s)"] = "cur version(%s)        latest version(%s)",
}
end)