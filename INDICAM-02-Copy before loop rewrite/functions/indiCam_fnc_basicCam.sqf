comment "-------------------------------------------------------------------------------------------------------";
comment "											indiCam, by woofer.											";
comment "																										";
comment "										  indiCam_fnc_basicCam											";
comment "																										";
comment "																										";
comment "	This is the most basic EH-based logic camera for indiCam.										 	";
comment "	Moves the logic and camera once every frame. Can be a problem on servers with low fps.				";
comment "																										";
comment "																										";
comment "	Params: [																							";
comment "			_object		(the object the camera is to follow)											";
comment "			_cameraPos	(relative camera position from object)											";
comment "			_targetPos	(point relative to object that the camera is to track)							";
comment "			_speed		(value between about 0.1 and 1, speed curve is a second degree polynomial)		";
comment "	 		]																							";
comment "																										";
comment "-------------------------------------------------------------------------------------------------------";
/* some copypasta to start with

[player,[3,-10,3],[0,1,1],0.5] execVM "INDICAM\functions\indiCam_fnc_basicCam.sqf";

[player,[3,-10,3],[0,1,1],0.5] execVM "indiCam_fnc_basicCam.sqf";

*/


indiCam_fnc_basicCamEH = {

	params [
			"_object",		// The object that is to be moved
			"_target",		// The target which the object is to follow
			"_speed"		// The speed of the object as a function of distance from the target speed*distance^2
			];
			
	// First find out where our object is located
	_pos = getPosASL _object;

	// Find the vector along which we want to move. Both direction and length in this one.
	_vector = _pos vectorDiff _target;

	// Then we decide on how far to move
	_distance = vectorMagnitude _vector;			// Get the length of the vector
	_speedModifier = (-1 * _speed * _distance^2);	// Speed will increase by function of a second degree polynomial with distance from target
	_fps = diag_fps;								// Get the current mean fps
	_frameDist = _speedModifier * (1 / _fps);		// This is how far we move each frame

	// Get the movement direction and multiply by how far to move the object
	_velocityVector = (vectorNormalized _vector) vectorMultiply _frameDist;

	// Find the new position by adding the _velocityVector to the current pos
	_newPos = _pos vectorAdd _velocityVector;

	// Move the object one _frameDistance in the direction of _velocityVector
	_object setPosASL _newPos;

};

private _object = player;
private _cameraPos = [3,-10,3];
private _targetPos = [0,1,1];
private _speed = 0.5;


params [
		"_object",
		"_cameraPos",
		"_targetPos",
		"_speed"
		];

indiCam_object = _object;
indiCam_cameraPos = _cameraPos;
indiCam_targetPos = _targetPos;
indiCam_speed = _speed;

indiCam_var_basicCamTarget = createVehicle ["ModuleEmpty_F",(indiCam_object modelToWorldWorld indiCam_targetPos), [], 0, "CAN_COLLIDE"];


indiCam = "camera" camCreate (indiCam_object modelToWorldWorld _cameraPos);
indiCam cameraEffect ["internal","back"];
camUseNVG false;
showCinemaBorder false;
indiCam camCommand "inertia on";
indiCam camSetTarget indiCam_var_basicCamTarget;
indiCam camSetFov 0.4;
indiCam camCommit 0;

["indiCam_id_basicCamTarget", "onEachFrame", {[indiCam_var_basicCamTarget,(indiCam_object modelToWorldWorld indiCam_targetPos),indiCam_speed] call indiCam_fnc_basicCamEH}] call BIS_fnc_addStackedEventHandler;
["indiCam_id_basicCamCamera", "onEachFrame", {[indiCam,(indiCam_object modelToWorldWorld indiCam_cameraPos),indiCam_speed] call indiCam_fnc_basicCamEH}] call BIS_fnc_addStackedEventHandler;


