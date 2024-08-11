/*
 * Author: woofer
 * Spawn this script to detect CAS action
 * When the script deem it appropriate, it will force an CAS scene on the object
 *
 * If a mission maker want to set a custom array of vehicles for this script,
 * global var indiCam_var_CASVehicles can be set as an override. Otherwise
 * this script will set that variable on first launch only.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * spawn indiCam_fnc_CASScan
 *
 * Public: No
 */

/* ----------------------------------------------------------------------------------------------------
		Long loop unit list to keep a unit list up to date.											
   ---------------------------------------------------------------------------------------------------- */


//TODO- Connect detection system to actual scripted scenes
//TODO- Make this detect that it is running in huntsmen scenarios
//TODO- Write a generic version of the huntsmen cas detection for default use
//TODO- Add chance to detect scripted scenes
//TODO- Add indiCam debug system
//TODO- 

// Function for detecting and initiating camera on CAS operations in the Huntsmen environment
indiCam_fnc_CASScanHuntsmen = {


	private _scriptTimer = 5; 		// How often in seconds this script will run
	private _maxDistance = 5000;	// Max distance between actor and CAS aircraft before script should attempt scripted scene

	// If no CAS vehicle array has been set already, use this default array
	if (isNil "indiCam_var_CASVehicles") then {
		indiCam_var_CASVehicles = [
									"vn_b_air_f100d_bmb", 	// (Light) Switchblade
									"vn_b_air_f4c_cas", 	// (Heavy) Sundown
									"uns_A4E_skyhawk_CAS", 	// (Light) Apollo
									"uns_c130_h_blu82", 	// (Heavy) Crusader
									"uns_A7_BMB", 			// (Heavy) Groundhog
									"uns_A1J_BMB" 			// (Light) Sixgun
		];
	};

	
	while {indiCam_running} do { // Kill this script if camera isn't running

		{ // forEach that checks all vehicles against our list of vehicles

			// find returns index of found item or -1 when not found in the array
			if ((indiCam_var_CASVehicles find typeOf _x) > -1) then {

				// Do a series of tests to make sure we really want this candidate
				private _abort = false;
				// Make sure pilot is AI
				if (isPlayer (currentPilot _x)) then {_abort = true};

				// Check proximitiy to current actor, but hard to define a good number here
				// Maybe should dynamically depend on size of terrain
				if ((indiCam_actor distance _x) > _maxDistance) then {_abort = true};


				// If nothing says otherwise we are good to initiate a scripted scene on this bad boy
				if (_abort == false) then {

					//systemchat "Scripted scene detected!"; // Confirmed working

					// Launch the scripted scene with the selected aircraft unit
					indiCam_var_scriptedSceneRunning = true;
					["CAS", _x] spawn indiCam_scene_selectScripted;


					indiCam_var_scriptedSceneRunning = false;



					// Suspend the script until scene is done and it's time to start checking for AT actions again.
					waitUntil {!indiCam_var_scriptedSceneRunning};



				};



			};
		} foreach vehicles;

	
	sleep _scriptTimer;
	};

};
[] spawn indiCam_fnc_CASScanHuntsmen; // Spawn this to run in background until camera is stopped
