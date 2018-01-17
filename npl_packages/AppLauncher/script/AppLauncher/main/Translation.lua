local Translation = commonlib.gettable("AppLauncher.Translation")

local currentLanguage

function Translation.GetSystemLanguage()
	local langID = ParaEngine.GetAttributeObject():GetField("CurrentLanguage", 0);
	if(langID == 1) then
		return "zhCN";
	else
		return "enUS";
	end
end

function Translation.GetCurrentLanguage()
	if(currentLanguage) then
		return currentLanguage;
	else
		currentLanguage = ParaEngine.GetLocale();
		return currentLanguage;
	end
end

function Translation.SetCurrentLanguage(lan)
    currentLanguage = lan
    ParaEngine.SetLocale(currentLanguage)
end
