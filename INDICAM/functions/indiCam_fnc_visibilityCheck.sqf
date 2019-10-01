/*
 * Author: woofer
 * Continuously checks if the camera has a clear line of sight or is close enough
 * to the actor based on values given by the active scene.
 * It is started and continuously executed while the camera is in use.
 * It is terminated on camera termination.
 *
 * Arguments:
 * None
 *
 * Reutrn Value:
 * None
 *
 * Example:
 * spawn indicam_fnc_visibilityCheck
 *
 * Public: No
 */

/*
lineIntersectsSurfaces is useful for LOS checking (returns list, seems heavy)
*/

private _actorObscured = false;
private _future = time;
private _timerStarted = false;
private _timerRestart = true;

while {indiCam_running} do {

/* ----------------------------------------------------------------------------------------------------
										Visibility Check
   ---------------------------------------------------------------------------------------------------- */

	if (!indiCam_appliedVar_ignoreHiddenActor) then {
		// Do the LOS check
		private _actorVisibility = [indiCam_camera, "VIEW", (vehicle indiCam_actor)] checkVisibility [getPosASL indiCam_camera, eyePos indiCam_actor];
		private _actorObscuredLine = lineIntersects [getPosASL indiCam_camera, eyePos indiCam_actor, indiCam_camera, (vehicle indiCam_actor)];
		private _actorObscuredTerrain = terrainIntersectASL [getPosASL indiCam_camera, eyePos indiCam_actor];

		
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
			indiCam_var_requestMode = "default";
			_actorObscured = false;
			_future = time + indiCam_var_hiddenActorTime;
		};
		
		

		
		
	};
	
/* ----------------------------------------------------------------------------------------------------
										Distance Check
   ---------------------------------------------------------------------------------------------------- */
	// Check if the actor is further away from the camera than what is allowed by the scene
	// Force a scene change if that's the case
	private _distanceCheck = indiCam_camera distance indiCam_actor;

	if (_distanceCheck >= indiCam_appliedVar_maxDistance) then {
		if (indiCam_debug) then {systemchat "Actor too far away for scene"};
		indiCam_var_requestMode = "default";
	};

	sleep 1;

};

if (indiCam_debug) then {systemChat "stopping visibility check"};
