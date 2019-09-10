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
comment "									initialization of the camera										";
comment "-------------------------------------------------------------------------------------------------------";

// This variable allows or disallows scripts to run
indiCam_runIndiCam = true;

if (indiCam_devMode) then { // Keeps track of input and operation modes of the camera
	[] execVM "INDICAM\indiCam_fnc_cameraControl.sqf";
	} else {
	[] spawn indiCam_fnc_cameraControl;
};

if (indiCam_devMode) then { // Keeps track of the situation and provides that info for scene selection
	[] execVM "INDICAM\indiCam_fnc_situationCheck.sqf";
	} else {
	[] spawn indiCam_fnc_situationCheck;
};

if (indiCam_devMode) then { // Keeps track of the general visibility of the actor
	[] execVM "INDICAM\indiCam_fnc_visibilityCheck.sqf";
	} else {
	[] spawn indiCam_fnc_visibilityCheck;
};

if (indiCam_devMode) then { // Keeps track of the general visibility of the actor
	[] execVM "INDICAM\indiCam_fnc_actorManager.sqf";
	} else {
	[] spawn indiCam_fnc_actorManager;
};


// Create the camera
// Maybe should pull an initial scene from sceneSelect, but for now a hard coded scene every time
indiCam = "camera" camCreate (actor modelToWorld [5,5,20]);
indiCam cameraEffect ["internal","back"];
indiCam camSetTarget actor;
camUseNVG false;
showCinemaBorder false;
indiCam camCommand "inertia on";


[] spawn { // Setup the logics for camera point and the camera target point.

	// I should probably put all the logics into a global array so that I don't have to do them one by one
	// I tried to simply use hideObject, but there is a hideObjectGlobal that seem to have to be run on the server

	if (indiCam_debug) then { // When debug is on, create all logics locally visible
		//indiCam_followLogicFPS = createVehicle ["Sign_Sphere25cm_F", [0,0,0], [], 0, "CAN_COLLIDE"];
		//indiCam_followLogic = createVehicle ["Sign_Sphere25cm_F", [0,0,0], [], 0, "CAN_COLLIDE"];
		//indiCam_infrontLogic = createVehicle ["Sign_Sphere25cm_F", [0,0,0], [], 0, "CAN_COLLIDE"];
		//indiCam_weaponLogic = createVehicle ["Sign_Sphere25cm_F", [0,0,0], [], 0, "CAN_COLLIDE"];
		//indiCam_orbitLogic = createVehicle ["Sign_Sphere25cm_F", [0,0,0], [], 0, "CAN_COLLIDE"];
		//indiCam_centerLogic = createVehicle ["Sign_Sphere25cm_F", [0,0,0], [], 0, "CAN_COLLIDE"];
		//indiCam_linearLogic = createVehicle ["Sign_Sphere100cm_F", [0,0,0], [], 0, "CAN_COLLIDE"];
		
		indiCam_followLogicFPS = "Sign_Sphere25cm_F" createVehicleLocal [0,0,0]; 	// createVehicleLocal might be blacklisted on servers
		indiCam_followLogic = "Sign_Sphere25cm_F" createVehicleLocal [0,0,0]; 		// createVehicleLocal might be blacklisted on servers
		indiCam_infrontLogic = "Sign_Sphere25cm_F" createVehicleLocal [0,0,0]; 		// createVehicleLocal might be blacklisted on servers
		indiCam_weaponLogic = "Sign_Sphere25cm_F" createVehicleLocal [0,0,0]; 		// createVehicleLocal might be blacklisted on servers
		indiCam_orbitLogic = "Sign_Sphere25cm_F" createVehicleLocal [0,0,0]; 		// createVehicleLocal might be blacklisted on servers
		indiCam_centerLogic = "Sign_Sphere25cm_F" createVehicleLocal [0,0,0]; 		// createVehicleLocal might be blacklisted on servers
		indiCam_linearLogic = "Sign_Sphere100cm_F" createVehicleLocal [0,0,0]; 		// createVehicleLocal might be blacklisted on servers
		
		indiCam_var_logicTarget = "Sign_Sphere100cm_F" createVehicleLocal [0,0,0]; // New FPS based target. This command can be blacklisted. hideObject has to be run on each machine.
		indiCam_var_logicTarget setPos [0,0,0]; // createVehicleLocal sets z = -1.#IND
		
	} else { // When debug is off, create invisible logics
		indiCam_followLogicFPS = createVehicle ["ModuleEmpty_F", [0,0,0], [], 0, "CAN_COLLIDE"];
		indiCam_followLogic = createVehicle ["ModuleEmpty_F", [0,0,0], [], 0, "CAN_COLLIDE"];
		indiCam_infrontLogic = createVehicle ["ModuleEmpty_F", [0,0,0], [], 0, "CAN_COLLIDE"];
		indiCam_weaponLogic = createVehicle ["ModuleEmpty_F", [0,0,0], [], 0, "CAN_COLLIDE"];
		indiCam_orbitLogic = createVehicle ["ModuleEmpty_F", [0,0,0], [], 0, "CAN_COLLIDE"];
		indiCam_centerLogic = createVehicle ["ModuleEmpty_F", [0,0,0], [], 0, "CAN_COLLIDE"];
		indiCam_linearLogic = createVehicle ["ModuleEmpty_F", [0,0,0], [], 0, "CAN_COLLIDE"];
		
		indiCam_var_logicTarget = createVehicle ["ModuleEmpty_F", [0,0,0], [], 0, "CAN_COLLIDE"]; // New FPS based target
		indiCam_var_logicTarget setPos [0,0,0]; // createVehicleLocal sets z = -1.#IND
	};

	// Delete all vehicles when the main loop stops running
	waitUntil {!indiCam_runIndiCam};
	deleteVehicle indiCam_followLogicFPS;
	deleteVehicle indiCam_followLogic;
	deleteVehicle indiCam_infrontLogic;
	deleteVehicle indiCam_weaponLogic;
	deleteVehicle indiCam_orbitLogic;
	deleteVehicle indiCam_centerLogic;
	deleteVehicle indiCam_linearLogic;
	
	deleteVehicle indiCam_var_logicTarget;
	
	["indiCam_id_logicTarget", "onEachFrame"] call BIS_fnc_removeStackedEventHandler;
	["indiCam_id_logicCamera", "onEachFrame"] call BIS_fnc_removeStackedEventHandler;

};


