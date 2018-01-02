local Window = commonlib.gettable("System.Windows.Window")

local LoginWindow = commonlib.gettable("AppLauncher.LoginWindow")

function LoginWindow.OnInit()
    LoginWindow.page = document:GetPageCtrl()
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
