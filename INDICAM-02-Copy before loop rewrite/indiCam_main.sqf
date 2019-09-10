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
comment "	F1 Open UI																							";
comment "	F2 forces next scene																				";
comment "	F3 Randomize actor																					";
comment "	F4 toggles manual camera on/off L-key disables focal square											";
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
indiCam camCommand "inertia on"; // This is for manual camera mode


// Spawning target objects depending on debug mode or not while making sure it's only visible on the local machine.
if (indiCam_debug) then { // When debug is on, create all logics locally visible
	
	// This command can be blacklisted. hideObject has to be run on each machine.
	indiCam_var_logicTarget = "Sign_Sphere100cm_F" createVehicleLocal [0,0,0]; 
	indiCam_var_logicTarget setPos [0,0,0]; // createVehicleLocal sets z = -1.#IND
	
} else { // When debug is off, create invisible logics
	
	indiCam_var_logicTarget = createVehicle ["ModuleEmpty_F", [0,0,0], [], 0, "CAN_COLLIDE"]; // New FPS based target
	indiCam_var_logicTarget setPos [0,0,0]; // createVehicleLocal sets z = -1.#IND
};


// Disable player damage and make him invisible to enemies
// Should I use _this?
player allowDamage false;
player enableSimulationGlobal false;




comment "-------------------------------------------------------------------------------------------------------";
comment "										main camera loop start											";
comment "-------------------------------------------------------------------------------------------------------";
while {indiCam_runIndiCam} do {



comment "-------------------------------------------------------------------------------------------------------";
comment "										manual mode hold												";
comment "-------------------------------------------------------------------------------------------------------";	

	// This loop completely suspends normal camera operation
	if (indiCam_var_manualMode) then {
	
		// Stop eventhandlers that are connected to the camera
		[] call indiCam_fnc_clearEventhandlers;
	
		// This seems like a very crude thing to do, but I'll leave it like this for now
		while {indiCam_var_manualMode} do {
			detach indiCam;
			
		};
		
	};
	

comment "-------------------------------------------------------------------------------------------------------";
comment "									scripted scene hold	(cinematics)									";
comment "-------------------------------------------------------------------------------------------------------";

	// evaluate if a scripted scene is currently being requested
	if (indiCam_var_scriptedScene) then {
		
		// Run scripted scene select
		if (indiCam_devMode) then {
			_sceneSelectRun = [] execVM "INDICAM\scenes\indiCam_scene_mainScripted.sqf";
			waitUntil {scriptDone _sceneSelectRun};
		} else {
			[] call indiCam_scene_mainScripted; // This used to be spawned
		};
		
		// Commit the scripted scene (maybe move this)
		if (indiCam_devMode) then {
			_sceneSelectRun = [] execVM "INDICAM\indiCam_fnc_sceneCommit.sqf";
			waitUntil {scriptDone _sceneSelectRun};
		} else {
			[] call indiCam_fnc_sceneCommit;
		};
		
		// halt the main loop until it's let loose again by the scripted scene
		waitUntil {!indiCam_var_scriptedScene};
	
		// set a new actor to get things going again if he got dead while the scripted scene was going on
		if (!alive actor) then {
			[indiCam_var_actorAutoSwitchMode,300] call indiCam_fnc_actorAutoSwitch;
		};
	
	};
	
	// Reset variables and script container for any scripted scenes that might have been run
	indiCam_var_scriptedScene = false;
	indiCam_scene_scriptedScene = {};
	
	
	
	
comment "-------------------------------------------------------------------------------------------------------";
comment "											select a new scene											";
comment "-------------------------------------------------------------------------------------------------------";

	// Pull scenes and test them until we find one that works
	if (indiCam_devMode) then {
		_sceneSelectRun = [] execVM "INDICAM\indiCam_fnc_sceneSelect.sqf";
		waitUntil {scriptDone _sceneSelectRun};
	} else {
		[] call indiCam_fnc_sceneSelect;
	};



comment "-------------------------------------------------------------------------------------------------------";
comment "									commit the selected scene											";
comment "-------------------------------------------------------------------------------------------------------";

	// Now that there is a working and selected scene, commit it to camera
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





comment "-------------------------------------------------------------------------------------------------------";
comment "										main loop block													";
comment "-------------------------------------------------------------------------------------------------------";	
	// This is the block that looks for impulses from the user or other scripts
	while {time <= _future} do {
		if (!indiCam_runIndiCam) exitWith {}; // Stops the camera from running
		if (indiCam_var_interruptScene) exitWith {}; // Stops this loop before time is out
		if (indiCam_var_visibilityCheckObscured) exitWith {}; // Stops this loop if actor was hidden for too longd
		if (!alive actor) exitWith {if (indiCam_debug) then {systemChat "actor died"};}; // Stops this loop if actor dies
	};
	
}; // end of main camera loop



comment "-------------------------------------------------------------------------------------------------------";
comment "						code executed after main indiCam loop is interrupted							";
comment "-------------------------------------------------------------------------------------------------------";


//TODO- Run a function that resets everything

// Kill any onEachFrame camera eventhandlers still going.
[] call indiCam_fnc_clearEventhandlers;

deleteVehicle indiCam_var_logicTarget;

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
