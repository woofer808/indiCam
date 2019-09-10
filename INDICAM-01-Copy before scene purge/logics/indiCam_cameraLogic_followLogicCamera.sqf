comment "-------------------------------------------------------------------------------------------------------";
comment "											indiCam, by woofer.											";
comment "																										";
comment "									indiCam_cameraLogic_followLogicCamera									";
comment "																										";
comment "	Activates and contiunally commits a camera in relation to the camera logic							";
comment "																										";
comment "	This script contains sleep and has to be spawned.													";
comment "	Arguments: [ cameraChaseSpeed ]																		";
comment "																										";
comment "-------------------------------------------------------------------------------------------------------";




comment "-------------------------------------------------------------------------------------------------------";
comment "	Arguments			 																				";
comment "-------------------------------------------------------------------------------------------------------";
private _relativePosition = _this select 0;
private _cameraChaseSpeed = (1 / (_this select 1));
private _cameraChaseDistance = _this select 2; // Determines how close the logic can come to the actor
comment "-------------------------------------------------------------------------------------------------------";



comment "-------------------------------------------------------------------------------------------------------";
comment "	Script control block 																				";
comment "-------------------------------------------------------------------------------------------------------";
// Hold on to the marbles until the script is let loose - or kill it if it won't be used.
// Basically I only want it to run when the scene change is happening in sceneCommit.
// It will not have to be held for long, only for the duration to evaluate the next scene.
indiCam_var_holdScript = true;
while {indiCam_var_holdScript} do {
	if (indiCam_var_exitScript || indiCam_var_runScript) then {indiCam_var_holdScript = false;};
	sleep 0.01;
};

if (indiCam_var_runScript) then { // if this script is terminated above, don't run this section

comment "-------------------------------------------------------------------------------------------------------";



comment "-------------------------------------------------------------------------------------------------------";
comment "	Game logic animation																				";
comment "-------------------------------------------------------------------------------------------------------";

	// The following creates a logic position for the camera
	[_relativePosition,_cameraChaseSpeed,_cameraChaseDistance] spawn {
	//indiCam_followLogic setPos indiCam_appliedVar_cameraPos;
		indiCam_indiCamLogicLoop = true;
		indiCam_followLogic setPos indiCam_appliedVar_cameraPos; // Move the logic to it's starting point
		while {indiCam_indiCamLogicLoop} do {
			_distanceCamera = indiCam_followLogic distance actor;
			if (_distanceCamera > (_this select 2)) then {
				_offsetVectorCamera = (getposASL indiCam_followLogic) vectorFromTo (getPosASL actor);
				_offsetVectorCamera = _offsetVectorCamera vectorMultiply _distanceCamera*(_this select 1);//_cameraChaseSpeed
				_offsetVectorCamera = (getposASL indiCam_followLogic) vectorAdd _offsetVectorCamera;
				indiCam_followLogic setPosASL _offsetVectorCamera;
			};
			
			indiCam camSetRelPos (_this select 0);
			indiCam camCommit 0;
			
			sleep (1/90);
		};
		
	};


};

comment "-------------------------------------------------------------------------------------------------------";
comment "	Script control block 																				";
comment "																										";
indiCam_var_exitScript = false; // Used for killing waiting logic scripts
comment "-------------------------------------------------------------------------------------------------------";

