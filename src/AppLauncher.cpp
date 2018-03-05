//-----------------------------------------------------------------------------
// Class:	App Launcher for NPL Applications
// Authors:	LiXizhi
// Emails:	LiXizhi@yeah.net
// Company: ParaEngine Co.
// Date:	2017.10.2
//-----------------------------------------------------------------------------
#include "AppLauncher.h"
#include "IO/ResourceEmbedded.h"
#include <Psapi.h>
#include <windows.h>
#include <fstream>
#include <Shellapi.h>
using namespace ParaEngine;

std::string sParentDir;
std::string g_strProcessName;

//-----------------------------------------------------------------------------
// Name: WinMain()
/// Entry point to the program. Initializes everything, and goes into a
///       message-processing loop. Idle time is used to render the scene.
//-----------------------------------------------------------------------------
INT WINAPI WinMain( HINSTANCE hInst, HINSTANCE, LPSTR lpCmdLine, INT )
{
    static const char* ExeName = "AppLauncher.exe";
    static const char* ImgExeName = "AppLauncher.mem.exe";

    DWORD pid = GetCurrentProcessId();
    HANDLE handle = OpenProcess(PROCESS_QUERY_INFORMATION | PROCESS_VM_READ, FALSE, pid);
    if (handle)
    {
        TCHAR processName[2048];
        //get process path
        if (GetModuleFileNameEx(handle, 0, processName, 2048))
        {
            g_strProcessName = processName;
            int len = (int)(g_strProcessName.size());
            std::string::size_type last_dir_index = g_strProcessName.find_last_of("/\\");
            if (last_dir_index != std::string::npos)
            {
                // this ensures that the application is in the directory where module is installed. 
                sParentDir = g_strProcessName.substr(0, last_dir_index + 1);
                ::SetCurrentDirectoryA(sParentDir.c_str());
            }
            // for debug version, we will skip mem.exe copy, so that we can set breakpoints and debug. 
#ifndef _DEBUG
            if (processName[len - 8] != '.' || processName[len - 7] != 'm' || processName[len - 6] != 'e'
                || processName[len - 5] != 'm' || processName[len - 4] != '.' || processName[len - 3] != 'e'
                || processName[len - 2] != 'x' || processName[len - 1] != 'e')
            {
                // AutoUpdate::FileUtils::setWriteable(std::string(ImgExeName));
                if (!CopyFile(ExeName, ImgExeName, FALSE))
                {
                    DWORD err = GetLastError();
                    std::ofstream fileStream("log.txt", std::ios_base::app);
                    if (!fileStream.fail())
                    {
                        fileStream << "err code:" << err << ", Launcher:copy process failed\n";
                    }
                }

                if (GetFileAttributes(ImgExeName) != INVALID_FILE_ATTRIBUTES)
                {
                    if (::ShellExecute((HWND)NULL, "open", ImgExeName, NULL, NULL, 1) > ((HINSTANCE)32))
                    {
                        return 0;
                    }
                    else
                    {
                        OUTPUT_LOG("%s process ShellExecute failed, we will use the current %s to launch\n", ImgExeName, ExeName);
                    }
                }
            }
#endif
        }
    }

	std::string sAppCmdLine;
	if(lpCmdLine)
		sAppCmdLine = lpCmdLine;
	

	auto pParaEngine = ParaEngine::GetCOREInterface();
	if (pParaEngine)
	{
		auto pParaEngineApp = pParaEngine->CreateApp();

		if (pParaEngineApp == 0)
			return E_FAIL;
		std::string sCmd = lpCmdLine;
		sCmd.append(" bootstrapper=\"script/AppLauncher/main/main.lua\"");

#ifdef _DEBUG
		sCmd.append(" launcher_debug=\"true\"");
#endif // _DEBUG

		if (pParaEngineApp->StartApp(sCmd.c_str()) != S_OK)
			return E_FAIL;

		// load archive from embedded resource 
		ADD_RESOURCE("npl_packages/LauncherScript.zip", AppLauncher_zip);
		ADD_RESOURCE("npl_packages/AppLauncherTexture.zip", AppLauncherTexture_zip);
		ADD_RESOURCE("npl_packages/Mod_AutoUpdater.zip", AutoUpdater_zip);
		ADD_RESOURCE("npl_packages/TruckStar.zip", TruckStar_zip);

		pParaEngineApp->LoadNPLPackage("npl_packages/LauncherScript/");
		pParaEngineApp->LoadNPLPackage("npl_packages/AppLauncherTexture/");
		pParaEngineApp->LoadNPLPackage("npl_packages/Mod_AutoUpdater/");
		pParaEngineApp->LoadNPLPackage("npl_packages/TruckStar/");
#ifdef NDEBUG
		ADD_RESOURCE("cmakes/main/Mod_main.zip", main_zip);
		pParaEngineApp->LoadNPLPackage("cmakes/main/Mod_main/");
#endif
		// Run to end
		auto result = pParaEngineApp->Run(hInst);
		pParaEngine->Destroy();
		return result;
	}
	return 0;
}

