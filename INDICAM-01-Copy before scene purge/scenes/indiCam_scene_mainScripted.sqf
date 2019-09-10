comment "-------------------------------------------------------------------------------------------------------";
comment "											indiCam, by woofer.											";
comment "																										";
comment "										 indiCam_scene_mainScripted										";
comment "																										";
comment "	Contains scene definitions used in scripted scens													";
comment "	Scenes are first defined as usual, then a code block containing code that is passed to,				";
comment "	and executed by indiCam_fnc_sceneCommit.															";
comment "																										";
comment "	Each scene type is dedicated to a specific type of scene.";
comment "-------------------------------------------------------------------------------------------------------";



comment "-------------------------------------------------------------------------------------------------------";
comment "											scripted scenes												";
comment "-------------------------------------------------------------------------------------------------------";

if (indiCam_var_scriptedSceneType == "ATGuy") then { // Low action value scenes

	indiCam_var_scene = selectRandom [
								"ATcamOne",	// Basic scripted AT scene that tracks projectile
								"ATcamTwo"	// Basic scripted AT scene that tracks projectile
							];

	switch (indiCam_var_scene) do {
		
		case "ATcamOne": {
			indiCam_var_cameraType = "scripted"; // Specifies how the camera will be committed
			indiCam_var_disqualifyScene = false; // If true, this scene will not be applied and a new one will be selected
			indiCam_var_takeTime = 60; // Duration of scene in seconds
			indiCam_var_cameraMovementRate = 0; // Speed of camera to get into position. Zero = instantly.
			_posX = selectRandom [0];
			_posY = selectRandom [-10];
			_posZ = selectRandom [60];
			indiCam_var_cameraPos = indiCam_var_scriptedActor modelToWorld [_posX,_posY,_posZ]; // Position of camera
			indiCam_var_cameraTargetScripted = indiCam_var_scriptedActor; // This is the object the camera will be pointed towards
			indiCam_var_cameraAttach = false; // True if scene is using attachTo command
			indiCam_var_cameraFov = selectRandom [0.74]; // Set FOV, standard Arma FOV is 0.74
			indiCam_var_maxDistance = 10000; // Distance from indiCam_var_scriptedActor to camera that forces a scene switch
			indiCam_var_ignoreHiddenActor = true; // True means scene will be applied regardless of LOS checks
			
			
			// The following script will be run after the camera has been committed. Use with caution.
			// These scripts ALWAYS have to be able to exit on their own volition in a respectable time frame or the main loop will stay halted.
			indiCam_scene_scriptedScene = { // Start of scripted scene

				private _timeout = 60; // This is how long the scene is allowed to continue regardless of how it went
				
				private _future = time + _timeout; // Stores the mission time at which the timeout is to happen
				
				// Check the scripted actors' secondary weapon and store it in a variable for use in spawned scripts.
				indiCam_var_scriptedActorSecondary = (secondaryWeapon indiCam_var_scriptedActor);
				
				// Setup before the scene loop
				// secondaryWeaponMagazine Returns either single element array, containing class name of currently loaded in the secondary weapon magazine, or an empty array if unit has no secondary weapon or secondary weapon is not loaded.
				private _ehFiredMan = indiCam_var_scriptedActor addEventHandler ["FiredMan",
					{
						params ["_unit", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine", "_projectile", "_vehicle"];
						
[_unit,_weapon,_muzzle,_mode,_ammo,_magazine,_projectile,_vehicle] spawn {

						private _firedWeapon = _this select 1; // Used to check if fired weapon is the launcher
						private _firedProjectile = _this select 6; // Used as camera target when the projectile is flying

						// Only track projectile if fired weapon is the same as the units' secondary weapon (launcher)
						if (_firedWeapon == indiCam_var_scriptedActorSecondary) then {
						
							// While the projectile exists, log it's current position and commit camera when it has stopped existing
							[_firedProjectile] spawn {
							private "_pos";
								while {!isNull (_this select 0)} do {
									_pos = getPos (_this select 0);
								};
								// Commit the camera target
								indiCam camSetTarget _pos;
								indiCam camCommit 0;
								sleep 5; // Let the camera stay on the hopefully destroyed target for a while
								//indiCam_var_scriptedScene = false; // Terminate the scripted scene
							};
						
							// Switch camera target to the fired projectile as soon as it's fired
							indiCam camSetTarget _firedProjectile;
							indiCam camCommit 0;
							// Right after the rocket starts flying, make the camera slowly zoom onto it.
							indiCam camSetFov (indiCam_var_cameraFov / 2);
							indiCam camCommit 4;
							
							sleep 8;
							
							// Reset loop to go back to regular camera
							indiCam_var_scriptedScene = false;
							sleep 4;
							indiCam_var_interruptScene = true;

							
						};
};
					}
				];
				
				
				
				// The scripted scene loop controls what will contain all code executed during the scene
				while {(time < _future) || (indiCam_var_scriptedScene)} do { // When the timeout time has been reached, stop running this loop.
					
				};
				
				
				// Remove eventhandlers that were added.
				indiCam_var_scriptedActor removeEventHandler ["FiredMan", _ehFiredMan];
				
				
				
				comment "-----------------------------------------------------------";
				comment "				Scripted scene end block					";
				comment "-----------------------------------------------------------";
				// Everything the script was set to do is now done.
				// Let the main loop start working again by un-arresting the arrest.
				indiCam_var_scriptedScene = false;
			}; // end of scripted scene script
			
		}; // end of case
		
		case "ATcamTwo": {
			indiCam_var_cameraType = "scripted"; // Specifies how the camera will be committed
			indiCam_var_disqualifyScene = false; // If true, this scene will not be applied and a new one will be selected
			indiCam_var_takeTime = 60; // Duration of scene in seconds
			indiCam_var_cameraMovementRate = 0; // Speed of camera to get into position. Zero = instantly.
			_posX = selectRandom [-25,25];
			_posY = selectRandom [50];
			_posZ = selectRandom [25];
			indiCam_var_cameraPos = indiCam_var_scriptedActor modelToWorld [_posX,_posY,_posZ]; // Position of camera
			indiCam_var_cameraTargetScripted = indiCam_var_scriptedActor; // This is the object the camera will be pointed towards
			indiCam_var_cameraAttach = false; // True if scene is using attachTo command
			indiCam_var_cameraFov = selectRandom [0.74]; // Set FOV, standard Arma FOV is 0.74
			indiCam_var_maxDistance = 10000; // Distance from indiCam_var_scriptedActor to camera that forces a scene switch
			indiCam_var_ignoreHiddenActor = true; // True means scene will be applied regardless of LOS checks
			
			
			// The following script will be run after the camera has been committed. Use with caution.
			// These scripts ALWAYS have to be able to exit on their own volition in a respectable time frame or the main loop will stay halted.
			indiCam_scene_scriptedScene = { // Start of scripted scene

				private _timeout = 60; // This is how long the scene is allowed to continue regardless of how it went
				
				private _future = time + _timeout; // Stores the mission time at which the timeout is to happen
				
				// Check the scripted actors' secondary weapon and store it in a variable for use in spawned scripts.
				indiCam_var_scriptedActorSecondary = (secondaryWeapon indiCam_var_scriptedActor);
				
				// Setup before the scene loop
				// secondaryWeaponMagazine Returns either single element array, containing class name of currently loaded in the secondary weapon magazine, or an empty array if unit has no secondary weapon or secondary weapon is not loaded.
				private _ehFiredMan = indiCam_var_scriptedActor addEventHandler ["FiredMan",
					{
						params ["_unit", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine", "_projectile", "_vehicle"];
						
[_unit,_weapon,_muzzle,_mode,_ammo,_magazine,_projectile,_vehicle] spawn {

						private _firedWeapon = _this select 1; // Used to check if fired weapon is the launcher
						private _firedProjectile = _this select 6; // Used as camera target when the projectile is flying

						// Only track projectile if fired weapon is the same as the units' secondary weapon (launcher)
						if (_firedWeapon == indiCam_var_scriptedActorSecondary) then {
						
							// While the projectile exists, log it's current position and commit camera when it has stopped existing
							[_firedProjectile] spawn {
							private "_pos";
								while {!isNull (_this select 0)} do {
									_pos = getPos (_this select 0);
								};
								// Commit the camera target
								indiCam camSetTarget _pos;
								indiCam camCommit 0;
								sleep 5; // Let the camera stay on the hopefully destroyed target for a while
								//indiCam_var_scriptedScene = false; // Terminate the scripted scene
							};
						
							// Switch camera target to the fired projectile as soon as it's fired
							indiCam camSetTarget _firedProjectile;
							indiCam camCommit 0;
							// Right after the rocket starts flying, make the camera slowly zoom onto it.
							indiCam camSetFov (indiCam_var_cameraFov / 2);
							indiCam camCommit 4;
							
							sleep 8;
							
							// Reset loop to go back to regular camera
							indiCam_var_scriptedScene = false;
							sleep 4;
							indiCam_var_interruptScene = true;

							
						};
};
					}
				];
				
				
				
				// The scripted scene loop controls what will contain all code executed during the scene
				while {(time < _future) || (indiCam_var_scriptedScene)} do { // When the timeout time has been reached, stop running this loop.
					
				};
				
				
				// Remove eventhandlers that were added.
				indiCam_var_scriptedActor removeEventHandler ["FiredMan", _ehFiredMan];
				
				
				
				comment "-----------------------------------------------------------";
				comment "				Scripted scene end block					";
				comment "-----------------------------------------------------------";
				// Everything the script was set to do is now done.
				// Let the main loop start working again by un-arresting the arrest.
				indiCam_var_scriptedScene = false;
			}; // end of scripted scene script
			
		}; // end of case
		
	}; // End of switch

}; // End of ATGuy scenes












if (indiCam_var_scriptedSceneType == "actorDeath") then { // Low action value scenes

	indiCam_var_scene = selectRandom [
								"actorDeathOne",	// Basic scripted AT scene that tracks projectile
								"actorDeathTwo"	// Basic scripted AT scene that tracks projectile
							];

	switch (indiCam_var_scene) do {
		
		case "actorDeathOne": {
		systemchat "actorDeathOne";
			indiCam_var_cameraType = "scripted"; // Specifies how the camera will be committed
			indiCam_var_disqualifyScene = false; // If true, this scene will not be applied and a new one will be selected
			indiCam_var_takeTime = 60; // Duration of scene in seconds
			indiCam_var_cameraMovementRate = 0; // Speed of camera to get into position. Zero = instantly.
			_posX = selectRandom [0];
			_posY = selectRandom [0];
			_posZ = selectRandom [30];
			indiCam_var_cameraPos = indiCam_var_scriptedActor modelToWorld [_posX,_posY,_posZ]; // Position of camera
			indiCam_var_cameraTargetScripted = indiCam_var_scriptedActor; // This is the object the camera will be pointed towards
			indiCam_var_cameraAttach = false; // True if scene is using attachTo command
			indiCam_var_cameraFov = selectRandom [0.4]; // Set FOV, standard Arma FOV is 0.74
			indiCam_var_maxDistance = 20000; // Distance from indiCam_var_scriptedActor to camera that forces a scene switch
			indiCam_var_ignoreHiddenActor = true; // True means scene will be applied regardless of LOS checks
			
			
			// The following script will be run after the camera has been committed. Use with caution.
			// These scripts ALWAYS have to be able to exit on their own volition in a respectable time frame or the main loop will stay halted.
			indiCam_scene_scriptedScene = { // Start of scripted scene


					private _timeout = 60; // This is how long the scene is allowed to continue regardless of how it went
					
					private _future = time + _timeout; // Stores the mission time at which the timeout is to happen
			
			
					systemchat "this happened";
					
					
					private _pos = getPos indiCam_var_scriptedActor;
					
					// Switch camera target to the downed actor
					indiCam camSetTarget _pos;
					indiCam camSetPos [_pos select 0,_pos select 1,(_pos select 2) + 30];
					indiCam camSetFov 0.4;
					indiCam camCommit 0;
					// After the camera has been positioned, do a slow zoom out from his pos.
					indiCam camSetFov (indiCam_var_cameraFov * 2);
					indiCam camCommit 4;
					
					sleep 8;
					
					// Reset loop to go back to regular camera
					indiCam_var_scriptedScene = false;
					sleep 4;
					indiCam_var_interruptScene = true;

					// The scripted scene loop controls what will contain all code executed during the scene
					while {(time < _future) || (indiCam_var_scriptedScene)} do { // When the timeout time has been reached, stop running this loop.
					
					};
				

				

				
				
				
				comment "-----------------------------------------------------------";
				comment "				Scripted scene end block					";
				comment "-----------------------------------------------------------";
				// Everything the script was set to do is now done.
				// Let the main loop start working again by un-arresting the arrest.
				indiCam_var_scriptedScene = false;
			}; // end of scripted scene script
			
		}; // end of case
		
		
		
		case "actorDeathTwo": {
		systemchat "actorDeathTwo";
			indiCam_var_cameraType = "scripted"; // Specifies how the camera will be committed
			indiCam_var_disqualifyScene = false; // If true, this scene will not be applied and a new one will be selected
			indiCam_var_takeTime = 60; // Duration of scene in seconds
			indiCam_var_cameraMovementRate = 0; // Speed of camera to get into position. Zero = instantly.
			_posX = selectRandom [0];
			_posY = selectRandom [0];
			_posZ = selectRandom [30];
			indiCam_var_cameraPos = indiCam_var_scriptedActor modelToWorld [_posX,_posY,_posZ]; // Position of camera
			indiCam_var_cameraTargetScripted = indiCam_var_scriptedActor; // This is the object the camera will be pointed towards
			indiCam_var_cameraAttach = false; // True if scene is using attachTo command
			indiCam_var_cameraFov = selectRandom [0.4]; // Set FOV, standard Arma FOV is 0.74
			indiCam_var_maxDistance = 20000; // Distance from indiCam_var_scriptedActor to camera that forces a scene switch
			indiCam_var_ignoreHiddenActor = true; // True means scene will be applied regardless of LOS checks
			
			
			// The following script will be run after the camera has been committed. Use with caution.
			// These scripts ALWAYS have to be able to exit on their own volition in a respectable time frame or the main loop will stay halted.
			indiCam_scene_scriptedScene = { // Start of scripted scene


					private _timeout = 60; // This is how long the scene is allowed to continue regardless of how it went
					
					private _future = time + _timeout; // Stores the mission time at which the timeout is to happen
			
			
					systemchat "this happened";
					
					
					private _pos = getPos indiCam_var_scriptedActor;
					
					// Switch camera target to the downed actor
					indiCam camSetTarget _pos;
					indiCam camSetPos [_pos select 0,_pos select 1,(_pos select 2) + 30];
					indiCam camSetFov 0.4;
					indiCam camCommit 0;
					// After the camera has been positioned, do a slow zoom out from his pos.
					indiCam camSetFov (indiCam_var_cameraFov * 2);
					indiCam camCommit 4;
					
					sleep 8;
					
					// Reset loop to go back to regular camera
					indiCam_var_scriptedScene = false;
					sleep 4;
					indiCam_var_interruptScene = true;

					// The scripted scene loop controls what will contain all code executed during the scene
					while {(time < _future) || (indiCam_var_scriptedScene)} do { // When the timeout time has been reached, stop running this loop.
					
					};
				

				

				
				
				
				comment "-----------------------------------------------------------";
				comment "				Scripted scene end block					";
				comment "-----------------------------------------------------------";
				// Everything the script was set to do is now done.
				// Let the main loop start working again by un-arresting the arrest.
				indiCam_var_scriptedScene = false;
			}; // end of scripted scene script
			
		}; // end of case
		
	}; // End of switch

}; // End of ATGuy scenes