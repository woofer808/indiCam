// [] execVM "INDICAM\smoothcam.sqf"

// The following creates a logic target for the target position if _target!=actor


// I might need to spawn the two points independently and have them be updated at all times


// I want to be able to move the targetpoint along certain paths, like a direction or a parabola to do dolly shots during a scene
// _targetPointStartPos
// _targetPointEndPos
// _targetPointMovementSpeed


private _cameraTaketime = 5;
private _cameraMovementRate = 0;
private _cameraTarget = actor;
private _newCameraPos = getPos actor;
private _newFov = 0.7;

private _maxDistance = 1000;
private _ignoreActorHidden = false;
private _detachCamera = true;


logicTarget = createVehicle ["Sign_Sphere25cm_F", actor modelToWorld [0,5,1], [], 0, "NONE"];




// Create and initialize the camera on the actor to get it started
indiCam = "camera" camCreate (getPos actor);
indiCam cameraEffect ["internal","back"];
camUseNVG false;
showCinemaBorder false;
indiCam camSetFov 1.3;
indiCam camSetTarget logicTarget;



// [] execVM "INDICAM\smoothcam.sqf"


indiCamLogicLoop = false;


// The following creates a logic position for the camera
[] spawn {
	// Sign_Sphere25cm_F or ModuleEmpty_F
	logicCamera = createVehicle ["Sign_Sphere25cm_F", actor modelToWorld [0,10,0], [], 0, "NONE"]; // This should be hidden or completely removed 
	indiCam attachTo [logicCamera, [0,-1,2.2]];
	indiCamLogicLoop = true;
	while {indiCamLogicLoop} do {

		_distanceCamera = logicCamera distance actor;
		_offsetVectorCamera = (getpos logicCamera) vectorFromTo (getPos actor);
		_offsetVectorCamera = _offsetVectorCamera vectorMultiply _distanceCamera*0.009;
		_offsetVectorCamera = (getpos logicCamera) vectorAdd _offsetVectorCamera;
		logicCamera setPos _offsetVectorCamera; // This is only for debug purposes
		indiCam camSetRelPos [0.3,-1,1.8]; // shouldn't just output a position rather than attaching the camera like this?
		indiCam camCommit 0;
		sleep (1/90);
	};
};






// The following creates a logic position for the camera target
[] spawn {
	//logicTarget = createVehicle ["Sign_Sphere25cm_F", actor modelToWorld [0,5,1], [], 0, "NONE"]; // This should be hidden or completely removed
	indiCamLogicLoop = true;
	while {indiCamLogicLoop} do {
		_logicTargetRelativePos = actor modelToWorld [0,5,1];
		_distanceTarget = logicTarget distance _logicTargetRelativePos;
		_offsetVectorTarget = (getpos logicTarget) vectorFromTo _logicTargetRelativePos;
		_offsetVectorTarget = _offsetVectorTarget vectorMultiply _distanceTarget*0.1;
		_offsetVectorTarget = (getpos logicTarget) vectorAdd _offsetVectorTarget;
		logicTarget setPos _offsetVectorTarget; // This is only for debug purposes
		sleep (1/90);
	};
};










