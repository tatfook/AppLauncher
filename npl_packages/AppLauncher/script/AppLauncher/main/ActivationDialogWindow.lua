local Window = commonlib.gettable("System.Windows.Window")
local MainWindow = commonlib.gettable("AppLauncher.MainWindow")

local ActivationDialogWindow = commonlib.gettable("AppLauncher.ActivationDialogWindow")

function ActivationDialogWindow.OnInit()
    ActivationDialogWindow.page = document:GetPageCtrl()
end

function ActivationDialogWindow.OnSure()

end

function ActivationDialogWindow.OnCancel()

end

function ActivationDialogWindow.ShowPage()
    local window = Window:new()
	window:Show({
		url = "script/AppLauncher/main/ActivationDialogWindow.html",
		alignment = "_ct", left = 0, top = 0, width = 296, height = 170,
	})

    ActivationDialogWindow.window = window
end
