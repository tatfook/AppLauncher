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
	ADD_RESOURCE(":AppLauncherPackage", AppLauncher_zip);

	auto pParaEngine = ParaEngine::GetCOREInterface();
	if (pParaEngine)
	{
		auto pParaEngineApp = pParaEngine->CreateApp();

		if (pParaEngineApp == 0)
			return E_FAIL;

		// TODO: load archive from ":AppLauncherPackage"
		// pParaEngineApp->LoadNPLPackage();

		if (pParaEngineApp->StartApp(lpCmdLine) != S_OK)
			return E_FAIL;

		// Run to end
		return pParaEngineApp->Run(hInst);
	}
	return 0;
}
