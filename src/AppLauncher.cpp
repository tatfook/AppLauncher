//-----------------------------------------------------------------------------
// Class:	App Launcher for NPL Applications
// Authors:	LiXizhi
// Emails:	LiXizhi@yeah.net
// Company: ParaEngine Co.
// Date:	2017.10.2
//-----------------------------------------------------------------------------
#include "AppLauncher.h"

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
	
	return 0;
}
