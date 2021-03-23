/* -------------------------------------------------------------------------------------------------------
* 	initialization of camera and main loop
*  ------------------------------------------------------------------------------------------------------- */
indiCam_running = true;

// Initialize the keyboard controls
[] spawn indiCam_core_inputControls;

// Spawning target objects depending on debug mode or not while making sure it's only visible on the local machine.
if (indiCam_debug) then { // When debug is on, create all logics locally visible
	
	// This command can be blacklisted. hideObject has to be run on each machine.
	indiCam_var_proxyTarget = "Sign_Sphere25cm_F" createVehicleLocal [0,0,0]; 
	indiCam_var_proxyTarget setPos [0,0,0]; // createVehicleLocal sets z = -1.#IND
	
} else { // When debug is off, create invisible logics
	
	indiCam_var_proxyTarget = createVehicle ["ModuleEmpty_F", [0,0,0], [], 0, "CAN_COLLIDE"]; // New FPS based target
	indiCam_var_proxyTarget setPos [0,0,0]; // createVehicleLocal sets z = -1.#IND

};


// Initialize the eventhandler that is the main loop
// It will wait for changes to indiCam_var_requestMode and for timers to run out
["indiCam_id_mainLoop", "onEachFrame", {[] call indiCam_core_mainLoop}] call BIS_fnc_addStackedEventHandler;


// Create the camera
indiCam_camera = "camera" camCreate (indiCam_actor modelToWorld [5,5,20]);
indiCam_camera cameraEffect ["internal","back"];
indiCam_camera camSetTarget indiCam_actor;
indiCam_camera camCommand "inertia on"; // This is for manual camera mode
showCinemaBorder false;
camUseNVG false;

// Start off by resetting default running mode and thereby pulling a new scene
if (indiCam_devMode) then {
	[] execVM "INDICAM\scenes\indiCam_scene_selectMain.sqf";
} else {
	[] spawn indiCam_scene_selectMain;
};


/* -------------------------------------------------------------------------------------------------------
* 	initialization of background functions
*  ------------------------------------------------------------------------------------------------------- */
// Actor auto switching
if (indiCam_var_actorAutoSwitch) then { // If actor autoswtiching is on, reset the timer with the current duration
	indiCam_var_actorTimer = time + (indiCam_var_actorSwitchSettings select 4);
} else { // If actor autoswitching is off, set the current duration to something very long
	indiCam_var_actorTimer = time + 99999;
};


// Keeps track of the situation and provides that info for scene selection
if (indiCam_devMode) then {
	[] execVM "INDICAM\functions\indiCam_fnc_situationCheck.sqf";
} else {
	[] spawn indiCam_fnc_situationCheck;
};

// Check that the actor hasn't been hidden for too long.
if (indiCam_devMode) then {
	[] execVM "INDICAM\functions\indiCam_fnc_visibilityCheck.sqf";
} else {
	[] spawn indiCam_fnc_visibilityCheck;
};

// This initializes the special event of an AT guy attempting to fire a launcher
if (indiCam_devMode) then {
	[] execVM "INDICAM\functions\indiCam_fnc_launcherScan.sqf";
} else {
	[] spawn indiCam_fnc_launcherScan;
};


// Post the player unit of this indicam instance to the server so that he can be excluded from other peoples' actor auto switching
if (isMultiplayer) then {

	indiCam_var_indiCamInstance pushBackUnique player;
	/* // Saved for posterity in case publicVariable "indiCam_var_indiCamInstance" from indiCam_core_init doesn't get sent in time
	if (isNil {missionNamespace getVariable "indiCam_var_indiCamInstance"}) then {

		// The server hasn't had a chance to push the variable just yet
		indiCam_var_indiCamInstance = [player];
	};
	*/

	// Spawn code that waits for the camera to shut down and therefore remove this user from the array
	// This has the benefit of everything being in the same place of the script.
	[] spawn {
		waitUntil {indiCam_running}; // I can't be sure that this has been set just yet. Doing it like this for now.
		waitUntil {!indiCam_running};
		indiCam_var_indiCamInstance = indiCam_var_indiCamInstance - [player];
		publicVariable "indiCam_var_indiCamInstance";
	};
	// Publish the variable for the duration of the mission to all connected clients, servers and JIP
	publicVariable "indiCam_var_indiCamInstance";

};


indiCam_var_requestMode = "default";
