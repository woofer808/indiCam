/*
 * Author: woofer
 * Handles running mode changes, impulse checks, and timers.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * call indicam_core_fnc_mainLoop
 *
 * Public: No
 */

// If the current mode is different from the currently active value,
// stop whatever is going on and switch to the new mode
if (indiCam_var_currentMode != indiCam_var_requestMode) then {

	switch (indiCam_var_requestMode) do {
		
		
		// Everytime the default mode is requested, it will fetch a new scene
		case "default": {
			// If indiCam_var_currentMode isn't the value "running", then all other modes should be terminated
			// Preferably without temporarily going back to the player character
			
			// Pull a new scene by spawning scene select.
			// When scene select is done, it will commit the new scene to camera
			if (indiCam_devMode) then {
				[] execVM "INDICAM\scenes\indiCam_scene_selectMain.sqf";
			} else {
				[] spawn indiCam_scene_selectMain;
			};
			
			// Make adjustments if any scene override controls are used
			indiCam_var_sceneTimer = time + indiCam_appliedVar_takeTime;
			if (indiCam_var_sceneOverride) then {indiCam_var_sceneTimer = time + indiCam_var_SceneOverrideDuration} else {indiCam_var_sceneTimer = time + indiCam_appliedVar_takeTime};
			if (indiCam_var_sceneHold) then {indiCam_var_sceneTimer = time + 99999};
			
			// set this mode to stable
			indiCam_var_currentMode = "running";
			indiCam_var_requestMode = "running";
			indiCam_running = true;
			if (indiCam_debug) then {systemchat "mainLoop --> Default mode active."};
		};
		
		
		case "scripted": {
			// Spawn the current scripted scene

			indiCam_var_currentMode = "scripted";
			indiCam_var_requestMode = "scripted";
			indiCam_running = true;
			if (indiCam_debug) then {systemchat "mainLoop --> Scripted mode active."};
		};
		
		
		case "manual": {
		
			// Reset the running mode
			[] call indiCam_fnc_clearEventhandlers;
			
			// Stop the camera in its current position
			// Stop all running camera movement functions
			// Make sure no scripted scenes can take over
			indiCam_var_actorTimer = time + 99999;
			indiCam_appliedVar_maxDistance = 99999;
			indiCam_appliedVar_ignoreHiddenActor = true;

			// Start manual camera functions
			
			// set this mode to stable
			indiCam_var_currentMode = "manual";
			indiCam_var_requestMode = "manual";
			indiCam_running = true;
			if (indiCam_debug) then {systemchat "mainLoop --> Manual mode active."};
		};
		
		
		case "off": {
		
			// Reset the running mode
			[] call indiCam_fnc_clearEventhandlers;
			
			// Stop the camera
			indiCam_camera cameraEffect ["terminate","back"];
			camDestroy indiCam_camera;
			
			
			// set this mode to stable
			indiCam_var_currentMode = "off";
			indiCam_var_requestMode = "off";
			indiCam_running = false;
			if (indiCam_debug) then {systemchat "mainLoop --> Off mode active."};
			
			// Stop the main loop by killing the eventhandler that runs this function
			["indiCam_id_mainLoop", "onEachFrame"] call BIS_fnc_removeStackedEventHandler;
		};
	
	}; // End of switch



// If there was no change in running mode, just do timer and impulse checks instead
} else {
	
	// Only do timers if sceneSelect isn't currently running
	if (!indiCam_var_sceneSelectRunning) then {
	
		// Switch scene only if it's time AND default mode is on AND scene switching is enabled
		// Nested if-statements halves the execution time for when the timer HASN'T run out
		If (time > indiCam_var_sceneTimer) then {
			if ( (indiCam_var_currentMode == "running") && (indiCam_var_sceneSwitch) ) then {
				if (indiCam_debug) then {systemchat "mainLoop --> Scene timer ran out."};
				// Interrupt the main loop to force scene change
				indiCam_var_sceneTimer = time + 10; // Stops this if-statement to fire before scene selection is done
				indiCam_var_requestMode ="default";
			};
		};
		
		// Auto switch actor only if it's time AND actor switch is on
		If ( (time > indiCam_var_actorTimer) && (indiCam_var_actorSwitchSettings select 3) ) then {
			if (indiCam_debug) then {systemchat "mainLoop --> Actor timer ran out."};
			// Get the new actor with actor switch function by spawning it.
			[] call indiCam_fnc_actorSwitch;
			// Interrupt the main loop to force scene change with the new actor
			indiCam_var_actorTimer = time + (indiCam_var_actorSwitchSettings select 4);
		};

		// This may be a bit overkill. I could just put an eventhandler on the player instead.
		if (!alive player) then {
			// camera isn't of much use if the player dies, is it?
			if (indiCam_debug) then {systemchat "mainLoop --> Cameraman died."};
			// Set the proper ending condition that all live scripts will be looking for
			indiCam_var_requestMode = "off";
		};
		
	};
	
};
