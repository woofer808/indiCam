comment "-------------------------------------------------------------------------------------------------------";
comment "											indiCam, by woofer.											";
comment "																										";
comment "									    indiCam_core_inputControls										";
comment "																										";
comment "	Register keybinds with CBA eventhandlers.															";
comment "																										";
comment "   F1 - Stop camera / open GUI																			";
comment "   F2 - Force new scene																				";
comment "   F3 - Force new actor																				";
comment "   F4 - Manual mode																					";
comment "   F5 - Previous vision mode																			";
comment "   F6 - Next vision mode																				";
comment "   F9 - Print scene name to chat																		";
comment "																										";
comment "-------------------------------------------------------------------------------------------------------";


/* DIK keycodes
https://community.bistudio.com/wiki/DIK_KeyCodes
DIK_F1	0x3B, DEC_F1 59
*/




comment "-------------------------------------------------------------------------------------------------------";
comment "	Stop camera / Open GUI - F1-key																		";
comment "-------------------------------------------------------------------------------------------------------";
// When the camera isn't running, the EH will be killed off

// Define the function that is to run when the CBA bound key is pressed.
indiCam_fnc_keyGUI = {
	// Only open the dialog if it's not already open
	if (isNull (findDisplay indiCam_id_guiDialogMain)) then {createDialog "indiCam_gui_dialogMain";} else {closeDialog 0};
};	
// [ "addonName" , "actionID" , ["pretty name","tooltip"] , {downCode} , {upCode} ]
["indiCam","guiKey", ["indiCam control windows", "Show or hide indiCam controls."], {_this spawn indiCam_fnc_keyGUI}, {}, [59, [false, false, false]]] call CBA_fnc_addKeybind;




comment "-------------------------------------------------------------------------------------------------------";
comment "	Next scene - F2-key																					";
comment "-------------------------------------------------------------------------------------------------------";
// Define the function that is to run when the CBA bound key is pressed.
indiCam_fnc_keypressNextScene = {
	if (indiCam_var_currentMode == "running") then {indiCam_var_requestMode = "default"};
};
// [ "addonName" , "actionID" , ["pretty name","tooltip"] , {downCode} , {upCode} ]
["indiCam","nextScene", ["next scene", "Forces a scene switch according to current settings."], {
	if (indiCam_running) then { // Only execute if the camera is running
		_this spawn indiCam_fnc_keypressNextScene
	};
}, {}, [60, [false, false, false]]] call CBA_fnc_addKeybind;



comment "-------------------------------------------------------------------------------------------------------";
comment "	New actor - F3-key																					";
comment "-------------------------------------------------------------------------------------------------------";
// [ "addonName" , "actionID" , ["pretty name","tooltip"] , {downCode} , {upCode} ]
["indiCam","newActor", ["next actor", "Forces switching to new actor and scene according to current settings."], {
	if (indiCam_running) then { // Only execute if the camera is running
		[] call indiCam_fnc_actorSwitch;
		indiCam_var_requestMode = "default";
	};
}, {}, [61, [false, false, false]]] call CBA_fnc_addKeybind;




comment "-------------------------------------------------------------------------------------------------------";
comment "	Manual mode - F4-key																				";
comment "-------------------------------------------------------------------------------------------------------";
// Define the function that is to run when the CBA bound key is pressed.
indiCam_fnc_manualMode = {
	if (indiCam_var_currentMode != "manual") then { // This is a basic toggle
		if (indiCam_debug) then {systemChat "manual camera controls on"};
		indiCam_camera camSetTarget indiCam_actor;
		indiCam_camera camCommand "manual on";
		indiCam_var_requestMode = "manual";
	} else {
		indiCam_camera camCommand "manual off";
		indiCam_var_requestMode = "default";
		if (indiCam_debug) then {systemChat "manual camera controls off"};
	};
};



// [ "addonName" , "actionID" , ["pretty name","tooltip"] , {downCode} , {upCode} ]
["indiCam","manualMode", ["manual mode", "Engage the vanilla splendid camera in manual mode. L-key will turn off or on the red square."], {
	if (indiCam_running) then { // Only execute if the camera is running
		[] spawn indiCam_fnc_manualMode;
	};
}, {}, [62, [false, false, false]]] call CBA_fnc_addKeybind;


comment "-------------------------------------------------------------------------------------------------------";
comment "	Previous vision mode - F5-key																		";
comment "-------------------------------------------------------------------------------------------------------";
// [ "addonName" , "actionID" , ["pretty name","tooltip"] , {downCode} , {upCode} ]
["indiCam","previousVisionMode", ["previous vision mode", "Cycles to the previous vision mode."], {
	if (indiCam_running) then { // Only execute if the camera is running
		["previous"] call indiCam_fnc_visionMode;
	};
}, {}, [63, [false, false, false]]] call CBA_fnc_addKeybind;



comment "-------------------------------------------------------------------------------------------------------";
comment "	Next vision mode - F6-key																			";
comment "-------------------------------------------------------------------------------------------------------";
// [ "addonName" , "actionID" , ["pretty name","tooltip"] , {downCode} , {upCode} ]
["indiCam","nextVisionMode", ["next vision mode", "Cycles to the next vision mode."], {
	if (indiCam_running) then { // Only execute if the camera is running
		["next"] call indiCam_fnc_visionMode;
	};
}, {}, [64, [false, false, false]]] call CBA_fnc_addKeybind;



comment "-------------------------------------------------------------------------------------------------------";
comment "	Print scene - F9-key																				";
comment "-------------------------------------------------------------------------------------------------------";
// Spawn a script that will print scene names if the key was pressed during camera operation
[] spawn {
	while {true} do {
		// Make the list show as a hint when camera is stopped
		waitUntil {indiCam_var_currentMode == "running"};
		waitUntil {!indiCam_running};
		hintSilent str indiCam_var_sceneList;
	};
};
// [ "addonName" , "actionID" , ["pretty name","tooltip"] , {downCode} , {upCode} ]
indiCam_fnc_scenePrint = {
	systemchat str indiCam_var_previousScene;
	indiCam_var_sceneList pushBackUnique indiCam_var_previousScene;
};

// [ "addonName" , "actionID" , ["pretty name","tooltip"] , {downCode} , {upCode} ]
["indiCam","scenePrint", ["print scene name", "Prints current scene to screen and stores it in array. (development use)"], {
	if (indiCam_running) then { // Only execute if the camera is running
		[] call indiCam_fnc_scenePrint;
	};
}, {}, [67, [false, false, false]]] call CBA_fnc_addKeybind;
