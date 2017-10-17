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
	NPL.load("script/AppLauncher/MainWindow.lua");
    local MainWindow = commonlib.gettable("AppLauncher.MainWindow");
    MainWindow.ShowPage();
end

local main_state = nil;
NPL.this(function()
	if(not main_state) then
		main_state = "inited";
		ShowLauncher();
	end
end);