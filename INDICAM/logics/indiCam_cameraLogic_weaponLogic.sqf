/*
 * Author: woofer
 * TODO
 *
 * Arguments:
 * 0: Distance <NUMBER>
 *
 * Reutrn Value:
 * None
 *
 * Example:
 * [10] call indiCam_cameraLogic_fnc_weaponLogic
 *
 * Public: No
 */


/* This is for testing the script as stand-alone
indiCam = createVehicle ["Sign_Sphere100cm_F", getPos actor, [], 0, "NONE"];
indiCam_debug = true;
indiCam_running = true;
*/

// I need to somehow commit this after the scene pre-check
// Otherwise the current logic will break

// Make this into a function and pass these arguments here
private _distance = _this select 0; // How far in front of the actor to place the logic target

/* ----------------------------------------------------------------------------------------------------
									Script control block
   ---------------------------------------------------------------------------------------------------- */

// Hold on to the marbles until the script is let loose - or kill it if it won't be used.
// Basically I only want it to run when the scene change is happening in sceneCommit.
// It will not have to be held for long, only for the duration to evaluate the next scene.
indiCam_var_holdScript = true;

while {indiCam_var_holdScript} do {
	if (indiCam_var_exitScript || indiCam_var_runScript) then {indiCam_var_holdScript = false;};
	sleep 0.01;
};

if (indiCam_var_runScript) then { // if this script is terminated, don't run this
/* ----------------------------------------------------------------------------------------------------
									Game animation logic
   ---------------------------------------------------------------------------------------------------- */

	// The following creates a logic position for the camera target
	[_distance] spawn {
		indiCam_indiCamLogicLoop = true;
		indiCam_weaponLogic setPos indiCam_appliedVar_cameraPos; // Move the logic close to it's starting point
		while {indiCam_indiCamLogicLoop} do {
			_weaponHandPos = actor modelToWorld (actor selectionPosition ["RightHandMiddle1", "memory"]);
			_weaponDirection = vectorNormalized (actor weaponDirection currentWeapon actor);
			_weaponLogicVector = _weaponDirection vectorMultiply (_this select 0);
			_weaponLogicPos = _weaponHandPos vectorAdd _weaponLogicVector;
			indiCam_weaponLogic setPos _weaponLogicPos; // This is only for debug purposes
			if (indiCam_debug) then {drawLine3D [_weaponHandPos,_weaponLogicPos, [1,1,0,1]];};
			sleep (1/90);
		};
		
	};
};

indiCam_var_exitScript = false; // Used for killing waiting logic scripts
