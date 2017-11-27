--[[
Title: TipsWindow
Author(s): Shangzhi
Date: 2017/11/24
Desc:
]]
local Window = commonlib.gettable("System.Windows.Window")

local TipsWindow = commonlib.gettable("AppLauncher.TipsWindow")

function TipsWindow.OnInit()

end

function TipsWindow.ShowPage()
    local window = Window:new();
    url = "script/AppLauncher/main/TipsWindow.html";
	window:Show({
		url = url,
		alignment = "_ct", left = -250, top = -154.5, width = 500, height = 309,
	});
end
