/*
 * Author: woofer
 * Scripted scenes for CAS aircraft
 * 
 *
 * Arguments:
 * _scriptMode (string)
 * _unit
 * 
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



private _scriptMode = _this select 0;
private _unit = (_this select 1);		// The desired unit
private _scriptedTimer = time + 30;		// Timer to check that the script will time out if needed

scopeName "topLevel";

// All the different ATguy scripts are located in here, select the appropriate one based on what was passed here
switch (_scriptMode) do {

	// Run this if mode wasn't provided
	default {};

	case "huntsmenCAS": {
				
		// Rewrite so that it only detects aircraft once and then tracks only that.
		// We now need to put the camera in an interesting position in the simplest way possible
		// The best is probably to do a fixed position far in front of the aircraft.
		// Simplex spawns the aircraft just outside of the terrain limit. Then rails it in a straight direction.
		// Could dynamically detect the starting distance and adapt.
		// Waypoints is a no-go. Simplex doesn't use them at the very least. (seen in proper testing)
		// May be that I need to detect the target marker (will be off 350m for nape)
		// Should take view distance set at 500 into account.


		systemchat "running CAS scene";



indiCam_actor = testplane;

// ["huntsmenCAS",testplane] execVM "INDICAM\scenes\indiCam_scene_CAS.sqf"

// Create the camera
indiCam_camera = "camera" camCreate (indiCam_actor modelToWorld [5,5,20]);
indiCam_camera cameraEffect ["internal","back"];
indiCam_camera camSetTarget indiCam_actor;
indiCam_camera camCommand "inertia on"; // This is for manual camera mode
showCinemaBorder false;
camUseNVG false;






		// Regular stationary camera tracking a logic target around the actor
		private _posX = selectRandom [random [-50,-5,-50],random [5,50,5]]; 		// Specifies the range for the camera position sideways to the actor
		private _posY = random [500,400,500]; 	// Specifies the range for the camera position to the front and back of the actor
		private _posZ = -100;
		//private _posZ = selectRandom [random [-50,-5,-50],random [5,30,5]];			// Specifies the range for the camera position vertically from the actor
		private _cameraPos = _unit modelToWorldWorld [_posX,_posY,_posZ];			// Define camera position
		indiCam_camera setPosASL _cameraPos; 										// Put the camera at the proper position (do NOT use camSetPos)
		indiCam_camera camSetTarget _unit; 											// Make the camera look at the AT unit
		indiCam_camera camSetFov (random [0.5,0.74,1]); 							// Set the proper field of view by calculating it
		indiCam_camera camCommit 0;													// Commit the camera to it's starting properties

		sleep 5;



// Projectile is now in the air. Set the camera on it.
				[_projectile] spawn {
					private _projectile = _this select 0;
					while {!(isNull _projectile)} do {							// For as long as the projectile exists, set camera position and target
						
						private _cameraPos = getPos indiCam_camera;
						private _projectilePos = getPos _projectile;
						indiCam_camera setPos _cameraPos; 						// Put the camera at the proper position (do NOT use camSetPos)
						indiCam_camera camSetTarget _projectilePos;	 				// Make the camera look at the AT unit
						indiCam_camera camSetFov 0.74; 								// Set the proper field of view by calculating it
						indiCam_camera camCommit 0;									// Commit the camera to it's starting properties



					};
					indiCam_var_eventhandlerDone = true;





	}; // End of case



	case "generic": {
	}; // End of case

}; // End of switch



