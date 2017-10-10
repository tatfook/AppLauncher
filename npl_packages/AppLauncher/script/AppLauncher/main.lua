-- main loop
-- LiXizhi

NPL.load("(gl)script/ide/System/System.lua")

local function DumpUsedFiles()
	local files = __rts__:GetStats({loadedfiles={}})

	for filename, status in pairs(files.loadedfiles) do
		if(ParaIO.DoesFileExist(filename)) then
			echo(filename)
		end
	end
end

-- DumpUsedFiles();


local function ShowLauncher()
	NPL.load("(gl)script/ide/System/Windows/Window.lua");
	local Window = commonlib.gettable("System.Windows.Window")
	local window = Window:new();
	window:Show({
		url="script/AppLauncher/MainWindow.html", 
		alignment="_fi", left = 0, top = 0, width = 0, height = 0,
	});
end

local main_state = nil;
NPL.this(function()
	if(not main_state) then
		main_state = "inited";
		ShowLauncher();
	end
end);