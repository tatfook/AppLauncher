--[[
Title: TipsWindow
Author(s): Shangzhi
Date: 2017/11/24
Desc:
]]
local Window = commonlib.gettable("System.Windows.Window")
local MainWindow = commonlib.gettable("AppLauncher.MainWindow")

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

    TipsWindow.window = window
end

function TipsWindow.OnJump()
    local node = MainWindow.GetSelectedNode()
    if node then
        MainWindow.OpenApp(node.id)
    else
        LOG.std(nil, "debug", "AppLauncher", "TipsWindow.OnJump() failed. Can not get the selected node.")
    end
end

function TipsWindow.OnUpdate()
    MainWindow.OnUpdate()

    TipsWindow.window:CloseWindow(true)
    TipsWindow.window = nil
end
