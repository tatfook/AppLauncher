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
local version_url = "https://raw.githubusercontent.com/tatfook/AppLauncher/master/npl_packages/AppLauncher/script/AppLauncher/versions/LauncherVersion.lua";
local assets_url = "https://raw.githubusercontent.com/tatfook/AppLauncher/master/npl_packages/AppLauncher/script/AppLauncher/versions/LauncherAssets.lua";
local version_latest_filepath = "temp/LauncherVersion.lua";
local assets_latest_filepath = "temp/LauncherAssets.lua";
local version_old_filepath = "versions/LauncherVersion.lua";
local version_file_prefix = "versions/launcher";
PageLoader.index = 0;
PageLoader.status = {
    finished = 1,
    error = 2,
}
PageLoader.download_assets = nil;
PageLoader.old_version = -1;
PageLoader.latest_version = 0;
function PageLoader.LoadFileModule(path)
    if(not path)then return {} end
    local full_path = ParaIO.GetCurDirectory(0) .. path;
    if(ParaIO.DoesFileExist(full_path))then
        local mod = NPL.load(path);
        return mod;
    end
    return {};
end
function PageLoader.DownloadFileModle(url,filepath,callback)
    if(not url or not filepath)then
        callback(PageLoader.status.error);
        return
    end
    System.os.GetUrl(url, function(err, msg, data)  
        if(err == 200)then
            if(data)then
                ParaIO.CreateDirectory(filepath);
                local file = ParaIO.open(filepath,"w");
                if(file:IsValid()) then
					file:write(data,#data);
					file:close();
                    callback(PageLoader.status.finished);
                end
            else
                callback(PageLoader.status.error);
            end
        else
            callback(PageLoader.status.error);
        end
    end);
end
function PageLoader.CheckVersion()
    --load local version
    local Old_LauncherVersion = PageLoader.LoadFileModule(version_old_filepath);
    if(Old_LauncherVersion.version)then
        PageLoader.old_version = Old_LauncherVersion.version;
    end
    --load remote version
    PageLoader.DownloadFileModle(version_url,version_latest_filepath,function(s)
        if(s == PageLoader.status.error)then
            PageLoader.ShowAppPage(true,false);
        elseif(PageLoader.status.finished)then
            local version_module = PageLoader.LoadFileModule(version_latest_filepath);
            PageLoader.latest_version = version_module.version or 0;
	        LOG.std(nil, "debug", "CheckVersion", "old_version:%s           latest_version:%s", tostring(PageLoader.old_version), tostring(PageLoader.latest_version));
            --set temp latest_version to download assets
            if(PageLoader.latest_version > PageLoader.old_version)then
                PageLoader.DownloadFileModle(assets_url,assets_latest_filepath,function(s)
                    if(s == PageLoader.status.error)then
                        PageLoader.ShowAppPage(true,false);
                    elseif(PageLoader.status.finished)then
                        local assets_module = PageLoader.LoadFileModule(assets_latest_filepath);
                        if(assets_module and assets_module.latest_assets)then
                            PageLoader.index = 0;
                            PageLoader.download_assets = assets_module.latest_assets;

                             PageLoader.DownloadNext(function(status)
                                if(status == PageLoader.status.finished)then
                                    --update version
                                    ParaIO.MoveFile(version_latest_filepath,version_old_filepath);

                                    -- load the latest packages
                                    PageLoader.ShowAppPage(true,true);
                                else
                                    -- load the old pacakges
                                    PageLoader.ShowAppPage(true,false);
                                end
                            end)
                        end
                    end
                end);
            else
                -- load the old pacakges
                PageLoader.ShowAppPage(true,false);
            end
        end
    end)
end
function PageLoader.GetDownloadFolder_Latest()
    local s = string.format("%s_%s",version_file_prefix,PageLoader.latest_version);
    return s;
end
function PageLoader.GetDownloadFolder_Old()
    local s = string.format("%s_%s",version_file_prefix,PageLoader.old_version);
    return s;
end
-- @param is_check:if true enable search path
-- @param is_latest:if ture add search path with the latest folder,otherwise use old path
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