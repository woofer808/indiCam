/*
 * Author: woofer
 * Make a unit follow a position, use in onEachFrame.
 * Uses FPS only as a divider of time for now. Would be nice to detect low FPS and mitigate that.
 *
 * Arguments:
 * 0: Unit <OBJECT>
 * 1: Target <OBJECT>
 * 2: Speed <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * [someUnit, player, 5] call indiCam_fnc_followLogicFPS
 *
 * Public: No
 */

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
		"_target",		// The target which the object is to follow
		"_speed"		// Range should be around 0.05 - 0.3. Lower value means the follow point moves lazier. Higher value will get jittery at higher vehicle speeds.
		];

//if (_speed == 0) then {_speed = 0.5}; // Prevents division by zero
		
// First find out where our object is located
_pos = getPosASL _object;

// Find the vector along which we want to move. Both direction and length in this one.
_vector = _pos vectorDiff _target;


// Then we decide on how far to move
_distance = vectorMagnitude _vector; // Get the length of the vector


if (_distance > 100000) then {

	// If _distance exceeds too high of a number during iterations, it will reset to 1. Not battle proven, but works for now.
	_distance = 1;
	if (indiCam_debug) then {systemChat "memory overflow in:\nindiCam_fnc_followLogicFPS\n\nwas prevented..."};
	indiCam_fnc_requestMode = "default";

	// The following two lines was the previous way to work around the memory overflow issue by stopping the camera
	// hintSilent "memory overflow in:\nindiCam_fnc_followLogicFPS\n\naborting...";
	// indiCam_var_requestMode	= "off";
	
	// I kind of want to let the system do a little of both. Try and fix it a few times and start/stop camera when it doesn't work.
	/* if (_iteration > 10) then {indiCam_var_requestMode = "default"};*/
	
	// Start/Stop would look like this:
	/*
	[] spawn {
		indiCam_var_requestMode	= "off";
		sleep 0.5;
		[] execVM "INDICAM\indiCam_core_main.sqf";
	};
	*/
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
