

class CfgPatches 
{
	class INDICAM
	{
		units[] = {};
		weapons[] = {}; 
		requiredAddons[] = {};	
		author[]= {"woofer"}; 		
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
				file = "\INDICAM\woof_indiCam_init.sqf";
				preInit = 1;
			};
		};

	};
};
