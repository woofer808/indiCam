/*
 * Author: woofer
 * Animates a logic around a target from random point to random point.
 * Currently uses a half period sinusoidal movement pattern along each distance.
 *
 * Arguments:
 * 0: X Distance <NUMBER>
 * 1: Y Distance <NUMBER>
 * 2: Z Distance <NUMBER>
 * 3: Speed <NUMBER>
 * 4: Proximity <NUMBER>
 * 5: Target <OBJECT>
 *
 * Reutrn Value:
 * None
 *
 * Example:
 * [10, 10, 0, 50, 0.5, actor] spawn indicam_cameraLogic_fnc_randomLinear
 *
 * Public: No
 */


// Needs to be fixed so that target can accept a point in space rather than an object (or both).

/* ----------------------------------------------------------------------------------------------------
								Arguments
   ---------------------------------------------------------------------------------------------------- */

//[_xDistance,yDistance,zheight,speed,proximity,target]
params	[ // Params is pretty clever. Privatizes vars while also assigning both the (_this select x) and a default value
		["_posX", 10], 		// Relative x-distance from target, Assumes 10 if no argument was passed.
		["_posY", 10], 		// Relative y-distance from target, Assumes 10 if no argument was passed.
		["_posZ", 0], 		// Relative y-distance from target, Assumes 10 if no argument was passed.
		["_speed", 50], 	// Overall speed. Should be kept between maybe 30 and 100.
		["_proximity", 0.5],// Dictates how close the movement logic can get to each point before a new one is generated.
		["_target",actor]	// Defines the target to use as zero point to generate movement around. Assumes actor if no object was passed.
		];

private [ // No need to use private when params exist really, but to keep them apart we'll go like this for now
		"_startingPoint",
		"_endingPoint",
		"_currentPoint",
		"_newPoint",
		"_movingVector",
		"_startingDistance",
		"_distance"
		];

/* ----------------------------------------------------------------------------------------------------
									Script control block
   ---------------------------------------------------------------------------------------------------- */
// Hold on to the marbles until the script is let loose - or kill it if it won't be used.
// Basically I only want it to run when the scene change is happening in sceneCommit.
// It will not have to be held for long, only for the duration to evaluate the next scene.
indiCam_var_holdScript = true;
while {indiCam_var_holdScript} do {
	if (indiCam_var_exitScript || indiCam_var_runScript) then {indiCam_var_holdScript = false;};
	sleep 0.01;
};

if (indiCam_var_runScript) then { // if the script is terminated, don't run this section
	/* ----------------------------------------------------------------------------------------------------
										Game logic animation
	---------------------------------------------------------------------------------------------------- */

	// Set a starting point for the logic to move toward
	_startingPoint = _target modelToWorld [random [-_posX,0,_posX],random [-_posY,0,_posY],random [-_posZ,0,_posZ]];
	_currentPoint = _startingPoint;
	_newPoint = _startingPoint;
	_movingVector = 0;

	indiCam_indiCamLogicLoop = true;
	while {indiCam_indiCamLogicLoop} do {
		_endingPoint = _target modelToWorld [random [-_posX,0,_posX],random [-_posY,0,_posY],random [-_posZ,0,_posZ]];

		_startingDistance = _startingPoint distance _endingPoint;
		_distance = 20;

		indiCam_linearLogic setPos _startingPoint;
		while {(_distance) > _proximity} do {
			_distanceVector = _currentPoint vectorFromTo _endingPoint; // Determine the vector between the two points
			_distance = _currentPoint distance _endingPoint; // Get the actual length of the vector
			
			_speedModifier = (sin (_distance * (180 / _startingDistance)))+0.05;
			if (_speedModifier < 0.03) then {_speedModifier = 0.03};
			
			_movingVector = _distanceVector vectorMultiply (1/_speed)*_distance*_speedModifier; // Cut the vector to this cycle's movement
			_newPoint = _currentPoint vectorAdd _movingVector; // Add this cycles movment vector to the current point to get the new position

			indiCam_linearLogic setPos _newPoint; // Set the position of the logic
			_currentPoint = _newPoint; // Promote the current point now that the new point has been utilized

			sleep (1/90); // Update frequency of the logic movement cycle
		};
		_currentPoint = _newPoint;
		_startingPoint = _currentPoint;
	};
};

indiCam_var_exitScript = false; // Used for killing waiting logic scripts
