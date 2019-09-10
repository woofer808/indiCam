comment "-------------------------------------------------------------------------------------------------------";
comment "											indiCam, by woofer.											";
comment "																										";
comment "										indiCam_scene_defaultScripted									";
comment "																										";
comment "	This is an example script of a complex scripted camera that can be called from sceneSelect.			";
comment "																										";
comment "-------------------------------------------------------------------------------------------------------";
//[] execVM "indiCam\indiCam_scene_defaultScripted.sqf";



comment "-------------------------------------------------------------------------------------------------------";
comment "	Code block script init																				";
indiCam_var_scriptedSceneDone = false;
comment "-------------------------------------------------------------------------------------------------------";



comment "-------------------------------------------------------------------------------------------------------";
comment "	Camera script code																					";
/*
This is where the code goes.
Use all available functions within the indiCam scripts like logics or tests to script your own scenes outside of the main loop.
*/



/* Interrupt condition */
// Maybe I should convert the main loop's interrupt to a function that I can call wherever?
// Then I can put it in here as well.
// Either that or I'll have to figure a way to maybe spawn this script like a regular scene and add something to the main interrupt loop.




// Detach camera if needed
if (!(indiCam_appliedVar_cameraAttach)) then {detach indiCam};






comment "-------------------------------------------------------------------------------------------------------";




comment "-------------------------------------------------------------------------------------------------------";
comment "	Code block script ending																				";
indiCam_var_scriptedSceneDone = true;
comment "-------------------------------------------------------------------------------------------------------";
