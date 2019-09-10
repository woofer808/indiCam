comment "-------------------------------------------------------------------------------------------";
comment "This script generates different scenes based on situation given by woof_fnc_situationCheck	";
comment " situationCheck = [movingValue,actionValue,proximityValue,vicValue] 						";
comment "-------------------------------------------------------------------------------------------";

sceneSelectorDone = false; // Here to support a waitUntil command

// Resetting the variables
private _newCameraPos = [0,0,0];
private _newFov = 1;
private _cameraTaketime = 10;
private _cameraMovementRate = 1;
private _cameraTarget = actor;
private _maxDistance = 10000;
private _ignoreActorHidden = false;
private _detachCamera = false;


comment "-------------------------------------------------------------------------------------------";
comment "									actor deathcam											";
comment "-------------------------------------------------------------------------------------------";

if (!alive actor) then { // The death of an actor

	if (isPlayer actor) then { // If it was a player that was the actor - go to deathcam
	
		/* DEBUG */ if (indiCamDebug) then {systemChat "so welcome to the deathcam"};

		detach indiCam;

		// Start the camera close on the actors' eyes
		sleep 3;
		_eyepos = ASLToAGL eyePos actor;
		indiCam camPrepareTarget _eyepos;
		indiCam camPreparePos [_eyepos select 0,_eyepos select 1,(_eyepos select 2) + 0.3];
		indiCam camPrepareFov 2;
		waitUntil {camPreloaded indiCam};
		indiCam camCommitPrepared 0;
		waitUntil {camCommitted indicam};
		
		// Pull the camera away from the actor while going to a narrower FOV
		//indiCam camPrepareTarget actor; // Shouldn't need this
		indiCam camPreparePos [_eyepos select 0,_eyepos select 1,(_eyepos select 2) + 300];
		indiCam camPrepareFov 0.5;
		//waitUntil {camPreloaded indiCam}; // Shouldn't need this
		indiCam camCommitPrepared 30;
		
		waitUntil {alive actor}; // As soon as the actor is alive again, jump to his location

		// Start a bit away and up
		indiCam camPrepareTarget actor;
		indiCam camPreparePos (actor modelToWorld [10, 10, 50]);
		indiCam camPrepareFov 1;
		waitUntil {camPreloaded indiCam};
		indiCam camCommitPrepared 0;
		waitUntil {camCommitted indicam};
		
		// Boom shot closer to the actor
		indiCam camPrepareTarget actor;
		indiCam camPreparePos (actor modelToWorld [0, 3, 1]);
		indiCam camPrepareFov 1;
		waitUntil {camPreloaded indiCam};
		indiCam camCommitPrepared 5;
		waitUntil {camCommitted indicam};
		
			
		sleep 3;
		
	} else { // If it was an AI that died, play a quick deathcam and set the camera on another AI
	
	
	
	
	/* DEBUG */ if (indiCamDebug) then {systemChat "so welcome to the deathcam"};
		sleep 3;
		detach indiCam;

		// Start the camera close on the actors eyes
		_eyepos = ASLToAGL eyePos actor;
		_actorcampos = actor modelToWorld [0,0,1];
		indiCam camPrepareTarget _eyepos;
		indiCam camPreparePos _actorcampos;
		indiCam camPrepareFov 0.5;
		waitUntil {camPreloaded indiCam};
		indiCam camCommitPrepared 0;
		
		_actorcampos = actor modelToWorld [0,0,10];
		indiCam camPreparePos _actorcampos;
		indiCam camPrepareFov 0.2;
		waitUntil {camPreloaded indiCam};
		indiCam camCommitPrepared 5;
		//waitUntil camCommitted indiCam;
		sleep 3;
	
	

	
	
		// https://forums.bohemia.net/forums/topic/94695-how-to-find-nearest-unit-of-a-given-side/
		_nearestObjects = nearestObjects [actor,["Man"],750];
		_nearestFriendlies = [];

		if ((actorSide) countSide _nearestObjects > 0) then {
			{
				private _unit = _x;
				if (((side _unit) == (actorSide)) && (!isPlayer _unit) && (alive _unit) && (_unit isKindOf "Man")) then {
					_nearestFriendlies = _nearestFriendlies + [_unit]
				};
			} foreach _nearestObjects;
			
			actor = _nearestFriendlies select 0;

		};
		
		if (count _nearestFriendlies == 0) then {
			/* DEBUG */ if (indiCamDebug) then {systemChat "no AI could be found around the actor, switching to player..."};
			actor = player;
		};
		
		indiCam camPreparePos (actor modelToWorld [0,-50,200]);
		indiCam camPrepareTarget actor;
		indiCam camPrepareFov 0.075;
		waitUntil {camPreloaded indiCam};
		indiCam camCommitPrepared 5;
		waitUntil {camCommitted indiCam};

		

	};
	
}; // End of deathcam






comment "-------------------------------------------------------------------------------------------";
comment "									actor obscured											";
comment "-------------------------------------------------------------------------------------------";

if (actorObscuredPersistent) then { // These scenes are for when the actor is detected to be obscured
	// Should contain only closeups and first person views
	/* DEBUG */ if (indiCamDebug) then {systemChat "obscured actor scenes"};

	// This is so that the delay in woof_fnc_visibilityCheck won't cause a flood in scene changes
	// Kinda needs to go, but it resets the actorObscuredPersistent bool directly after this script made use of it
	actorObscuredPersistent = false; 
	
	_newScene = selectRandom ["weaponPerson"];

	switch (_newScene) do {

		case "weaponPerson": {
			// Idea for having camera follow the weapon - add foreachframe
			// _weaponVectorDir = player weaponDirection currentWeapon player;
			if (indiCamDebug) then {systemChat "case is weaponPerson"};
			_cameraTaketime = 5;
			_cameraMovementRate = 0;
			_newCameraPos = (actor modelToWorld [0.05, 0.2, 0]);
			indiCam attachTo [actor, [0.05, 0.2, 0], "RightHand"];
			_logicTarget = createVehicle ["ModuleEmpty_F", getPos actor, [], 0, "NONE"];
			_logicTarget attachTo [actor, [0, 2, 1.5]];
			_cameraTarget = _logicTarget;
			_newFov = 1;
		}; // end of case

	}; // end of switch

}; // End of obscured actor scenes





