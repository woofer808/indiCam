comment "-------------------------------------------------------------------------------------------------------";
comment "											indiCam, by woofer.											";
comment "																										";
comment "										independent cinematic camera									";
comment "																										";
comment "																										";
comment "	It's function is to follow a designated actor around and position itself for decent camera shots	";
comment "	depending on circumstances such as visibility and situation around the actor.						";
comment "																										";
comment "	The original purpose of this script is to support a specific video recording workflow				";
comment "	with two separate perspectives of the same game session. It is meant to be executed					";
comment "	on a second gaming computer that is logged in as a regular player that only records gameplay.		";
comment "																										";
comment "	F1 Stop script																						";
comment "	F2 forces next scene																				";
comment "	F3 toggles manual camera on/off L-key disables focal square											";
comment "	F5 for previous vision mode																			";
comment "	F6 for next vision mode																				";
comment "-------------------------------------------------------------------------------------------------------";





comment "-------------------------------------------------------------------------------------------------------";
comment "												init													";
comment "-------------------------------------------------------------------------------------------------------";

// This variable allows or disallows scripts to run
indiCam_runIndiCam = true;

[] execVM "INDICAM\indiCam_fnc_cameraControl.sqf"; // Gives the player control actions over the camera
[] execVM "INDICAM\indiCam_fnc_situationCheck.sqf"; // Keeps track of the situation and provides that info for scene selection
[] execVM "INDICAM\indiCam_fnc_visibilityCheck.sqf"; // Keeps track of the general visibility of the actor


// Create the camera
// Maybe should pull an initial scene from sceneSelect, but for now a hard coded scene every time
indiCam = "camera" camCreate (actor modelToWorld [5,5,20]);
indiCam cameraEffect ["internal","back"];
indiCam camSetTarget actor;
camUseNVG false;
showCinemaBorder false;
indiCam camCommand "inertia on";



// Setup the logics for camera point and the camera target point. Hide them or use invisible if debug is turned off.
if (indiCam_debug) then {
	indiCam_followLogic = createVehicle ["Sign_Sphere25cm_F", [0,0,0], [], 0, "CAN_COLLIDE"];
	indiCam_infrontLogic = createVehicle ["Sign_Sphere25cm_F", [0,0,0], [], 0, "CAN_COLLIDE"];
	indiCam_weaponLogic = createVehicle ["Sign_Sphere25cm_F", [0,0,0], [], 0, "CAN_COLLIDE"];
	indiCam_orbitLogic = createVehicle ["Sign_Sphere25cm_F", [0,0,0], [], 0, "CAN_COLLIDE"];
	indiCam_centerLogic = createVehicle ["Sign_Sphere25cm_F", [0,0,0], [], 0, "CAN_COLLIDE"];
	indiCam_linearLogic = createVehicle ["Sign_Sphere25cm_F", [0,0,0], [], 0, "CAN_COLLIDE"];
} else {
	indiCam_followLogic = createVehicle ["ModuleEmpty_F", actor modelToWorld [0,0,0], [], 0, "CAN_COLLIDE"];
	indiCam_infrontLogic = createVehicle ["ModuleEmpty_F", actor modelToWorld [0,0,0], [], 0, "CAN_COLLIDE"];
	indiCam_weaponLogic = createVehicle ["ModuleEmpty_F", actor modelToWorld [0,0,0], [], 0, "CAN_COLLIDE"];
	indiCam_orbitLogic = createVehicle ["ModuleEmpty_F", actor modelToWorld [0,0,0], [], 0, "CAN_COLLIDE"];
	indiCam_centerLogic = createVehicle ["ModuleEmpty_F", actor modelToWorld [0,0,0], [], 0, "CAN_COLLIDE"];
	indiCam_linearLogic = createVehicle ["ModuleEmpty_F", actor modelToWorld [0,0,0], [], 0, "CAN_COLLIDE"];
};





comment "-------------------------------------------------------------------------------------------------------";
comment "											main loop													";
comment "-------------------------------------------------------------------------------------------------------";



while {indiCam_runIndiCam} do {


	if (!alive actor) then {
		indiCam_var_actorDeathComplete = false;
		[] spawn indiCam_fnc_actorDeath;
		waitUntil {indiCam_var_actorDeathComplete};
	};

comment "-------------------------------------------------------------------------------------------------------";
comment "										select a new scene												";
comment "-------------------------------------------------------------------------------------------------------";
	// Pull the next scene, check it and commit it to screen
	indiCam_var_sceneSelectDone = false;
	//[] execVM "INDICAM\indiCam_fnc_sceneSelect.sqf"; 	// Use this when developing scenes
	[] spawn indiCam_fnc_sceneSelect; 				// use this when packing the mod or script
	waitUntil {indiCam_var_sceneSelectDone};

comment "-------------------------------------------------------------------------------------------------------";





comment "-------------------------------------------------------------------------------------------------------";
comment "									commit the selected scene											";
comment "-------------------------------------------------------------------------------------------------------";

	// This kills any contiuous comitting of the camera
	indiCam_var_continuousCameraCommit = false;
	waitUntil {indiCam_var_continuousCameraStopped};

	// This applies the new camera
	[] call indiCam_fnc_sceneCommit;
	//[] execVM "INDICAM\indiCam_fnc_sceneCommit.sqf";
	
comment "-------------------------------------------------------------------------------------------------------";

	// This is needed to preserve the side of a dead unit, since side will switch to CIV immediately upon death
	// Make sure this is run after the death scene has been run. I should maybe combine the actor death detection scene and switch somehow
	if (!alive actor) then {[] call indiCam_fnc_actorSwitchToClosest};
	indiCam_var_actorSide = side actor;


	// Start a timer to last the length of the currently active scene
	_future = time + indiCam_appliedVar_takeTime;
	
	// Reset variables - maybe put these in exitWith down below?
	indiCam_var_interruptScene = false;
	indiCam_var_visibilityCheckObscured = false;
	
	// This is the block that looks for impulses from the user or other scripts
	while {time <= _future} do {
		if (!indiCam_runIndiCam) exitWith {}; // Stops the camera from running
		if (indiCam_var_interruptScene) exitWith {}; // Stops this loop before time is out
		if (indiCam_var_visibilityCheckObscured) exitWith {}; // Stops this loop if actor was hidden for too long
		if (!alive actor) exitWith {if (indiCam_debug) then {systemChat "actor died"};}; // Stops this loop if actor dies
		
		sleep 0.1;
	};
	
	



	}; // end of main camera loop

	

comment "-------------------------------------------------------------------------------------------------------";
comment "							code executed after carmera loop is interrupted								";
comment "-------------------------------------------------------------------------------------------------------";

// Terminate the camera
indiCam cameraEffect ["terminate","back"];
camDestroy indiCam;

// Stop other running scripts by making sure the main loop condition is false
// This is in case it was interrupted for some other reason than the intended
indiCam_runIndiCam = false;

// Tell the user that the camera script has been interrupted
if (indiCam_debug) then {systemchat "stopping camera..."};