comment "-------------------------------------------------------------------------------------------------------";
comment "											indiCam, by woofer.											";
comment "																										";
comment "									indiCam_fnc_followLogicTurretAim									";
comment "																										";
comment "																										";
comment "	Call this function using a stackable eventhandler onEachFrame to make an object follow a position.	";
comment "	Uses FPS only as a divider of time for now. Would be nice to detect low FPS and mitigate that.		";
comment "																										";
comment "	Params: [ _object, _target _speed ]																	";
comment "																										";
comment "-------------------------------------------------------------------------------------------------------";
// Result: 0.0431 ms
// Cycles: 10000/10000

/*
indiCam_var_ball = createVehicle ["Sign_Sphere25cm_F", (player modelToWorld [0,5,1]), [], 0, "CAN_COLLIDE"];
["indiCam_id_ballVelocity", "onEachFrame", {[indiCam_var_ball,(player modelToWorld [0,5,1]),1] call indiCam_fnc_followLogicFPS}] call BIS_fnc_addStackedEventHandler;

["indiCam_id_ballTarget", "onEachFrame", {}] call BIS_fnc_addStackedEventHandler; 
["indiCam_id_ballCamera", "onEachFrame", {}] call BIS_fnc_addStackedEventHandler;

["indiCam_id_logicTarget", "onEachFrame"] call BIS_fnc_removeStackedEventHandler;
["indiCam_id_logicCamera", "onEachFrame"] call BIS_fnc_removeStackedEventHandler;
*/

params [
		"_object",		// The object that is to be moved
		"_target",		// The relative target which the object is to follow
		"_speed"		// Range should be around 0.05 - 0.3. Lower value means the follow point moves lazier. Higher value will get jittery at higher vehicle speeds.
		];

//if (_speed == 0) then {_speed = 0.5}; // Prevents division by zero










/*

So, we're inputting a position that we want fixed in relation to turret movement


We achieve this by determining a vector from the base of the barrel and always adding that, so basically, just add [x,y,z] to the base point

*/





// First we find the start and end points of our barrel
private _barrelStart = (vehicle indiCam_actor) selectionPosition "konec hlavne";
private _barrelEnd = (vehicle indiCam_actor) selectionPosition "usti hlavne";  
_barrelStart = (vehicle indiCam_actor) modelToWorldWorld _barrelStart; 
_barrelEnd = (vehicle indiCam_actor) modelToWorldWorld _barrelEnd; 

// Get a unit vector from the base to the business end
private _weaponDirection = _barrelStart vectorFromTo _barrelEnd;

// Make a vector with desired length based on the y-value passed
private _weaponVector = _weaponDirection vectorMultiply (_target select 1);


// Get the vector point 
private _weaponVectorPoint = _barrelStart vectorAdd _weaponVector;

// Elevate the point a little and let that be the target point for the game proxy object
_targetPoint = _weaponVectorPoint vectorAdd [0,0,(_target select 2)];


// First find out where our object is located
_pos = getPosASL _object;

// Find the vector along which we want to move. Both direction and length in this one.
_vector = _pos vectorDiff _targetPoint;


// Then we decide on how far to move
_distance = vectorMagnitude _vector;			// Get the length of the vector


if (_distance > 100000) then {

	// If _distance exceeds too high of a number during iterations, it will reset to 1. Not battle tested, but works for now.
	_distance = 1;
	if (indiCam_debug) then {systemChat "memory overflow in:\indiCam_fnc_followLogicTurretAim\n\nwas prevented..."};

	// The following two lines was the previous way to work around the memory overflow issue by stopping the camera
	// hintSilent "memory overflow in:\indiCam_fnc_followLogicTurretAim\n\naborting...";
	// indiCam_var_requestMode	= "off";
};


_speedModifier = (-1 * _speed * _distance^(1.8 + _speed) );	// Speed will increase by function of a second degree polynomial with distance from target. _speed 0.3 resembles x^2.
_fps = diag_fps;								// Get the current mean fps
_frameDist = _speedModifier * (1 / _fps);		// This is how far we move each frame


//systemChat format ["_distance: %1, _frameDist: %2",_distance,_frameDist];


// Get the movement direction and multiply by how far to move the object
_velocityVector = (vectorNormalized _vector) vectorMultiply _frameDist;

// Find the new position by adding the _velocityVector to the current pos
_newPos = _pos vectorAdd _velocityVector;

// Move the object one _frameDistance in the direction of _velocityVector
_object setPosASL _newPos;
