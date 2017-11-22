//-----------------------------------------------------------------------------
// Class:	App Launcher for NPL Applications
// Authors:	LiXizhi
// Emails:	LiXizhi@yeah.net
// Company: ParaEngine Co.
// Date:	2017.10.2
//-----------------------------------------------------------------------------
#include "AppLauncher.h"
#include "IO/ResourceEmbedded.h"
using namespace ParaEngine;

//-----------------------------------------------------------------------------
// Name: WinMain()
/// Entry point to the program. Initializes everything, and goes into a
///       message-processing loop. Idle time is used to render the scene.
//-----------------------------------------------------------------------------
INT WINAPI WinMain( HINSTANCE hInst, HINSTANCE, LPSTR lpCmdLine, INT )
{
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
		pParaEngineApp->LoadNPLPackage("npl_packages/LauncherScript/");
		pParaEngineApp->LoadNPLPackage("npl_packages/AppLauncherTexture/");
		pParaEngineApp->LoadNPLPackage("npl_packages/Mod_AutoUpdater/");
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
