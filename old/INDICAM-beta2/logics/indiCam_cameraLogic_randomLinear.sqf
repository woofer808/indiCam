comment "-------------------------------------------------------------------------------------------------------";
comment "											indiCam, by woofer.											";
comment "																										";
comment "										indiCam_cameraLogic_randomLinear									";
comment "																										";
comment "	Makes the indiCam_logicA move linearly around the actor according to passed arguments			";
comment "	arguments: [  ] 												";
comment "																										";
comment "-------------------------------------------------------------------------------------------------------";




comment "-------------------------------------------------------------------------------------------------------";
comment "	Arguments			 																				";
comment "-------------------------------------------------------------------------------------------------------";
private _position = _this select 0;
private _distance = _this select 1;
private _speed = _this select 2;
private _followActor = _this select 3;
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

if (indiCam_var_runScript) then { // if this script is terminated, don't run this section
comment "-------------------------------------------------------------------------------------------------------";



// These are constant, could be changed to global
private _updateFrequency = (1 / _speed);



	
	
	
comment "-------------------------------------------------------------------------------------------------------";
comment "							static camera with target movement around actor								";
comment "-------------------------------------------------------------------------------------------------------";
// This script moves the target logic in a randomized fashion around the actor
// Effectively making the camera shake
	if (!_followActor) then {


		
		

		[_distance,_speed] spawn {
		
		private _distance = _this select 0;
		private _speed = _this select 1;

		
		private _oldPoint = getpos actor;
		
		indiCam_logicA setPos (getPos actor);
		indiCam_indiCamLogicLoop = true;
		while {indiCam_indiCamLogicLoop} do {

			private _newPoint = actor modelToWorld [(random [(-1 * _distance),0,_distance]),(random [(-1 * _distance),0,_distance]),(random [1,1.8,3])];

			while {(_newPoint distance _oldPoint) > 0.2} do {

				
						_distanceCamera = indiCam_logicA distance _newPoint;
						_offsetVectorCamera = (getpos indiCam_logicA) vectorFromTo _newPoint;
						_offsetVectorCamera = _offsetVectorCamera vectorMultiply _distanceCamera*(1 / _speed);
						_offsetVectorCamera = (getpos indiCam_logicA) vectorAdd _offsetVectorCamera;
						indiCam_logicA setPos _offsetVectorCamera; // This is only for debug purposes
						sleep (1 / _speed);
				};
				
			};
			
			_oldPoint = _newPoint;
			
		};
		
		
		
	}; // End of static part





comment "-------------------------------------------------------------------------------------------------------";
comment "						relative follow camera with target movement around actor						";
comment "-------------------------------------------------------------------------------------------------------";
	if (_followActor) then {
	// This is where I do the same as above, but the camera should move along with the actor
	
	
	
	
		
		
		
		


		[_distance,_speed] spawn {
		
		private _distance = _this select 0;
		private _speed = _this select 1;

		
		private _oldPoint = getpos actor;
		
		
		indiCam_indiCamLogicLoop = true;
		while {indiCam_indiCamLogicLoop} do {

			private _newPoint = actor modelToWorld [(random [(-1 * _distance),0,_distance]),(random [(-1 * _distance),0,_distance]),(random [1,1.8,3])];

			while {(_newPoint distance _oldPoint) > 0.2} do {

				
						_distanceCamera = indiCam_logicA distance _newPoint;
						_offsetVectorCamera = (getpos indiCam_logicA) vectorFromTo _newPoint;
						_offsetVectorCamera = _offsetVectorCamera vectorMultiply _distanceCamera*(1 / _speed);
						_offsetVectorCamera = (getpos indiCam_logicA) vectorAdd _offsetVectorCamera;
						indiCam_logicA setPos _offsetVectorCamera; // This is only for debug purposes
						sleep (1 / _speed);
				};
				
			};
			
			_oldPoint = _newPoint;
			
		};
			
		
	
	
	
	
	
		// Spawn the script that makes the camera logic follow the actor around and attach the camera to it 
		[_cameraChaseSpeed] spawn {
			indiCam_indiCamLogicLoop = true;
			while {indiCam_indiCamLogicLoop} do {
				_distanceCamera = indiCam_logicB distance actor;
				_offsetVectorCamera = (getpos indiCam_logicB) vectorFromTo (getPos actor);
				_offsetVectorCamera = _offsetVectorCamera vectorMultiply _distanceCamera*(_this select 0);//_cameraChaseSpeed;
				_offsetVectorCamera = (getpos indiCam_logicB) vectorAdd _offsetVectorCamera;
				indiCam_logicB setPos _offsetVectorCamera; // This is only for debug purposes
				// This will stick the camera onto the cameralogic
				indiCam camSetRelPos indiCam_appliedVar_relativePos; // shouldn't just output a position rather than attaching the camera like this?
				indiCam camCommit 0; // will this need to be done in the camera loop?
				
				sleep (1/90);
			};
		};


	
	}; // End of block that chases the actor





comment "-------------------------------------------------------------------------------------------------------";
comment "								end of main loop										";
comment "-------------------------------------------------------------------------------------------------------";

}; // if the script is skipped (never got started before getting termintated)


comment "-------------------------------------------------------------------------------------------------------";
comment "	Script control block 																				";
comment "																										";
indiCam_var_exitScript = false; // Used for killing waiting logic scripts
comment "-------------------------------------------------------------------------------------------------------";