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

DumpUsedFiles();

log("1111111111111111111\n")
ParaGlobal.Exit(0);