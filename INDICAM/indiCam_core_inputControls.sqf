/* -------------------------------------------------------------------------------------------------------
 * 									    indiCam_core_inputControls
 *
 * 	This purpose of this script is to keep the basic indiCam controls updated for the player.
 *
 *    F1 - Stop camera / open GUI	
 *    F2 - Force new scene
 *    F3 - Force new actor
 *    F4 - Manual mode
 *    F5 - Previous vision mode	
 *    F6 - Next vision mode
 *    F9 - Print scene name to chat
 *
 * ------------------------------------------------------------------------------------------------------- */




// Needs cleanup
if (indiCam_debug) then {
	if (isClass(configFile >> "CfgPatches" >> "cba_main_a3")) then {
		systemChat "indiCam --> CBA loaded, using that!";
	} else {
		systemChat "indiCam --> CBA not loaded! Gotta use F1 for indiCam controls";
	};
};




comment "-------------------------------------------------------------------------------------------------------";
comment "	Stop camera / Open GUI - F1-key																		";
comment "-------------------------------------------------------------------------------------------------------";
// This can only be initialized once and has to be persistent, so the control is located in indiCam_core_init

 

// Make sure the camera is running before attempting to create the camera control button event handlers
waituntil {indiCam_var_currentMode != "off"};



comment "-------------------------------------------------------------------------------------------------------";
comment "	Next scene - F2-key																					";
comment "-------------------------------------------------------------------------------------------------------";
// Define the function that is to run when the CBA bound key is pressed.
indiCam_fnc_keypressNextScene = {
	if (indiCam_var_currentMode == "running") then {indiCam_var_requestMode = "default"};
};

// Assign the key depending on CBA being loaded or not
if (isClass(configFile >> "CfgPatches" >> "cba_main_a3")) then {
	// [ "addonName" , "actionID" , ["pretty name","tooltip"] , {downCode} , {upCode} ]
	["indiCam","nextScene", ["next scene", "Forces a scene switch according to current settings."], {
		if (indiCam_running) then { // Only execute if the camera is running
			_this spawn indiCam_fnc_keypressNextScene
		};
	}, {}, [60, [false, false, false]]] call CBA_fnc_addKeybind;
	
} else {
	
	// When the camera isn't running, the EH will be killed off
	[] spawn {
		while {indiCam_running} do {
			waituntil {(inputAction "SelectGroupUnit2" > 0) or (!indiCam_running)};
			if (!indiCam_running) exitWith {};
			if (indiCam_debug) then {systemChat "F2-key pressed"};
			[] spawn indiCam_fnc_keypressNextScene;
			waituntil {inputAction "SelectGroupUnit2" <= 0};
		};
	};
};


comment "-------------------------------------------------------------------------------------------------------";
comment "	New actor - F3-key																					";
comment "-------------------------------------------------------------------------------------------------------";

// Assign the key depending on CBA being loaded or not
if (isClass(configFile >> "CfgPatches" >> "cba_main_a3")) then {
	// [ "addonName" , "actionID" , ["pretty name","tooltip"] , {downCode} , {upCode} ]
	["indiCam","newActor", ["next actor", "Forces switching to new actor and scene according to current settings."], {
		if (indiCam_running) then { // Only execute if the camera is running
			[] call indiCam_fnc_actorSwitch;
			indiCam_var_requestMode = "default";
		};
	}, {}, [61, [false, false, false]]] call CBA_fnc_addKeybind;
	
} else {
	
	// When the camera isn't running, the EH will be killed off
	[] spawn {
		while {indiCam_running} do {
			waituntil {(inputAction "SelectGroupUnit3" > 0) or (!indiCam_running)};
			if (!indiCam_running) exitWith {};
			if (indiCam_debug) then {systemChat "F3-key pressed"};
			[] call indiCam_fnc_actorSwitch;
			indiCam_var_requestMode = "default";
			waituntil {inputAction "SelectGroupUnit3" <= 0};
		};
	};
};




comment "-------------------------------------------------------------------------------------------------------";
comment "	Manual mode - F4-key																				";
comment "-------------------------------------------------------------------------------------------------------";