/* SAFE MODE

comment "-------------------------------------------------------------------------------------------";
comment "									camera safe mode										";
comment "-------------------------------------------------------------------------------------------";
if (safeMode) then { // These scenes are for when the regular programming sucks
	// Should contain only closeups and first person views
	systemChat "safe mode scenes";

	_newScene = selectRandom ["weaponPerson"];

	switch (_newScene) do {

		case "weaponPerson": {
			// Idea for having camera follow the weapon - add foreachframe
			// _weaponVectorDir = player weaponDirection currentWeapon player;
			if (indiCamDebug) then {systemChat "case is weaponPerson"};
			_cameraTaketime = 5;
			_cameraMovementRate = 0;
			_newCameraPos = (actor modelToWorld [0.05, 0.2, 0]);
			indiCam attachTo [actor, [0.05, 0.2, 0], "RightHand"];
			_logicTarget = createVehicle ["ModuleEmpty_F", getPos actor, [], 0, "NONE"];
			_logicTarget attachTo [actor, [0, 2, 1.5]];
			_cameraTarget = _logicTarget;
			_newFov = 1;
		}; // end of case

	}; // end of switch

}; // End of safe mode

*/









comment "-------------------------------------------------------------------------------------------";
comment "								This is a testing area										";
comment "-------------------------------------------------------------------------------------------";
_testScene = false;
if (_testScene) then {











			
	// Return the values
	sceneSelector = [
	_newCameraPos,			// This select 0	//	(sceneSelector select 0)
	_newFov,				// This select 1	//	(sceneSelector select 1)
	_cameraTarget,			// This select 2	//	(sceneSelector select 2)
	_cameraTaketime,		// This select 3	//	(sceneSelector select 3)
	_cameraMovementRate,	// This select 4	//	(sceneSelector select 4)
	_maxDistance,			// This select 5	//	(sceneSelector select 5)
	_ignoreActorHidden		// This select 6	//	(sceneSelector select 6)
	];
	sceneSelectorDone = true; // Here to support a waitUntil command
	
};

if (_testScene) exitWith {};




