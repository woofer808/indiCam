comment "-------------------------------------------------------------------------------------------------------";
comment "											camera logic												";
comment "																										";
comment "	Creates points and vectors around the actor determines if attachTo or onEachFrame is needed.		";
comment "																										";
comment "	Outputs:	logicHandPoint																			";
comment "				logicAimPoint																			";
comment "																										";
comment "-------------------------------------------------------------------------------------------------------";

/* DEBUG */ cameraLogicDebug = true;

/* DEBUG */ if (cameraLogicDebug) then {logicHandPointEmpty = createVehicle ["Sign_Sphere10cm_F", getpos actor, [], 0, "CAN_COLLIDE"];};
/* DEBUG */ if (cameraLogicDebug) then {logicAimDirectionEmpty = createVehicle ["Sign_Sphere10cm_F", getpos actor, [], 0, "CAN_COLLIDE"];};
/* DEBUG */ if (cameraLogicDebug) then {logicAimPointEmpty = createVehicle ["Sign_Sphere10cm_F", getpos actor, [], 0, "CAN_COLLIDE"];};


onEachFrame { // EachFrame executes assigned code each frame. Stackable version of onEachFrame.

	_weaponHandPos = actor modelToWorld (actor selectionPosition ["RightHandMiddle1", "memory"]);

	_weaponDirection = vectorNormalized (actor weaponDirection currentWeapon actor);
	_weaponVector = _weaponDirection vectorMultiply 5;
	_weaponVectorEndPos = _weaponHandPos vectorAdd _weaponVector;
	
	logicHandPoint = _weaponHandPos; 
	logicAimPoint = _weaponVectorEndPos;
	/* DEBUG */ if (cameraLogicDebug) then {logicHandPointEmpty setPos _weaponHandPos;};
	/* DEBUG */ if (cameraLogicDebug) then {logicAimPointEmpty setPos _weaponVectorEndPos;};

	
	
	
	
	// Create an empty that moves around randomly that the camera can look at
	
	
	// Linear movement
	logicMoveEmpty = createVehicle ["Sign_Sphere10cm_F", getPos actor, [], 0, "CAN_COLLIDE"];
	onEachFrame {
		_speed = 1;
		_time = (1 / diag_fps);
		movingLogic = [(_speed * _time),0,0];
		_oldPos = getPos logicMoveEmpty;
		_newPos = _oldPos vectorAdd movingLogic;
		logicMoveEmpty setPos _newPos;
	};
	
	
	// Radial movement
	logicRadialMoveEmpty = createVehicle ["Sign_Sphere10cm_F", getPos actor, [], 0, "CAN_COLLIDE"];
	currentAngle = 0;
	onEachFrame {
		_angleSpeed = 90;
		_time = (1 / diag_fps);
		_angleDelta = _angleSpeed * _time;
		currentAngle = currentAngle + _angleDelta;
		_newVector = 	[
						cos currentAngle,
						sin currentAngle,
						1.8
					];
		_newVector = _newVector vectorMultiply 1;
		_newPos = (getPos actor) vectorAdd _newVector;
		logicRadialMoveEmpty setPos _newPos;
	};
	
	

};
