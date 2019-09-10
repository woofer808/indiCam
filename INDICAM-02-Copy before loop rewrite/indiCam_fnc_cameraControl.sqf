comment "-------------------------------------------------------------------------------------------------------";
comment "											indiCam, by woofer.											";
comment "																										";
comment "										  indiCam_fnc_cameraControl										";
comment "																										";
comment "	This purpose of this script is to keep the indiCam controls updated for the player					";
comment "																										";
comment "-------------------------------------------------------------------------------------------------------";

// Make sure the camera is running before attempting to create the camera control button event handlers
waituntil {indiCam_runIndiCam};


/* Commenting out this one as it is used for the GUI. Probably will have to make it run only if gui is present

// This EH waits for button press that terminates the script
// When the camera isn't running, the EH will be killed off
[] spawn {
		while {indiCam_runIndiCam} do {
			waituntil {(inputAction "SelectGroupUnit1" > 0) or (!indiCam_runIndiCam)};
			if (indiCam_debug) then {systemChat "F1-key pressed"};
			indiCam_runIndiCam = false;
			indiCam_var_manualMode = false;
			waituntil {inputAction "SelectGroupUnit1" <= 0};
		};
};
*/


// This EH waits for button press that forces the next scene
// When the camera isn't running, the EH will be killed off
[] spawn {
	indiCam_var_interruptScene = false;
	while {indiCam_runIndiCam} do {
		waituntil {(inputAction "SelectGroupUnit2" > 0) or (!indiCam_runIndiCam)};
		if (indiCam_runIndiCam) then {
			if (indiCam_debug) then {systemChat "F2-key pressed"};
			indiCam_var_interruptScene = true;
		};
		waituntil {inputAction "SelectGroupUnit2" <= 0};
	};
};




// This EH waits for button press that switches to a new actor
// When the camera isn't running, the EH will be killed off
[] spawn {
	indiCam_var_interruptScene = false;
	while {indiCam_runIndiCam} do {
		waituntil {(inputAction "SelectGroupUnit3" > 0) or (!indiCam_runIndiCam)};
		if (indiCam_runIndiCam) then {
			if (indiCam_debug) then {systemChat "F3-key pressed"};
			// Randomize a new player actor by starting to look within 25m of the current actor
			[indiCam_var_actorAutoSwitchMode,300] call indiCam_fnc_actorAutoSwitch;
		};
		waituntil {inputAction "SelectGroupUnit3" <= 0};
	};
};



// Set the initial values for view mode
camUseNVG false;
false setCamUseTI 0;

indiCam_fnc_visionMode = {
	if (indiCam_var_visionIndex == 0) then {false setCamUseTI 0;camUseNVG false;if (indiCam_debug) then {systemChat "0 - Automatic"};};
	if (indiCam_var_visionIndex == 1) then {false setCamUseTI 0;camUseNVG true;if (indiCam_debug) then {systemChat "1 - Night vision"};};
	if (indiCam_var_visionIndex == 2) then {camUseNVG false;true setCamUseTI 0;if (indiCam_debug) then {systemChat "2 - White Hot"};};
	if (indiCam_var_visionIndex == 3) then {camUseNVG false;true setCamUseTI 1;if (indiCam_debug) then {systemChat "3 - Black Hot"};};
	if (indiCam_var_visionIndex == 4) then {camUseNVG false;true setCamUseTI 2;if (indiCam_debug) then {systemChat "4 - Light Green Hot / Darker Green cold"};};
	if (indiCam_var_visionIndex == 5) then {camUseNVG false;true setCamUseTI 3;if (indiCam_debug) then {systemChat "5 - Black Hot / Darker Green cold"};};
	if (indiCam_var_visionIndex == 6) then {camUseNVG false;true setCamUseTI 4;if (indiCam_debug) then {systemChat "6 - Light Red Hot /Darker Red Cold"};};
	if (indiCam_var_visionIndex == 7) then {camUseNVG false;true setCamUseTI 5;if (indiCam_debug) then {systemChat "7 - Black Hot / Darker Red Cold"};};
	if (indiCam_var_visionIndex == 8) then {camUseNVG false;true setCamUseTI 6;if (indiCam_debug) then {systemChat "8 - White Hot / Darker Red Cold"};};
	if (indiCam_var_visionIndex == 9) then {camUseNVG false;true setCamUseTI 7;if (indiCam_debug) then {systemChat "9 - Thermal (Shade of Red and Green, Bodies are white)"};};
	if (indiCam_var_visionIndex == 10) then {false setCamUseTI 0;camUseNVG false;if (indiCam_debug) then {systemChat "10 - Forced Daylight"};};
	
	
	/* This will put a light above an actor - use to create the flashlight-effect
	_light = "#lightpoint" createVehicleLocal (getPosATL actor); 
	_light setLightBrightness 0.75; 
	_light setLightAmbient [0.75, 0.75, 0.75]; 
	_light setLightColor [0.75, 0.75, 0.75]; 
	_light lightAttachObject [actor, [0,0,10]];
	
	*/
	
	
};
[] call indiCam_fnc_visionMode; // Make sure to set the previous set vision mode if the camera has been started once.


