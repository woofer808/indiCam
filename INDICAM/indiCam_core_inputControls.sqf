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


// Make sure the camera is running before attempting to create the camera control button event handlers
waituntil {indiCam_var_currentMode != "off";};


/* Commenting out this one as it is used for the GUI. Probably will have to make it run only if gui is present
/* ----------------------------------------------------------------------------------------------------
			Stop Camera / Open GUI - F1
   ---------------------------------------------------------------------------------------------------- */
// When the camera isn't running, the EH will be killed off
[] spawn {
		while {indiCam_running} do {
			waituntil {(inputAction "SelectGroupUnit1" > 0) or (!indiCam_running)};
			if (indiCam_debug) then {systemChat "F1-key pressed"};
			indiCam_running = false;
			indiCam_var_manualMode = false;
			waituntil {inputAction "SelectGroupUnit1" <= 0};
		};
};


/* ----------------------------------------------------------------------------------------------------
			Next Scene - F2
   ---------------------------------------------------------------------------------------------------- */
// When the camera isn't running, the EH will be killed off
[] spawn {
	while {indiCam_running} do {
		waituntil {(inputAction "SelectGroupUnit2" > 0)};
		if (indiCam_var_currentMode == "running") then {indiCam_var_requestMode = "default"};
		if (indiCam_debug) then {systemChat "F2-key pressed"};
		waituntil {inputAction "SelectGroupUnit2" <= 0};
	};
};

/* ----------------------------------------------------------------------------------------------------
			New Actor - F3
   ---------------------------------------------------------------------------------------------------- */
// When the camera isn't running, the EH will be killed off
[] spawn {
	while {indiCam_running} do {
		waituntil {(inputAction "SelectGroupUnit3" > 0)};
		[] call indiCam_fnc_actorSwitch;
		indiCam_var_requestMode = "default";
		if (indiCam_debug) then {systemChat "F3-key pressed"};
		waituntil {inputAction "SelectGroupUnit3" <= 0};
	};
};

/* ----------------------------------------------------------------------------------------------------
			Manual Mode - F4
   ---------------------------------------------------------------------------------------------------- */
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

// When the camera isn't running, the EH will be killed off
[] spawn {
	indiCam_var_interruptScene = false;
	while {indiCam_running} do {
		waituntil {(inputAction "SelectGroupUnit4" > 0) or (!indiCam_running)};
		if (indiCam_running) then {
			if (indiCam_debug) then {systemChat "F4-key pressed"};
			// Randomize a new player actor by starting to look within 25m of the current actor
			[] call indiCam_fnc_manualMode;
		};
		waituntil {inputAction "SelectGroupUnit4" <= 0};
	};
};

/* ----------------------------------------------------------------------------------------------------
			Previous Vision Mode - F5
   ---------------------------------------------------------------------------------------------------- */
// When the camera isn't running, the EH will be killed off
[] spawn {
	while {indiCam_running} do {
		waituntil {(inputAction "SelectGroupUnit5" > 0)};
		["previous"] call indiCam_fnc_visionMode;
		if (indiCam_debug) then {systemChat "F5-key pressed"};
		waituntil {inputAction "SelectGroupUnit5" <= 0};
	};
};

/* ----------------------------------------------------------------------------------------------------
			Next Vision Mode - F6
   ---------------------------------------------------------------------------------------------------- */
// When the camera isn't running, the EH will be killed off
[] spawn {
	while {indiCam_running} do {
		waituntil {(inputAction "SelectGroupUnit6" > 0)};
		["next"] call indiCam_fnc_visionMode;
		if (indiCam_debug) then {systemChat "F6-key pressed"};
		waituntil {inputAction "SelectGroupUnit6" <= 0};
	};
};

/* ----------------------------------------------------------------------------------------------------
			Print Scene - F9
   ---------------------------------------------------------------------------------------------------- */
// Will print scene name in systemChat and store in an array for later use - useful for development
// When the camera isn't running, the EH will be killed off
[] spawn {

	[] spawn{
		// Make the list show as a hint when camera is stopped
		waitUntil {indiCam_var_currentMode == "running"};
		waitUntil {!indiCam_running};
		hintSilent str indiCam_var_sceneList;
	};

	while {indiCam_running} do {
		waituntil {(inputAction "SelectGroupUnit9" > 0) or (!indiCam_running)};
		if (indiCam_running) then {
			if (indiCam_debug) then {systemChat "F9-key pressed"};
			// Print the current scene name to the screen
			systemchat str indiCam_var_previousScene;
			indiCam_var_sceneList pushBackUnique indiCam_var_previousScene;
		};
		waituntil {inputAction "SelectGroupUnit9" <= 0};
	};
};
