comment "-------------------------------------------------------------------------------------------------------";
comment "											indiCam, by woofer.											";
comment "																										";
comment "										independent cinematic camera									";
comment "																										";
comment "																										";
comment "	The purpose of the init is to compile all functions and set all variables from start.				";
comment "																										";
comment "-------------------------------------------------------------------------------------------------------";


comment "-------------------------------------------------------------------------------------------------------";
comment "												variables												";
comment "-------------------------------------------------------------------------------------------------------";
indiCam = [];


comment "-------------------------------------------------------------------------------------------------------";
comment "												scripts													";
comment "-------------------------------------------------------------------------------------------------------";
[] execVM "INDICAM\indiCam_diary.sqf"


comment "-------------------------------------------------------------------------------------------------------";
comment "												functions												";
comment "-------------------------------------------------------------------------------------------------------";

woof_fnc_indiCam = compile preprocessFileLineNumbers "INDICAM\woof_fnc_indiCam2.sqf";
woof_fnc_sceneSelector = compile preprocessFileLineNumbers "INDICAM\woof_fnc_sceneSelector.sqf";
woof_fnc_situationCheck = compile preprocessFileLineNumbers "INDICAM\woof_fnc_situationCheck.sqf";
woof_fnc_visibilityCheck = compile preprocessFileLineNumbers "INDICAM\woof_fnc_visibilityCheck.sqf";
woof_fnc_cameraControl = compile preprocessFileLineNumbers "INDICAM\woof_fnc_cameraControl.sqf";





