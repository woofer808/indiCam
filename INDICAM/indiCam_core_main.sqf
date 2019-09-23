
comment "-------------------------------------------------------------------------------------------------------";
comment "								initialization of camera and main loop									";
comment "-------------------------------------------------------------------------------------------------------";

indiCam_running = true;

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



comment "-------------------------------------------------------------------------------------------------------";
comment "								initialization of background functions									";
comment "-------------------------------------------------------------------------------------------------------";

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


indiCam_var_requestMode = "default";