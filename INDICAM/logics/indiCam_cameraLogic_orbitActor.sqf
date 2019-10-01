/*
 * Author: woofer
 * Tests if there is line of sight between the camera and ther target object.
 * Camera Target: indiCam_centerLogic
 * Camera Attach: indiCam_orbitLogic
 *
 * Arguments:
 * 0: Radius <NUMBER>
 * 1: Height AGL <NUMBER>
 * 2: Chase Speed <NUMBER>
 * 3: Rotation Speed <NUMBER>
 *
 * Return Value:
 * Visible <BOOL>
 *
 * Example:
 * [15, 10, 10, 5] spawn indicam_cameraLogic_fnc_orbitActor
 *
 * Public: No
 */

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

if (indiCam_var_runScript) then { // if this script is terminated, don't run this section
	// Pull the values passed to the function
	private _radius = (_this select 0);
	private _altitude = (((getposASL actor) select 2) + (_this select 1));
	private _logicChaseSpeed = (1 / (_this select 2)); // recalculate from values around 100
	private _logicRotationSpeed = (_this select 3);

	// These are constant, could be changed to global
	private _updateFrequency = (1/90);

	// Start the logic off in a random direction from the actor
	private _currentAngle = random 360;

/* ----------------------------------------------------------------------------------------------------
								Game logic animation
   ---------------------------------------------------------------------------------------------------- */

	// Create the first game logic that the second game logic can rotate around
	// Doing it this way instead of rotating around the actual actor unit will make it way less jittery
	[_logicChaseSpeed,_updateFrequency] spawn {

		
		indiCam_indiCamLogicLoop = true;
		indiCam_centerLogic setPos indiCam_appliedVar_cameraPos; // Move the logic close to it's starting point
		while {indiCam_indiCamLogicLoop} do {
			_distanceCamera = indiCam_centerLogic distance actor;
			if (_distanceCamera > 1) then { // Only try to shorten the distance if the logic is farther than this distance
				_offsetVectorCamera = (getpos indiCam_centerLogic) vectorFromTo (getPos actor);
				_offsetVectorCamera = _offsetVectorCamera vectorMultiply _distanceCamera*(_this select 0);
				_offsetVectorCamera = (getpos indiCam_centerLogic) vectorAdd _offsetVectorCamera;
				indiCam_centerLogic setPos _offsetVectorCamera; // This is only for debug purposes
			};
			sleep (_this select 1);
		};
		
	};

	// Setup the loop that actually animates the rotation logic
	[_radius,_altitude,_logicChaseSpeed,_updateFrequency,_logicRotationSpeed] spawn {
		private _currentAngle = random 360;
		private _angleDelta = (_this select 4);
		
		
		
		indiCam_indiCamLogicLoop = true;
		indiCam_orbitLogic setPosASL indiCam_appliedVar_cameraPos; // Move the logic close to it's starting point
		while {indiCam_indiCamLogicLoop} do {

			_angleDelta = (_this select 4); // Peripheral velocity: v=2*pi*R*freq (but I use this in a bullshit way - too tired now)
			_currentAngle = _currentAngle + _angleDelta;
			_newVector = 	[
							cos _currentAngle,
							sin _currentAngle,
							0
						];
			//_newVector = ATLToASL _newVector; // I got screwed on this too - fix so that it isn't following AGL
			_newVector = _newVector vectorMultiply (_this select 0);
			_newPos = (getPosASL indiCam_centerLogic) vectorAdd [(_newVector select 0), (_newVector select 1), (_this select 1)];
			//indiCam setPos _newPos;
			indiCam_orbitLogic setPosASL _newPos;
			sleep (_this select 3);
		};
		
	};
};

indiCam_var_exitScript = false; // Used for killing waiting logic scripts
