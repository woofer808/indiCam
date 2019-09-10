

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
				postInit = 1;
				file = "\INDICAM\indiCam_init.sqf";
			};
		};

	};
};
