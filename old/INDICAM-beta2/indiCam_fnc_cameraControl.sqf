comment "-------------------------------------------------------------------------------------------------------";
comment "											indiCam, by woofer.											";
comment "																										";
comment "										  indiCam_fnc_cameraControl										";
comment "																										";
comment "	This purpose of this script is to keep the indiCam controls updated for the player					";
comment "	It's epecially important for when remote control is used (for example Advanced AI Command mod)		";
comment "																										";
comment "	Future functionality is to hand control over to other players										";
comment "																										";
comment "-------------------------------------------------------------------------------------------------------";
// TODO- Add ability for the cameraman to hand control over to another player, 
//		maybe by giving that player vars containing compiled functions?
//		That would entail making everything below into functions


/*



_myaction = player addAction ["Hello", "hello.sqs"];
This stores the action's ID in the local variable "_myaction" and assists in keeping track of the action ID. To remove the above action, you would use the following line:
player removeAction _myaction;

- Maybe something like if (!isNull) indiCam_addAction_startCamera. Gotta test that properly.



*/




/*	 - ADDACTIONS

Check if the player currently has proper addActions on him. Only add them if needed
Should be done in actorManager, I guess

*/




// Make sure the camera is running before attempting to create the camera control button event handlers
waituntil {indiCam_runIndiCam};



// This EH waits for button press that terminates the script
[] spawn {
		while {indiCam_runIndiCam} do {
			waituntil {inputAction "SelectGroupUnit1" > 0}; // F1 to stop indiCam
			if (indiCam_debug) then {systemChat "F1-key pressed"};
			indiCam_runIndiCam = false;
			waituntil {inputAction "SelectGroupUnit1" <= 0};
		};
};



// This EH waits for button press that forces the next scene

[] spawn {
	indiCam_var_interruptScene = false;
	while {indiCam_runIndiCam} do {
		waituntil {inputAction "SelectGroupUnit2" > 0}; // F2 to force next scene
		if (indiCam_debug) then {systemChat "F2-key pressed"};
		indiCam_var_interruptScene = true;
		waituntil {inputAction "SelectGroupUnit2" <= 0};
	};
};



// This EH waits for button press that toggles manual camera on/off

[] spawn {
	indiCam_var_manualCamera = false;
	while {indiCam_runIndiCam} do {
		waituntil {inputAction "SelectGroupUnit3" > 0}; // F3 to toggle manual mode
		if (indiCam_debug) then {systemChat "F3-key pressed"};
		
		detach indiCam;
		
		if (!indiCam_var_manualCamera) then {
			indiCam camCommand "manual on";indiCam_var_manualCamera = true;
			if (indiCam_debug) then {systemChat "manual on"};
		} else {
			indiCam camCommand "manual off";indiCam_var_manualCamera = false;
			if (indiCam_debug) then {systemChat "manual off"};
		};
		
		waituntil {inputAction "SelectGroupUnit3" <= 0};
	};
};






[] spawn {
	camUseNVG false;
	false setCamUseTI 0;
	indiCam_var_visionIndex = -1;
	while {indiCam_runIndiCam} do {
		waitUntil {(inputAction "SelectGroupUnit5" > 0) or (inputAction "SelectGroupUnit6" > 0)};
		if (indiCam_var_visionIndex == -1) then {false setCamUseTI 0;camUseNVG false;nightVisionOverride = false;if (indiCam_debug) then {systemChat "-1 - Automatic"};};
		if (indiCam_var_visionIndex == 0) then {false setCamUseTI 0;camUseNVG false;nightVisionOverride = true;if (indiCam_debug) then {systemChat "0 - Daylight"};};
		if (indiCam_var_visionIndex == 1) then {false setCamUseTI 0;camUseNVG true;nightVisionOverride = true;if (indiCam_debug) then {systemChat "1 - Night vision"};};
		if (indiCam_var_visionIndex == 2) then {camUseNVG false;true setCamUseTI 0;if (indiCam_debug) then {systemChat "2 - White Hot"};};
		if (indiCam_var_visionIndex == 3) then {camUseNVG false;true setCamUseTI 1;if (indiCam_debug) then {systemChat "3 - Black Hot"};};
		if (indiCam_var_visionIndex == 4) then {camUseNVG false;true setCamUseTI 2;if (indiCam_debug) then {systemChat "4 - Light Green Hot / Darker Green cold"};};
		if (indiCam_var_visionIndex == 5) then {camUseNVG false;true setCamUseTI 3;if (indiCam_debug) then {systemChat "5 - Black Hot / Darker Green cold"};};
		if (indiCam_var_visionIndex == 6) then {camUseNVG false;true setCamUseTI 4;if (indiCam_debug) then {systemChat "6 - Light Red Hot /Darker Red Cold"};};
		if (indiCam_var_visionIndex == 7) then {camUseNVG false;true setCamUseTI 5;if (indiCam_debug) then {systemChat "7 - Black Hot / Darker Red Cold"};};
		if (indiCam_var_visionIndex == 8) then {camUseNVG false;true setCamUseTI 6;if (indiCam_debug) then {systemChat "8 - White Hot / Darker Red Cold"};};
		if (indiCam_var_visionIndex == 9) then {camUseNVG false;true setCamUseTI 7;if (indiCam_debug) then {systemChat "9 - Thermal (Shade of Red and Green, Bodies are white)"};};
		sleep 0.1;
	};
};



// This EH waits for button press that switches to previous vision mode
[] spawn {
		indiCam_var_visionIndex = -1;
	while {indiCam_runIndiCam} do {
		waituntil {inputAction "SelectGroupUnit5" > 0};
		if (indiCam_debug) then {systemChat "F5-key pressed"};
		indiCam_var_visionIndex = indiCam_var_visionIndex - 1;
		if (indiCam_var_visionIndex < -1) then {indiCam_var_visionIndex = 9};
		waituntil {inputAction "SelectGroupUnit5" <= 0};
	};
};



// This EH waits for button press that switches to next vision mode
[] spawn {
	indiCam_var_visionIndex = -1;
	while {indiCam_runIndiCam} do {
		waituntil {inputAction "SelectGroupUnit6" > 0};
		if (indiCam_debug) then {systemChat "F6-key pressed"};
		indiCam_var_visionIndex = indiCam_var_visionIndex + 1;
		if (indiCam_var_visionIndex > 9) then {indiCam_var_visionIndex = -1};
		waituntil {inputAction "SelectGroupUnit6" <= 0};
	};
	
};
