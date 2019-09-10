comment "-------------------------------------------------------------------------------------------------------";
comment "											indiCam, by woofer.											";
comment "																										";
comment "											indiCam_fnc_sceneCommit										";
comment "																										";
comment "	This script commits a selected and tested scene to the indiCam camera.								";
comment "																										";
comment "	Takes the values from the selected scene and promotes them to applied variables which are in turn	";
comment "	used in the selected camera commit type.															";
comment "																										";
comment "																										";
comment "-------------------------------------------------------------------------------------------------------";

/*
Available camera commit types:
default - For general basic camera use
logics - For use with game logics
relative - Used when camSetRelPos is in effect rather than attachTo
*/

//TODO- Go through all the variables to see what is actually used
//TODO- Add a commit type that skips applying any camera stuff so that a scene can just execute a script.


// Kill any onEachFrame camera eventhandlers still going.
[] call indiCam_fnc_clearEventhandlers;


// Stop any already running logic scripts
indiCam_indiCamLogicLoop = false;


// Move the values over to permanent variables so that the scene selection can get going again
indiCam_appliedVar_takeTime = indiCam_var_takeTime;
indiCam_appliedVar_cameraMovementRate = indiCam_var_cameraMovementRate;
indiCam_appliedVar_cameraPos = indiCam_var_cameraPos;
indiCam_appliedVar_targetPos = indiCam_var_targetPos;

indiCam_appliedVar_cameraSpeed = indiCam_var_cameraSpeed;
indiCam_appliedVar_targetSpeed = indiCam_var_targetSpeed;


indiCam_appliedVar_cameraTarget = indiCam_var_cameraTarget;
indiCam_appliedVar_cameraTargetScripted = indiCam_var_cameraTargetScripted;
indiCam_appliedVar_cameraFov = indiCam_var_cameraFov;
indiCam_appliedVar_maxDistance = indiCam_var_maxDistance;

indiCam_appliedVar_ignoreHiddenActor = indiCam_var_ignoreHiddenActor;

indiCam_appliedVar_cameraType = indiCam_var_cameraType;