comment "-------------------------------------------------------------------------------------------";
comment "									actor on foot											";
comment "-------------------------------------------------------------------------------------------";
if (vicValue == 0) then { // Actor on foot scenes



comment "-------------------------------------------------------------------------------------------";
comment "									non-action scenes										";
comment "-------------------------------------------------------------------------------------------";
	if (actionValue == 0) then { // non-action scenes

		if (indiCamDebug) then {systemChat "actor on foot scenes"};
		
		_newScene = selectRandom [
									"thirdPerson", 				// homebrew third person view - kinda jerky
									"thirdPersonHigh",			// homebrew third person view higher- kinda jerky
									"randomWideFocusPerson", 	// Randomized stationary wide angle camera from close to far
									"birdPerson", 				// Top-down view
									"closeup",					// Randomized stationary close camera for quick run-bys
									"closeup",// Added probability of use by duplication
									"randomWideFocusPerson",	// Randomized low stationary medium wide camera from close to far
									"randomNarrowFocusPerson",	// Randomized low stationary zoom camera from close to far
									"dronePerson",				// Top-down view
									"satellitePersonStill"		// Top-down still view actor walking into the shot
								];

		switch (_newScene) do {

			case "thirdPerson": {
				if (indiCamDebug) then {systemChat "case is third person view"};
				_cameraTaketime = 5;
				_cameraMovementRate = 0;
				_newCameraPos = (actor modelToWorld [0,0,0]);
				_logicTarget = createVehicle ["ModuleEmpty_F", getPos actor, [], 0, "NONE"];
				_logicTarget attachTo [actor, [0.5, 5, 1.8]];
				indiCam camSetTarget _logicTarget;
				_cameraTarget = _logicTarget;
				indiCam attachTo [actor, [0, -2, 0], "camera"];
				_newFov = 0.8;
				_maxDistance = 1000;
				_ignoreActorHidden = false;
				_detachCamera = false;
			}; // end of case
			
			case "thirdPersonHigh": {
				if (indiCamDebug) then {systemChat "case is thirdPersonHigh"};
				_cameraTaketime = 5;
				_cameraMovementRate = 0;
				_newCameraPos = (actor modelToWorld [0.05, 0.2, 0]);
				indiCam attachTo [actor, [-0.3, -2, 1], "camera"];
				_logicTarget = createVehicle ["ModuleEmpty_F", getPos actor, [], 0, "NONE"];
				_logicTarget attachTo [actor, [0, 20, 1.5]];
				_cameraTarget = _logicTarget;
				_newFov = 0.75;
				_maxDistance = 1000;
				_ignoreActorHidden = false;
				_detachCamera = false;
			}; // end of case

			case "randomWideFocusPerson": {
				if (indiCamDebug) then {systemChat "case is randomized wide shots"};
				//detach indiCam;
				_cameraTaketime = 30;
				_cameraMovementRate = 0;
				_cameraTarget = actor;
				// Randomize the next position for camera around the actor
				_posX = random [-100,0,100];
				_posY = random [-100,0,100];
				_posZ = random [1,5,40];
				_newCameraPos = (actor modelToWorld [_posX,_posY,_posZ]);
				_newFov = (selectRandom [0.5,0.7,1.2]);
				_maxDistance = 200;
				_ignoreActorHidden = false;
				_detachCamera = true;
			}; // end of case

			case "birdPerson": {
				if (indiCamDebug) then {systemChat "case is top-down"};
				//detach indiCam;
				_cameraTaketime = 10;
				_cameraMovementRate = 0;
				// Randomize the next position for camera around the actor
				_posX = random [-10,0,30];
				_posY = random [-10,0,30];
				_posZ = random [15,20,30];
				_newCameraPos = (actor modelToWorld [_posX,_posY,_posZ]);
				_cameraTarget = actor;
				_newFov = (selectRandom [1.8,2,2.2]);
				_maxDistance = 100;
				_ignoreActorHidden = false;
				_detachCamera = true;
			}; // end of case

			case "closeup": {
				if (indiCamDebug) then {systemChat "case is randomized close quick shots"};
				//detach indiCam;
				_cameraTaketime = 5;
				_cameraMovementRate = 0;
				_cameraTarget = actor;
				// Randomize the next position for camera around the actor
				_posX = random [-10,0,10];
				_posY = random [-2,0,10];
				_posZ = random [0.2,0.5,3];
				_newCameraPos = (actor modelToWorld [_posX,_posY,_posZ]);
				_newFov = (selectRandom [0.5,0.7,1.2]);
				_maxDistance = 1000;
				_ignoreActorHidden = false;
				_detachCamera = true;
			}; // end of case
			
			case "randomWideFocusPerson": {
				if (indiCamDebug) then {systemChat "case is randomized wide shots"};
				//detach indiCam;
				_cameraTaketime = 30;
				_cameraMovementRate = 0;
				_cameraTarget = actor;
				// Randomize the next position for camera around the actor
				_posX = random [-100,0,100];
				_posY = random [-100,0,100];
				_posZ = random [1,5,10];
				_newCameraPos = (actor modelToWorld [_posX,_posY,_posZ]);
				_newFov = (selectRandom [0.05,0.15,0.3]);
				_maxDistance = 1000;
				_ignoreActorHidden = false;
				_detachCamera = true;
			}; // end of case
			
			case "randomNarrowFocusPerson": {
				if (indiCamDebug) then {systemChat "case is randomized narrow shots"};
				//detach indiCam;
				_cameraTaketime = 30;
				_cameraMovementRate = 0;
				_cameraTarget = actor;
				// Randomize the next position for camera around the actor
				_posX = random [-200,0,300];
				_posY = random [-200,0,300];
				_posZ = random [1,5,40];
				_newCameraPos = (actor modelToWorld [_posX,_posY,_posZ]);
				_newFov = (selectRandom [0.075,0.1,0.2]);
				_maxDistance = 10000;
				_ignoreActorHidden = false;
				_detachCamera = true;
			}; // end of case
			
			case "dronePerson": {
				if (indiCamDebug) then {systemChat "case is top-down"};
				//detach indiCam;
				_cameraTaketime = 20;
				_cameraMovementRate = 10;
				_newCameraPos = (actor modelToWorld [0,-50,200]);
				_cameraTarget = actor;
				_newFov = 0.075;
				_maxDistance = 500;
				_ignoreActorHidden = false;
				_detachCamera = true;
			}; // end of case
			
			
			case "satellitePersonStill": {
				if (indiCamDebug) then {systemChat "case is satellite still"};
				//detach indiCam;
				_cameraTaketime = 15;
				_cameraMovementRate = 0;
				_newCameraPos = (actor modelToWorld [50,50,200]);
				_logicTarget = createVehicle ["ModuleEmpty_F", actor modelToWorld [0,50,0], [], 0, "NONE"];
				indiCam camSetTarget _logicTarget;
				_cameraTarget = _logicTarget;
				_newFov = 0.2;
				_maxDistance = 1000;
				_ignoreActorHidden = false;
				_detachCamera = true;
			}; // end of case
			
			
		}; // end of switch
	
	}; // End of low action value scenes
	
	
	
	
comment "-------------------------------------------------------------------------------------------";
comment "									low-action scenes										";
comment "-------------------------------------------------------------------------------------------";
	if (actionValue == 1) then {  // low actionValue scenes
	
		if (indiCamDebug) then {systemChat "low actionValue"};
		
		_newScene = selectRandom 	[
									"thirdPerson", 				// homebrew third person view - kinda jerky
									"randomWideFocusPerson", 	// Randomized stationary wide angle camera from close to far
									"birdPerson", 				// Top-down view
									"closeup",					// Randomized stationary close camera for quick run-bys
									"closeup",// Added probability of use by duplication
									"closeup",// Added probability of use by duplication
									"randomNarrowFocusPerson"	// Randomized low stationary zoom camera from close to far
									];
		
		switch (_newScene) do {
		
			case "thirdPerson": {
				// Put something here that only updates the scene if the previous case was something else
				if (indiCamDebug) then {systemChat "case is third person view"};
				_cameraTaketime = 10;
				_cameraMovementRate = 0;
				_newCameraPos = (actor modelToWorld [0,0,0]);
				_logicTarget = createVehicle ["ModuleEmpty_F", getPos actor, [], 0, "NONE"];
				_logicTarget attachTo [actor, [0.5, 5, 1.8]];
				indiCam camSetTarget _logicTarget;
				_cameraTarget = _logicTarget;
				indiCam attachTo [actor, [0, -2, 0], "camera"];
				_newFov = 0.8;
				_maxDistance = 1000;
				_ignoreActorHidden = false;
				_detachCamera = false;
			}; // end of case

			case "randomWideFocusPerson": {
				if (indiCamDebug) then {systemChat "case is randomized wide shots"};
				//detach indiCam;
				_cameraTaketime = 15;
				_cameraMovementRate = 0;
				_cameraTarget = actor;
				// Randomize the next position for camera around the actor
				_posX = random [-100,0,100];
				_posY = random [-100,0,100];
				_posZ = random [1,5,40];
				_newCameraPos = (actor modelToWorld [_posX,_posY,_posZ]);
				_newFov = (selectRandom [0.5,0.7,1.2]);
				_maxDistance = 300;
				_ignoreActorHidden = false;
				_detachCamera = true;
			}; // end of case

			case "birdPerson": {
				if (indiCamDebug) then {systemChat "case is top-down"};
				//detach indiCam;
				_cameraTaketime = 10;
				_cameraMovementRate = 10;
				_newCameraPos = (actor modelToWorld [0,-50,200]);
				_cameraTarget = actor;
				_newFov = 0.075;
				_ignoreActorHidden = false;
				_detachCamera = true;
			}; // end of case

			case "closeup": {
				if (indiCamDebug) then {systemChat "case is randomized close quick shots"};
				//detach indiCam;
				_cameraTaketime = 10;
				_cameraMovementRate = 0;
				_cameraTarget = actor;
				// Randomize the next position for camera around the actor
				_posX = random [-10,0,10];
				_posY = random [-2,0,10];
				_posZ = random [0.2,0.5,3];
				_newCameraPos = (actor modelToWorld [_posX,_posY,_posZ]);
				_newFov = (selectRandom [0.5,0.7,1.2]);
				_maxDistance = 1000;
				_ignoreActorHidden = false;
				_detachCamera = true;
			}; // end of case
			
			case "randomNarrowFocusPerson": {
				if (indiCamDebug) then {systemChat "case is randomized wide shots"};
				//detach indiCam;
				_cameraTaketime = 15;
				_cameraMovementRate = 0;
				_cameraTarget = actor;
				// Randomize the next position for camera around the actor
				_posX = random [-100,0,100];
				_posY = random [-100,0,100];
				_posZ = random [1,5,10];
				_newCameraPos = (actor modelToWorld [_posX,_posY,_posZ]);
				_newFov = (selectRandom [0.05,0.15,0.3]);
				_maxDistance = 300;
				_ignoreActorHidden = false;
				_detachCamera = true;
			}; // end of case
			
		}; // end of switch
			
	}; // End of low actionValue scenes

	
	
comment "-------------------------------------------------------------------------------------------";
comment "								medium-action scenes										";
comment "-------------------------------------------------------------------------------------------";
	if (actionValue == 2) then {  // medium actionValue scenes
	
	if (indiCamDebug) then {systemChat "medium actionValue"};
		_newScene = selectRandom 	[
									"mediumclose",		// Randomized stationary medium close camera for run-bys
									"weaponPerson", 		// First attempt at a weapon mounted camera
									"closeup",			// Randomized stationary close camera for quick run-bys
									"closeup",// Added probability of use by duplication
									"birdPerson" 				// Top-down view
									];
									
		switch (_newScene) do {
		
		case "mediumclose": {
				if (indiCamDebug) then {systemChat "case is randomized close quick shots"};
				//detach indiCam;
				_cameraTaketime = 10;
				_cameraMovementRate = 0;
				_cameraTarget = actor;
				// Randomize the next position for camera around the actor
				_posX = random [-30,0,30];
				_posY = random [-10,0,30];
				_posZ = random [0.2,0.5,3];
				_newCameraPos = (actor modelToWorld [_posX,_posY,_posZ]);
				_newFov = (selectRandom [0.5,0.7,1]);
				_maxDistance = 1000;
				_ignoreActorHidden = false;
				_detachCamera = true;
			}; // end of case
			
		case "weaponPerson": {
				// Idea for having camera follow the weapon - add foreachframe
				// _weaponVectorDir = player weaponDirection currentWeapon player
				if (indiCamDebug) then {systemChat "case is weaponPerson"};
				_cameraTaketime = 5;
				_cameraMovementRate = 0;
				_newCameraPos = (actor modelToWorld [0.05, 0.2, 0]);
				indiCam attachTo [actor, [0.05, 0.2, 0], "RightHand"];
				_logicTarget = createVehicle ["ModuleEmpty_F", getPos actor, [], 0, "NONE"];
				_logicTarget attachTo [actor, [0, 2, 1.5]];
				_cameraTarget = _logicTarget;
				_newFov = 1;
				_maxDistance = 1000;
				_ignoreActorHidden = false;
				_detachCamera = false;
			}; // end of case
			
		case "closeup": {
				if (indiCamDebug) then {systemChat "case is randomized close quick shots"};
				//detach indiCam;
				_cameraTaketime = 10;
				_cameraMovementRate = 0;
				_cameraTarget = actor;
				// Randomize the next position for camera around the actor
				_posX = random [-10,0,10];
				_posY = random [-2,0,10];
				_posZ = random [0.2,0.5,3];
				_newCameraPos = (actor modelToWorld [_posX,_posY,_posZ]);
				_newFov = (selectRandom [0.5,0.7,1.2]);
				_maxDistance = 1000;
				_ignoreActorHidden = false;
				_detachCamera = true;
			}; // end of case
			
			case "birdPerson": {
				if (indiCamDebug) then {systemChat "case is top-down"};
				//detach indiCam;
				_cameraTaketime = 10;
				_cameraMovementRate = 10;
				_newCameraPos = (actor modelToWorld [0,-50,200]);
				_cameraTarget = actor;
				_newFov = 0.075;
				_ignoreActorHidden = false;
				_detachCamera = true;
			}; // end of case
			
		}; // end of switch
			
	}; // End of medium actionValue scenes



comment "-------------------------------------------------------------------------------------------";
comment "									high-action scenes										";
comment "-------------------------------------------------------------------------------------------";
	if (actionValue == 3) then {  // high actionValue scenes
	
	if (indiCamDebug) then {systemChat "high actionValue"};
		_newScene = selectRandom 	[
									"closeup",		// Randomized stationary close camera for quick run-bys
									"closeup",// Added probability of use by duplication
									"closeup",// Added probability of use by duplication
									"weaponPerson", 	// First attempt at a weapon mounted camera
									"birdPerson" 				// Top-down view
									];
		
		switch (_newScene) do {
		
		case "closeup": {
				if (indiCamDebug) then {systemChat "case is randomized close quick shots"};
				//detach indiCam;
				_cameraTaketime = 10;
				_cameraMovementRate = 0;
				_cameraTarget = actor;
				// Randomize the next position for camera around the actor
				_posX = random [-10,0,10];
				_posY = random [-2,0,10];
				_posZ = random [0.2,0.5,3];
				_newCameraPos = (actor modelToWorld [_posX,_posY,_posZ]);
				_newFov = (selectRandom [0.5,0.7,1.2]);
				_maxDistance = 1000;
				_ignoreActorHidden = false;
				_detachCamera = true;
			}; // end of case
			
			case "weaponPerson": {
				// Idea for having camera follow the weapon - add foreachframe
				// _weaponVectorDir = player weaponDirection currentWeapon player
				if (indiCamDebug) then {systemChat "case is weaponPerson"};
				_cameraTaketime = 5;
				_cameraMovementRate = 0;
				_newCameraPos = (actor modelToWorld [0.05, 0.2, 0]);
				indiCam attachTo [actor, [0.05, 0.2, 0], "RightHand"];
				_logicTarget = createVehicle ["ModuleEmpty_F", getPos actor, [], 0, "NONE"];
				_logicTarget attachTo [actor, [0, 2, 1.5]];
				_cameraTarget = _logicTarget;
				_newFov = 1;
				_maxDistance = 1000;
				_ignoreActorHidden = false;
				_detachCamera = false;
			}; // end of case
			
			case "birdPerson": {
				if (indiCamDebug) then {systemChat "case is top-down"};
				//detach indiCam;
				_cameraTaketime = 10;
				_cameraMovementRate = 10;
				_newCameraPos = (actor modelToWorld [0,-50,200]);
				_cameraTarget = actor;
				_newFov = 0.075;
				_ignoreActorHidden = false;
				_detachCamera = true;
			}; // end of case
			
		}; // end of switch
			
	}; // End of high actionValue scenes
	
}; // End of actor on foot scenes





