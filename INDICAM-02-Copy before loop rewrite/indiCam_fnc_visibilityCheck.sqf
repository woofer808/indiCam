comment "-------------------------------------------------------------------------------------------------------";
comment "											indiCam, by woofer.											";
comment "																										";
comment "										indiCam_fnc_visibilityCheck										";
comment "																										";
comment "	This function continuously checks if the camera has a clear line of sight or is close enough 		";
comment "	to the actor based on values given by the active scene.												";
comment "	It is started and continuously executed while the camera is in use.									";
comment "	It is terminated on camera termination.																";
comment "																										";
comment "	This script contains sleep and has to be spawned.													";
comment "																										";
comment "-------------------------------------------------------------------------------------------------------";

/*
lineIntersectsSurfaces is useful for LOS checking (returns list, seems heavy)
*/



private _actorObscured = false;
private _future = time;
private _timerStarted = false;
private _timerRestart = true;

while {indiCam_runIndiCam} do {


comment "-------------------------------------------------------------------------------------------";
comment "									Visibility check										";
comment "-------------------------------------------------------------------------------------------";

if (!indiCam_appliedVar_ignoreHiddenActor) then {
	// Do the LOS check
	private _actorVisibility = [indiCam, "VIEW", (vehicle actor)] checkVisibility [getPosASL indiCam, eyePos actor];
	private _actorObscuredLine = lineIntersects [getPosASL indiCam, eyePos actor, indicam, (vehicle actor)];
	private _actorObscuredTerrain = terrainIntersectASL [getPosASL indiCam, eyePos actor];

	
	// Set a collected state based on all the visibility checks
	if ((_actorVisibility < 0.2) || _actorObscuredLine || _actorObscuredTerrain) then {
		_actorObscured = true;
	} else {
		_actorObscured = false;
		_future = time + indiCam_var_hiddenActorTime;
	};

	//if (indiCam_debug) then {systemChat format ["visibility:%1, line:%2, terrain:%3 --> detected:%4",_actorVisibility,_actorObscuredLine,_actorObscuredTerrain,_actorObscured];};
	//if (indiCam_debug) then {systemChat format ["time before switch:%1",(_future - time)];};

	
	// Do a check on the timer to see if the actor has been hidden for long enough
	if (time >= _future) then {
		if (indiCam_debug) then {systemchat "Actor was hidden for too long"};
		indiCam_var_visibilityCheckObscured = true;
		_actorObscured = false;
		_future = time + indiCam_var_hiddenActorTime;
	} else {
		indiCam_var_visibilityCheckObscured = false;
	};
	
	

	
	
};
	
comment "-------------------------------------------------------------------------------------------";
comment "									Distance check											";
comment "-------------------------------------------------------------------------------------------";
	// Check if the actor is further away from the camera than what is allowed by the scene
	// Force a scene change if that's the case
	private _distanceCheck = indiCam distance actor;

	if (_distanceCheck >= indiCam_appliedVar_maxDistance) then {
		if (indiCam_debug) then {systemchat "Actor too far away for scene"};
		indiCam_var_interruptScene = true;
	};


	
	
	sleep 1;

};

if (indiCam_debug) then {systemChat "stopping visibility check"};