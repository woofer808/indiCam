comment "-------------------------------------------------------------------------------------------------------";
comment "											indiCam, by woofer.											";
comment "																										";
comment "											indiCam_cameraLogic_orbit									";
comment "																										";
comment "	Makes the indiCam_logicA orbit a position AGL according to passed arguments							";
comment "	arguments: [ radius , heightAGL , chaseSpeed , rotationSpeed ] 																						";
comment "	camera target: indiCam_orbitLogic						 										";
comment "																										";
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

if (indiCam_var_runScript) then { // if this script is terminated, don't run this
comment "-------------------------------------------------------------------------------------------------------";


	// Pull the values passed to the function
	private _radius = (_this select 0);
	private _altitude = (((getpos actor) select 2) + (_this select 1));
	private _logicChaseSpeed = (1 / (_this select 2)); // recalculate from values around 100
	private _logicRotationSpeed = (_this select 3);

	// These are constant, could be changed to global
	private _updateFrequency = (1/90);

	// Start the logic off in a random direction from the actor
	private _currentAngle = random 360;

	
	

comment "-------------------------------------------------------------------------------------------------------";
comment "	Game logic animation																				";
comment "-------------------------------------------------------------------------------------------------------";
	
	
	// Setup the loop that actually animates the rotation logic
	[_radius,_altitude,_logicChaseSpeed,_updateFrequency,_logicRotationSpeed] spawn {
		private _currentAngle = random 360;
		private _angleDelta = (_this select 4);
		
		
	
		indiCam_indiCamLogicLoop = true;
		indiCam_orbitLogic setPos indiCam_appliedVar_cameraPos; // Move the logic close to it's starting point
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
			_newPos = (getPosASL indiCam_orbitLogic) vectorAdd [(_newVector select 0), (_newVector select 1), (_this select 1)];
			//indiCam_logicA setPos _newPos;
			indiCam setPos _newPos;
			sleep (_this select 3);
		};
		
	};
	
	
};

comment "-------------------------------------------------------------------------------------------------------";
comment "	Script control block 																				";
comment "																										";
indiCam_var_exitScript = false; // Used for killing waiting logic scripts
comment "-------------------------------------------------------------------------------------------------------";
