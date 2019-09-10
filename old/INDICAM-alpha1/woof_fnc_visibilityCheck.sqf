comment "---------------------------------------------------------------------------------------";
comment "This function continuously  checks if the camera has a clear line of sight to the actor";
comment "Sets a bool and gives a value depending on visibility level							";
comment "																						";
comment "Intended for use with woof_fnc_cameraRandomizer										";
comment "																						";
comment "Returns																				";
comment "actorObscuredPersistent																";
comment "actorVisibility = [_actorVisibility,_actorObscured]									";
comment "---------------------------------------------------------------------------------------";


/* NOTES
 checkVisibility - Checks how well one position is visible from another position and how much. Returns value from 0 to 1.
 lineIntersects - checks if there is an object between two points
 terrainIntersect - checks if any terrain is between two points
 lineIntersectsWith - Returns an array of objects that intersect a line between two points lets you ignore objects
 lineIntersectsObjs - Returns array of intersecting objects between points (or an object?)
						Can sort by distance and use flags

 Useful points:
 eyePos Player

 checkVisibility
 Syntax: [ignore, LOD, ignore2] checkVisibility [beg, end]
 ignore: Object - object to exclude from calculations
 LOD: String - level of details to use. Possible values are: "FIRE", "VIEW", "GEOM", "IFIRE"
 [beg, end]: Array
*/


actorVisibility = [];

private [
			"_newCameraPos",		// This select 0	//	(sceneSelector select 0)
			"_newFov",				// This select 1	//	(sceneSelector select 1)
			"_cameraTarget",		// This select 2	//	(sceneSelector select 2)
			"_cameraTaketime",		// This select 3	//	(sceneSelector select 3)
			"_cameraMovementRate",	// This select 4	//	(sceneSelector select 4)
			"_maxDistance",			// This select 5	//	(sceneSelector select 5)
			"_ignoreActorHidden",	// This select 6	//	(sceneSelector select 6)
			"_actorObscuredPersistent"
		];



visibilityCheckRunning = true;
_actorObscuredPersistent = false;
_cameraObscuredTimestamp = 0;

comment "-------------------------------------------------------------------------------------------";
comment "									 Main loop												";
comment "-------------------------------------------------------------------------------------------";
while {runIndiCam} do {
	
	// Check the visibility level on a line from the camera to the actor. Ignore interference any with actor vehicle and the actor itself.
	
	_actorVisibility = [indiCam, "VIEW", actor] checkVisibility [getPosASL indiCam, eyePos actor];
	_actorObscured = lineIntersects [getPosASL indiCam, eyePos actor, indicam, vehicle actor];
	_actorObscuredTerrain = terrainIntersectASL [getPosASL indiCam, eyePos actor];
	
	_ignoreActorHidden = sceneSelector select 6;
	
	if (_actorObscured or _actorObscuredTerrain) then {
		
		if (_cameraObscuredTimestamp == 0) then {
		_cameraObscuredTimestamp = time; // Reset the timer
		};
		
		if ((time - _cameraObscuredTimestamp) >= 3) then {
		if (indiCamDebug) then {systemChat "actor hidden for too long, switching scene..."};
		if (_ignoreActorHidden) then {_actorObscuredPersistent = false} else {_actorObscuredPersistent = true}; // This is a bool that reboots indiCam main loop
		};
		
	} else {
	_cameraObscuredTimestamp = 0;
	_actorObscuredPersistent = false;
	};
	

	

	// Insert a test for distance here
	// Currently this sketch probably won't work as it isn't synced to the main loop
	/* SKETCH
	private _distanceCheck = (getposASL indicam) distance (getPosASL actor);
	if (_distanceCheck > (sceneSelector select 5)) then {systemChat "actor is too far away, switching scene"};
	*/
	

	
	
	// update a var for use in other scripts
	actorObscuredPersistent = _actorObscuredPersistent;
	actorVisibility = [_actorVisibility,_actorObscured];

	sleep 1;
};

if (indiCamDebug) then {systemChat "stopping woof_fnc_visibilityCheck..."};