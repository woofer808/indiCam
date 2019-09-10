




private [
		"_camera",
		"_newCameraPos",
		"_cameraDistance",
		"_currentCameraPos",
		"_currentCameraDir",
		"_newCameraDir",
		"_cameraMovementRate",
		"_newFov",
		"_cameraTakeTime",
		"_commitDuration"
		];



	// Setup of variables
	_currentCameraPos = [0,0,0];
	_currentCameraDir = 0;
	_newCameraPos = [0,0,0];
	_newCameraDir = 0;
	_cameraMovementRate = 1; // This value determines the speed of the camera over each distance
	_cameraTakeTime = 10; // First time to loop the camera take


	// Create the camera on the actor
	_camera = "camera" camCreate (getPos actor);
	_camera cameraEffect ["internal","back"];
	
	
	
	
	

	
	
	
	














	camUseNVG false;
	showCinemaBorder false;







	comment "Find out where the camera currently is and where it's pointing";
	_currentCameraPos = getPos _camera;
	_currentCameraDir = getDir _camera;




					systemChat "case is third person view";
					_cameraTakeTime = 10;
					_cameraMovementRate = 1;

					_newCameraPos = (actor modelToWorld [5,-1,10]);

					
					
					
					
					
					
					
					_emptyTarget = createVehicle ["ModuleEmpty_F", getPos actor, [], 0, "NONE"];
					_emptyTarget attachTo [actor, [0.20, 5, 1.8]]; 
					_camera camSetTarget _emptyTarget;
					_camera attachTo [actor, [0.20, -1, 1.8]];
					
					
					
					
					
					
					
					
					
					
					
					
					
					_newFov = 0.5;

					
					
					
						if ( (date select 3) < 4 || (date select 3) >= 20 ) then {camUseNVG true;} else {camUseNVG false;};

// Determine distance between new and old camera position
	_cameraDistance = _currentCameraPos distance _newCameraPos;
// Determine how long in seconds the camCommit needs to be
	_commitDuration = (_cameraDistance/_cameraMovementRate);

// Do the actual commit
	_camera camSetFov _newFov;
	_camera camSetPos _newCameraPos;
	_camera camCommit 0;

	
sleep 2;

camDestroy _camera;