// Disable player damage and make him invisible to enemies
// Should I use _this?
player allowDamage false;
player enableSimulationGlobal false;




comment "-------------------------------------------------------------------------------------------------------";
comment "										main camera loop start											";
comment "-------------------------------------------------------------------------------------------------------";
while {indiCam_runIndiCam} do {

	

	
	
	// This is to help keep track of players through death, used in indiCam_fnc_actorManager
	// but
	// Is it really neccessary?
	// Maybe there is an eventhandler for the job?
	if (isPlayer actor) then {
		indiCam_var_playerID = owner actor;
	};

	
	
comment "-------------------------------------------------------------------------------------------------------";
comment "										manual mode hold												";
comment "-------------------------------------------------------------------------------------------------------";	
	// This is the loop keeping the camera from switching while in manual mode.
	// This loop completely suspends normal camera operation
	while {indiCam_var_manualMode} do {
		detach indiCam;
	};


	
	
comment "-------------------------------------------------------------------------------------------------------";
comment "										actor death hold												";
comment "-------------------------------------------------------------------------------------------------------";	
	/*
	// The scene showing a dead actor completely suspends the main loop while it's showing.
	if (!alive actor) then {
		indiCam_var_actorDeathComplete = false;
		[] call indiCam_fnc_actorDeath;
		waitUntil {indiCam_var_actorDeathComplete};
	};
	*/
	
	
	
	
	/*
	
	if (!alive actor) then {
		// Set the scripted actor
		indiCam_var_scriptedActor = actor;
		// Set the correct scene type
		indiCam_var_scriptedSceneType = "actorDeath";
		// First select a scene
		if (indiCam_devMode) then {
			_sceneSelectRun = [6] execVM "INDICAM\indiCam_fnc_sceneSelect.sqf";
			waitUntil {scriptDone _sceneSelectRun};
		} else {
			[6] call indiCam_fnc_sceneSelect; // call for a scripted scene
		};
		
		

		// Commit the scripted scene
		indiCam_var_continuousCameraCommit = false;
		waitUntil {indiCam_var_continuousCameraStopped};
		
		if (indiCam_devMode) then {
			_sceneSelectRun = [] execVM "INDICAM\indiCam_fnc_sceneCommit.sqf";
			waitUntil {scriptDone _sceneSelectRun};
		} else {
			[] spawn indiCam_fnc_sceneCommit;
		};

	// Wait until the script is done or indiCam_var_scriptedActor dies
	waitUntil {(!indiCam_var_scriptedScene) || (!alive indiCam_var_scriptedActor) || (!indiCam_runIndiCam)};
	// Camera will now return to normal operation
	
	};
	
	
	*/
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	

	

comment "-------------------------------------------------------------------------------------------------------";
comment "									scripted scene hold	(cinematics)									";
comment "-------------------------------------------------------------------------------------------------------";

	// Only even attempt this if there is a non-zero chance for it to happen.
	if (indiCam_var_scriptedSceneChance > 0) then {
		// Hold my beer while the scripted scene is run. Arrest the main loop.
		if (indiCam_var_scriptedScene) then {

			// First select a scene
			if (indiCam_devMode) then {
				_sceneSelectRun = [] execVM "INDICAM\scenes\indiCam_scene_mainScripted.sqf";
				waitUntil {scriptDone _sceneSelectRun};
			} else {
				[] call indiCam_scene_mainScripted; // This used to be spawned
			};
			

			// Commit the scripted scene
			indiCam_var_continuousCameraCommit = false;
			waitUntil {indiCam_var_continuousCameraStopped};
			
			if (indiCam_devMode) then {
				_sceneSelectRun = [] execVM "INDICAM\indiCam_fnc_sceneCommit.sqf";
				waitUntil {scriptDone _sceneSelectRun};
			} else {
				[] call indiCam_fnc_sceneCommit;
			};

		// Wait until the script is done or indiCam_var_scriptedActor dies
		waitUntil {(!indiCam_var_scriptedScene) || (!alive indiCam_var_scriptedActor) || (!indiCam_runIndiCam)};
		// Camera will now return to normal operation
		
		};
	
	};
	// Reset variables and script container for any scripted scenes that might have been run
	indiCam_var_scriptedScene = false;
	indiCam_scene_scriptedScene = {};

  
comment "-------------------------------------------------------------------------------------------------------";
comment "										select a new scene												";
comment "-------------------------------------------------------------------------------------------------------";
	// Pull the next scene, check it and commit it to screen
		if (indiCam_devMode) then {
		_sceneSelectRun = [] execVM "INDICAM\indiCam_fnc_sceneSelect.sqf";
		waitUntil {scriptDone _sceneSelectRun};
	} else {
		[] call indiCam_fnc_sceneSelect;
	};



comment "-------------------------------------------------------------------------------------------------------";
comment "									commit the selected scene											";
comment "-------------------------------------------------------------------------------------------------------";
	// This kills any contiuous comitting of the camera
	indiCam_var_continuousCameraCommit = false;
	waitUntil {indiCam_var_continuousCameraStopped};


	if (indiCam_devMode) then {
		_sceneSelectRun = [] execVM "INDICAM\indiCam_fnc_sceneCommit.sqf";
		waitUntil {scriptDone _sceneSelectRun};
	} else {
		[] call indiCam_fnc_sceneCommit;
	};
	
	
	
comment "-------------------------------------------------------------------------------------------------------";
comment "									data and impulse checks												";
comment "-------------------------------------------------------------------------------------------------------";
	

	// Preserve the UID of the actor if he is a player. Used in indiCam_fnc_trackDeadActor
	if ((isMultiplayer) && (isPlayer actor)) then {
		indiCam_var_actorUID = getPlayerUID actor;
		if (indiCam_debug) then {systemChat format ["Actor UID assigned: %1",indiCam_var_actorUID]};
	};

	
	

	
	// This is needed to preserve the side of a dead unit, since side will switch to CIV immediately upon death
	indiCam_var_actorSide = side actor;
	
	
	// Start a timer to last the length of the currently active scene
	_future = time + indiCam_appliedVar_takeTime;
	if (indiCam_var_sceneHold) then {_future = 999999};
	// Check if there is a forced scene duration set in gui:
	if (indiCam_var_SceneOverrideState) then {_future = time + indiCam_var_SceneOverrideDuration};
	if (indiCam_debug && indiCam_var_checkBoxOverride) then {systemChat format ["Forced duration: %1",indiCam_var_SceneOverrideDuration]};
	
	// Reset variables - maybe put these in exitWith down below?
	indiCam_var_interruptScene = false;
	indiCam_var_visibilityCheckObscured = false;
	indiCam_var_ATScene = false; // After scene was committed, reset the ATScene option


	
	
comment "-------------------------------------------------------------------------------------------------------";
comment "										main loop block													";
comment "-------------------------------------------------------------------------------------------------------";	
	// This is the block that looks for impulses from the user or other scripts
	while {time <= _future} do {
		if (!indiCam_runIndiCam) exitWith {}; // Stops the camera from running
		if (indiCam_var_interruptScene) exitWith {}; // Stops this loop before time is out
		if (indiCam_var_visibilityCheckObscured) exitWith {}; // Stops this loop if actor was hidden for too longd
		if (indiCam_var_scriptedSceneDone) exitWith {}; // When the scripted scene is done (remove and use indiCam_var_interruptScene instead?)
		if (!alive actor) exitWith {if (indiCam_debug) then {systemChat "actor died"};}; // Stops this loop if actor dies
		
		sleep 0.1;
	};
	


}; // end of main camera loop



comment "-------------------------------------------------------------------------------------------------------";
comment "						code executed after main indiCam loop is interrupted							";
comment "-------------------------------------------------------------------------------------------------------";


//TODO- Run a function that resets everything

// Kill any eventhandlers still going. Should probably be a forEach on a variable containing every started eventhandler.
["indiCam_id_logicTarget", "onEachFrame"] call BIS_fnc_removeStackedEventHandler;
["indiCam_id_logicCamera", "onEachFrame"] call BIS_fnc_removeStackedEventHandler;


// Terminate the camera
indiCam cameraEffect ["terminate","back"];
camDestroy indiCam;

// Stop other running scripts by making sure the main loop condition in those loops is false
// This is in case it was interrupted for some other reason than the intended
indiCam_runIndiCam = false;
indiCam_var_actorAutoSwitch = false;

// Tell the user that the camera script has been interrupted
if (indiCam_debug) then {systemchat "stopping camera..."};


// Let the cameraman take damage again and be visible to other units
// Should I use _this?
player allowDamage true;
player enableSimulationGlobal true;