// Assign the key depending on CBA being loaded or not
if (isClass(configFile >> "CfgPatches" >> "cba_main_a3")) then {

	// [ "addonName" , "actionID" , ["pretty name","tooltip"] , {downCode} , {upCode} ]
	["indiCam","manualMode", ["manual mode", "Engage the vanilla splendid camera in manual mode. L-key will turn off or on the red square."], {
		if (indiCam_running) then { // Only execute if the camera is running
			[] spawn indiCam_fnc_manualMode;
		};
	}, {}, [62, [false, false, false]]] call CBA_fnc_addKeybind;
	
} else {
	
	// When the camera isn't running, the EH will be killed off
	[] spawn {
		while {indiCam_running} do {
			waituntil {(inputAction "SelectGroupUnit4" > 0) or (!indiCam_running)};
			if (!indiCam_running) exitWith {};
			if (indiCam_debug) then {systemChat "F4-key pressed"};
			[] spawn indiCam_fnc_manualMode;
			waituntil {inputAction "SelectGroupUnit4" <= 0};
		};
	};
	
};





comment "-------------------------------------------------------------------------------------------------------";
comment "	Previous vision mode - F5-key																		";
comment "-------------------------------------------------------------------------------------------------------";

// Assign the key depending on CBA being loaded or not
if (isClass(configFile >> "CfgPatches" >> "cba_main_a3")) then {

	// [ "addonName" , "actionID" , ["pretty name","tooltip"] , {downCode} , {upCode} ]
	["indiCam","previousVisionMode", ["previous vision mode", "Cycles to the previous vision mode."], {
		if (indiCam_running) then { // Only execute if the camera is running
			["previous"] call indiCam_fnc_visionMode;
		};
	}, {}, [63, [false, false, false]]] call CBA_fnc_addKeybind;
	
} else {
	
	// When the camera isn't running, the EH will be killed off
	[] spawn {
		while {indiCam_running} do {
			waituntil {(inputAction "SelectGroupUnit5" > 0) or (!indiCam_running)};
			if (!indiCam_running) exitWith {};
			if (indiCam_debug) then {systemChat "F5-key pressed"};
			["previous"] call indiCam_fnc_visionMode;
			waituntil {inputAction "SelectGroupUnit5" <= 0};
		};
	};
};





comment "-------------------------------------------------------------------------------------------------------";
comment "	Next vision mode - F6-key																			";
comment "-------------------------------------------------------------------------------------------------------";

// Assign the key depending on CBA being loaded or not
if (isClass(configFile >> "CfgPatches" >> "cba_main_a3")) then {

	// [ "addonName" , "actionID" , ["pretty name","tooltip"] , {downCode} , {upCode} ]
	["indiCam","nextVisionMode", ["next vision mode", "Cycles to the next vision mode."], {
		if (indiCam_running) then { // Only execute if the camera is running
			["next"] call indiCam_fnc_visionMode;
		};
	}, {}, [64, [false, false, false]]] call CBA_fnc_addKeybind;
	
} else {
	
	// When the camera isn't running, the EH will be killed off
	[] spawn {
		while {indiCam_running} do {
			waituntil {(inputAction "SelectGroupUnit6" > 0) or (!indiCam_running)};
			if (!indiCam_running) exitWith {};
			if (indiCam_debug) then {systemChat "F6-key pressed"};
			["next"] call indiCam_fnc_visionMode;
			waituntil {inputAction "SelectGroupUnit6" <= 0};
		};
	};
};





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



// Assign the key depending on CBA being loaded or not
if (isClass(configFile >> "CfgPatches" >> "cba_main_a3")) then {

	// [ "addonName" , "actionID" , ["pretty name","tooltip"] , {downCode} , {upCode} ]
	["indiCam","scenePrint", ["print scene name", "Prints current scene to screen and stores it in array. (development use)"], {
		if (indiCam_running) then { // Only execute if the camera is running
			[] call indiCam_fnc_scenePrint;
		};
	}, {}, [67, [false, false, false]]] call CBA_fnc_addKeybind;
	
} else {
	
	// When the camera isn't running, the EH will be killed off
	[] spawn {
		while {indiCam_running} do {
			waituntil {(inputAction "SelectGroupUnit9" > 0) or (!indiCam_running)};
			if (!indiCam_running) exitWith {};
			if (indiCam_debug) then {systemChat "F9-key pressed"};
			[] call indiCam_fnc_scenePrint;
			waituntil {inputAction "SelectGroupUnit9" <= 0};
		};
	};
};
