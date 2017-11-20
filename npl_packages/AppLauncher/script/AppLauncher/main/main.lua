-- main loop
-- LiXizhi

NPL.load("(gl)script/ide/System/System.lua")
local launcher_debug = ParaEngine.GetAppCommandLineByParam("launcher_debug", nil);

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
    NPL.load("(gl)script/AppLauncher/lang/lang.lua");
	NPL.load("script/AppLauncher/main/PageLoader.lua");
    local PageLoader = commonlib.gettable("AppLauncher.PageLoader");
    if(launcher_debug)then
        PageLoader.ShowAppPage();
    else
        PageLoader.CheckVersion()
    end
end

local main_state = nil;
NPL.this(function()
	if(not main_state) then
		main_state = "inited";
		ShowLauncher();
	end
end);