comment "-------------------------------------------------------------------------------------------";
comment "								actor in land vehicles										";
comment "-------------------------------------------------------------------------------------------";

if (vicValue == 1) then { // All non-standard scenes go in here
	if (indiCamDebug) then {systemChat "car scenes"};

	_newScene = selectRandom [
								"thirdCar",
								"wheelCamCar",
								"windShieldCamCar",
								"randomWideFocusCar",
								"satelliteCarStill",
								"closeupCar",
								"topDownCar",
								"farZoomCar"
							];

	switch (_newScene) do {

		case "thirdCar": {
			if (indiCamDebug) then {systemChat "case is third person view"};
			_cameraTaketime = 10;
			_cameraMovementRate = 0;
			//_newCameraPos = (actor modelToWorld [5,-1,10]);
			_logicTarget = createVehicle ["ModuleEmpty_F", getPos actor, [], 0, "NONE"];
			_logicTarget attachTo [(vehicle actor), [0, 20, 1.8]]; 
			_cameraTarget = _logicTarget;
			_posX = selectRandom [-2,2];
			_posY = -10;
			_posZ = 1;
			indiCam attachTo [(vehicle actor), [_posX, _posY, _posZ]];
			_newFov = 0.5;
			_maxDistance = 1000;
			_ignoreActorHidden = true;
			_detachCamera = false;
		}; // end of case

		case "wheelCamCar": {
			if (indiCamDebug) then {systemChat "case is wheel cam"};
			_cameraTaketime = 10;
			_cameraMovementRate = 0;
			//_newCameraPos = (actor modelToWorld [5,-1,10]);
			_logicTarget = createVehicle ["ModuleEmpty_F", getPos actor, [], 0, "NONE"];
			_logicTarget attachTo [(vehicle actor), [0, 20, 1]]; 
			_cameraTarget = _logicTarget;
			_posX = selectRandom [-2,2];
			_posY = -0.8;
			_posZ = -0.7;
			indiCam attachTo [(vehicle actor), [_posX, _posY, _posZ]];
			_newFov = 1,2;
			_maxDistance = 1000;
			_ignoreActorHidden = true;
			_detachCamera = false;
		}; // end of case

		case "windShieldCamCar": {
			if (indiCamDebug) then {systemChat "case is windshieldcam"};
			_cameraTaketime = 10;
			_cameraMovementRate = 0;
			//_newCameraPos = (actor modelToWorld [5,-1,10]);
			_logicTarget = createVehicle ["ModuleEmpty_F", getPos actor, [], 0, "NONE"];
			_logicTarget attachTo [(vehicle actor), [0, 20, 1]]; 
			_cameraTarget = actor;
			_posX = random [-1,0,1];
			_posY = 5;
			_posZ = 2;
			indiCam attachTo [(vehicle actor), [_posX, _posY, _posZ]];
			_newFov = 1.1;
			_maxDistance = 1000;
			_ignoreActorHidden = true;
			_detachCamera = false;
		}; // end of case
		
		case "randomWideFocusCar": {
			if (indiCamDebug) then {systemChat "case is randomized wide shots"};
			//detach indiCam;
			_cameraTaketime = 10;
			_cameraMovementRate = 0;
			_cameraTarget = (vehicle actor);
			// Randomize the next position for camera around the actor
			_posX = random [-100,0,100];
			_posY = random [-275,0,275];
			_posZ = random [10,50,100];
			_newCameraPos = (actor modelToWorld [_posX,_posY,_posZ]);
			_newFov = (selectRandom [0.7,1,1.2]);
			_maxDistance = 1000;
			_ignoreActorHidden = false;
			_detachCamera = true;
		}; // end of case
		
		case "satelliteCarStill": {
			if (indiCamDebug) then {systemChat "case is satellite still"};
			//detach indiCam;
			_cameraTaketime = 10;
			_cameraMovementRate = 0;
			_newCameraPos = (actor modelToWorld [50,100,200]);
			_logicTarget = createVehicle ["ModuleEmpty_F", actor modelToWorld [0,50,0], [], 0, "NONE"];
			indiCam camSetTarget _logicTarget;
			_cameraTarget = _logicTarget;
			_newFov = 0.5;
			_maxDistance = 1000;
			_ignoreActorHidden = false;
			_detachCamera = true;
		}; // end of case
		
		case "closeupCar": {
			if (indiCamDebug) then {systemChat "case is randomized close quick shots"};
			//detach indiCam;
			_cameraTaketime = 10;
			_cameraMovementRate = 0;
			_cameraTarget = (vehicle actor);
			// Randomize the next position for camera around the actor
			_posX = random [-10,0,10];
			_posY = random [-2,0,10];
			_posZ = random [0.2,0.5,3];
			_newCameraPos = (actor modelToWorld [_posX,_posY,_posZ]);
			_newFov = (selectRandom [0.5,0.7,1.2]);
			_maxDistance = 1000;
			_ignoreActorHidden = false;
			_detachCamera = true;
		}; // end of case
			

		case "topDownCar": {
			if (indiCamDebug) then {systemChat "case is top-down view"};
			_cameraTaketime = 10;
			_cameraMovementRate = 0;
			_cameraTarget = (vehicle actor);
			_posX = random [-25,0,25];
			_posY = random [-50,-25,-1];
			_posZ = selectRandom [50,75,100];
			_newCameraPos = (actor modelToWorld [_posX,_posY,_posZ]);
			_newFov = (random [0.7,0.85,1]);
			_maxDistance = 600;
			_ignoreActorHidden = true;
			_detachCamera = true;
		}; // end of case
		
		case "farZoomCar": {
			if (indiCamDebug) then {systemChat "case is far off telezoom"};
			_cameraTaketime = 10;
			_cameraMovementRate = 0;
			_cameraTarget = (vehicle actor);
			_posX = selectRandom [-300,300,-200,200];
			_posY = selectRandom [-300,300,-200,200];
			_posZ = selectRandom [50,75,100];
			_newCameraPos = (actor modelToWorld [_posX,_posY,_posZ]);
			_newFov = (random [0.05,0.10,0.15]);
			_maxDistance = 600;
			_ignoreActorHidden = true;
			_detachCamera = true;
		}; // end of case
		
	}; // end of switch

}; // End of car scenes




