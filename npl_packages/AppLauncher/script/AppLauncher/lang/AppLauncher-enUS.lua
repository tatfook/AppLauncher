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
    ["已经最最新版，不需要在更新"] = "Already latest version",
    ["准备下载版本号"] = "Ready to download version number",
    ["下载版本号"] = "Downloading version number",
    ["检测版本号"] = "Checking version number",
    ["版本号错误"] = "Version number error",
    ["准备下载文件列表"] = "Ready to download list of files",
    ["下载文件列表"] = "Downloading list of files",
    ["下载文件列表完成"] = "Downloading list of files finished",
    ["下载文件列表错误"] = "Downloading list of files error",
    ["准备下载资源文件"] = "Ready to download resource files",
    ["下载资源文件结束"] = "Downloading resource files finished",
    ["下载资源文件错误"] = "Downloading resource files error",
    ["准备更新"] = "Ready to update",
    ["更新中"] = "Updating",
    ["更新完成"] = "Updated",
    ["更新错误"] = "Updating error",
    ["登录"] = "Login",
    ["注册"] = "Register",
    ["已经激活"] = "Activated",
    ["激活"] = "Activate"
    ["进入"] = "Enter",
    ["更新"] = "Update",
}
end)