// This EH waits for button press that switches to previous vision mode
// When the camera isn't running, the EH will be killed off
[] spawn {
	while {indiCam_runIndiCam} do {
		waituntil {(inputAction "SelectGroupUnit5" > 0) or (!indiCam_runIndiCam)};
		if (indiCam_runIndiCam) then {
			if (indiCam_debug) then {systemChat "F5-key pressed"};
			indiCam_var_visionIndex = indiCam_var_visionIndex - 1;
			if (indiCam_var_visionIndex < 0) then {indiCam_var_visionIndex = 10};
			[] call indiCam_fnc_visionMode;
		};
		waituntil {inputAction "SelectGroupUnit5" <= 0};
	};
};


// This EH waits for button press that switches to next vision mode
// When the camera isn't running, the EH will be killed off
[] spawn {
	while {indiCam_runIndiCam} do {
		waituntil {(inputAction "SelectGroupUnit6" > 0) or (!indiCam_runIndiCam)};
		if (indiCam_runIndiCam) then {
			if (indiCam_debug) then {systemChat "F6-key pressed"};
			indiCam_var_visionIndex = indiCam_var_visionIndex + 1;
			if (indiCam_var_visionIndex > 10) then {indiCam_var_visionIndex = 0};
			[] call indiCam_fnc_visionMode;
		};
		waituntil {inputAction "SelectGroupUnit6" <= 0};
	};
};





// This EH waits for button press that toggles manual camera on/off
// Gotta rewrite it so that it stops the main loop and keeps the camera open until toggled off or camera is stopped
// When the camera isn't running, the EH will be killed off
indiCam_fnc_manualMode = {


	if (!indiCam_var_manualMode) then { // This is a basic toggle
	
		indiCam_var_manualMode = true;
		if (indiCam_debug) then {systemChat "manual on"};
		indiCam_var_interruptScene = true; // I need to halt the camera loop
		indiCam camCommand "manual on";
		indiCam camSetTarget actor;
	} else {
		indiCam_var_manualMode = false;
		indiCam camCommand "manual off";
		if (indiCam_debug) then {systemChat "manual off"};
	};
		

};


// This EH waits for button press that stops the camera switching and gives manual control over the camera
// When the camera isn't running, the EH will be killed off
[] spawn {
	indiCam_var_interruptScene = false;
	while {indiCam_runIndiCam} do {
		waituntil {(inputAction "SelectGroupUnit4" > 0) or (!indiCam_runIndiCam)};
		if (indiCam_runIndiCam) then {
			if (indiCam_debug) then {systemChat "F4-key pressed"};
			// Randomize a new player actor by starting to look within 25m of the current actor
			[] call indiCam_fnc_manualMode;
		};
		waituntil {inputAction "SelectGroupUnit4" <= 0};
	};
};




// This EH waits for button press that stops the camera switching and gives manual control over the camera
// When the camera isn't running, the EH will be killed off
[] spawn {
	indiCam_var_interruptScene = false;
	while {indiCam_runIndiCam} do {
		waituntil {(inputAction "SelectGroupUnit9" > 0) or (!indiCam_runIndiCam)};
		if (indiCam_runIndiCam) then {
			if (indiCam_debug) then {systemChat "F9-key pressed"};
			// Print the current scene name to the screen
			systemchat str indiCam_var_previousScene;
			indiCam_var_sceneList pushBackUnique indiCam_var_previousScene;
			hintSilent str indiCam_var_sceneList;
		};
		waituntil {inputAction "SelectGroupUnit9" <= 0};
	};
};