comment "-------------------------------------------------------------------------------------------";
comment "								actor in aircraft											";
comment "-------------------------------------------------------------------------------------------";

if (vicValue == 2) then { // All non-standard scenes go in here



comment "-------------------------------------------------------------------------------------------";
comment "									landing / takeoff scenes								";
comment "-------------------------------------------------------------------------------------------";


	if ((getPos actor select 2) < 5) then {
	if (indiCamDebug) then {systemChat "low altitude aircraft scenes"};

		_newScene = selectRandom 	[
									"landingGearRear",
									"landingGearFront",
									"landingWideFocusAir", // Extra probability, remove this
									"landingWideFocusAir", // Extra probability, remove this
									"landingWideFocusAir", // Extra probability, remove this
									"landingWideFocusAir", // Extra probability, remove this
									"landingWideFocusAir",
									"landingZoomAir",
									"topDownAir"
									];

		switch (_newScene) do {

			case "landingGearRear": {
				if (indiCamDebug) then {systemChat "case is landing gear view"};
				_cameraTaketime = 8;
				_cameraMovementRate = 0;
				_logicTarget = createVehicle ["ModuleEmpty_F", getPos actor, [], 0, "NONE"];
				_logicTarget attachTo [(vehicle actor), [0,10,-2]];
				_cameraTarget = _logicTarget;
				indiCam attachTo [(vehicle actor), [selectRandom [-2,2],-10,-0.5]];
				_newFov = 0.1;
				_maxDistance = 1000;
				_ignoreActorHidden = true;
				_detachCamera = false;
			}; // end of case
			
			case "landingGearFront": {
				if (indiCamDebug) then {systemChat "case is landing gear view"};
				_cameraTaketime = 5;
				_cameraMovementRate = 0;
				_logicTarget = createVehicle ["ModuleEmpty_F", getPos actor, [], 0, "NONE"];
				_logicTarget attachTo [(vehicle actor), [0,-5,-2]];
				_cameraTarget = _logicTarget;
				indiCam attachTo [(vehicle actor), [selectRandom [-2,2],10,-0.5]];
				_newFov = 0.1;
				_maxDistance = 1000;
				_ignoreActorHidden = true;
				_detachCamera = false;
			}; // end of case
			
			case "landingWideFocusAir": {
				if (indiCamDebug) then {systemChat "case is randomized wide shots"};
				_cameraTaketime = 10;
				_cameraMovementRate = 0;
				_cameraTarget = (vehicle actor);
				_posX = selectRandom [10,-10];
				_posY = selectRandom [random [-15,-10,-5],random [5,10,15]];
				_posZ = 1;
				_newCameraPos = (actor modelToWorld [_posX,_posY,_posZ]);
				_newCameraPos = [_newCameraPos select 0,_newCameraPos select 1,1.8]; // ugly quick fix
				_newFov = (random [0.7,1,1.2]);
				_maxDistance = 400;
				_ignoreActorHidden = true;
				_detachCamera = true;
			}; // end of case
			
			case "topDownAir": {
				if (indiCamDebug) then {systemChat "case is top-down view"};
				_cameraTaketime = 10;
				_cameraMovementRate = 0;
				_cameraTarget = (vehicle actor);
				_posX = random [-25,0,25];
				_posY = random [-25,0,25];
				_posZ = selectRandom [50,75,100];
				_newCameraPos = (actor modelToWorld [_posX,_posY,_posZ]);
				_newFov = (random [0.7,0.85,1]);
				_maxDistance = 600;
				_ignoreActorHidden = true;
				_detachCamera = true;
			}; // end of case
			
			case "landingZoomAir": {
				if (indiCamDebug) then {systemChat "case is landing telezoom"};
				_cameraTaketime = 10;
				_cameraMovementRate = 0;
				_cameraTarget = (vehicle actor);
				_posX = selectRandom [-300,300,-200,200];
				_posY = selectRandom [-300,300,-200,200];
				_posZ = selectRandom [50,75,100];
				_newCameraPos = (actor modelToWorld [_posX,_posY,_posZ]);
				_newFov = (random [0.05,0.10,0.15]);
				_maxDistance = 600;
				_ignoreActorHidden = true;
				_detachCamera = true;
			}; // end of case
			
		}; // end of switch

	}; // End of landing / takeoff scenes



comment "-------------------------------------------------------------------------------------------";
comment "									low altitude scenes										";
comment "-------------------------------------------------------------------------------------------";


	if (((getPos actor select 2) >= 5) && ((getPos actor select 2) < 100)) then {
	if (indiCamDebug) then {systemChat "low altitude aircraft scenes"};

		_newScene = selectRandom 	[
									"thirdAir", // Jittery on AI
									"randomWideFocusAir", // OK
									"closeupAir", //OK
									"frontalAir", // OK
									"sideFollowAir" // Jitter on AI
									];

		switch (_newScene) do {

			case "thirdAir": {
				if (indiCamDebug) then {systemChat "case is third person view"};
				_cameraTaketime = 15;
				_cameraMovementRate = 0;
				_logicTarget = createVehicle ["ModuleEmpty_F", getPos actor, [], 0, "NONE"];
				_logicTarget attachTo [(vehicle actor), [0.30, 20, 1.8]]; 
				_cameraTarget = _logicTarget;
				indiCam attachTo [(vehicle actor), [selectRandom [-5,5], -5, 1]];
				_newFov = 0.85;
				_maxDistance = 1000;
				_ignoreActorHidden = true;
				_detachCamera = false;
			}; // end of case
			
			case "sideFollowAir": {
				if (indiCamDebug) then {systemChat "case is side follow view"};
				_cameraTaketime = 10;
				_cameraMovementRate = 0;
				_logicTarget = createVehicle ["ModuleEmpty_F", getPos actor, [], 0, "NONE"];
				_logicTarget attachTo [(vehicle actor), [0, 5, 0]]; 
				_cameraTarget = _logicTarget;
				indiCam attachTo [(vehicle actor), [selectRandom [-15,15],0,0]];
				_newFov = 0.85;
				_maxDistance = 1000;
				_ignoreActorHidden = true;
				_detachCamera = false;
			}; // end of case

			case "randomWideFocusAir": {
				if (indiCamDebug) then {systemChat "case is randomized wide shots"};
				_cameraTaketime = 10;
				_cameraMovementRate = 0;
				_cameraTarget = (vehicle actor);
				_posX = selectRandom [75,-10];
				_posY = selectRandom [-5,5,-10,10];
				_posZ = selectRandom [-3,random [3,10,30]];
				_newCameraPos = (actor modelToWorld [_posX,_posY,_posZ]);
				_newFov = (random [0.7,1,1.2]);
				_maxDistance = 400;
				_ignoreActorHidden = true;
				_detachCamera = true;
			}; // end of case

			case "closeupAir": {
				if (indiCamDebug) then {systemChat "case is randomized close quick shots"};
				_cameraTaketime = 5;
				_cameraMovementRate = 0;
				_cameraTarget = (vehicle actor);
				_posX = selectRandom [-50,50];
				_posY = selectRandom [random [-100,-50,-10],random [10,50,100]];
				_posZ = random [5,10,20];
				_newCameraPos = ((vehicle actor) modelToWorld [_posX,_posY,_posZ]);
				_newFov = (random [0.7,0.8,0.9]);
				_maxDistance = 300;
				_ignoreActorHidden = true;
				_detachCamera = true;
			}; // end of case
			
			case "frontalAir": {
				if (indiCamDebug) then {systemChat "case is frontal view"};
				_cameraTaketime = 15;
				_cameraMovementRate = 0;
				_cameraTarget = (vehicle actor);
				_posX = random [-5,0,5];
				_posY = selectRandom [100,150,200];
				_posZ = random [1,6,20];
				_newCameraPos = ((vehicle actor) modelToWorld [_posX,_posY,_posZ]);
				_newFov = (random [0.1,0.3,0.5]);
				_maxDistance = 600;
				_ignoreActorHidden = true;
				_detachCamera = true;
			}; // end of case
			
		}; // end of switch

	}; // End of low-altitude scenes
		
comment "-------------------------------------------------------------------------------------------";
comment "									medium altitude scenes										";
comment "-------------------------------------------------------------------------------------------";

	if (((getPos actor select 2) >= 100) && ((getPos actor select 2) < 300)) then {
	if (indiCamDebug) then {systemChat "medium altitude aircraft scenes"};

		_newScene = selectRandom 	[
									"thirdAir", // Not so jittery with AI
									"randomWideFomcusAir",
									"closeupAir",
									"frontalAir",
									"sideFollowAir", // Very jittery with AI
									"topDownAir",
									"downLowZoomAir"
									];

		switch (_newScene) do {

			case "thirdAir": {
				if (indiCamDebug) then {systemChat "case is third person view"};
				_cameraTaketime = 15;
				_cameraMovementRate = 0;
				_logicTarget = createVehicle ["ModuleEmpty_F", getPos actor, [], 0, "NONE"];
				_logicTarget attachTo [(vehicle actor), [0.30, 40, 1.8]]; 
				_cameraTarget = _logicTarget;
				indiCam attachTo [(vehicle actor), [selectRandom [-8,8], -10, 1]];
				_newFov = 0.95;
				_maxDistance = 1000;
				_ignoreActorHidden = true;
				_detachCamera = false;
			}; // end of case
			
			case "sideFollowAir": {
				if (indiCamDebug) then {systemChat "case is side follow view"};
				_cameraTaketime = 10;
				_cameraMovementRate = 0;
				_logicTarget = createVehicle ["ModuleEmpty_F", getPos actor, [], 0, "NONE"];
				_logicTarget attachTo [(vehicle actor), [0, 5, 0]]; 
				_cameraTarget = _logicTarget;
				indiCam attachTo [(vehicle actor), [selectRandom [-40,40],0,0]];
				_newFov = 0.85;
				_maxDistance = 1000;
				_ignoreActorHidden = true;
				_detachCamera = false;
			}; // end of case

			case "randomWideFocusAir": {
				if (indiCamDebug) then {systemChat "case is randomized wide shots"};
				_cameraTaketime = 10;
				_cameraMovementRate = 0;
				_cameraTarget = (vehicle actor);
				_posX = selectRandom [75,-10];
				_posY = random [-10,50,150];
				_posZ = selectRandom [-3,random [3,10,30]];
				_newCameraPos = (actor modelToWorld [_posX,_posY,_posZ]);
				_newFov = (random [0.4,0.6,0.8]);
				_maxDistance = 400;
				_ignoreActorHidden = true;
				_detachCamera = true;
			}; // end of case

			case "closeupAir": {
				if (indiCamDebug) then {systemChat "case is randomized close quick shots"};
				_cameraTaketime = 5;
				_cameraMovementRate = 0;
				_cameraTarget = (vehicle actor);
				_posX = selectRandom [-75,75,-50,50];
				_posY = selectRandom [random [-25,-15,-5],random [10,50,100]];
				_posZ = random [-50,0,50];
				_newCameraPos = ((vehicle actor) modelToWorld [_posX,_posY,_posZ]);
				_newFov = (random [0.1,0.3,0.5]);
				_maxDistance = 500;
				_ignoreActorHidden = true;
				_detachCamera = true;
			}; // end of case
			
			case "frontalAir": {
				if (indiCamDebug) then {systemChat "case is frontal view"};
				_cameraTaketime = 15;
				_cameraMovementRate = 0;
				_cameraTarget = (vehicle actor);
				_posX = random [-5,0,5];
				_posY = selectRandom [300,400,500];
				_posZ = random [-20,-10,-5];
				_newCameraPos = ((vehicle actor) modelToWorld [_posX,_posY,_posZ]);
				_newFov = (random [0.1,0.3,0.5]);
				_maxDistance = 600;
				_ignoreActorHidden = true;
				_detachCamera = true;
			}; // end of case
			
			case "topDownAir": {
				if (indiCamDebug) then {systemChat "case is top-down view"};
				_cameraTaketime = 10;
				_cameraMovementRate = 0;
				_cameraTarget = (vehicle actor);
				_posX = random [-50,0,50];
				_posY = random [100,150,200];
				_posZ = selectRandom [75,125,175];
				_newCameraPos = (actor modelToWorld [_posX,_posY,_posZ]);
				_newFov = (random [0.7,0.85,1]);
				_maxDistance = 600;
				_ignoreActorHidden = true;
				_detachCamera = true;
			}; // end of case
			
			case "downLowZoomAir": {
				if (indiCamDebug) then {systemChat "case is low with zoom"};
				_cameraTaketime = 10;
				_cameraMovementRate = 0;
				_cameraTarget = (vehicle actor);
				_posX = random [-200,0,200];
				_posY = random [-300,0,300];
				_posZ = 1;
				_newCameraPos = (actor modelToWorld [_posX,_posY,_posZ]);
				_newCameraPos = [_newCameraPos select 0,_newCameraPos select 1,1.8]; // ugly quick fix
				_newFov = (random [0.05,0.2,0.3]);
				_maxDistance = 600;
				_ignoreActorHidden = true;
				_detachCamera = true;
			}; // end of case
			
		}; // end of switch

	}; // End of medium-altitude scenes


comment "-------------------------------------------------------------------------------------------";
comment "									high altitude scenes									";
comment "-------------------------------------------------------------------------------------------";		
		
	if ((getPos actor select 2) >= 300) then {
	if (indiCamDebug) then {systemChat "high altitude aircraft scenes"};

		_newScene = selectRandom 	[
									"thirdAir",
									"randomWideFocusAir",
									"closeupAir",
									"frontalAir"
									];

		switch (_newScene) do {

			case "thirdAir": {
				if (indiCamDebug) then {systemChat "case is third person view"};
				_cameraTaketime = 15;
				_cameraMovementRate = 0;
				_logicTarget = createVehicle ["ModuleEmpty_F", getPos actor, [], 0, "NONE"];
				_logicTarget attachTo [(vehicle actor), [0, 12, 0]]; 
				_cameraTarget = _logicTarget;
				indiCam attachTo [(vehicle actor), [selectRandom [-2,2], -10, 13]];
				_newFov = 0.95;
				_maxDistance = 1000;
				_ignoreActorHidden = true;
				_detachCamera = false;
			}; // end of case
			
			case "randomWideFocusAir": {
				if (indiCamDebug) then {systemChat "case is randomized wide shots"};
				_cameraTaketime = 10;
				_cameraMovementRate = 0;
				_cameraTarget = (vehicle actor);
				_posX = selectRandom [75,-10];
				_posY = random [-10,50,150];
				_posZ = selectRandom [-3,random [3,10,30]];
				_newCameraPos = (actor modelToWorld [_posX,_posY,_posZ]);
				_newFov = (random [0.4,0.6,0.8]);
				_maxDistance = 400;
				_ignoreActorHidden = true;
				_detachCamera = true;
			}; // end of case

			case "closeupAir": {
				if (indiCamDebug) then {systemChat "case is randomized close quick shots"};
				_cameraTaketime = 10;
				_cameraMovementRate = 0;
				_cameraTarget = (vehicle actor);
				_posX = selectRandom [-100,100,-75,75,-50,50];
				_posY = selectRandom [random [-25,-15,-5],random [10,50,100]];
				_posZ = random [50,75,100];
				_newCameraPos = ((vehicle actor) modelToWorld [_posX,_posY,_posZ]);
				_newFov = (random [0.1,0.3,0.5]);
				_maxDistance = 500;
				_ignoreActorHidden = true;
				_detachCamera = true;
			}; // end of case
			
			case "frontalAir": {
				if (indiCamDebug) then {systemChat "case is frontal view"};
				_cameraTaketime = 15;
				_cameraMovementRate = 0;
				_cameraTarget = (vehicle actor);
				_posX = random [-5,0,5];
				_posY = selectRandom [300,400,500];
				_posZ = random [20,30,40];
				_newCameraPos = ((vehicle actor) modelToWorld [_posX,_posY,_posZ]);
				_newFov = (random [0.1,0.3,0.5]);
				_maxDistance = 600;
				_ignoreActorHidden = true;
				_detachCamera = true;
			}; // end of case
			
		}; // end of switch

	}; // End of high-altitude scenes		

}; // End of aircraft scenes


comment "-------------------------------------------------------------------------------------------";
comment "									return values											";
comment "-------------------------------------------------------------------------------------------";	

// Return the values

sceneSelector = [
_newCameraPos,			// This select 0	//	(sceneSelector select 0)
_newFov,				// This select 1	//	(sceneSelector select 1)
_cameraTarget,			// This select 2	//	(sceneSelector select 2)
_cameraTaketime,		// This select 3	//	(sceneSelector select 3)
_cameraMovementRate,	// This select 4	//	(sceneSelector select 4)
_maxDistance,			// This select 5	//	(sceneSelector select 5)
_ignoreActorHidden,		// This select 6	//	(sceneSelector select 6)
_detachCamera			// This select 7	//	(sceneSelector select 7)
];




sceneSelectorDone = true; // Here to support a waitUntil command
