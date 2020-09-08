
class CfgPatches 
{
	class INDICAM
	{
		units[] = {};
		weapons[] = {};
		requiredAddons[] = {"A3_Ui_F"};
		name = indiCam;
		author = "woofer";
		requiredVersion = 0.1;
		version = 1;
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
				file = "\INDICAM\indiCam_core_init.sqf";
			};
		};
	};
};


#include "indiCam_gui\indiCam_gui_definitions.hpp"
#include "indiCam_gui\indiCam_gui_dialogs.hpp"

//#include "\a3\editor_f\Data\Scripts\dikCodes.h"