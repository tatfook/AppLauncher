--[[
Title: PageLoader.lua
Author(s): leio
Date: 2017/11/9
Desc: 
use the lib:
------------------------------------------------------------
NPL.load("script/AppLauncher/main/PageLoader.lua");
local PageLoader = commonlib.gettable("AppLauncher.PageLoader");
PageLoader.CheckVersion()
------------------------------------------------------------
]]
local PageLoader = commonlib.gettable("AppLauncher.PageLoader");
local version_url = "";
local version_latest_filepath = "temp/LauncherVersion.lua";
local version_filepath = "versions/LauncherVersion.lua";
local version_file_prefix = "versions/launcher";
PageLoader.index = 0;
PageLoader.status = {
    finished = 1,
    error = 2,
}
PageLoader.download_assets = nil;
PageLoader.old_version = 0;
PageLoader.latest_version = 0;
function PageLoader.CheckVersion()
    --load local version
    local Old_LauncherVersion = NPL.load("version/LauncherVersion.lua");
    local old_version = Old_LauncherVersion.version or 0;
    PageLoader.old_version = old_version;
    --load remote version
    System.os.GetUrl(version_url, function(err, msg, data)  
        if(err == 200)then
            if(data)then
                ParaIO.CreateDirectory(version_latest_filepath);
                local file = ParaIO.open(version_latest_filepath,"w");
                if(file:IsValid()) then
					file:write(data,#data);
					file:close();

                    local Latest_LauncherVersion = NPL.load(version_latest_filepath);
                    local latest_version = Latest_LauncherVersion.version or 0;
                    --set temp latest_version to download assets
                    PageLoader.latest_version = latest_version;
                    if(latest_version > old_version)then
                        --download latest assets
                        if(Latest_LauncherVersion.latest_assets)then
                            PageLoader.index = 0;
                            PageLoader.download_assets = Latest_LauncherVersion.latest_assets;

                             PageLoader.DownloadNext(function(status)
                                if(status == PageLoader.status.finished)then
                                    --update version
                                    ParaIO.MoveFile(version_latest_filepath,version_filepath);

                                    -- load the latest packages
                                    PageLoader.ShowAppPage(true,true);
                                else
                                    -- load the old pacakges
                                    PageLoader.ShowAppPage(true,false);
                                end
                            end)
                        else
                            PageLoader.ShowAppPage(true,false);
                        end
                    else
                        PageLoader.ShowAppPage(true,false);
                    end
                end
            else
                PageLoader.ShowAppPage(true,false);
            end
        else
            PageLoader.ShowAppPage(true,false);
        end
    end);
end
function PageLoader.GetDownloadFolder_Latest()
    local s = string.format("%s_%s",version_file_prefix,PageLoader.latest_version);
    return s;
end
function PageLoader.GetDownloadFolder_Old()
    local s = string.format("%s_%s",version_file_prefix,PageLoader.old_version);
    return s;
end
-- @param is_check:check if add search path
-- @param is_latest:if ture add search path with the latest folder,otherwise old
function PageLoader.ShowAppPage(is_check,is_latest)
    if(is_check)then
        if(is_latest)then
            ParaIO.AddSearchPath(PageLoader.GetDownloadFolder_Latest());
        else
            ParaIO.AddSearchPath(PageLoader.GetDownloadFolder_Old());
        end
    end
    NPL.load("script/AppLauncher/main/MainWindow.lua");
    local MainWindow = commonlib.gettable("AppLauncher.MainWindow");
    MainWindow.ShowPage();
end
function PageLoader.DownloadNext(callback)
    PageLoader.index = PageLoader.index + 1;
    local len = #PageLoader.download_assets;
    if(PageLoader.index > len)then
        callback(PageLoader.status.finished);  
        return;      
    end
    local page = PageLoader.download_assets[PageLoader.index];
    local url = page.url;
    local name = page.name;
	LOG.std(nil, "debug", "PageLoader", "Downloading:%s", url);
    System.os.GetUrl(url, function(err, msg, data)  
	        LOG.std(nil, "debug", "PageLoader", "Download status:%d", err);
            if(err == 200)then
                if(data)then
                    name = PageLoader.GetDownloadFolder_Latest() .. "/" .. name;
	                ParaIO.CreateDirectory(name);
                    local file = ParaIO.open(name,"w");
                    if(file:IsValid()) then
					    file:write(data,#data);
					    file:close();
                        PageLoader.DownloadNext(callback);
                        return;
                    end
                    callback(PageLoader.status.error);        
                end
            else
                callback(PageLoader.status.error);        
            end
        end);
end