// Apply the camera using the last values pulled on the scene
switch (indiCam_appliedVar_cameraType) do {


	case "default": {
	/*
	This is the basic camera commit without any bells or whistles
	*/
		
		// Detach camera if needed
		if (!(indiCam_var_cameraAttach)) then {detach indiCam};
		
		// Prepare camera before committing it
		indiCam camSetPos indiCam_appliedVar_cameraPos;
		indiCam camSetTarget indiCam_appliedVar_cameraTarget;
		indiCam camSetFov indiCam_appliedVar_cameraFov;

		// Do the actual commit 
			if (indiCam_appliedVar_takeTime == 1) then {indiCam_appliedVar_takeTime = 2}; // prevents division by zero
			if (indiCam_appliedVar_cameraMovementRate == 0) then {  // prevents division by zero
				indiCam camCommit 0;
			} else {
				indiCam camCommit (((indiCam distance indiCam_appliedVar_cameraPos) / (indiCam_appliedVar_takeTime - 1)) / indiCam_appliedVar_cameraMovementRate);
			};
				
	}; // end of case
	
	
	
	case "scripted": {
		/*
		This camera type allows for passing code from scenes that will be executed here
		*/
		
		detach indiCam;
	
		// Prepare camera before committing it
		indiCam camSetPos indiCam_appliedVar_cameraPos;
		indiCam camSetTarget indiCam_appliedVar_cameraTargetScripted;
		indiCam camSetFov indiCam_appliedVar_cameraFov;
		indiCam camCommit 0;
		
		// Do the actual commit
		if (indiCam_appliedVar_takeTime == 1) then {indiCam_appliedVar_takeTime = 2}; // prevents division by zero
		
		// Spawn the scene code that was passed here
		[] spawn indiCam_scene_scriptedScene;
		if (indiCam_debug) then {systemChat "Scripted scene script was spawned"};
	
	}; // end of case
	
	
	case "stationaryCameraLogicTarget": {
		/*
		Camera is stationary at given point.
		Camera target is a follow logic calculated on each frame.
		*/
		
		indiCam_var_logicTarget setPosASL (actor modelToWorldWorld indiCam_appliedVar_targetPos);
		indiCam setPosASL (actor modelToWorldWorld indiCam_appliedVar_cameraPos);

		["indiCam_id_logicTarget", "onEachFrame", {[indiCam_var_logicTarget,(actor modelToWorldWorld indiCam_appliedVar_targetPos),indiCam_appliedVar_targetSpeed] call indiCam_fnc_followLogicFPS}] call BIS_fnc_addStackedEventHandler;
		// Add this eventhandler to the current EH list
		indiCam_var_activeEventHandlers pushBackUnique "indiCam_id_logicTarget";
		
		indiCam camSetFov indiCam_appliedVar_cameraFov;
		indiCam camSetTarget indiCam_appliedVar_cameraTarget;
		indiCam camCommit 0;
	
	}; // end of case
	
	
	case "followCameraLogicTarget": {
		
		indiCam_var_logicTarget setPosASL (actor modelToWorldWorld indiCam_appliedVar_targetPos);
		indiCam setPosASL (actor modelToWorldWorld indiCam_appliedVar_cameraPos);

		["indiCam_id_logicTarget", "onEachFrame", {[indiCam_var_logicTarget,(actor modelToWorldWorld indiCam_appliedVar_targetPos),indiCam_appliedVar_targetSpeed] call indiCam_fnc_followLogicFPS}] call BIS_fnc_addStackedEventHandler;
		// Add this eventhandler to the current EH list
		indiCam_var_activeEventHandlers pushBackUnique "indiCam_id_logicTarget";
		
		["indiCam_id_logicCamera", "onEachFrame", {[indiCam,(actor modelToWorldWorld indiCam_appliedVar_cameraPos),indiCam_appliedVar_cameraSpeed] call indiCam_fnc_followLogicFPS}] call BIS_fnc_addStackedEventHandler;
		// Add this eventhandler to the current EH list
		indiCam_var_activeEventHandlers pushBackUnique "indiCam_id_logicCamera";
		
		
		
		
		indiCam camSetFov indiCam_appliedVar_cameraFov;
		indiCam camSetTarget indiCam_appliedVar_cameraTarget;
		indiCam camCommit 0;
	
	}; // end of case
	
	
	case "followCameraWeaponLogic": {
		
		indiCam_var_logicTarget setPosASL (actor modelToWorldWorld indiCam_appliedVar_targetPos);
		indiCam setPosASL (actor modelToWorldWorld indiCam_appliedVar_cameraPos);

		["indiCam_id_logicTarget", "onEachFrame", {[indiCam_var_logicTarget,indiCam_appliedVar_targetPos,indiCam_appliedVar_targetSpeed] call indiCam_fnc_followLogicTurretAim}] call BIS_fnc_addStackedEventHandler;
		// Add this eventhandler to the current EH list
		indiCam_var_activeEventHandlers pushBackUnique "indiCam_id_logicTarget";
		
		["indiCam_id_logicCamera", "onEachFrame", {[indiCam,indiCam_appliedVar_cameraPos,indiCam_appliedVar_cameraSpeed] call indiCam_fnc_followLogicTurretAim}] call BIS_fnc_addStackedEventHandler;
		// Add this eventhandler to the current EH list
		indiCam_var_activeEventHandlers pushBackUnique "indiCam_id_logicCamera";
		
		
		
		indiCam camSetFov indiCam_appliedVar_cameraFov;
		indiCam camSetTarget indiCam_appliedVar_cameraTarget;
		indiCam camCommit 0;
	
	}; // end of case
	
	
}; // end of switch


