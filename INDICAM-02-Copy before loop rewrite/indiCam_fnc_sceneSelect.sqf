comment "-------------------------------------------------------------------------------------------------------";
comment "											indiCam, by woofer.											";
comment "																										";
comment "											indiCam_fnc_sceneSelect										";
comment "																										";
comment "	This script contains and selects from the available scenes.											";
comment "																										";
comment "	Each scene is a separate case and so can be duplicated and slightly altered to give more variation.	";
comment "																										";
comment "-------------------------------------------------------------------------------------------------------";

// This is the new way to collect the current vicvalue by simply passing it here instead of relying on global vars
if (!(_this isEqualTo [])) then {indiCam_var_vicValue = _this select 0};


comment "-------------------------------------------------------------------------------------------------------";
comment "												init													";
comment "-------------------------------------------------------------------------------------------------------";


// Check the environment 
private _environmentCheck = [] call indicam_fnc_environmentCheck;



comment "-------------------------------------------------------------------------------------------------------";
comment "											main loop start												";
comment "-------------------------------------------------------------------------------------------------------";
// This loop will run until a scene is found that will have enough visibility of the actor.
private _runSceneSelect = true;
while {_runSceneSelect} do {


	comment "-------------------------------------------------------------------------------------------------------";
	comment "										scene vehicle selection											";
	comment "-------------------------------------------------------------------------------------------------------";

	
	switch (indiCam_var_vicValue) do {
		
		case 0: { // Actor on foot scenes
			if (indiCam_devMode) then {
			_handle = [] execVM "INDICAM\scenes\indiCam_scene_mainFoot.sqf";
			waitUntil {scriptDone _handle};
			} else {
			[] call indiCam_scene_mainFoot;
			};
		};

		case 1: { // Car, quad, truck or similar type scenes
			if (indiCam_devMode) then {
			_handle = [] execVM "INDICAM\scenes\indiCam_scene_mainCar.sqf";
			waitUntil {scriptDone _handle};
			} else {
			[] call indiCam_scene_mainCar;
			};
		};
		
		case 2: { // Helicopter scenes
			if (indiCam_devMode) then {
			_handle = [] execVM "INDICAM\scenes\indiCam_scene_mainHelicopter.sqf";
			waitUntil {scriptDone _handle};
			} else {
			[] call indiCam_scene_mainHelicopter;
			};
		};
		
		case 3: { // plane scenes
			if (indiCam_devMode) then {
			_handle = [] execVM "INDICAM\scenes\indiCam_scene_mainPlane.sqf";
			waitUntil {scriptDone _handle};
			} else {
			[] call indiCam_scene_mainPlane;
			};
		};
		
		case 4: { // Tank scenes
			if (indiCam_devMode) then {
			_handle = [] execVM "INDICAM\scenes\indiCam_scene_mainTank.sqf";
			waitUntil {scriptDone _handle};
			} else {
			[] call indiCam_scene_mainTank;
			};
			
		};

		case 5: { // Boat scenes
			if (indiCam_devMode) then {
			_handle = [] execVM "INDICAM\scenes\indiCam_scene_mainBoat.sqf";
			waitUntil {scriptDone _handle};
			} else {
			[] call indiCam_scene_mainBoat;
			};
		};

		

		

	}; // Switch closed
	
	
	
	
	comment "-------------------------------------------------------------------------------------------------------";
	comment "										scene prototyping area											";
	comment "																										";
	private _prototypeScene = false; // Switch this to true to use the prototyping area
	if (_prototypeScene) then {
	systemChat "Testing area scene";
	indiCam_var_exitScript = true; // This kills any held scripts
	//sleep 0.1; // Just giving the scripts time to die (removed because of call rather than spawn)
	comment "-------------------------------------------------------------------------------------------------------";
	// Change the stuff below here

	//sleep 1;

				// Advanced chase cam with logic target updated on every frame
				indiCam_var_cameraType = "fps";
				indiCam_var_disqualifyScene = false; 	// If true, this scene will not be applied and a new one will be selected
				indiCam_var_takeTime = 60;				// Time after which a new scene will be selected
				indiCam_var_cameraPos = [0,-10,3];		// Position of camera relative to the actor
				indiCam_var_targetPos = [0,1,1];		// Position of camera target relative to the actor
				indiCam_var_cameraTarget = indiCam_var_logicTarget;		// The object that the camera is aimed at
				indiCam_var_cameraFov = 1;				// Field of view, Arma default is 0.74
				indiCam_var_maxDistance = 10000;		// Max distance between actor and camera before scene switches
				indiCam_var_ignoreHiddenActor = true;	// True will disable line of sight checks during scene, actor may stay hidden
				indiCam_var_cameraAttach = false;		// Control whether the camera should be attached to anything
				





	comment "-------------------------------------------------------------------------------------------------------";
	indiCam_var_previousScene = "letsnotgothere";
	}; // End of prototyping area
	comment "-------------------------------------------------------------------------------------------------------";





	// This disables the previous scene check that prevents scenes repeating
	// Used for debugging
	if (indiCam_debug) then {
		indiCam_var_previousScene = "letsnotgothere";
	};




comment "-------------------------------------------------------------------------------------------------------";
comment "											test the scene												";
comment "-------------------------------------------------------------------------------------------------------";

	// Do all the necessary tests
	if (indiCam_var_disqualifyScene) then {
		
		// If the scene doesn't qualify to be applied as per a check preformed or if it's been disabled, pick a new scene
		if (indiCam_debug) then {systemChat "scene didn't pass qualification - selecting new scene"};
		
	} else {
	
	
		// Test the the scene before applying it
		_sceneTest = [(actor modelToWorldWorld indiCam_var_cameraPos)] call indiCam_fnc_sceneTest; // If the scene test checks out good, this will return true
		
		// If the scene is ok, exit sceneSelect and keep what's stored in global
		// Also make sure the scene doesn't have the same name as the previously committed one
		if (_sceneTest && !(indiCam_var_scene isEqualTo indiCam_var_previousScene)) then {
		
			if (indiCam_debug) then {systemChat format ["Scene selected: %1",indiCam_var_scene]};
				// Store the last used scene in a variable so that it can be prevented to run the very next time
				indiCam_var_previousScene = indiCam_var_scene;
				_runSceneSelect = false;

		} else {

			if (indiCam_debug) then {systemChat "actor obscured or same scene - selecting new scene"};
			
		};
		
	};

};




