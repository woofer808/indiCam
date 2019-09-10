


//TODO- Maybe add a counter so that it only tries a set number of times before waiting a little while before trying again.
// [] execVM "INDICAM\indiCam_fnc_sceneSelect.sqf";

comment "-------------------------------------------------------------------------------------------------------";
comment "												init													";
comment "-------------------------------------------------------------------------------------------------------";
//private _sceneTest = true;


comment "-------------------------------------------------------------------------------------------------------";
comment "												scenes													";
comment "-------------------------------------------------------------------------------------------------------";
	
private _runSceneSelect = true;
while {_runSceneSelect} do {


	_scene = selectRandom [
								"cheeseCam",	// Advanced chase cam with logic target
								"actorChase",	// Basic chase cam with actor as target
								"relativeCam"	// Preforms a contiuous commit alongside camSetRelPos
							];

	switch (_scene) do {

		case "cheeseCam": {
			indiCam_var_cameraType = "logics"; // "default", "continuous", "relative" and whatever we can invent
			indiCam_var_cameraChaseSpeed = 0.009; // for the chase camera on how quickly it should close in on the player
			indiCam_var_targetTrackingSpeed = 0.1;// for the chase camera target on how quickly it should close in on the camera target
			
			indiCam_var_takeTime = 5;
			indiCam_var_cameraPos = indiCam_logicB modelToWorldWorld [0.3,-1,1.8];
			indiCam_var_cameraAttach = true;
			indiCam attachTo [indiCam_logicB, [0.3,-1,1.8]];
			indiCam_var_cameraTarget = logicTarget;
			indiCam_var_cameraFov = 0.8;
			indiCam_var_maxDistance = 1000;
			indiCam_var_ignoreHiddenActor = false;
			
			// unused for now
			indiCam_var_cameraMovementRate = 5;
			
		}; // end of case
		
		case "actorChase": {
			indiCam_var_cameraType = "default"; // "default", "continuous", "relative" and whatever we can invent
			indiCam_var_cameraChaseSpeed = 0.009; // for the chase camera on how quickly it should close in on the player
			indiCam_var_targetTrackingSpeed = 0.1;// for the chase camera target on how quicly it should close in on the camera target
			indiCam_var_takeTime = 5;
			indiCam_var_cameraPos = indiCam_logicB modelToWorldWorld [0.3,-1,1.8];
			indiCam_var_cameraAttach = true;
			indiCam attachTo [indiCam_logicB, [0.3,-1,1.8]];
			indiCam_var_cameraTarget = actor;
			indiCam_var_cameraFov = 0.8;
			indiCam_var_maxDistance = 1000;
			indiCam_var_ignoreHiddenActor = false;
			
			// unused for now
			indiCam_var_cameraMovementRate = 5;
		}; // end of case
		
		case "relativeCam": {
			indiCam_var_cameraType = "relative"; // "default", "continuous", "relative" and whatever we can invent
			indiCam_var_cameraChaseSpeed = 0.009; // for the chase camera on how quickly it should close in on the player
			indiCam_var_targetTrackingSpeed = 0.1;// for the chase camera target on how quicly it should close in on the camera target
			indiCam_var_takeTime = 5;
			indiCam_var_cameraTarget = actor;
			indiCam_var_relativePos = [0.75,-2,2];
			indiCam_var_cameraPos = indiCam_var_cameraTarget modelToWorldWorld indiCam_var_relativePos;
			indiCam_var_cameraFov = 0.8;
			indiCam_var_maxDistance = 1000;
			indiCam_var_cameraAttach = false;
			indiCam_var_ignoreHiddenActor = false;
			
			// unused for now
			indiCam_var_cameraMovementRate = 5;
		}; // end of case
		
		
	}; // end of switch
	
	
	
	
	
	
	
comment "-------------------------------------------------------------------------------------------------------";
comment "											test the scene												";
comment "-------------------------------------------------------------------------------------------------------";
	
	// Test the the scene before applying it
	_sceneTest = [indiCam_var_cameraPos] call indiCam_fnc_sceneTest;
	
	
	// If the scene is ok, exit sceneSelect and keep what's stored in global
	if (_sceneTest) then {
	
		if (indiCam_debug) then {systemChat format ["Scene selected: %1",_scene]};
		_runSceneSelect = false;

	} else {

		if (indiCam_debug) then {systemChat "actor obscured, trying a new scene..."};
		sleep 0.5; // This pause gives the actor a chance to move before trying again
	};
	
	// Maybe add a counter so that it only tries a set number of times and then wait a little while before trying again.

};

comment "-------------------------------------------------------------------------------------------------------";
comment "										commit the scene												";
comment "-------------------------------------------------------------------------------------------------------";

	// This kills any contiuous comitting of the camera
	indiCam_var_continuousCameraCommit = false;
	waitUntil {indiCam_var_continuousCameraStopped};

	// This applies the new camera
	//[] call indiCam_fnc_sceneCommit;
	[] execVM "INDICAM\indiCam_fnc_sceneCommit.sqf";
	