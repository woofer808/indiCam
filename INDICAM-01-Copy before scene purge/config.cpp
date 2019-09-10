
class CfgPatches 
{
	class INDICAM
	{
		units[] = {};
		weapons[] = {};
		requiredAddons[] = {};
		name = indiCam;
		author = "woofer";
	};
};



class CfgFunctions
{
	class INDI
	{
		class INDI_Initialization
		{
			class Init
			{
				postInit = 1;
				file = "\INDICAM\indiCam_init.sqf";
			};
		};

	};
};

#include "indiCam_gui\indiCam_gui_definitions.hpp"
#include "indiCam_gui\indiCam_gui_dialogs.hpp"