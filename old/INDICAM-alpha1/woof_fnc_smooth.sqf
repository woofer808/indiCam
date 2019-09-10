comment "-------------------------------------------------------------------------------------------------------";
comment "																										";
comment "										Camera chasing actor											";
comment "																										";
comment "-------------------------------------------------------------------------------------------------------";
	
// [] execVM "INDICAM\woof_fnc_cameraMotion.sqf";

// [] execVM "INDICAM\woof_fnc_indiCam.sqf";
// removeAllActions player;
// actor = cursorTarget;



// Create and initialize the camera on the actor to get it started
indiCam = "camera" camCreate (getPos actor);
indiCam cameraEffect ["internal","back"];
camUseNVG false;
showCinemaBorder false;
indiCam camSetFov 1.3;
indiCam camSetTarget actor;


// Create a target with ModuleEmpty_F or Sign_Sphere100cm_F
logicTargetActor = createVehicle ["ModuleEmpty_F", actor modelToWorld [0,5,0], [], 0, "NONE"];
indiCam attachTo [logicTargetActor, [0,-1,2.2]];
while {loop} do {
//onEachFrame {
	_distance = logicTargetActor distance actor;
	_offsetVector = (getpos logicTargetActor) vectorFromTo (getPos actor);
	_offsetVector = _offsetVector vectorMultiply _distance*0.009;
	_offsetVector = (getpos logicTargetActor) vectorAdd _offsetVector;
	logicTargetActor setPos _offsetVector;
	indiCam camSetRelPos [0.3,-1,1.8];
	indiCam camCommit 0;
	sleep (1/60);
};

