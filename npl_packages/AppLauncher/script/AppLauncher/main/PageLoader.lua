--[[
Title: PageLoader.lua
Author(s): leio
Date: 2017/11/9
Desc: 
use the lib:
------------------------------------------------------------
NPL.load("script/AppLauncher/main/PageLoader.lua");
local PageLoader = commonlib.gettable("AppLauncher.PageLoader");
PageLoader.Download();
------------------------------------------------------------
]]
local PageLoader = commonlib.gettable("AppLauncher.PageLoader");
PageLoader.index = 0;
PageLoader.html_name = "MainWindow.html";
PageLoader.lua_name = "MainWindow.lua";
PageLoader.status = {
    finished = 1,
    error = 2,
}
PageLoader.pages = {
    {url  = "http://git.keepwork.com/gitlab_rls_zhanglei/keepworkhelloworld/raw/master/zhanglei/helloworld/MainWindowHtml.md", name = PageLoader.html_name, },
    {url  = "http://git.keepwork.com/gitlab_rls_zhanglei/keepworkhelloworld/raw/master/zhanglei/helloworld/MainWindowLua.md", name = PageLoader.lua_name, },
}
function PageLoader.ShowLocalPage()
    NPL.load("script/AppLauncher/main/MainWindow.lua");
    local MainWindow = commonlib.gettable("AppLauncher.MainWindow");
    MainWindow.ShowPage("script/AppLauncher/main/MainWindow.html");
end
function PageLoader.Download()
    PageLoader.DownloadNext(function(status)
        if(status == PageLoader.status.finished)then
	        LOG.std(nil, "debug", "PageLoader", "Show Remote Page");
            NPL.load(PageLoader.lua_name);
            local MainWindow = commonlib.gettable("AppLauncher.MainWindow");
            MainWindow.ShowPage(PageLoader.html_name);
        else
	        LOG.std(nil, "debug", "PageLoader", "Show Local Page");
            PageLoader.ShowLocalPage();
        end
    end)
end
function PageLoader.DownloadNext(callback)
    PageLoader.index = PageLoader.index + 1;
    local len = #PageLoader.pages;
    if(PageLoader.index > len)then
        callback(PageLoader.status.finished);  
        return;      
    end
    local page = PageLoader.pages[PageLoader.index];
    local url = page.url;
    local name = page.name;
	LOG.std(nil, "debug", "PageLoader", "Downloading:%s", url);
    System.os.GetUrl(url, function(err, msg, data)  
	        LOG.std(nil, "debug", "PageLoader", "Download status:%d", err);
            if(err == 200)then
                if(data)then
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