comment "-------------------------------------------------------------------------------------------------------";
comment "																										";
comment "										Camera chasing systemChat										";
comment "																										";
comment "-------------------------------------------------------------------------------------------------------";
	
// [] execVM "INDICAM\woof_fnc_cameraMotion.sqf";

actor = attacker;

private [
			"_cameraTarget",
			"_logicTargetActor",
			"_logicTargetCamera",
			"_cameraPos",
			"_cameraFov"		
		];

_cameraTarget = actor;
_cameraPos = getPos actor;
_cameraFov = 0.74;
		
private _cameraCycleTime = 2; // The time for each camera loop cycle and commit time


// Create a target with ModuleEmpty_F or Sign_Sphere100cm_F
_logicTargetActor = createVehicle ["Sign_Sphere100cm_F", getPos actor, [], 0, "NONE"];



// Create and initialize the camera on the actor to get it started
indiCam = "camera" camCreate (getPos actor);
indiCam cameraEffect ["internal","back"];
indiCam camSetTarget (getPos _logicTargetActor);
camUseNVG false;
showCinemaBorder false;
indiCam camCommand "inertia on";
detach indiCam;

// Prepare camera before committing it
indiCam camPrepareTarget (getPos _logicTargetActor);
indiCam camPreparePos _cameraPos;
indiCam camPrepareFov _cameraFov;

// Do the actual commit
// waitUntil {camPreloaded indiCam};
indiCam camCommitPrepared 0;





comment "I'm going to need two empties";
comment "One that guides the camera targeting and one that is attached to the actor providing new camer positions";




while {true} do {

	// Calculate the necessary time for the commit using distance. That will move the camera fast enough to catch up with the target.
	_logicTargetMoveDistance = _logicTargetActor distance actor; // how far the actor have moved from the previous logicTarget
	_cameraSpeed = _logicTargetMoveDistance / _cameraCycleTime;
	


	// Prepare camera before committing it
	indiCam camPrepareTarget (getPos _logicTargetActor); // Only aim the camera at a position, don't get stuck on the actual target.
	indiCam camPreparePos (getPos _logicTargetCamera);
	indiCam camPrepareFov _cameraFov;

	// Do the actual commit
	// waitUntil {camPreloaded indiCam};
	indiCam camCommitPrepared (_cameraSpeed * 2); // Commit time should be (slightly?) longer than the loop cycle
	
	_logicTargetActor setpos (getPos actor);
	
	sleep _cameraCycleTime;
	
}; // End of main loop




