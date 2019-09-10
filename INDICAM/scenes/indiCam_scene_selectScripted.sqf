comment "-------------------------------------------------------------------------------------------------------";
comment "											indiCam, by woofer.											";
comment "																										";
comment "										 indiCam_scene_selectScripted									";
comment "																										";
comment "	Contains scene definitions used in scripted scens													";
comment "	Scenes are first defined as usual, then a code block containing code that is passed to,				";
comment "	and executed by indiCam_fnc_sceneCommit.															";
comment "																										";
comment "	Each scene type is dedicated to a specific type of scene.											";
comment "-------------------------------------------------------------------------------------------------------";




comment "												WARNING                        							";
comment "-------------------------------------------------------------------------------------------------------";
comment "					!!! DO NOT USE CAMSETPOS AND CAMCOMMIT IN SCRIPTED SCENES!!!                        ";
comment "																										";
comment "					!!! ALL SCRIPTS HERE NEED TERMINATION STATES OF THEIR OWN !!!						";
comment "-------------------------------------------------------------------------------------------------------";

// Declaring this scope to give scene scripts the ability to exit to the main scope
scopeName "topLevel";


// This script has to be spawned, so let's give a simple way of knowing if it's currently running
indiCam_var_scriptedSceneRunning = true;

// Stop regular camera operation
[] call indiCam_fnc_clearEventhandlers;sleep 0.1;

// Set the proper running mode
indiCam_var_requestMode = "scripted";


// The required scene type should have been set by now in one of the monitoring funcitons or eventhandlers

// Chance of a scene type to be requested should have been set by the monitoring functions or eventhandlers

// This script should now select a scene and we will commit it outside of here

private _sceneType = (_this select 0);
private _unit = (_this select 1);
private _selectedScene = "";


// ["actorDeath",unitone] call indiCam_scene_selectScripted

if (_sceneType == "actorDeath") then { // Start of actor death scene type

	
	// These scenes should always run and not be subject to scene Chance tests
	

	_selectedScene = selectRandom [
								"actorDeathOne",	// Basic scripted death scene
								"actorDeathTwo"		// Basic scripted death scene
							];

	switch (_selectedScene) do {
		
		case "actorDeathOne": {
			
			// Get the actual position of the actor
			private _pos = getPosASL _unit;
			
			// Switch camera target to the downed actor
			indiCam_camera camSetTarget _unit;
			indiCam_camera setPosASL (_unit modelToWorldWorld [-10,-10,10]);
			indiCam_camera camSetFov 0.4;
			indiCam_camera camCommit 0;
			
			// After the camera has been positioned, do a slow zoom out from his pos.
			indiCam_camera camSetTarget _unit;
			indiCam_camera camSetFov 0.05;
			indiCam_camera camCommit 3;
			
			// Let the camera hang around for a while
			sleep 6;			
			
			// Switch to a new actor
			[] call indiCam_fnc_actorSwitch;
			
			
		}; // end of case
		
		
		
		case "actorDeathTwo": {
			
			// Get the actual position of the actor
			private _pos = getPosASL _unit;
			
			// Switch camera target to the downed actor
			indiCam_camera camSetTarget _unit;
			indiCam_camera setPosASL (_unit modelToWorldWorld [-10,-10,30]);
			indiCam_camera camSetFov 0.4;
			indiCam_camera camCommit 0;

			// After the camera has been positioned, do a slow zoom out from his pos.
			indiCam_camera camSetTarget _unit;
			indiCam_camera camSetFov 2;
			indiCam_camera camCommit 3;
			
			// Let the camera hang around for a while
			sleep 6;			
			
			// Switch to a new actor
			[] call indiCam_fnc_actorSwitch;
			
			
		}; // end of case
		
	}; // End of switch

}; // End of actor death scenes





comment "-------------------------------------------------------------------------------------------------------";
comment "											scripted scenes												";
comment "-------------------------------------------------------------------------------------------------------";

if (_sceneType == "ATGuy") then {
	
	
	// Evaluate the chance of these scenes to happen in the corresponding monitoring function
	
	
	_selectedScene = selectRandom [
								"ATcamOne",	// Basic scripted AT scene that tracks projectile
								"ATcamTwo"	// Basic scripted AT scene that tracks projectile
							];
	
	switch (_selectedScene) do {
		
		case "ATcamOne": {
				_handle = ["new",_unit] execVM "INDICAM\scenes\indiCam_scene_atGuy.sqf";
				waitUntil {scriptDone _handle};
		}; // end of case
		
		
		case "ATcamTwo": {
				_handle = ["working",_unit] execVM "INDICAM\scenes\indiCam_scene_atGuy.sqf";
				waitUntil {scriptDone _handle};
		}; // end of case
		
	}; // End of switch

}; // End of ATGuy scenes



indiCam_var_scriptedSceneRunning = false;
// When done, resume normal operations
indiCam_var_requestMode = "default";
