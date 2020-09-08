// NOTE - Examples at the bottom of the script


private _scriptMode = _this select 0;
private _unit = (_this select 1);		// The desired unit
private _scriptedTimer = time + 30;		// Timer to check that the script will time out if needed

scopeName "topLevel";

// All the different ATguy scripts are located in here, select the appropriate one based on what was passed here
switch (_scriptMode) do {

	// Run this if mode wasn't provided
		default {};

	case "new": {
				
		// We now need to put the camera in an interesting position in the simplest way possible
		// I can't assume there will always be a target assigned to the unit - especially for players
		// Let's go with behind and above the unit
		private _cameraPos = _unit modelToWorldWorld [0,-10,10];	// Define camera position
		private _cameratarget = (getPos _unit);						// Define camera target position
		indiCam_camera setPosASL _cameraPos; 						// Put the camera at the proper position (do NOT use camSetPos)
		indiCam_camera camSetTarget _cameraTarget; 					// Make the camera look at the AT unit
		indiCam_camera camSetFov 0.74; 								// Set the proper field of view by calculating it
		indiCam_camera camCommit 0;									// Commit the camera to it's starting properties

		// Script that will run when the actor fires his weapon. It will be spawned independently from the rest of the script, so globals are needed for it
		indiCam_var_eventhandlerDone = false;
		private _ehFiredMan = _unit addEventHandler ["FiredMan",
			{ 
				params ["_unit", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine", "_projectile", "_vehicle"]; // Pull all the variables that the eventhandler passes on activation

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
				};

			} // End of eventhandler code
		]; // End of eventhandler


		waitUntil {indiCam_var_eventhandlerDone};

		// Make sure the eventhandler is removed from the scripted actor after all is said and done
		_unit removeAllEventHandlers "FiredMan"; // This will stop the camera from tracking any more shots

		indiCam_camera camSetFov 0.3; 	// Set the proper field of view by calculating it
		indiCam_camera camCommit 4;		// Commit the camera to it's starting properties

		sleep 5;						// Hang around for a while to look at the camera zoom in

	}; // End of case



	case "working": {

						dirConverter = {
							// Converts azimuth angle to BIS vectorDir array
							// Author: Ruger392, a.k.a. Lt. Col. Ruger of Air Combat Command
							_return = [0, 1, 0]; // North
							_angle = _this select 0;
							_xlen = tan _angle;
							// Determine quadrant and special cases and return
							if ((_angle > 0) && (_angle < 90)) then {_return = [_xlen, 1, 0]};
							if ((_angle > 90) && (_angle < 180)) then {_return = [-_xlen, -1, 0]};
							if ((_angle > 180) && (_angle < 270)) then {_return = [-_xlen, -1, 0]};
							if ((_angle > 270) && (_angle < 360)) then {_return = [_xlen, 1, 0]};
							if (_angle == 90) then {_return = [1, 0, 0]};
							if (_angle == 180) then {_return = [0, -1, 0]};
							if (_angle == 270) then {_return = [-1, 0, 0]};
							_return;
						};

						private _cameraPos = false; 			// The initial bool value is used to determine if a function provides an array instead

						// Get the current target of the given unit
						// Needs a failsafe so that when there is no target for the unit aiming, it should take a position a little ways infront of the actor


						// Find a point that has line of sight to both the unit and the target
						// When there is a target to be found, use that for direction
						private _target = assignedTarget _unit;
						if (!isNull _target) then {
							private _iteration = 0;
							while { ((typeName _cameraPos) != "BOOL") && (_iteration < 50) } do {
								_cameraPos = [_unit,_target,(_unit modelToWorldWorld [0,-60,40])] call indiCam_fnc_twopointLOS;
								_iteration = _iteration + 1;
							};
						};


						// If there is no target, just put the camera behind the actor
						if ((typeName _cameraPos) == "BOOL") then {
							_cameraPos = (_unit modelToWorldWorld [0,200,100]);	// When there is no target assigned, give a manual camera position
							private _actorDir = getDir _unit;					// Find the 2D direction of the projectile using the looking direction of the actor
							
						};



						// Set up the initial camera position
						indiCam_camera setPosASL _cameraPos; 		// Put the camera at the proper position (do NOT use camSetPos)
						indiCam_camera camSetTarget (getPos _unit); // Make the camera look at the AT unit
						indiCam_camera camSetFov 1; 				// Set the proper field of view by calculating it
						indiCam_camera camCommit 0;					// Commit the camera to it's starting properties

						// Now we are waiting for the _unit to fire its AT put an eventhandler on him that will make the camera move properly
						indiCam_var_eventhandlerDone = false;

						indiCam_var_scriptedActor = _unit;
						indiCam_var_tempPos = [0,0,0];

						// We'll use an eventhandler to get the moment the rocket is fired and all the necessary variables related to it
						private _ehFiredMan = indiCam_var_scriptedActor addEventHandler ["FiredMan",
							{
								// Pull all the variables that the eventhandler passes on activation
								params ["_unit", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine", "_projectile", "_vehicle"];
								
								[_weapon, _projectile] spawn {
									
									// Only track projectile if fired weapon is the same as the units' secondary weapon (launcher)
									if (_this select 0 == (secondaryWeapon indiCam_var_scriptedActor)) then {
									indiCam_var_projectileDone = false;
									indiCam_var_scriptedTimer = time + 30;
									
										// The projectile is now in the air, follow its position with the camera since we seemingly can't camSetTarget the actual object
										private _projectile = _this select 1;
										while {!(isNull _projectile)} do {		// For as long as the projectile exists, set camera position and target 
											
											private _cameraPos = (indiCam_var_scriptedActor modelToWorldWorld [0,-10,10]);	// find a suitable position behind the rocket and up
											private _projectilePos = getPos _projectile;
											
											private _actorDirection = getDir indiCam_var_scriptedActor; // Get a direction toward the target through the direction the actor faces
											_unitVector = [_actorDirection] call dirConverter;			// Use a little script to convert to unit vector toward
											_vector = _unitVector vectorMultiply -5;					// Make the unit vector a negative length for
											_newPos = _projectilePos vectorAdd _vector;					// Put the base of the vector onto the projectile to find the position at it's end
											_newPos = _newPos vectorAdd [0,0,40];						// Give the position som height above the floor
											
											indiCam_camera setPos _newPos; 					// Set the camera position
											indiCam_camera camSetTarget _projectilePos; 	// Set the projectile as camera target
											indiCam_camera camCommit 0; 					// Commit the camera target
											indiCam_var_tempPos = _projectilePos;			// Store temporarily to use after the spawned script is done
											
										};
										
										// This will let the rocket thing happen only once during this scripted scene
										indiCam_var_scriptedActor removeEventHandler ["FiredMan", _ehFiredMan]; // Thanks to VileAce!
										
										// Switch camera target to the fired projectile as soon as it's fired
										indiCam_camera camSetTarget indiCam_var_tempPos;
										indiCam_camera camCommit 0;
										// Right after the rocket starts flying, make the camera slowly zoom onto it.
										indiCam_camera camSetFov (1 / 2);
										indiCam_camera camCommit 4;
										
										sleep 8;
										
										// Tell the scene that the eventhandler just ran
										indiCam_var_eventhandlerDone = true;
										
									};
								};
							}
						];


						// Wait until the timer runs out, or the script in the eventhandler is done. Then exit the scripted scene regardless
						while { !indiCam_var_eventhandlerDone &&
								(_scriptedTimer > time) &&
								( (currentMagazine indiCam_var_scriptedActor) isEqualTo ((secondaryWeaponMagazine indiCam_var_scriptedActor) select 0) ) // Checks if the current ammo is the same as the secondary weapon ammo
						} do {
							// Now the rocket has been fired or scene timer is out.
							if (_scriptedTimer < time) then {
								breakTo "topLevel"; // Stop doing the script
							} else {
								sleep 5; // Let the camera hang around for a while
							};
						};

						// Make sure the eventhandler is removed from the scripted actor after all is said and done
						indiCam_var_scriptedActor removeEventHandler ["FiredMan", _ehFiredMan]; // Thanks to VileAce!











	}; // End of case

}; // End of switch




/* EXAMPLE
indiCam_camera setPosASL _cameraPos; 						// Put the camera at the proper position (do NOT use camSetPos)
indiCam_camera camSetFov 0.02; 								// Set the proper field of view by calculating it
indiCam_camera camCommit 5;									// Commit the camera to it's starting properties
waitUntil {camCommitted indiCam_camera};					// This now works
*/